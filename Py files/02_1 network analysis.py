
      # Highly experimental code #
# Documentation for networkx: https://networkx.org/documentation/stable/index.html
# Start from 01 network init.py

# Network Metrics
net_name = 'pinks'

net_df = pd.DataFrame({'network':net_name,
              'net_n_nodes':nx.number_of_nodes(G),
              'net_n_edges': nx.number_of_edges(G),
              'net_is_connected':nx.is_connected(G),
              'net_distance':nx.average_shortest_path_length(G),
              'net_diameter':nx.diameter(G),
              'net_density':nx.density(G),
              'net_sum_weights':sum([G[u][v]['weight'] for u,v in G.edges()])
              },
              index = [net_name])

# Edges Centrality

# Edges df
edges_df = pd.DataFrame(G.edges(data=False), columns = ['node1','node2'])
edges_df['edge_weight'] = nx.get_edge_attributes(G,'weight').values()
edges_df['edge_betweenness'] = nx.get_edge_attributes(G,'betweenness').values()
edges_df['network'] = net_df.index[0]
edges_df = edges_df[['network','node1','node2','edge_weight','edge_betweenness']]
edges_df.sort_values(by = 'edge_betweenness',ascending = False).head()

# Add full paths data
shortest_path = {}
for tar in G.nodes:
    for src in G.nodes:
      if nx.has_path(G,src,tar) and src != tar:
        shortest_path[(tar,src)] = nx.shortest_path(G,tar,src)

shortest_path_df = pd.DataFrame(shortest_path.items(), columns = ['pair','shortest_path'])
shortest_path_df['distance'] = shortest_path_df['shortest_path'].apply(lambda x: len(x)-1)
# Split pair inshortest_path_dfto node1 and node2, drop pair, and join to edges_df
shortest_path_df[['node1','node2']] = pd.DataFrame(shortest_path_df['pair'].tolist(), index=shortest_path_df.index)
shortest_path_df.drop(columns = 'pair', inplace = True)
shortest_path_df = shortest_path_df[['node1','node2','shortest_path','distance']]
# Drop duplicates
shortest_path_df = shortest_path_df[shortest_path_df['node1'] < shortest_path_df['node2']]

edges_df = shortest_path_df.merge(edges_df, on = ['node1','node2'], how = 'left')
edges_df['network'].fillna(net_name, inplace = True)
# filter out NaN
edges_df[~edges_df['edge_weight'].isna()]
edges_df = edges_df[['network','node1','node2','shortest_path','distance','edge_weight','edge_betweenness']]

# Nodes Centrality

# Degree Centrality -- weighted

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

w_degree_centrality = weighted_degree_centrality(G)
sorted(w_degree_centrality.items(), key=lambda x: -x[1])
nx.set_node_attributes(G, w_degree_centrality, 'degree_centrality')
sum(nx.get_node_attributes(G,'degree_centrality').values())
  # sanity: should be 2, as in undirected graphs the sum of degrees is twice the number of edges


load_centrality = nx.load_centrality(G, weight = None) # Unweighted since wieghts represent the capacity of the edge, not distance
  # Let's store everything in a nice df [DONT round!!]



# Nodes df
nodes_df = pd.DataFrame({
        'network': [net_name] * len(G.nodes()),
        'node': list(G.nodes()),
        'node_group': [G.nodes[node].get('group', '') for node in G.nodes()],
        'node_strength': [G.degree(node, weight='weight') for node in G.nodes()],
        'node_degree_centrality': [G.nodes[node].get('degree_centrality', 0) for node in G.nodes()],
        'node_betweenness': [G.nodes[node].get('betweenness', 0) for node in G.nodes()],
        'node_eigen': [G.nodes[node].get('eigen', 0) for node in G.nodes()],
        'node_closeness': [G.nodes[node].get('closeness', 0) for node in G.nodes()]
    })

