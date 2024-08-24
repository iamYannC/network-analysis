source('R files/01 csv from xlsx.R')

# Functions to then use through the analysis
library(docstring)
library(igraph)
library(ggnet)

get_degrees <- function(xl_tab){
  #' Get the degree of each node in a network
  #'
  #' This is a tailored function to get the degree of each node in a network specified by the input data
  #'
  #' @param data A dataframe with the network data (adj matrix)
  #' @return A tibble with the node and its degree
  #' @examples
    #' map(xl,get_degrees) # given that `xl` is the name of the list of dataframes
    #' get_degrees(xl$all)
  
    
  df <- data.frame(xl_tab[,-1])
  rownames(df) <- colnames(df)
  all_items <- numeric(length = length(colnames(df)))
  
  for(i in seq_along(all_items)){
    all_items[i] <-sum(df[colnames(df)[i],]
                       ,df[,colnames(df)[i]],na.rm = T)
  }
  
  tibble(
    node = colnames(df),
    degree = all_items
  )
}

make_graph <- function(xl_tab){
  #' Create a graph from an adjacency matrix
  #' 
  #' This function creates a graph from an adjacency matrix. It is tailored to the data in this project.
  #' 
  #' @param xl_tab A dataframe with the network data (adj matrix)
  #' @return A graph object
  #' @examples
  #' make_graph(xl$all)
  
  adj_matrix <- as.matrix(xl_tab[,-1])
  adj_matrix[is.na(adj_matrix)] <- 0
  diag(adj_matrix) <- 0
  
  # actual graph
  
  g <- graph_from_adjacency_matrix(adj_matrix,
                                   mode = "undirected",
                                   weighted = TRUE)
  
  g <- delete_vertices(g, V(g)[igraph::degree(g) == 0])
  # The degree function is inferior to mine, but is still safe to use to detect 0 degree nodes
  
  # V(g)$degrees <- get_degrees(xl_tab) |> filter(degree!=0)%>%.$degree # If i want to store degrees in V(g)...
  return(g)
}

plot_net <- function(i){
  #' Plot a network
  #' 
  #' This function plots a network from an adjacency matrix. It is tailored to the data in this project.
  #' 
  #' @param i The index of the network in the list of dataframes (R file 01)
  #' @examples
    #' plot_net(1)
    #' map(1:4,plot_net)
  
  # inner definitions -- can change but dont put as function argument, its not important.
  cols <- c('tomato','lightpink','seagreen','gold3') 
  node_size <- get_degrees(xl[[i]])$degree[get_degrees(xl[[i]])$degree>0]
  
  g <- make_graph(xl[[i]])
  title <- names(xl)[i]
  color <- cols[i]
  
  # simple network plot - this should definitly be modified
  ggnet2(g, 
         mode = "fruchtermanreingold",
         node.size = degree(g),
         node.color = color,
         # edge.size = E(g)$weight,
         edge.color = "gray50",
         edge.alpha = 0.5,
         label = TRUE,
         label.size = 3) +
    theme_minimal() +
    ggtitle(paste0("Questionnaire Item Network for group ",str_to_title(title))) +
    theme(plot.title = element_text(hjust = 0.5),
          legend.position = 'none')  # Center the title
}

get_stats <- function(i){
  #' Get network statistics
  #' 
  #' This function calculates network statistics for a given network. It is tailored to the data in this project.
  #' 
  #' @param i The index of the network in the list of dataframes (R file 01)
  #' @return A list with node and global metrics
  #' @examples
    #' get_stats(1)
    #' map(1:4,get_stats)

    g <- make_graph(xl[[i]])
  node_metrics <- tibble(
    Node = V(g)$name,
    Degree = get_degrees(xl[[i]])$degree[get_degrees(xl[[i]])$degree>0],
    Betweenness = betweenness(g),
    Closeness = closeness(g),
    Eigenvector = eigen_centrality(g)$vector
  )
  
  
  # Calculate global network metrics
  global_metrics <- list(
    Density = edge_density(g),
    Transitivity = transitivity(g),
    Average_Path_Length = mean_distance(g),
    Diameter = diameter(g)
  )
  return(list(
    node_metrics = node_metrics,
    global_metrics = global_metrics
  ))
}


# TODO --------------------------------------------------------------------

# There is a bug regarding the node size definition, or it might be that i am unable to delete size 0 nodes,
# because when i call ggnet2 with the sizes(only > 0) i get an error
# Error in is.null(x) || is.na(x) : 
  # 'length = 15' in coercion to 'logical(1)'
# in this case, 15 is the number of nodes with degree > 0, but the data is 34 rows long, so it should be 34
