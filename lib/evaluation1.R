## Rank Score
rank_score <- function(predicted_test,true_test){
  d <- 0.02
  rank_mat_pred <- ncol(predicted_test)+1-t(apply(predicted_test,1,function(x){return(rank(x,ties.method = 'first'))}))
  rank_mat_test <- ncol(true_test)+1-t(apply(true_test,1,function(x){return(rank(x,ties.method = 'first'))}))
  vec = ifelse(true_test - d > 0, true_test - d, 0)
  R_a <- apply(1/(2^((rank_mat_pred-1)/4)) * vec,1,sum)
  R_a_max <- apply(1/(2^((rank_mat_test-1)/4)) * vec,1,sum)
  R <- 100*sum(R_a)/sum(R_a_max)
  return(R)
}

## MAE
evaluation.mae <- function(pred.val, true.val){
  mae <- mean(abs(pred.val - true.val), na.rm = T)
  return(mae)
}
