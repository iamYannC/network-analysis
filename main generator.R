source("functions.R")

xl <- read_matrix()
df_py <- read_python()

main <- function(my_name){
  
  adj_matrix <- write_adj(xl,my_name)
  
  inet <- net_init(adj_matrix)
  
  py_df_flt <- filter_py(df_py, my_name)
  
  layout <- custom_layout(my_name,network_obj = inet,
                          layout_function =  igraph::layout_with_kk, 121)
  
  py_df_mod <- modify_py(py_df_flt,layout)
  
  ##
  viz_opt <- 
    tibble(
      network = names(xl),
      lgnd_dir = c('horizontal', 'vertical', 'horizontal', 'vertical'),
      lgnd_pos = list( c(0.54, 1), c(0.1, 0.90), c(0.7, 0.08),c(0.14, 0.85) ) |> set_names(names(xl)),
      s = c(6,4,4,2),
      w = c(2,rep(5,3)),
      label_size_coef = rep(0.35,4),
      node_size_coef = rep(1.1,4),
      xpnd_x = list(c(0.2, 0), c(0.2, 0), c(0.2, 0), c(0.2, 0)) |> set_names(names(xl)),
      xpnd_y = list(c(0.2, 0), c(0.1, 0), c(0.1, 0), c(0.1, 0)) |> set_names(names(xl))
    )

  ##
  print(
    ggnetwork(py_df_mod,my_net,
              w = viz_opt$w[viz_opt$network==my_name],
              s = viz_opt$s[viz_opt$network==my_name],
              lgnd_pos = unlist(viz_opt$lgnd_pos[viz_opt$network==my_name]),
              lgnd_dir = viz_opt$lgnd_dir[viz_opt$network==my_name],
              label_size_coef = viz_opt$label_size_coef[viz_opt$network==my_name],
              node_size_coef = viz_opt$node_size_coef[viz_opt$network==my_name],
              xpnd_x = unlist(viz_opt$xpnd_x[viz_opt$network==my_name]),
              xpnd_y = unlist(viz_opt$xpnd_y[viz_opt$network==my_name])
              )
    )
  # Save as png & svg
  ggsave(glue::glue("output files/net_{my_name}3.png"),
         width = 12, height = 10,dpi = 300)
  
  ggsave(glue::glue("output files/{my_name}_svg.svg"),
         width = 12, height = 10, units = "in", dpi = 300)
}

map(names(xl),main)