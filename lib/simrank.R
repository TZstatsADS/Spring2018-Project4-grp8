##ms
#load pkg and data
library("igraph")
setwd("~/Documents/GitHub/Spring2018-Project4-grp-8/lib")
load("../output/ms_train_mat.RData")

#create the network graph
users <- rownames(ms_train_mat)
votes <- colnames(ms_train_mat)
nodes <- c(users, votes)
df_edges <- data.frame()
for (i in 1:length(users)){
  sink <- names(which(ms_train_mat[i,]==1))
  n_edges <- length(sink)
  edges <- data.frame(rep(users[i],n_edges), sink)
  colnames(edges) <- c("from","to")
  df_edges <- rbind(df_edges, edges)  
}
graph <- graph_from_data_frame(d=df_edges, vertices=nodes, directed=F) 
graph
save(graph, file="../output/graph_ms.RData")

##matrix representation of SimRank
#adjacency matrix
A <- as_adjacency_matrix(graph)
A <- as.matrix(A, "adjacency")
#normalized by columns
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
res <- simrank()
simrank_weight_ms <- res[[5]][1:4151,1:4151]
save(simrank_weight_ms, file="../output/simrank_weight_ms.RData")

##basic simrank equation
#neighbors(graph, v, mode = c("out", "in", "all", "total"))
get_votes <- function(user){
  votes <- neighbors(graph, user, mode = "out")
  return(votes)
}

get_users <- function(vote){
  users <- neighbors(graph, vote, mode = "in")
  return(users)
}

#simrank
user_sim <- diag(length(users))
vote_sim <- diag(length(votes))

user_simrank <- function(u1, u2, C) {
  if (u1 == u2){
    return(1)
  } 
  else {
    pre <- C / (length(get_votes(u1)) * length(get_votes(u2)))
    post <- 0
    for (i in get_votes(u1)){
      for (j in get_votes(u2)){
        o1 <- match(nodes[i], votes)
        o2 <- match(nodes[j], votes)
        #print(paste(o1,o2,post,vote_sim[o1, o2]))
        post <- post + vote_sim[o1, o2]
      }
    }
    return(pre*post)
  }
}

vote_simrank <- function(v1, v2, C) {
  if (v1 == v2){
    return(1)
  } 
  else {
    pre <- C / (length(get_users(v1)) * length(get_users(v2)))
    post <- 0
    for (i in get_users(v1)){
      for (j in get_users(v2)){
        i1 <- match(nodes[i], users)
        i2 <- match(nodes[j], users)
        post <- post + user_sim[i1, i2]
      }
    }
    return(pre*post)
  }
}

simrank <- function(C = 0.8, K = 1, calc_user = T, calc_vote = F){
  
  for (k in 1:K){
    
    if(calc_user){
      for (ui in users){
        for (uj in users){
          i <- match(ui, users)
          j <- match(uj, users)
          sim <- user_simrank(ui, uj, C)
          user_sim[i, j] <- sim
          print(paste(ui, uj, sim))
        }
      }
    }
    
    if(calc_vote){
      for (vi in votes){
        for (vj in votes){
          i <- match(vi, votes)
          j <- match(vj, votes)
          sim <- vote_simrank(vi, vj, C)
          vote_sim[i, j] <- sim
          print(paste(vi, vj, sim))
        }
      }
    }
  }
}
#simrank()