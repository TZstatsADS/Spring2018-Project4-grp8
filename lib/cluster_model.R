library(dplyr)

set.seed(2018)



# EM cluster model
EM_ClusterModel <- function(data, C, T, N, M, movie.id, user.id) {
  
  # clusters: C 
  # maximum iterations: T
  
  mu.last <- mu.initial(C)
  gamma.last <- gamma.initial(M,C)
  
  for (t in 1:T) {
    
    pi.est <- responsibilities(data,N,C,gamma.last,mu.last,user.id,movie.id)
    mu.est <- apply(pi.est, 2, mean)
    gamma.est <- gamma.update(data,M,C,movie.id,user.id,pi.est)

    mu.dif <- sum((mu.est-mu.last)^2) 
    gamma.dif <- sum((gamma.est-gamma.last)^2) 
    cat("Iteration:", t, " mu.dif:", mu.dif, " gamma.dif:", gamma.dif, "\n")
    if (mu.dif < 1e-8 & gamma.dif < 1e-2) {break}
    mu.last <- mu.est
    gamma.last <- gamma.est

  }
  return(list(mu = mu.est,gamma = gamma.est,pi = pi.est))
}


# initialize mu
mu.initial <- function(C) {
  mu.random <- runif(C)
  return(mu.random/sum(mu.random))
}


# initialize gamma 
gamma.initial <- function(M,C) {
  gamma <- array(NA, dim = c(M,6,C))
  for (c in 1:C) {
    for(j in 1:M) {
      gamma[j,,c] <- mu.initial(6)
    }
  }
  return(gamma)  
}


# compute responsibilities
responsibilities <- function(data,N,C,gamma,mu,user.id,movie.id) {
  pi <- matrix(nrow = N, ncol = C)
  for (i in 1:N) {
    user.select <- data %>% filter(User == user.id[i])
    movie.index <- match(user.select$Movie, movie.id)
    sum.log <- rep(0,C) 
    for (c in 1:C) {
      for (j in 1:length(movie.index)) {
        sum.log[c] <- sum.log[c] + log(gamma[movie.index[j],user.select$Score[j],c])
      }
    }
    max.sum.log <- max(sum.log)
    pi[i,] <- exp(sum.log-max.sum.log) * mu / rep(exp(sum.log-max.sum.log) %*% mu,C)
    #cat("Pi for user", i, "is", pi[i,], "\n" )
  }
  return(pi)
}


# update gamma
gamma.update <- function(data,M,C,movie.id,user.id,pi) {
  gamma <- array(NA, dim = c(M,6,C))
  for (c in 1:C) {
    pi.select <- pi[,c]
    for (j in 1:M) {
      movie.select <- data %>% filter(Movie == movie.id[j])
      user.index <- match(movie.select$User, user.id)
      indicator <- matrix(ncol = 6, nrow = length(user.index))
      if (sum(pi.select[user.index]) == 0) {
        gamma[j,,c] <- 0
        #cat("gamma for movie", j, "in cluster", c, "is", gamma[j,,c], "\n" )
      }
      else {
        for (k in 1:6) {
          indicator[,k] <- as.numeric(movie.select$Score == k)
        }
        gamma[j,,c] <- as.numeric((pi.select[user.index] %*% indicator)/sum(pi.select[user.index]))
        #cat("gamma for movie", j, "in cluster", c, "is", gamma[j,,c], "\n" )
      }
    }
  }
  return(gamma)
}


# cross validation for choosing cluster size C
cross.validation <- function(dataSet, C_range, F, T) {
  
  user.id <- sort(unique(dataSet$User))
  movie.id <- sort(unique(dataSet$Movie))
  N <- length(user.id)
  M <- length(movie.id)
  
  nonvalidSet <- dataSet

  C_mae   <- matrix(ncol = F, nrow = length(C_range))
  
  for(f in 1:F) {
    
    cat("Cross validation: ", f, "\n")
    
    # separate training set and validation set
    cv.train <- nonvalidSet %>% group_by(User) %>% sample_frac(size=(F-f)/(F+1-f)) %>% arrange(User,Movie) %>% data.frame()
    if (f>1) {cv.train <- rbind(cv.train, setdiff(dataSet, nonvalidSet))}
    if (length(unique(cv.train$Movie)) != length(movie.id)) {
      cv.train <- rbind(cv.train, dataSet %>% filter(Movie %in% setdiff(movie.id,unique(cv.train$Movie))))
    }
    cv.valid <- setdiff(dataSet, cv.train) %>% arrange(User,Movie) %>% data.frame()
    nonvalidSet <- setdiff(nonvalidSet, cv.valid)
    
    
    for (C in 1:length(C_range)) {
      cat("Cluster size C =", C_range[C], "\n")
      cv.params <- EM_ClusterModel(cv.train, C_range[C], T, N, M, movie.id, user.id)
      cv.score.est <- estimate.score(cv.valid, cv.params, movie.id, user.id)
      C_mae[C,f] <- evaluation.mae(cv.score.est, cv.valid$Score)
      cat("MAE =", C_mae[C,f], "\n")
    }
  }
  write.csv(C_mae, "../output/cv_result.csv")
  C_opt <- C_range[which.min(rowMeans(C_mae))]
  cat("Best cluster size C =", C_opt, "\n")
  return(list(C_mae=C_mae, C_opt=C_opt))
}

# estimate scores
estimate.score <- function(testSet, params, movie.id, user.id) {
  
  pi <- params$pi
  gamma <- params$gamma
  
  test.user.id <- sort(unique(testSet$User))
  test.score.est <- c()
  for (id in test.user.id) {
    
    test.user.select <- testSet %>% filter(User == id)
    test.movie.index <- match(test.user.select$Movie, movie.id)
    
    for (j in 1:length(test.movie.index)) {
      score.est <- 0
      for (k in 1:6) {
        score.est <- score.est + 
          as.numeric(gamma[test.movie.index[j],k,] %*% pi[id == user.id,]) * k
      }
      test.score.est <- c(test.score.est, score.est)
    }
  }
  return(test.score.est)
}


# caculate mean absolute error for evaluation
evaluation.mae <- function(pred.val, true.val){  
  mae <- mean(abs(pred.val - true.val), na.rm = T)  
  return(mae)  
}