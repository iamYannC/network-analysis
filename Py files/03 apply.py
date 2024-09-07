import pandas as pd 
import networkx as nx

sheets_names = {1:'all',2:'pinks',3:'greens',4:'hetero'}

xl = pd.read_excel(r"C:\Users\97253\Documents\R\network-analysis\input files\matrixcorrect.xlsx",sheet_name=list(sheets_names.keys()),index_col=0,skiprows=1)
# fillna with 0 for all xl sheets and rename
xl = {sheet:xl[sheet].fillna(0) for sheet in xl.keys()}
xl = {sheets_names[sheet]:xl[sheet] for sheet in xl.keys()}

# Create the graphs (G) for each network
G = {net: nx.from_pandas_adjacency(xl[net], create_using=nx.Graph) for net in sheets_names.values()}

# Remove all nodes with no edges
{net: nx.number_of_isolates(G[net]) for net in G.keys()}
{net: G[net].remove_nodes_from(list(nx.isolates(G[net]))) for net in G.keys()}

# Check the number of nodes after removing isolates
{net: nx.number_of_nodes(G[net]) for net in G.keys()}

# ADD ATTRIBUTES
# Nodes

# Each node has a group attribute -- edit to meaningful group names!!!
group_labels = {1:'group1',2:'group2',3:'group3',4:'group4',5:'group5'}

{net: nx.set_node_attributes(G[net], {node: group_labels[int(str(node)[0])] for node in G[net].nodes()}, 'group') for net in G.keys()}

G['greens'].nodes(data=True) # check the nodes attributes

{net: nx.set_node_attributes(G[net], nx.betweenness_centrality(G[net], weight = 'weight', k = nx.number_of_nodes(G[net])), 'betweenness') for net in G.keys()}
{net: nx.set_node_attributes(G[net], G[net].degree(weight='weight'), 'strength') for net in G.keys()}
{net: nx.set_node_attributes(G[net], nx.eigenvector_centrality(G[net], weight='weight'), 'eigen') for net in G.keys()}
{net: nx.set_node_attributes(G[net], nx.closeness_centrality(G[net], distance=None), 'closeness') for net in G.keys()} # Unweighted since weights represent the capacity of the edge, not distance


# Edges

# set edges weight as attributes..
for net in G.keys():
    for src, tar, w in G[net].edges.data('weight'):
        w = G[net][src][tar]['weight'] # in G (graph) take the edge between src and tar and set the weight attribute to w
# apply
{net: nx.set_edge_attributes(G[net], nx.edge_betweenness_centrality(G[net]), 'betweenness') for net in G.keys()}
# check
{net: nx.get_edge_attributes(G[net],'betweenness') for net in G.keys()}

# Part 2, Put it all in a data frame
# Network Metrics

n_nodes = [nx.number_of_nodes(G[net_name]) for net_name in G.keys()]
n_edges = [nx.number_of_edges(G[net_name]) for net_name in G.keys()]
is_connected = [nx.is_connected(G[net_name]) for net_name in G.keys()]
distance = [nx.average_shortest_path_length(G[net_name]) if nx.is_connected(G[net_name]) else None for net_name in G.keys()]
diameter = [nx.diameter(G[net_name]) if nx.is_connected(G[net_name]) else None for net_name in G.keys()]
density = [nx.density(G[net_name]) for net_name in G.keys()]
sum_weights = [sum([G[net_name][u][v]['weight'] for u,v in G[net_name].edges()]) for net_name in G.keys()]

net_df = pd.DataFrame({'network':list(G.keys()),
                'net_n_nodes':n_nodes,
                'net_n_edges': n_edges,
                'net_is_connected':is_connected,
                'net_distance':distance,
                'net_diameter':diameter,
                'net_density':density,
                'net_sum_weights':sum_weights
                })

# Edges Centrality

