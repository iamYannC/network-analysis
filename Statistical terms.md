This file contains explenations on the centrality measures that I used in the project.
Please visit the links of each topic for more information. It is focused on Social Networks, rather than just networks in general,
but all the information is relevant to the project.
====================================================================================================

# [Social Network Analysis](https://www.sciencedirect.com/topics/social-sciences/social-network-analysis)
Social Network Analysis refers to the study conducted with an awareness of social networks, including connections with other analysts in the field. It involves examining relationships between individuals or groups to understand patterns and dynamics within social structures.

# [Undirected Network](https://www.sciencedirect.com/topics/computer-science/undirected-network)
An undirected network is a type of network where the relationships between nodes are symmetric, without any specific directionality assigned to the edges connecting them.

# [Distance Graph](https://www.sciencedirect.com/topics/computer-science/distance-graph)
A 'Distance Graph' is defined as a graph-based similarity measure where the distance between two query nodes is computed as the length of the shortest path between them. Smaller graph distances indicate a higher level of relatedness between the queries.

# [Network Density](https://www.sciencedirect.com/topics/computer-science/network-density)
Network density refers to the quantitative measure of the number of edges between nodes in a network. It is calculated by dividing the total number of edges in the network by the maximum number of possible edges. It is commonly used as an evaluation criterion in experiments in the field of network science.

## Diameter: 𝑚𝑎𝑥(𝜌(𝑖,𝑗)∀𝑖,𝑗)
Diameter is the longest of all the calculated path lengths or the distance [34]. A larger diameter signifies that information propagation will have higher latency.


# [Centrality Measures](https://www.sciencedirect.com/topics/computer-science/centrality-measure)
entrality measures refer to the evaluation of how central an individual is positioned within a social network, using tools like graph theory and network analysis. Various measures such as degree centrality, closeness centrality, betweenness centrality, eigenvector centrality, and Katz centrality are commonly used to analyze social influence within networks.

## [Degree Centrality](https://www.sciencedirect.com/topics/computer-science/degree-centrality)
Degree centrality refers to a measure in network analysis that quantifies the number of connections a node has. It is calculated based on the count of social connections (edges) a node possesses, with higher values indicating a more central position within the network.

## [Closeness Centrality](https://www.sciencedirect.com/topics/computer-science/closeness-centrality)
Closeness centrality refers to the measure of the average shortest distance between each person in a network. It indicates how quickly information can flow through the network, with lower scores indicating a more central and important position in the network.

## [Betweenness Centrality](https://www.sciencedirect.com/topics/computer-science/betweenness-centrality)
Betweenness centrality is defined as a measure of how often a node lies on the shortest path between all pairs of nodes in a network. It requires global knowledge of the entire network and assigns centrality values to nodes based on their position in these paths.

## [Eigenvector Centrality](https://www.sciencedirect.com/topics/mathematics/eigenvector)
Eigenvector centrality premises that a node’s importance in a network may increase by having connections to the other nodes
that are themselves important and it is calculated by giving each node a relative score proportional
to the sum of the scores of its neighbours (Bonacich, 2007).

Bonacich, P. (2007). Some unique properties of eigenvector centrality. Social networks, 29(4), 555-564.
