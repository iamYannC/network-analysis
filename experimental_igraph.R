# Libraries ---------------------------------------------------------------

library(tidyverse)
library(igraph)

# Load Data ---------------------------------------------------------------

  # Original data
xl <- purrr::map(2:5,\(tab) readxl::read_xlsx('input files/matrixcorrect.xlsx', sheet = tab,skip = 1))
xl <- xl |> purrr::set_names(c('all','pinks','greens','hetero'))
  # Python data
py_net <-  readr::read_csv("output files/Network_df.csv")
py_edge <- readr::read_csv("output files/Edges_df.csv") |> arrange(node1,node2)
py_node <- readr::read_csv("output files/Nodes_df.csv")

nets <- vector('list', length(xl)) |> set_names(names(xl))

for (i in 1:length(xl)){

  # Adjacency Matrix ---------------------------------------------------------
    
  dfadj <- as.data.frame(xl[[i]])
  rownames(dfadj) <- dfadj[,1]
  dfadj <- xl[[i]][,-1]
  dfadj[is.na(dfadj)] <- 0
  dfadj_mat <- as.matrix(dfadj)
  rownames(dfadj_mat) <- colnames(dfadj_mat) 
  
  
  # Initialize Network ------------------------------------------------------
  
  # Create a simple network
  inet <- igraph::graph_from_adjacency_matrix(dfadj_mat,
                                             mode='undirected', # this ensures that the matrix is symmetric, upper tri only is evaluated
                                             weighted = TRUE,
                                             diag = FALSE,
                                             add.rownames = TRUE)
  
  # Remove nodes with 0 degree
    inet <- inet |> 
      igraph::delete_vertices(which(igraph::degree(inet)==0))
    
    # igraph::delete_edges(inet,which(igraph::edge_attr(inet,'weight')==0))
    
  # Matrix looks like that:
    # igraph::as_adj(inet,type = 'upper',sparse = F,attr='weight')
    

# Load Py Data ------------------------------------------------------------

  py_net.net <-  py_net  |> filter(network==names(xl)[i])
  py_edge.net <- py_edge |> filter(network==names(xl)[i]) |> drop_na(edge_weight)
  py_node.net <- py_node |> filter(network==names(xl)[i])
  
  
  py_node.net$shapes <- case_match(py_node.net$node_group,
                             'group1' ~ 'meaningful name for group1',
                             'group2' ~ 'meaningful name for group2',
                             'group3' ~ 'meaningful name for group3',
                             'group4' ~ 'meaningful name for group4',
                             'group5' ~ 'meaningful name for group5',
                             ) 

    # Custom star layout for pink network
  if(names(xl)[i] == 'pinks'){
  lay <-  layout_as_star(inet,center = 2,
                                      order = c(1,12,4,
                                                13,7,14,
                                                15,3,8,
                                                6,9,10,
                                                11,2,5
                                      ))
  } else {
    # fr layout for all others:
    set.seed(123)
    lay <- layout_with_sugiyama(inet)$layout
  }
    # Modify Python data with coordinates (for pink net)
  py_node.net <- py_node.net |> 
    mutate(
      x = lay[,1],
      y = lay[,2]
    )
  py_edge.net <- py_edge.net |> rowwise() |> 
    mutate(
      x = py_node.net$x[py_node.net$node==node1],
      y = py_node.net$y[py_node.net$node==node1],
      xend = py_node.net$x[py_node.net$node==node2],
      yend = py_node.net$y[py_node.net$node==node2],
    ) |> ungroup()
  

# Plot --------------------------------------------------------------------

  gg <- ggplot() +
    geom_curve(data = py_edge.net, aes( x = x, xend = xend,
                                    y = y, yend = yend,
                                    linewidth = edge_weight,
                                    alpha = ifelse(edge_weight > 1, 0.8, 0.4)
    ),
    curvature = 0,lineend = 'round') +
    geom_point(data = py_node.net,aes(x = x,y = y,size = node_strength, shape = shapes),fill="grey10") +
    
    geom_label(data = py_node.net, aes(x = x,y = y, size = node_strength*.35,
                                   label = ifelse(node_strength >= 5, node, NA),
                                   ),
               label.r = unit(0.4, "lines"),
               label.padding = unit(.2, "lines"),
               label.size = unit(0,"lines"),
               fill = 'grey50', alpha = 0.3, color = "white"
    ) +
    labs(title = glue::glue('Network of\n{py_net.net$net_name}'),
         shape="Cluster",x="",y="",
         caption = glue::glue("Group: {py_net.net$network}")
    )+
    scale_size_identity() +
    scale_linewidth_continuous(range = c(.5,3)) +
    scale_shape_manual(values = c(24,22,21,23,25)) +
    scale_y_continuous(expand = expansion(add=1,mult=0))+
    scale_x_continuous(expand = expansion(add=1,mult=0))+
    guides(linewidth="none", size="none", alpha = "none",
           shape = guide_legend(title.position = "top",
                                direction = "vertical",
                                override.aes = list(size = 7)
           )
    ) +
    theme_void(base_size = 15) +
    theme(
      legend.position = c(0.07,.85),
      plot.background = element_blank(),
      panel.background = element_blank(),
      panel.grid = element_blank(), # turn on/off for setting coordinates
      axis.text = element_blank()  # turn on/off for setting coordinates
    )
  
nets[[i]] <- list(
  plot = gg,
  network = inet,
  py_net = py_net.net,
  py_edge = py_edge.net,
  py_node = py_node.net
)  
# rm(list=ls(pattern = "*\\.net"))
}

