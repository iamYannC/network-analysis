# Libraries ---------------------------------------------------------------

library(tidyverse)
library(network)
library(GGally)
library(ggnet)

# Load Data ---------------------------------------------------------------

xl <- purrr::map(2:5,\(tab) readxl::read_xlsx('input files/matrixcorrect.xlsx', sheet = tab,skip = 1))
xl <- xl |> purrr::set_names(c('all','pinks','greens','hetero'))
matrices <- vector('list', length(xl))



# Adjacency Matrix ---------------------------------------------------------
for (i in 1:length(xl)){
  
  dfadj <- as.data.frame(xl[[i]])
  rownames(dfadj) <- dfadj[,1]
  dfadj <- xl[[i]][,-1]
  dfadj[is.na(dfadj)] <- 0
  dfadj_mat <- as.matrix(dfadj)
  rownames(dfadj_mat) <- colnames(dfadj_mat) 

# Initialize Network ------------------------------------------------------

# Create a simple network
net <- network::network(dfadj_mat, directed=FALSE)

# Remove nodes with 0 degree
net <- network::delete.vertices(net, which(sna::degree(net)==0))
# Set Edges Attributes ----------------------------------------------------

# Set edge weights based on the adjacency matrix
# Edge list
edge_df <- network::as.edgelist(net)
edge_df <- tibble::tibble(
  from = network::network.vertex.names(net)[edge_df[,1]],
  to = network::network.vertex.names(net)[edge_df[,2]]
)

# Based on the adjacency matrix, get the weights
weights <- numeric(length = nrow(edge_df))
names(weights) <- paste(edge_df$from, edge_df$to,sep = '<=>')

for(v in network::network.vertex.names(net)){
  for (w in network::network.vertex.names(net)){
    if(max(dfadj_mat[v,w], dfadj_mat[w,v]) > 0){
      weights[paste(v,w,sep = '<=>')] <- max(dfadj_mat[v,w], dfadj_mat[w,v])
    }
  }
}
edge_df$weight <- weights[1:length(net$mel)]
network::set.edge.attribute(net, "width", edge_df$weight)

# Set Edge labels
edge_df$label <- ifelse(edge_df$weight > 2,names(edge_df$weight),NA) # x > 0 means all labels
network::set.edge.attribute(net, "label", edge_df$label)

# Set edge color if larger than 1
edge_col <- ifelse(network::get.edge.attribute(net,'width') > 1, "grey10", "grey90")
network::set.edge.attribute(net, "color", edge_col)

# Set edge alpha based on width
edge_alpha <- ifelse(network::get.edge.attribute(net,'width') > 1, 1, 0.3)
network::set.edge.attribute(net, "alpha", edge_alpha)

# Set Vertices (Nodes) Attributes -------------------------------------------
node_df <- tibble::tibble(name = network::network.vertex.names(net))

# Set 'group' attribute to nodes/vertices based on first digit of their name
network::set.vertex.attribute(net, "group", paste0('group',substr(network::network.vertex.names(net), 1, 1)))
node_df$group <- network::get.vertex.attribute(net, "group")

# --- 2 Custom functions to get node's degree and labels 

# Get node weighted degree
get_degrees <- function(net, adj_matrix = dfadj_mat){
  #' Get the degree of each node in a network
  #'
  #' This function iterates over the adjacency matrix and sums the rows and columns to get the weighted degree of each node
  #'
  #' @param net A network object
  #' @param adj_matrix An adjacency matrix, defaults to pre-proccessed matrix
  #' @return A names numeric vector with the degree of each node in the network. can be directly passed to set.vertex.attribute
  
  node_name <- network::network.vertex.names(net)
  all_items <- numeric(length = length(node_name))
  names(all_items) <- node_name
  all_items <- all_items[node_name]
  
  df.inner <- dfadj_mat
  rownames(df.inner) <- colnames(df.inner)

  # iterate over the nodes, sum rows and columns
  for (node in node_name){
    
    all_items[node] <- sum(df.inner[,node],df.inner[node,])
    
  }
  return(all_items)
}

# Get labels to plot
get_labels <- function(degrees_output,k){
  #' Get the labels of the N most valuable nodes
  #' 
  #' This function returns the labels of the N most valuable nodes in the network, based on their degree
  #' 
  #' @param degrees_output A named numeric vector with the degree of each node in the network. the direct output of `my_degree()`
  #' @param k The number of nodes to return. If k < 1, it will return the nodes with degree higher than the k-th percentile
  #' @return A character vector with the labels of the N most valuable nodes
  
  if(k < 1){
    t <- quantile(degrees_output, k,type = 6)
    labs <- ifelse(degrees_output > t, names(degrees_output), NA)
  } else{
    vnames <- names(sort(degrees_output, decreasing = T)[1:k])
    labs <- ifelse(names(degrees_output) %in% vnames, names(degrees_output), NA)
  }
  return(labs)
}

# ---

# Set node size based on their degree
network::set.vertex.attribute(net, "size", get_degrees(net))
node_df$size <- network::get.vertex.attribute(net, "size")

# Set node labels (names to plot)
network::set.vertex.attribute(net, "label", get_labels(get_degrees(net), 0.75))
node_df$label <- network::get.vertex.attribute(net, "label")



# Control Position --------------------------------------------------------

# Set node position using sna::gplot_layout_* functions [circular is the simplest]
      # node_position <- sna::gplot.layout.eigen(net,
      #                                          layout.par = list(var = 'raw',
      #                                                            evsel = 'size'))
      # 
      # # or
      # node_position <- sna::gplot.layout.kamadakawai(net,
      #                                          layout.par = list(niter = 500,
      #                                                            sigma = 0.1))
# or -- best!!!! spring with mass = 0.5
node_position <- sna::gplot.layout.spring(net,
                                         layout.par = list(mass = 0.5)
                                         )

# de-seelct x and y from node_df if exists
# try(node_df <- node_df %>% select(-x,-y))

colnames(node_position) <- c("x", "y")
node_df <- bind_cols(node_df,node_position)

network::set.vertex.attribute(net, "x", node_df$x)
network::set.vertex.attribute(net, "y", node_df$y)

  matrices[[i]] <- list(xl = xl[[i]],
                        net = net,
                        node_df = node_df,
                        edge_df = edge_df,
                        plot = NA)
  rm(node_position, edge_df, net)
}



