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
  
  print(
    ggnetwork(py_df_mod,my_net,
              lgnd_dir = 'horizontal',
              lgnd_pos = c(0.4,.06))
    )
}

map(names(xl)[2],main)
