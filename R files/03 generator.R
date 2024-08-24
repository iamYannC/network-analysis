source('R files/02 functions.R')

# generate everything
 plot_and_stats <- function(i){

   cli::cli_alert_info(paste0("Calculating statistics for group ",str_to_title(names(xl)[i])))
   
   print(plot_net(i))
   get_stats(i)
 }
 
 map(1:length(xl),plot_and_stats) |> set_names(names(xl))
 