edges_df = pd.DataFrame(columns = ['network','node1','node2','edge_weight','edge_betweenness'])
for net_name in G.keys():
    edges_df_net = pd.DataFrame(G[net_name].edges(data=False), columns = ['node1','node2'])
    edges_df_net['edge_weight'] = nx.get_edge_attributes(G[net_name],'weight').values()
    edges_df_net['edge_betweenness'] = nx.get_edge_attributes(G[net_name],'betweenness').values()
    edges_df_net['network'] = net_name
    edges_df_net = edges_df_net[['network','node1','node2','edge_weight','edge_betweenness']]
    edges_df = pd.concat([edges_df,edges_df_net])

# Which edge is the most important in each network? -- highest edge betweenness
edges_df.sort_values(by = 'edge_betweenness',ascending = False).groupby('network').head(1)

# Add full paths data
shortest_path = {}
for net_name in G.keys():
    for tar in G[net_name].nodes:
        for src in G[net_name].nodes:
            if nx.has_path(G[net_name],src,tar) and src != tar:
                shortest_path[(tar,src)] = nx.shortest_path(G[net_name],tar,src)

# add network name to shortest_path
shortest_path = {key:val for key,val in shortest_path.items()}


shortest_path_df = pd.DataFrame(shortest_path.items(), columns = ['pair','shortest_path'])
shortest_path_df['distance'] = shortest_path_df['shortest_path'].apply(lambda x: len(x)-1)
# Split pair in shortest_path_df to node1 and node2, drop pair, and join to edges_df
shortest_path_df[['node1','node2']] = pd.DataFrame(shortest_path_df['pair'].tolist(), index=shortest_path_df.index)
shortest_path_df.drop(columns = 'pair', inplace = True)
shortest_path_df = shortest_path_df[['node1','node2','shortest_path','distance']]
# Drop duplicates
shortest_path_df = shortest_path_df[shortest_path_df['node1'] < shortest_path_df['node2']]
# apply
edges_df = shortest_path_df.merge(edges_df, on = ['node1','node2'], how = 'left')
edges_df['network'].fillna(net_name, inplace = True)

# Nodes Centrality

# Let's define a function to calculate the weighted degree centrality
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

# apply across all networks in G:
w_degree_centrality = {net: weighted_degree_centrality(G[net]) for net in G.keys()}

# Not a very pleasnt view but ok...
[sorted(w_degree_centrality[net].items(), key=lambda x: -x[1]) for net in G.keys()]
# set node attribute as degree_centrality, for each network
{net: nx.set_node_attributes(G[net], w_degree_centrality[net], 'degree_centrality') for net in G.keys()}
# sanity check: sum of degrees centrality, per network, should be 2 (undirected, so counted twice)
[sum(nx.get_node_attributes(G[net],'degree_centrality').values()) for net in G.keys()]
 


# Nodes df
nodes_df = pd.DataFrame(columns = ['network','node','node_group','node_strength','node_degree_centrality','node_betweenness','node_eigen','node_closeness'])
for net in G.keys():
    nodes_df_net = pd.DataFrame({
        'network': [net] * len(G[net].nodes()),
        'node': list(G[net].nodes()),
        'node_group': [G[net].nodes[node].get('group', '') for node in G[net].nodes()],
        'node_strength': [G[net].degree(node, weight='weight') for node in G[net].nodes()],
        'node_degree_centrality': [G[net].nodes[node].get('degree_centrality', 0) for node in G[net].nodes()],
        'node_betweenness': [G[net].nodes[node].get('betweenness', 0) for node in G[net].nodes()],
        'node_eigen': [G[net].nodes[node].get('eigen', 0) for node in G[net].nodes()],
        'node_closeness': [G[net].nodes[node].get('closeness', 0) for node in G[net].nodes()]
    })
    nodes_df = pd.concat([nodes_df,nodes_df_net])

nodes_df.sort_values(by = 'node_degree_centrality',ascending = False).groupby('network').head(1)