# Plot Network ------------------------------------------------------------

plots <- map(1:4,\(i) {
set.seed(2)
ggnet::ggnet2(matrices[[i]]$net, 
              mode = c('x','y'),
              shape.legend = 'Groups',
              node.shape = 'group',
              node.size  = "size",
              node.color = 'grey30',
              # node.label = "label",
              label.color = "skyblue",
              
              edge.size = "width",
              edge.color = "color",
              edge.alpha = network::get.edge.attribute(matrices[[i]]$net, 'alpha'),
              edge.label.fill = NA,
              edge.label.size = 5,
              
) + 
  geom_label(aes(label = matrices[[i]]$node_df$label),
             label.size = unit(1,'mm'),
             label.padding = unit(.7,'mm'),
             label.r = unit(1,'mm'),
             size = unit(4,'cm'),
             color = "deeppink",
             fontface = 'bold',
             alpha = 0.8,
             nudge_y = sample(c(-.1,.1),sum(complete.cases(matrices[[i]]$node_df$label)),T)
  ) +
  guides('size' = F,
         shape = guide_legend(title.position = "top",
                              title.hjust = 0.5,
                              direction = "horizontal",
                              override.aes = list(size = 8)
         )
  ) + 
  theme(legend.position = c(.2,.08),
        legend.title = element_text(face = 'bold'),
        legend.key.size = unit(.001,'pt')
  ) +  
  ggtitle(glue::glue("Network of {names(xl)[i] |> str_to_title()}"))
})


for(i in 1:length(matrices)){
  matrices[[i]]$plot <- plots[[i]]
}

map(1:4,\(x) print(matrices[[x]]$plot))
walk(1:4,\(x) ggsave(glue::glue("output files/net_{names(xl)[x]}2.png"), matrices[[x]]$plot, width = 12, height = 9,dpi = 300))
