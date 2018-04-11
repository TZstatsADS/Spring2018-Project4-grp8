## Variance Weighting
find_var <- function(mat=movie_train){
  vari <- apply(mat, 2, var, na.rm=TRUE)
  var_max <- max(vari, na.rm = TRUE)
  var_min <- min(vari, na.rm = TRUE)
  vi <- (vari - var_min)/var_max
  return(vi)
}

variance_weight_assign <- function(i, j, vi, mat=movie_train){
  zai <- scale(mat[i, ])
  zui <- scale(mat[j, ])
  index <- intersect(which(!is.na(zai)), which(!is.na(zui)))
  wau <- sum(vi[index]*zai[index]*zui[index])/sum(vi[index])
  return(wau)
}

variance_weight_matrix <- function(mat_dim_1, mat = movie_train){
  mat_weight = matrix(1, nrow=mat_dim_1, ncol=mat_dim_1)
  vi <- find_var(mat = mat)
  for (i in 1:(mat_dim_1-1)){
    print(i)
    print(Sys.time())
    for (j in (i+1):mat_dim_1){
      wau <- variance_weight_assign(i, j, vi, mat = movie_train)
      mat_weight[i, j] <- wau
      mat_weight[j, i] <- wau
    }
  }
  return(mat_weight)
}