# save as rds
write_rds(nets, "output files/networks_full.rds")
# save as svg
walk(
  1:length(nets),
  \(i) {
    ggsave(glue::glue("output files/{nets[[i]]$py_net$network}_svg.svg"),
           nets[[i]]$plot, width = 12, height = 10, units = "in", dpi = 300)
  }
)

    # 
    # 
    # # previous plot code ------------------------------------------------------
    # 
    # # Custom Shapes -----------------------------------------------------------
    # # https://r.igraph.org/reference/shapes.html
    # 
    # mytriangle <- function(coords, v = NULL, params) {
    #   vertex.color <- params("vertex", "color")
    #   if (length(vertex.color) != 1 && !is.null(v)) {
    #     vertex.color <- vertex.color[v]
    #   }
    #   vertex.size <- 1 / 200 * params("vertex", "size")
    #   if (length(vertex.size) != 1 && !is.null(v)) {
    #     vertex.size <- vertex.size[v]
    #   }
    #   
    #   symbols(
    #     x = coords[, 1], y = coords[, 2], bg = vertex.color,
    #     stars = cbind(vertex.size, vertex.size, vertex.size),
    #     add = TRUE, inches = FALSE
    #   )
    # }
    # # clips as a circle
    # add_shape("triangle",
    #           clip = shapes("circle")$clip,
    #           plot = mytriangle
    # )
    # 
    # # function to create star shapes:
    # mystar <- function(coords, v = NULL, params) {
    #   vertex.color <- params("vertex", "color")
    #   if (length(vertex.color) != 1 && !is.null(v)) {
    #     vertex.color <- vertex.color[v]
    #   }
    #   vertex.size <- 1 / 200 * params("vertex", "size")
    #   if (length(vertex.size) != 1 && !is.null(v)) {
    #     vertex.size <- vertex.size[v]
    #   }
    #   norays <- params("vertex", "norays")
    #   if (length(norays) != 1 && !is.null(v)) {
    #     norays <- norays[v]
    #   }
    #   
    #   mapply(coords[, 1], coords[, 2], vertex.color, vertex.size, norays,
    #          FUN = function(x, y, bg, size, nor) {
    #            symbols(
    #              x = x, y = y, bg = bg,
    #              stars = matrix(c(size, size / 2), nrow = 1, ncol = nor * 2),
    #              add = TRUE, inches = FALSE
    #            )
    #          }
    #   )
    # }
    # # no clipping, edges will be below the vertices anyway
    # add_shape("star",
    #           clip = shape_noclip,
    #           plot = mystar, parameters = list(vertex.norays = 5)
    # )
    # 
    # # function to create diamond shapes:
    # mydiamond <- function(coords, v = NULL, params) {
    #   vertex.color <- params("vertex", "color")
    #   if (length(vertex.color) != 1 && !is.null(v)) {
    #     vertex.color <- vertex.color[v]
    #   }
    #   vertex.size <- 1 / 200 * params("vertex", "size")
    #   if (length(vertex.size) != 1 && !is.null(v)) {
    #     vertex.size <- vertex.size[v]
    #   }
    #   
    #   symbols(
    #     x = coords[, 1], y = coords[, 2], bg = vertex.color,
    #     squares = cbind(vertex.size, vertex.size),
    #     add = TRUE, inches = FALSE
    #   )
    # }
    # 
    # add_shape("diamond",
    #           clip = shapes("circle")$clip,
    #           plot = mydiamond
    # )
    # 
    # s <- py_node$node_strength
    # w <- py_edge$edge_weight
    # 
    # plot(inet,
    #      layout =  star_lyout_pinks,
    #      margin = -0.15,
    #      vertex.color = ifelse(s > 5,'#a5faC8','grey90'),
    #      vertex.size = s * 1.5,
    #      vertex.label = ifelse(s >= 5, py_node$node, NA),
    #      vertex.label.color = 'black',
    #      vertex.label.cex = s * 0.15,
    #      vertex.shape = V(inet)$shape,
    #      edge.color = ifelse(w > 1, "grey10", "grey90"),
    #      edge.width = w * 1.5,
    #      # edge.label = ifelse(w > 1, w, NA),
    #      edge.label.color = 'black',
    #      main = paste0('Network graph of\n',py_net$net_name)
    # )  
    # # shapes: square, star, circle, triangle, pie, diamond