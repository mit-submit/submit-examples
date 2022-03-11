# Remote GPU Monitor

source:
https://github.com/mseitzer/gpu-monitor

This Python script allows to check for free Nvidia GPUs in remote servers.
Additional features include to list the type of GPUs and who's using them.
The idea is to speed up the work of finding a free GPU in institutions that share multiple GPU servers.

The script works by using your account to SSH into the servers and running `nvidia-smi`. 

## Features

- Show all free GPUs across servers
- Show all current users of all GPUs (-l or --list)
- Show all GPUs used by yourself (-m or --me)
- Resolve usernames to real names (-f or --finger)

## Requirements

- python3
- SSH access to some Linux servers with Nvidia GPUs

## Usage

For checking for free GPUs on some server(s), simply add their address(es) after the script name.
You might need to enter your password. To avoid that, follow the steps in [setup for convenience](#setup-for-convenience).

```
python gpu_monitor.py myserver.com

Server myserver.com:
        GPU 5, Tesla K80
        GPU 7, Tesla K80
```

If you have some set of servers that you regularily check, specify them in the file `servers.txt`, one address per line.
Once you did that, running just `./gpu_monitor.py` checks all servers specified in this file by default.

If you want to list all GPUs and who currently uses them, you can use the `-l` flag:
```
python gpu_monitor.py -l myserver.com

Server myserver.com:
        GPU 0 (Tesla K80): Used by userA
        GPU 1 (Tesla K80): Used by userB
        GPU 2 (Tesla K80): Used by userA
        GPU 3 (Tesla K80): Used by userC
        GPU 4 (Tesla K80): Used by userC
        GPU 5 (Tesla K80): Free
        GPU 6 (Tesla K80): Used by userD
        GPU 7 (Tesla K80): Free
```

If you just want to see the GPUs used by yourself, you can use the `--me` flag.
This requires that your user name is the same as remotely, or that you specify the name using the `-s` flag.
```
python gpu_monitor.py --me myserver.com
Server myserver.com:
        GPU 3 (Tesla K80): Used by userC
```

Finally, if you also want to see the real names of users, you can use the `-f` flag.
This uses Linux's `finger` command.
```
python gpu_monitor.py -f myserver.com

Server myserver.com:
        GPU 0 (Tesla K80): Used by userA (Sue Parsons)
        GPU 1 (Tesla K80): Used by userB (Tim MacDonald)
        GPU 2 (Tesla K80): Used by userA (Sue Parsons)
        GPU 3 (Tesla K80): Used by userC (Neil Piper)
        GPU 4 (Tesla K80): Used by userC (Neil Piper)
        GPU 5 (Tesla K80): Free
        GPU 6 (Tesla K80): Used by userD (Brandon Ross)
        GPU 7 (Tesla K80): Free
```
