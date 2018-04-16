## For Dataset Movie
Transformer <- function(data.set){
  columns.data <- sort(unique(data.set$Movie))
  rows.data <- sort(unique(data.set$User))
  Table_ <- matrix(NA,nrow = length(rows.data), ncol = length(columns.data))
  for(i in 1:length(columns.data)){
    col.name <- columns.data[i]
    index <- which(data.set$Movie == col.name)
    scores <- data.set[index,4] 
    users <- data.set[index,3] 
    index2 <- which(rows.data %in% users)
    Table_[index2,i] = scores
    Table_[!index2,i] = NA
  }
  colnames(Table_) <- columns.data
  rownames(Table_) <- rows.data
  return(Table_)
}

## For Dataset MS
Transformer2 <- function(data){
  user_num <- which(data$V1 == 'C')
  user_id <- data$V2[user_num]
  page_id <- unique(data$V2[which(data$V1 == 'V')])
  Table_2 <- matrix(0, nrow=length(user_id), ncol=length(page_id))
  rownames(Table_2) <- as.character(user_id)
  colnames(Table_2) <- as.character(page_id)
  for (i in 1:length(user_num)){
    start_num <- user_num[i]
    if (i != length(user_num)){
      end_num <- user_num[i+1]
    }
    else {
      end_num <- nrow(data)+1
    }
    
    user_id_mat <- as.character(user_id[i])
    
    for (j in (start_num+1):(end_num-1)){
      page_id_mat <- as.character(data$V2[j])
      Table_2[user_id_mat, page_id_mat] <- 1
    }
  }
  return(Table_2)
}