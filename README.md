# Network analysis from research data
Yann Cohen
2024-10-17

- [Introduction](#introduction)
- [Repository Contents](#repository-contents)
- [Network Plots](#network-plots)
- [Statistics](#statisticssceiencedirect)
  - [Graph Theory](#graph-theory)
  - [Social Network Analysis](#social-network-analysis)
  - [Undirected Network](#undirected-network)
  - [Distance Graph](#distance-graph)
  - [Network Density](#network-density)
    - [Diameter: 𝑚𝑎𝑥(𝜌(𝑖,𝑗)∀𝑖,𝑗)](#diameter-𝑚𝑎𝑥𝜌𝑖𝑗𝑖𝑗)
  - [Centrality Measures](#centrality-measures)
    - [Degree Centrality](#degree-centrality)
    - [Closeness Centrality](#closeness-centrality)
    - [Betweenness Centrality](#betweenness-centrality)
    - [Eigenvector Centrality](#eigenvector-centrality)

# Introduction

This folder contains the analysis and visualization of a research
conducted by *Yossy Machluf*[^1] & *Ronit Rozenszajn*[^2]. The data was
processed and analyzed by *Yann Cohen*[^3] using
[*networkx*](https://networkx.org/)[^4] in Python and
[*igraph*](https://igraph.org)[^5] in R.

# Repository Contents

- [Input files](input%20files/)
  - [Main Excel](input%20files/matrixcorrect.xlsx)
  - [All students](input%20files/all.csv)
  - [Green group](input%20files/greens.csv)
  - [Pink group](input%20files/pinks.csv)
  - [Mixed group](input%20files/hetero.csv)
- Analysis and Vizualization
  - [Analysis in Python](Network%20analysis.py)
  - [Vizualization in R](main%20generator.R) (helper:
    [functions.R](functions.R))
- [Output files](output%20files/)
  - [All students](output%20files/all_svg.svg)
  - [Green group](output%20files/greens_svg.svg) [*(2nd
    version)*](output%20files/net_greens.png)
  - [Pink group](output%20files/pinks_svg.svg) [*(2nd
    version)*](output%20files/net_pinks2.png)
  - [Mixed group](output%20files/hetero_svg.svg) [*(2nd
    version)*](output%20files/net_hetero2.png)
  - [Network data](output%20files/Network_df.csv)
  - [Edges data](output%20files/Edges_df.csv)
  - [Nodes data](output%20files/Nodes_df.csv)
  - [Binary R file for networks](networks_full.rds)
- [Statistical terms](statistical%20terms.md) (*Also shown below*)

# Network Plots

The output folder currently contains plots with random titles, without
group names. This will eventually change. There are 4 networks, each has
one or two plots.

Here is an example of the ‘pink’ group network:
![](output%20files/pinks_svg.svg)

# Statistics[^6]

## [Graph Theory](https://www.sciencedirect.com/topics/computer-science/graph-theory)

Graph Theory is defined as a branch of mathematics that utilizes graphs
to represent theoretical or structural relations, providing a useful
tool for forming, viewing, and analyzing various kinds of structural
models in different fields such as anthropology.

## [Social Network Analysis](https://www.sciencedirect.com/topics/social-sciences/social-network-analysis)

Social Network Analysis refers to the study conducted with an awareness
of social networks, including connections with other analysts in the
field. It involves examining relationships between individuals or groups
to understand patterns and dynamics within social structures.

## [Undirected Network](https://www.sciencedirect.com/topics/computer-science/undirected-network)

An undirected network is a type of network where the relationships
between nodes are symmetric, without any specific directionality
assigned to the edges connecting them.

## [Distance Graph](https://www.sciencedirect.com/topics/computer-science/distance-graph)

A Distance Graph is defined as a graph-based similarity measure where
the distance between two query nodes is computed as the length of the
shortest path between them. Smaller graph distances indicate a higher
level of relatedness between the queries.

## [Network Density](https://www.sciencedirect.com/topics/computer-science/network-density)

Network density refers to the quantitative measure of the number of
edges between nodes in a network. It is calculated by dividing the total
number of edges in the network by the maximum number of possible edges.
It is commonly used as an evaluation criterion in experiments in the
field of network science.

### Diameter: 𝑚𝑎𝑥(𝜌(𝑖,𝑗)∀𝑖,𝑗)

Diameter is the longest of all the calculated path lengths or the
distance \[34\]. A larger diameter signifies that information
propagation will have higher latency.

## [Centrality Measures](https://www.sciencedirect.com/topics/computer-science/centrality-measure)

entrality measures refer to the evaluation of how central an individual
is positioned within a social network, using tools like graph theory and
network analysis. Various measures such as degree centrality, closeness
centrality, betweenness centrality, eigenvector centrality, and Katz
centrality are commonly used to analyze social influence within
networks.

### [Degree Centrality](https://www.sciencedirect.com/topics/computer-science/degree-centrality)

$DC(v_i) = \frac{1}{N-1} \sum_{j=1}^{N} a_{i,j}$

Degree centrality refers to a measure in network analysis that
quantifies the number of connections a node has. It is calculated based
on the count of social connections (edges) a node possesses, with higher
values indicating a more central position within the network.

### [Closeness Centrality](https://www.sciencedirect.com/topics/computer-science/closeness-centrality)

$C(u) = \frac{1}{\sum_y d(u, v)}$

Closeness centrality refers to the measure of the average shortest
distance between each person in a network. It indicates how quickly
information can flow through the network, with lower scores indicating a
more central and important position in the network.

### [Betweenness Centrality](https://www.sciencedirect.com/topics/computer-science/betweenness-centrality)

$Betw(n) = \sum_{\substack{i \neq n \\ j \neq n \\ i, j \in N}} \frac{a_{i,j}(n)}{a_{i,j}}$

Betweenness centrality is defined as a measure of how often a node lies
on the shortest path between all pairs of nodes in a network.

### [Eigenvector Centrality](https://www.sciencedirect.com/topics/mathematics/eigenvector)

$x_i = \frac{1}{\lambda} \sum_{k=1}^{N} a_{k,i} x_k$

Where $\lambda ≠ 0$ is a constant. In the matrix form, it is presented
$\lambda x = xA$

Eigenvector centrality premises that a node’s importance in a network
may increase by having connections to the other nodes that are
themselves important and it is calculated by giving each node a relative
score proportional to the sum of the scores of its neighbours (Bonacich,
2007).

Bonacich, P. (2007). Some unique properties of eigenvector centrality.
Social networks, 29(4), 555-564.

[^1]: **Yossy Machluf:** [Google
    Scholar](https://scholar.google.com/citations?user=ca8kGR4AAAAJ),
    [ResearchGate](https://www.researchgate.net/profile/Yossy-Machluf)

[^2]: **Ronit Rozenszajn:** [Google
    Scholar](https://scholar.google.com/citations?user=TTlKgE8AAAAJ),
    [ResearchGate](https://www.researchgate.net/profile/Ronit-Rozenszajn)

[^3]: **Yann Cohen:**
    [Linkedin](https://www.linkedin.com/in/yann-cohen-tourman/)

[^4]: Hagberg, A. A., Schult, D. A., & Swart, P. J. (2008). Exploring
    network structure, dynamics, and function using NetworkX. In G.
    Varoquaux, T. Vaught, & J. Millman (Eds.), Proceedings of the 7th
    Python in Science Conference (SciPy2008) (pp. 11–15). Pasadena, CA.

[^5]: Csardi G, Nepusz T (2006). “The igraph software package for
    complex network research.” *InterJournal*, *Complex Systems*, 1695.

[^6]: Visit
    [Mathematics](https://www.sciencedirect.com/topics/mathematics/) or
    [Computer
    Sceince](https://www.sciencedirect.com/topics/computer-science/)
    sections in [SceienceDirect](https://www.sciencedirect.com/topics/)
    for more information on these topics.
