# rank score 
rank_score <-function(predict, true, d=0, alpha=10){
  
  n <- nrow(true)
  r <- rep(0,n)
  r_max <- rep(0,n)
  
  for(a in 1:n){
    
    predict[a] <- sort(predict[a],decreasing = T)
    true[a,] <- sort(true[a,],decreasing = T)
    
    for(j in 1:ncol(true)){
      
      r[a] <- r[a]+max(predict[a,]-d,0)/2^((j-1)/(alpha-1))
      r_max[a] <- r_max[a]+sum(max(true[a,]-d,0)/2^((j-1)/(alpha-1)))
      
    }
  }
  
  score <- 100*sum(r)/sum(r_max)
  return(score)
}

# MAE
MAE <- function(pred, true){
  mae <- mean(abs(pred - true), na.rm = T)
  return(mae)
}

# ROC sensitivity
library("pROC")
ROCsensitivity <- function(pred, true){
  ## 0-5 star ratings are recorded as integers 1-6
  ## 0-2 noise vs 3-5 signal
  pred <- ifelse(round(pred)>=4,1,0)
  true <- ifelse(true>=4,1,0)
  
  roc_obj <- roc(pred, true)
  return(roc_obj$sensitivities)
}