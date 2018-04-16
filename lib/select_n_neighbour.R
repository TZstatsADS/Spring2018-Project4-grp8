## Selecting Neighborhoods
neighbors.select <- function(simweights, n){
  top.neighbors = list()
  coverage = 0
  for(i in 1:nrow(simweights)){
    index_ = head(order(simweights[i,], decreasing=T),n)
    top.neighbors[[i]] = index_
    coverage = coverage + length(top.neighbors[[i]])
  }
  return(top.neighbors)
}