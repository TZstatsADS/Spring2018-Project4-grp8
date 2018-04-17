msd_weight <- function(mat){
  n <- dim(mat)[1]
  dissim <- matrix(NA, n, n)
  user <- rownames(mat)
  colnames(dissim) <- user
  rownames(dissim) <- user
  for (i in 1:n){
    for (j in 1:n){
      ui <- mat[i,]
      uj <- mat[j,]
      dissim[i,j] <- mean((ui - uj)^2, na.rm = T)
    }
  }
  L <- max(dissim, na.rm = T)
  w <- (L - dissim)/L
  return(w)
}

# ms
msd_weight_ms <- msd_weight(ms_train_mat)
save(msd_weight_ms, file="../output/msd_weight_ms.RData")

# movie
msd_weight_movie <- msd_weight(movie_train_mat)
save(msd_weight_movie, file="../output/msd_weight_movie.RData")