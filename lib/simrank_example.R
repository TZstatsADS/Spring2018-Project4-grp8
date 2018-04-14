library("igraph")
nodes <- c("A","B","sugar","frosting","eggs","flour")
edges <- data.frame(c("A","A","A","B","B","B"),
                    c("sugar","frosting","eggs","frosting","eggs","flour"))
colnames(edges) <- c("from","to")
graph <- graph_from_data_frame(d=edges, vertices=nodes, directed=F)
graph
plot(graph)
## matrix representation of SimRank
# adjacency matrix
A <- as_adjacency_matrix(graph)
A <- as.matrix(A, "adjacency")
# normalized by columns
W <- scale(A, center=FALSE, scale=colSums(A))
I <- diag(length(nodes))
S <- diag(length(nodes))
simrank <- function(C = 0.8, K = 5){
  res <- list()
  for (k in 1:K){
    X <- t(W) %*% S %*% W
    D <- I
    diag(D) <- diag(X)
    S <- C*X - C*D + I
    res[[k]] <- S
  }
  return(res)
}
simrank()