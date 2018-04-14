msd_weight2 <- function(df){
  n_user <- dim(df)[1]
  n_item <- dim(df)[2]
  c <- df
  c[which(c>0)] <- 1
  s <- df
  dissim <- matrix(NA, n_user, n_user)
  user <- rownames(df)
  colnames(dissim) <- user
  rownames(dissim) <- user
  for (i in 1:n_user){
    for (j in 1:n_user){
      t <- 0
      b <- 0
      for (n in 1:n_item){
        t <- t + c[i,n]*c[j,n]*(s[i,n]-s[j,n])^2
        b <- b + c[i,n]*c[j,n]
      }
      dissim[i,j] <- t/b
      print(paste(i,j,t,b,dissim))
    }
  }
  L <- max(dissim)
  w <- (L - dissim)/L
  return (w)
}