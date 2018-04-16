## Prediction
pred.matrix.movie <- function(testdat = movie_test, traindat = movie_train, simweights, top.neighbors){
  prediction.matrix = matrix(NA, ncol = ncol(testdat), nrow = nrow(testdat))
  test.loc = is.na(testdat)
  avg.ratings = apply(traindat, 1, mean, na.rm = T)
  neighbor.avg <- apply(traindat,1,mean,na.rm=T)
  for(i in 1:nrow(traindat)){
    train.col = colnames(testdat)[which(!is.na(testdat[i,]))]
    neighbor.weights = simweights[i,top.neighbors[[i]]]
    neighbor.ratings = traindat[top.neighbors[[i]], train.col]
    if(length(top.neighbors[[i]]) <2){
      if(length(top.neighbors[[i]]) <1){
        prediction.matrix[i,!test.loc[i,]] = round(avg.ratings[i],0)
        
      }
      else{
        prediction.matrix[i,!test.loc[i,]] = round(avg.ratings[i] + (neighbor.ratings-neighbor.avg[top.neighbors[[i]]]) * neighbor.weights / sum(neighbor.weights, na.rm = T),0)
      }
    }
    else{
      prediction.matrix[i,!test.loc[i,]] = round(avg.ratings[i] + apply((neighbor.ratings-neighbor.avg[top.neighbors[[i]]]) * neighbor.weights, 2, sum, na.rm=T) / sum(neighbor.weights, na.rm = T),0)
    }
    
  }
  return(prediction.matrix)
}

pred.matrix.ms <- function(testdat = MS_test, traindat = MS_train, simweights, top.neighbors){
  prediction.matrix = matrix(0, ncol = ncol(traindat), nrow = nrow(traindat))
  avg.ratings = apply(traindat, 1, mean, na.rm = T)
  test.col = colnames(testdat)
  test.row = rownames(testdat)
  for(i in 1:nrow(traindat)){
    neighbor.weights = simweights[i,top.neighbors[[i]]]
    neighbor.ratings = traindat[top.neighbors[[i]], ]
    if(length(top.neighbors[[i]]) <2){
      if(length(top.neighbors[[i]]) < 1){
        prediction.matrix[i,] = avg.ratings[i]
      }
      else{prediction.matrix[i,] = avg.ratings[i] + (neighbor.ratings-avg.ratings[top.neighbors[[i]]]) * neighbor.weights / sum(neighbor.weights, na.rm = T)}
    }
    else{
      prediction.matrix[i,] = avg.ratings[i] + apply((neighbor.ratings-avg.ratings[top.neighbors[[i]]]) * neighbor.weights, 2, sum, na.rm=T) / sum(neighbor.weights, na.rm = T)
    }
    
  }
  colnames(prediction.matrix) = colnames(traindat)
  rownames(prediction.matrix) = rownames(traindat)
  prediction1 = prediction.matrix[test.row,test.col]
  return(prediction1)
}