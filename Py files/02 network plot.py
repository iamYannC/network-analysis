      # Highly experimental code #
# Documentation for networkx: https://networkx.org/documentation/stable/index.html
# Start from 01 network init.py

# Set Graph attributes

node_coef = 30

node_sizes = [G.degree(node) * node_coef for node in G.nodes()]

# Define edge with by weight
edge_coef = 1.3
edge_weights = [G[u][v]['weight'] for u,v in G.edges()]
edge_weights = [w * edge_coef for w in edge_weights] # scale down the weights

vcolor='skyblue'
ecolor='grey'

# Dont display all nodes, only those with a minimum degree
min_degree = 5
labels = {node: node for node in G.nodes()}
for node in G.nodes():
    if G.degree(node) < min_degree:
        del labels[node]


# shapes -- cant make it work in the graph
node_shapes = ['o' if int(node) < 200 else 's' if int(node) < 300 else 'p' if int(node) < 400 else 'h' if int(node) < 500 else 'd' for node in G.nodes()]

# All kind of drawing algorithms draw_*

pos_spring = nx.spring_layout(G)
pos_kamkaw = nx.kamada_kawai_layout(G)
pos_circlular = nx.circular_layout(G)


plt.title('Basic draw function for Network')
nx.draw(G, with_labels=True,
           node_size=node_sizes,
           pos=pos_spring,
           node_color=vcolor,node_shape='h',
           edge_color=ecolor,
           width=edge_weights,
           style = '-',
           labels  = labels)  # use ?draw_networkx to see all options
plt.show()
plt.close()



plt.title('Spring draw function for Network')
nx.draw_spring(G, with_labels=True,
                  node_size=node_sizes,
                  node_color=vcolor,
                  edge_color=ecolor,
                  width=edge_weights,
                  style = '-',
                  labels  = labels)  # use ?draw_networkx to see all options
plt.show()
plt.close()


plt.title('Kamada Kawai draw function for Network')
nx.draw_kamada_kawai(G, with_labels=True,
                        node_size=node_sizes,
                        node_color=vcolor,
                        edge_color=ecolor,
                        width=edge_weights,
                        style = '-',
                        labels  = labels)  # use ?draw_networkx to see all options
plt.show()
plt.close()

# other options: shell, circular, spectral, spring, random, (planar) -- planar is not working for > 5 nodes

### The folowing code does the same thing, only it modifies label size
# Define the position of nodes
pos = nx.random_layout(G) # this is a deterministic layout

# Draw the graph
plt.title('Basic draw function for Network')
nx.draw(G, pos,
        with_labels=False,
        node_size=node_sizes,
        node_color=vcolor,node_shape='h',
        edge_color=ecolor,
        width=edge_weights,
        style = '-',
        labels  = labels)  # use ?draw_networkx to see all options
 


def add_label(network, position,label_sizecoef, min_degree):
  
  labels = {node: node for node in network.nodes()}
  label_sizes = {node: 10 + degrees[node] * label_sizecoef for node in network.nodes()}
  # if degrees < minimum degree, remove the label
  for node in network.nodes():
      if degrees[node] < min_degree:
        label_sizes[node] = 0
          

# Draw the labels with varying font sizes
  for node, (x, y) in position.items():
    
      plt.text(x, y, s=node, bbox=dict(facecolor='white', alpha=0.0), horizontalalignment='center', 
               verticalalignment='center', fontsize=label_sizes[node])
  plt.show()

add_label(G,pos,label_sizecoef = 1.1,min_degree=min_degree)  
plt.close()
