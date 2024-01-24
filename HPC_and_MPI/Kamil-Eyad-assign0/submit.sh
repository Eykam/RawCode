#!/bin/bash

#SBATCH -N 2

#SBATCH --ntasks-per-node=8

#SBATCH -t 00:10

mpirun -np 1 ./cpiexe




