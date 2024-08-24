source('R files/01 csv from xlsx.R')
# a simpler version --older and working to plot GRAPHS
library(ggnet)
library(GGally)
library(sna)
library(ggtext)
library(network)

map(1:length(xl),\(i) {
  
  # Initial load & transformation 
  dfadj <- as.data.frame(xl[[i]])
  rownames(dfadj) <- dfadj[,1]
  dfadj <- xl[[i]][,-1]
  dfadj[is.na(dfadj)] <- 0
  dfadj_mat <- as.matrix(dfadj)
  
  
  # Transform into a network
  my_net <- network::as.network(dfadj_mat)
  
  # Set informative names to each cluster (1xx, 2xx etc...)
  clusters <- case_when(
    as.numeric(str_extract(network.vertex.names(my_net),"\\d")) == 1 ~ "Informative name 1",
    as.numeric(str_extract(network.vertex.names(my_net),"\\d")) == 2 ~ "Another informative 2",
    as.numeric(str_extract(network.vertex.names(my_net),"\\d")) == 3 ~ "Very informative 3",
    as.numeric(str_extract(network.vertex.names(my_net),"\\d")) == 4 ~ "Not so informative 4",
    as.numeric(str_extract(network.vertex.names(my_net),"\\d")) == 5 ~ "Cluster begins with 5",
    as.numeric(str_extract(network.vertex.names(my_net),"\\d")) == 6 ~ "Done 6",
  )
  my_net %v% "cluster" = clusters
  
  shape_palette <-15:20
  names(shape_palette) <- unique(clusters)[complete.cases(unique(clusters))]
  
  #### Positioning mode:
  mode_ <- "fruchtermanreingold"     # modes:  "kamadakawai" "fruchtermanreingold" "circle" "target", "hall" "spring" and more from sna package
  niters_ <- 4000
  
  #### Vertices / Nodes:
  # function to get top N valuable nodes
  top_n_nodes <- function(n,network_=my_net){
    
    if(n==0) return(NULL)
    
    if(n > sna::degree(network_)[sna::degree(network_)>0] |> length()){
      n <-  sna::degree(network_)[sna::degree(network_)>0] |> length() }
    
    top_x <- which(sna::degree(network_) %in%  sort(sna::degree(network_),decreasing = TRUE)[1:n])
    return(map_vec(top_x,\(x) network_$val[x][[1]][[2]])  )
  }
  
  node_col <- "grey10"
  # Limit the size of the nodes (range)
  node_size_range <- seq(12,3,-3)
  # Pick nodes to label on the graph
  node_labels <- top_n_nodes(5)
  node_label_size <- 3
  node_label_col <- "white"
  
  
  #### Edges:
  edge_scale <- .5
  edge_size <- as.vector(as.matrix(dfadj_mat))[dfadj_mat>0]*edge_scale
  edge_col <- "lightblue"
  
  # Pick the size of the legend's keys
  lgnd_key_size <- 8
  lgnd_position_coords <- c(0.2,0.85)
  lgnd_title <- "Cluster"
  
  
  
  set.seed(2)
  ggnet2(my_net, shape = "cluster",size = "degree",
         node.color=node_col,
         edge.color = edge_col,
         label.color =node_label_col,
         mode = mode_,size.min = 1,
         shape.legend = lgnd_title,
         shape.palette = shape_palette,
         label = node_labels,
         label.size = node_label_size,
         edge.size = edge_size#,
         # layout.par = list(niter = niters_,
         # cell.pointpointrad = 10)
  ) +
    scale_size_discrete("",range = c(min(node_size_range),
                                     max(node_size_range)),
                        breaks = node_size_range) +
    guides(size = "none",
           shape = guide_legend(title.position = "top",
                                title.hjust = 0.5,
                                direction = "vertical",
                                override.aes = list(size = lgnd_key_size)
           )
    ) +
    theme(legend.position = lgnd_position_coords) +
    ggtitle(glue("Network of {names(xl)[i] |> str_to_title()}"))
  
  ggsave(glue('output files/net_{names(xl)[i]}.png'),width = 14,height = 10,dpi = 300)
  
})
# get max
# my_net$val[which.max(sna::degree(my_net))]