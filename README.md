# Roger Skyline 1

I love Linux

## About

After learning some basics commands and scripting in network administration
from the first project `Init`.
This project will help us to implement some practical case to:

- Install a Virtual Machine;
- Implement a static ip;
- Create a SSH token with access restriction;
- Configure a firewall;
- Create a web server.
- Schedule a task
- Deploy the server

## Getting Started

### Prerequisites

Hypervisor of your choice

```text
Virtual Box, Hyper-v, VMWare...
```

- A disk size of 8 GB.
- Have at least one 4.2 GB partition.

Download a Linux OS image of your choice and install it in your hypervisor.
(Debian, Jessie, CentOS 7...)

### Running the program

This project in my case will be implemented with Debian it might some
slightly difference in some command based on the os you choose.

Run your virtual machine with preference to use non graphical mode or
if you are in graphical mode open a terminal. A script will be used to
automatise the process.
Run the command `su` and enter your Password

```bash
$> su
$> apt update
$> apt install git
$> git clone https://github.com/kabascolby/roger-skyline-1.git
```

I created a script to install and update all the dependencies needed for
the project by running the following

```bash
git clone https://github.com/kabascolby/Minishell.git
```

## Implementions

Based on the restrictions to implement this project
and the coding style imposed by 42.

### Mandatory

the instruction was to implement a serie's of builtins commands
with their basic functionality also to be able to run some
externals commands(with binary files) specified in the PATH environement.

- Builtins commands: echo, cd, setenv, unsetenv, env, exit

```
Give an example
```

Explain what these tests test and why

### Bonuses

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

- C programing language
- Makefile to genrate the executable

## Authors

- **Lamine kaba** - _Initial work_ - [kabascolby](https://github.com/kabascolby)

## License

open source

## Acknowledgments

- Hat tip to anyone whose code was used
- Inspiration
- etc
