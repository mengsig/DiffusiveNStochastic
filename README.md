This is the repository for the assignment for Diffusive and Stochastic Processes.

--------------------------------
Problems:
--------------------------------
1. Langevin: Brownian particle in the over-damped limit under the force of a potential (potential-well).
2. SIR Model (Gillespie): Pandemic spreading of the flu with re-contagion and well-mixed population.
3. SIR Model (Gillespie): Pandemic spreading of the flu with re-contagion and well-mixed population, with flu immunity.

--------------------------------
Instructions:
--------------------------------
If you have a debian distribution, install Zig via the following command:

$ sudo snap install zig

If you do not have the snap package manager, you can install it via:

$ sudo apt-get update
$ sudo apt-get install snapd


If you have a MacOS, you can install Zig via Brew with the following command:

$ brew install zig

Otherwise, you have to do a manual installation of Zig (see https://github.com/ziglang/zig).

Once you have installed Zig, navigate to a directory, and clone the repository.
$ git clone git@github.com:mengsig/DiffusiveNStochastic.git

Once you have cloned the repository, you will find 3 folders - i.e. q1, q2, and q3, which pertain to the questions in the Problem statement.

From here, navigate to your desired problem and run (only run <$ rm -r data> if you want to remove the data files):

$ zig build run -Doptimize=ReleaseFast

$ python3 plot.py

Then, your data will be extracted to the new data folder, and the plot.py script will build the figures!

--------------------------------
IMPORTANT NOTE: 
--------------------------------
Remember to run 

$ rm -r data

between every zig build run

$ zig build run -Doptimize=ReleaseFast

as otherwise, you will run into the issue that the directory already exists!

--------------------------------
Some figures
--------------------------------
1. Langevin brownian particle in potential well:
![Model](https://github.com/mengsig/DiffusiveNStochastic/blob/main/q1/q1_plot.png?raw=true)

2. SIR with Gillespie for well-mixed and "external" contagion.
![Model](https://github.com/mengsig/DiffusiveNStochastic/blob/main/q2/q2_plot.png?raw=true)

3. SIR with Gillespie for well-mixed and "external" contigion, with short-term immunity.
![Model](https://github.com/mengsig/DiffusiveNStochastic/blob/main/q3/q3_plot.png?raw=true)

Good luck!

Marcus Engsig
