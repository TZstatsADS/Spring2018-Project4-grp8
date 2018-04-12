msd_weight <- function(df){
  n <- dim(df)[1]
  dissim <- matrix(NA, n, n)
  user <- rownames(df)
  colnames(dissim) <- user
  rownames(dissim) <- user
  for (i in 1:n){
    for (j in 1:n){
      u_i <- df[i,]
      u_j <- df[j,]
      dissim[i,j] <- mean((u_i - u_j)^2)
    }
  }
  L <- max(dissim)
  w <- (L - dissim)/L
  return (w)
}

#ms
msd_weight_ms <- msd_weight(ms_train_mat)
save(msd_weight_ms, file="../output/msd_weight_ms.RData")
#movie
msd_weight_movie <- msd_weight(movie_train_mat)
save(msd_weight_movie, file="../output/msd_weight_movie.RData")