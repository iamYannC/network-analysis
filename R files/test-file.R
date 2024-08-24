# For some reason igraph's degree counts different than mine. i tested and i prefer mine.
compare_deg <- function(data){
  
  # let's get rid of the pinks_ prefix
  adj_matrix <- as.matrix(data[,-1])
  adj_matrix[is.na(adj_matrix)] <- 0
  diag(adj_matrix) <- 0
  
  g <- graph_from_adjacency_matrix(adj_matrix,
                                   mode = "undirected",
                                   weighted = TRUE)
  
  
  
  bind_cols(get_degrees(data),
            degree_auto = degree(g)
  ) |> 
    filter(degree_auto != degree)
  
}
map(xl,compare_deg)
