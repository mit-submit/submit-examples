import bilby
from lightning import pytorch as pl
from pyro.nn import ConditionalAutoRegressiveNN
from pyro.distributions import ConditionalTransformedDistribution
from pyro.distributions.transforms import ConditionalAffineAutoregressive
import pandas as pd
import torch
import torch.distributions as dist


def cast_as_bilby_result(samples, truth, priors):
    injections = dict()
    injections['m'] = float(truth.cpu().numpy()[0])
    injections['c'] = float(truth.cpu().numpy()[1])

    posterior = dict.fromkeys(injections)
    samples_numpy = samples.cpu().numpy()
    posterior['m'] = samples_numpy.T[0].flatten()
    posterior['c'] = samples_numpy.T[1].flatten()
    posterior = pd.DataFrame(posterior)
    
    return bilby.result.Result(
        label="test_data",
        injection_parameters=injections,
        posterior=posterior,
        search_parameter_keys=list(injections.keys()),
        priors=priors
    )


class MADE(pl.LightningModule):
    def __init__(
        self,
        input_dim,
        context_dim,
        hidden_dim,
        prior,
        learning_rate: float = 1e-3,
    ):
        super().__init__()
        self.input_dim = input_dim
        self.context_dim = context_dim
        self.hidden_dim = hidden_dim
        self.learning_rate = learning_rate
        self.prior = prior

        self.hypernet = ConditionalAutoRegressiveNN(self.input_dim, self.context_dim, self.hidden_dim)
        self.transform = ConditionalAffineAutoregressive(self.hypernet)

    def distribution(self):
        return dist.Normal(
            torch.zeros(self.input_dim, device=self.device),
            torch.ones(self.input_dim, device=self.device),
        )

    @property
    def flow(self):
        return ConditionalTransformedDistribution(
            self.distribution(), [self.transform]
        )

    def log_prob(self, theta, data):
        return self.flow.condition(data).log_prob(theta).mean()

    
    def training_step(self, batch, batch_idx):
        theta, data = batch
        loss = - self.log_prob(theta, data)
        self.log("train_loss", loss, on_epoch=True, prog_bar=True, sync_dist=True)
        return loss

    def validation_step(self, batch, batch_idx):
        theta, data = batch
        loss = - self.log_prob(theta, data)
        self.log("valid_loss", loss, on_epoch=True, prog_bar=True, sync_dist=True)
        return loss

    def test_step(self, batch, batch_idx):
        theta, data = batch
        samples = self.flow.condition(data).sample([2000])
        res = cast_as_bilby_result(samples, theta[0], self.prior)
        self.test_results.append(res)

    def configure_optimizers(self):
        parameters = self.transform.parameters()
        optimizer = torch.optim.AdamW(parameters, self.learning_rate)
        scheduler = torch.optim.lr_scheduler.ExponentialLR(
            optimizer, gamma=0.95
        )
        scheduler_config = dict(scheduler=scheduler, interval="epoch")
        return dict(optimizer=optimizer, lr_scheduler=scheduler_config)

