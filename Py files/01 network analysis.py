      # Highly experimental code #
# Documentatiol for networkx: https://networkx.org/documentation/stable/index.html
      
# creating a graph from adjacency matrix
import networkx as nx
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

# import adjacency matrix as pandas dataframe
adj_matrix = pd.read_csv(r"input files\pinks.csv") # start by testing on pinks
print(adj_matrix)

# basic cleaning
adj_matrix.set_index('Unnamed: 0', inplace=True)
adj_matrix.index.name = None
adj_matrix.fillna(0,inplace = True)
adj_matrix = adj_matrix.astype(int)

# make sure its symetric 
adj_matrix.shape # 48 * 48

print(adj_matrix)

# before we create the graph, we need to make sure the column names are integers
  # first_col = adj_matrix.columns[0]
  # first_ind = adj_matrix.index[0]
  # type(first_col) # str
  # type(first_ind) # numpy.int64

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

nx.draw(G, with_labels=True)
plt.show()
plt.close()

## experimental views on graph -- wip
# One way to look at two-way connections
for n, nbrsdict  in G.adjacency():
  for nbr, eattr in nbrsdict.items():
    print(n, nbr, eattr)

# a bit better
for u, v, w in G.edges.data('weight'):
    print(u, v, w)


