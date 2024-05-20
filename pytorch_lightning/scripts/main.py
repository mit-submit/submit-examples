import os

from bilby.core.prior import Uniform
from lightning import pytorch as pl
import numpy as np
import torch

from model import MADE


def get_data(priors, m=None, c=None, num_points=1):
    """Sample m, c and return a batch of data with noise"""
    ### Sigma is hardcoded, posterior depends on this ###
    sigma = 0.6

    m = priors['m'].sample() if m is None else m
    c = priors['c'].sample() if c is None else c

    x = np.linspace(-4, 4, num_points)
    y = m * x + c
    y += sigma*np.random.normal(size=x.size)

    return x, y, m, c


class LinearRegressionDataset(torch.utils.data.Dataset):
    def __init__(self, theta, data):
        super().__init__()
        self.theta = theta
        self.data = data

    def __len__(self):
        return len(self.theta)

    def __getitem__(self, idx):
        if torch.is_tensor(idx):
            idx = idx.tolist()

        return self.theta[idx], self.data[idx]


class LinearRegressionDataModule(pl.LightningDataModule):
    def __init__(self, prior: dict, batch_size: int = 100, num_points: int = 50):
        super().__init__()
        self.batch_size = batch_size
        self.num_points = num_points
        self.prior = prior

    def setup(self, num_simulations=40000, stage=None):
        theta_vals = []
        data_vals = []
        # Generate the simulations
        for ii in range(num_simulations):
            x_val, y_val, m_val, c_val = get_data(self.prior, num_points=self.num_points)
            data_vals.append(torch.from_numpy(y_val).to(dtype=torch.float32))
            theta_vals.append(torch.tensor([m_val, c_val]).to(dtype=torch.float32))

        dataset = LinearRegressionDataset(theta_vals, data_vals)

        train_set_size = int(0.8 * num_simulations)
        val_set_size = int(0.1 * num_simulations)
        test_set_size = int(0.1 * num_simulations)

        self.train_data, self.val_data, self.test_data = \
            torch.utils.data.random_split(
                dataset, [train_set_size, val_set_size, test_set_size])

    def train_dataloader(self):
        return torch.utils.data.DataLoader(
            self.train_data,
            batch_size=self.batch_size,
            shuffle=True,
            num_workers=2,
            pin_memory=True
        )

    def val_dataloader(self):
        return torch.utils.data.DataLoader(
            self.val_data,
            batch_size=self.batch_size,
            shuffle=False,
            pin_memory=True
        )

    def test_dataloader(self):
        return torch.utils.data.DataLoader(
            self.test_data,
            batch_size=1,
            shuffle=False
        )


class PPPlotCallback(pl.Callback):
    def on_test_start(self, trainer, pl_module):
        pl_module.test_results = []

    def on_test_end(self, trainer, pl_module):
        import bilby, warnings
        rank = torch.distributed.get_rank()
        with warnings.catch_warnings():
            warnings.simplefilter('ignore')
            bilby.result.make_pp_plot(pl_module.test_results, save=True,
                                      filename=f'pp-plot-{rank}.png', keys=['m', 'c'])
        pl_module.test_results.clear()
        del bilby, warnings


def main():
    input_dim = 2
    num_points = 50
    batch_size = 100
    context_dim = num_points
    hidden_dims = [5*input_dim, 5*input_dim]
    prior = dict(
        m=Uniform(-3, 3, name='m', latex_label='m'),
        c=Uniform(-3, 3, name='c', latex_label='c'))
    model = MADE(input_dim, context_dim, hidden_dims, prior, learning_rate=1e-3 * torch.cuda.device_count())
    simulation_data = LinearRegressionDataModule(prior, batch_size=batch_size, num_points=num_points)

    trainer = pl.Trainer(
        accelerator='gpu',
        devices=torch.cuda.device_count(),
        strategy='ddp',
        max_epochs=30,
        log_every_n_steps=100,
        logger=pl.loggers.CSVLogger("made-logdir", name="made-expt"),
        callbacks=[PPPlotCallback()]
    )
    trainer.fit(model, simulation_data)
    trainer.test(model, simulation_data)

if __name__ == '__main__':
    main()
