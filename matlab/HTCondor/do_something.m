%% MPS simulations for Spin spirals
%%% Wen Wei Ho 2019

%% 
 

N = 10; 
% Model
DeltaList = [1.2 1.1 1.0 0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2];
numDelta = length(DeltaList);
Qlist = [8:2:28];
numQ = length(Qlist);
 

myId = 1; % This is the Id of the job run. 


whichQ = mod(myId-1,numQ)+1;
whichDelta = (myId - whichQ)/numQ + 1;
invQ = Qlist(whichQ);
Q = 2*pi/invQ;
Delta = DeltaList(whichDelta);

D = 8; % Default bond dimension
maxD = 512;

disp(['myId = ',num2str(myId),', Running MPS Simulations for Delta = ',num2str(Delta),', invQ = ',num2str(invQ),', D = ',num2str(D)]);

% MPS parameters
precision=1e-7;


% Time parameters
dt=0.01;
maxT = 5;
maxSteps = round(maxT/dt);
phase = 2*pi*0;
 
% Obs_lists
stepObs_list = [1:round(0.05/dt):maxSteps]; % Only measure at those steps @ which t = 0.05; but evolve under 0.01
tObs_list = dt*stepObs_list;
bigObsvalues_MPS = zeros(3,N, length(stepObs_list) );
bigSent_MPS = zeros(length(stepObs_list),N-1);



  
%% Observables
% magnetization in z-direction
 sx=[0,1;1,0]; sy=[0,-1i;1i,0]; sz=[1,0;0,-1]; id=eye(2);
 
% Set of all Sz s
oset_x = cell(N,N);
oset_y = cell(N,N);
oset_z = cell(N,N);

for j=1:N
    for i = 1:N
        oset_x{i,j} = id;
        oset_y{i,j} = id;
        oset_z{i,j} = id;
        if i==j
            oset_x{i,i} = sx/2;
            oset_y{i,i} = sy/2;
            oset_z{i,i} = sz/2;
        end
    end
end


%% Create state
 
mps0=cell(1,N);
upState = [1;0];
for j = 1:N
    state = expm(-1i*( Q*(j-0.5) - pi/2 + phase  )*sy/2)*upState;
    mps0{j}=reshape(state,[1,1,2]);
end

%% Time evolution parameters (CHECK!)
mpo_even=cell(1,N);
mpo_odd=cell(1,N);

I=reshape(id,[1,1,2,2]);
for j=1:N, mpo_even{j}=I; mpo_odd{j}=I; end

 
% time evolution operator
h=kron(sx,sx)/4+kron(sy,sy)/4+Delta*kron(sz,sz)/4;

% 2nd Order Trotter Decomposition
w=expm(-1i*dt*h);
w=reshape(w,[2,2,2,2]); w=permute(w,[2,4,1,3]); w=reshape(w,[4,4]);
[U,Sv,V]=svd2(w); eta=size(Sv,1);
U=U*sqrt(Sv); V=sqrt(Sv)*V; 
U=reshape(U,[2,2,eta]); U=permute(U,[4,3,1,2]);
V=reshape(V,[eta,2,2]); V=permute(V,[1,4,2,3]);

for j=2:2:(N-1), mpo_even{j}=U; mpo_even{j+1}=V; end

 

w=expm(-1i*dt/2*h);
w=reshape(w,[2,2,2,2]); w=permute(w,[2,4,1,3]); w=reshape(w,[4,4]);
[U,Sv,V]=svd2(w); eta=size(Sv,1);
U=U*sqrt(Sv); V=sqrt(Sv)*V; 
U=reshape(U,[2,2,eta]); U=permute(U,[4,3,1,2]);
V=reshape(V,[eta,2,2]); V=permute(V,[1,4,2,3]);
 
for j=1:2:(N-1), mpo_odd{j}=U; mpo_odd{j+1}=V; end


%% Time evolution
mps=mps0;

obsvaluesMPS=zeros(3,N);
Sent_list = 0*[1:N-1];
 

tic
currentCount = 1;
maxS_reached = 0;
for step=1:maxSteps
     
    if mod(step,50) == 0
        disp(['Time = ',num2str(dt*step)]);
        toc
        tic
    end
    
    
    % Apply 2nd order TEBD
    Sent_list_max = ones(1,N-1)*log(D);
    mps=reduceD(mps,mpo_odd,D,precision);
    mps=reduceD(mps,mpo_even,D,precision);
    mps=reduceD(mps,mpo_odd,D,precision);
     
    
    % Measure mz_values @ units of 0.05 and calculate EE
    if mod(step,round(0.05/dt)) == 0
        for j = 1:N
             obsvaluesMPS(1,j) = real(expectationvalue(mps,oset_x(j,:))); 
             obsvaluesMPS(2,j) = real(expectationvalue(mps,oset_y(j,:))); 
             obsvaluesMPS(3,j) = real(expectationvalue(mps,oset_z(j,:))); 
      
       if j ~= N
                 Sent_list(j) = measureSentMPS(mps,j);
             end
        end
        maxSent_now = max(Sent_list);
        
        
        %% Save the last mps
        if maxS_reached == 0
            mps_last = mps;
            step_last = step;
        end
        if (maxSent_now > 0.85*log(D))&&(maxS_reached==0)
            disp(' ');
            disp('**** Warning! Simulations might not be convergent now, reaching bond dimension limit...');
            mps_last = mps;
            maxS_reached = 1;
            step_last = step;
        end
        
        if (maxSent_now > 0.75*log(D))&&(maxS_reached==0)
            newD = min(2*D,maxD);
            if newD ~= D
                disp(['Adjusting bond dimension to D = ',num2str(newD)]);
                D = newD;
            end
        end
        
        bigObsvalues_MPS(:,:,currentCount) = obsvaluesMPS; 
        bigSent_MPS(currentCount,:) = Sent_list;
        
        currentCount = currentCount + 1;
    
    end
     
    %% Save data
    if mod(step,round(1/dt)) == 0
        disp('Saving data...');
        MPS_SS_data.N = N;
        MPS_SS_data.Q = Q;
        MPS_SS_data.D = D;
        MPS_SS_data.Delta = Delta;
        MPS_SS_data.phase = phase;
        MPS_SS_data.dt = dt;
        MPS_SS_data.maxT = maxT;
        MPS_SS_data.bigObsvalues_MPS = bigObsvalues_MPS;
        MPS_SS_data.bigSent_MPS = bigSent_MPS;
        MPS_SS_data.step_last = step_last;
        % MPS_SS_data.mps_last = mps_last;
        
        savefolder = './';
        save([savefolder,'do_something.mat'],'-struct','MPS_SS_data');
    end
    
end
 
disp('Done! Thanks Christoph!');
 
