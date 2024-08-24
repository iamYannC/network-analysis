# Network analysis from research data
Yann Cohen
2024-08-24

- [Introduction](#introduction)
- [Structure](#structure)
- [Plotting the network](#plotting-the-network)
- [Statistics](#statistics)

# Introduction

This folder contains the required R files as well as xlsx to run the
network analysis. There is still debugging to be done, but the code is
functional, and will probably not change much.

# Structure

- [Input files](input%20files/)
  - [main Excel](input%20files/matrixcorrect.xlsx)
  - [All students](input%20files/all.csv)
  - [Green group](input%20files/greens.csv)
  - [Pink group](input%20files/pinks.csv)
  - [Mixed group](input%20files/hetero.csv)
- [R files](R%20files/)
  - [01 CSV generator](R%20files/01%20csv%20from%20xlsx.R)
  - [02 Functions](R%20files/02%20functions.R)
  - [03 Generator](R%20files/03%20generator.R)
  - [Old generator](R%20files/old%20generator.R) Currently, only
    old_generator is producing anything meaningful. It will be changed
- [Output files](output%20files/)
  - [All students](output%20files/net_all.png)
  - [Green group](output%20files/net_greens.png)
  - [Pink group](output%20files/net_pinks.png)
  - [Mixed group](output%20files/net_hetero.png)

# Plotting the network

Here is an example of the network with all students:

![](output%20files/net_all.png)

# Statistics

Work in Progress
