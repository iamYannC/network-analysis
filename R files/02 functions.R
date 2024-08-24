# Functions to then use throught the analysis
library(docstring)


get_degrees <- function(data){
  #' Get the degree of each node in a network
  #'
  #' This is a tailored function to get the degree of each node in a network specified by the input data
  #'
  #' @param data A dataframe with the network data (adj matrix)
  #' @return A tibble with the node and its degree
  #' @examples
    #' map(xl,get_degrees) # given that `xl` is the name of the list of dataframes
    #' get_degrees(xl$all)
  
    
  df <- data.frame(data[,-1])
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
