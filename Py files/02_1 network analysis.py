
      # Highly experimental code #
# Documentation for networkx: https://networkx.org/documentation/stable/index.html
# Start from 01 network init.py

# check if length of connected components equals number of nodes, meaning the graph is connected 
len_connected = len(list(nx.connected_components(G))[0])
n_nodes = nx.number_of_nodes(G)
len_connected == n_nodes # it is.

# Let's analyse shortest paths...
shortest_path = {}
for tar in G.nodes:
    for src in G.nodes:
      if nx.has_path(G,src,tar) and src != tar:
        shortest_path[(tar,src)] = nx.shortest_path(G,tar,src)

for i in shortest_path.items():
    print(i)

# Edge Centrality

  # Total number of paires = n(n-1)/2
  n = nx.number_of_nodes(G)
  total_pairs = n * (n-1) / 2
edge_centrality = nx.edge_betweenness_centrality(G)

# Edges df
edges_df = pd.DataFrame(G.edges(data=True), columns=['node1', 'node2', 'weight'])
edges_df['weight'] = edges_df['weight'].apply(lambda x: x['weight'])

# add edge centrality to the df
edges_df['edge_centrality'] = edges_df.apply(lambda x: edge_centrality[(x['node1'],x['node2'])],axis=1)

edges_df.sort_values(by = 'edge_centrality',ascending = False).head()


# Community detection - Girvan-Newman Algorithm (experimental -- and honestly not very meaningful) 
n_iter = 5
g_iter = G.copy()
for i in range(n_iter):
  delete_this = sorted(nx.edge_betweenness_centrality(g_iter).items(), key = lambda p: -p[1])[0][0] # sort by the second element of each pair, which is the actual betweenness value. negative for descending order. then retreive the name of the edge (node1 and node2)
  g_iter.remove_edge(*delete_this) # (a tuple). * unpacks the tuple
  plt.title(f'Iteration {i+1}, deleted edge: {delete_this}')
  nx.draw_shell(g_iter, with_labels=True)
  plt.show()
  plt.close()
   


# Node Centrality -- manual calculations

def weighted_degree_centrality(G):
    """
    Calculate the weighted degree centrality for each node. consider the weight of the edges.
    
    Parameters:
    G (networkx.Graph): A weighted, undirected graph.
    
    Returns:
    dict: A dictionary with nodes as keys and their weighted degree centrality as values.
    """
    # Calculate the total weight of all edges in the graph
    total_weight = sum(weight for _, _, weight in G.edges(data='weight'))
    
    # Calculate the weighted degree (also: strength) for each node
    weighted_degrees = {node: sum(weight for _, _, weight in G.edges(node, data='weight'))
                        for node in G.nodes()}
    
    # Divide the weighted degrees by the total weight
    w_centralities = {node: degree / total_weight for node, degree in weighted_degrees.items()}
    
    return w_centralities


    # Calculate weighted degree centrality
    degree_centrality = weighted_degree_centrality(G)
    sorted(degree_centrality.items(), key=lambda x: -x[1])
   
    sum(degree_centrality.values()) # sanity: should be 2, as in undirected graphs the sum of degrees is twice the number of edges

sorted(degree_centrality.items(), key = lambda x: -x[1])
closeness_centrality = nx.closeness_centrality(G, distance=None) # Unweighted since weights represent the capacity of the edge, not distance
ei_centrality = nx.eigenvector_centrality(G, weight = 'weight')
betweenness_centrality = nx.betweenness_centrality(G, weight = 'weight', k = n_nodes)
load_centrality = nx.load_centrality(G, weight = None) # Unweighted since wieghts represent the capacity of the edge, not distance
  # Let's store everything in a nice df [DONT round!!]
node_data = pd.DataFrame([degree_centrality,closeness_centrality,ei_centrality,betweenness_centrality]).T
node_data = node_data.join(pd.Series(my_degree,name='degree'))
node_data.columns = ['degree_centrality','closeness_centrality','eigenvector_centrality','betweenness_centrality','degree']
# relocating...
node_data = node_data[['degree','degree_centrality','closeness_centrality','eigenvector_centrality','betweenness_centrality']]


# correlation between deg cen and deg should be 1, as they are a linear transformation of each other
node_data[['degree_centrality','degree']].corr()
node_data.applymap(lambda x: round(x,2)).sort_values(by='degree_centrality',ascending=False)

# To be continued..
