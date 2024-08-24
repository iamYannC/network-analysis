library(tidyverse)
library(glue)
# load xlsx ---------------------------------------------------------------
xl <- purrr::map(2:5,\(tab) readxl::read_xlsx('input files/matrixcorrect.xlsx', sheet = tab,skip = 1))
xl <- xl |> purrr::set_names(c('all','pinks','greens','hetero'))

# don't touch original xl, create a modified copy
xlfmt <- xl

# change item names
for(i in 1:length(xlfmt)){
  colnames(xlfmt[[i]]) <- paste(names(xlfmt)[i],colnames(xlfmt[[i]]),sep='_') |> str_remove_all('_...1')
  xlfmt[[i]][,1] <- colnames(xlfmt[[i]])[-1]
}
rm(i)
# write csv ---------------------------------------------------------------
# walk2(xlfmt,names(xlfmt),\(df,df_name) write_csv(df,glue('input files/{df_name}.csv')))
