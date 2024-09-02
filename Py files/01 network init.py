      # Highly experimental code #
# Documentation for networkx: https://networkx.org/documentation/stable/index.html
# Initialize a network based on csv files. make sure to change pinks/greens/all/hetero      

import networkx as nx
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

# import adjacency matrix as pandas dataframe
adj_matrix = pd.read_csv(r"input files\pinks.csv") # start by testing on pinks
print(adj_matrix)

# basic cleaning
adj_matrix['pinks'] = adj_matrix['pinks'].str.extract('(\d+)').astype(int) # throws A WARNING but works
adj_matrix.set_index('pinks', inplace=True)
adj_matrix.index.name = None

adj_matrix.fillna(0,inplace = True)
adj_matrix = adj_matrix.astype(int)
adj_matrix.columns = adj_matrix.columns.str.removeprefix('pinks_')
adj_matrix.index = adj_matrix.index.str.removeprefix('pinks_')
adj_matrix.index = adj_matrix.index.astype(int)
# make sure its symetric 
adj_matrix.shape # 48 * 48

print(adj_matrix.iloc[:5,:5])

# before we create the graph, we need to make sure the column names are integers
  # first_col = adj_matrix.columns[0]
  # first_ind = adj_matrix.index[0]
  # type(first_col) # str
  # type(first_ind) # numpy.int32

# By converting to numpy int we can create the graph
adj_matrix.columns = adj_matrix.columns.astype(int)
  # type(adj_matrix.columns[0]) # numpy.int32


###### create the graph
G = nx.from_pandas_adjacency(adj_matrix, create_using=nx.Graph) # nx.Graph is the default

nx.number_of_nodes(G) # 48 nodes
nx.number_of_isolates(G) # 33 isolates

# Remove from the graph all nodes that have no edges
G.remove_nodes_from(list(nx.isolates(G)))
nx.number_of_nodes(G) # should be 48 - 33 = 15 -- yes!





# For network graphs look at 02 network plot.py
# For network analysis look at 02_1 network analysis.py

# ==================================================================================================== #

## experimental views on graph -- wip
# One way to look at two-way connections
for n, nbrsdict  in G.adjacency():
  for nbr, eattr in nbrsdict.items():
    print(n, nbr, eattr)

# a bit better
for u, v, w in G.edges.data('weight'):
    print(u, v, w)

# set degree as a node attribute
for node in G.nodes():
    weighted_degree = G.degree(node, weight='weight')
    G.nodes[node]['weighted_degree'] = weighted_degree

def custom_degree(G):
    return {node: data['weighted_degree'] for node, data in G.nodes(data=True)}
custom_degree(G)


G.degree() # degree of the nodes, non-weighted
G.degree(weight='weight') # actual degree of the nodes

# compare the two in a pandas dataframe
nodes_names = [node for node in G.nodes()]
non_weighted = [G.degree(node) for node in G.nodes()]
weighted = [G.degree(node, weight='weight') for node in G.nodes()]
df = pd.DataFrame({'node':nodes_names,'non_weighted':non_weighted,'weighted':weighted})
# get difference
df['diff'] = df['weighted'] - df['non_weighted']
df.sort_values(by='diff',ascending=False)
