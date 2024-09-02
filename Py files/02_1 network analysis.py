
      # Highly experimental code #
# Documentation for networkx: https://networkx.org/documentation/stable/index.html
# Start from 01 network init.py

# check if length of connected components equals number of nodes, meaning the graph is connected 
len_connected = len(list(nx.connected_components(G))[0])
len_connected == nx.number_of_nodes(G) # it is.

# Let's analyse shortest paths...
shortest_path = {}
for tar in G.nodes:
    for src in G.nodes:
      if nx.has_path(G,src,tar) and src != tar:
        shortest_path[(tar,src)] = nx.shortest_path(G,tar,src)

for i in shortest_path.items():
    print(i)


# Edge Centrality
edge_centrality = nx.edge_betweenness_centrality(G)
'''
edge centrality is the number of shortest paths that go through an edge.
It is the sum of the fraction of shortest paths that go through an edge
'''

# edge df
edges_df = pd.DataFrame(G.edges(data=True), columns=['node1', 'node2', 'weight'])
edges_df['weight'] = edges_df['weight'].apply(lambda x: x['weight'])

# add edge centrality to the df
edges_df['edge_centrality'] = edges_df.apply(lambda x: edge_centrality[(x['node1'],x['node2'])],axis=1)

edges_df.sort_values(by = 'edge_centrality',ascending = False).head()


# Node Centrality -- manual calculations

# Manualy set degrees
my_degree = {}
for i in adj_matrix.index:
    # sum of rows
    r = adj_matrix.loc[i].sum()
    # sum of columns
    c = adj_matrix[i].sum()
    d = c + r
    # put in a dict where key is the node and value is the degree
    if d > 0:
      my_degree[i] = d

# degree centrality is the number of neighbors divided by the number of possible neighbors (degree / n-1)
degree_centrality = {k: v/(len(G.nodes)-1) for k,v in my_degree.items()}

closeness_centrality = nx.closeness_centrality(G)
ei = nx.eigenvector_centrality(G)
betweenness_centrality = nx.betweenness_centrality(G)

  # Let's store everything in a nice df [DONT round!!]
node_data = pd.DataFrame([degree_centrality,closeness_centrality,ei,betweenness_centrality]).T
node_data = node_data.join(pd.Series(my_degree,name='degree'))
node_data.columns = ['degree_centrality','closeness_centrality','eigenvector_centrality','betweenness_centrality','degree']
# relocating...
node_data = node_data[['degree','degree_centrality','closeness_centrality','eigenvector_centrality','betweenness_centrality']]


# correlation between deg cen and deg should be 1, as they are a linear transformation of each other
node_data[['degree_centrality','degree']].corr()
node_data.applymap(lambda x: round(x,2)).sort_values(by='degree_centrality',ascending=False)

# To be continued..
