# ms
## For each user, there is a case line followed by zero or more vote lines.
ms_mat <- function(df){
  case <- df[df$V1=="C",2]
  vote <- sort(unique(df[df$V1=="V",2]))
  mat <- matrix(0, nrow=length(case), ncol=length(vote))
  rownames(mat) <- as.character(case)
  colnames(mat) <- as.character(vote)
  df$chunk <- cumsum(df$V1 == "C")
  for (i in 1:length(case)){
    caseid <- df$V2[which((df$chunk == i) & (df$V1 == "C"))]
    voteid <- df$V2[which((df$chunk == i) & (df$V1 == "V"))]
    for (j in voteid){
      mat[as.character(caseid), as.character(j)] <- 1
    }
  }
  return(mat)
}

ms_train <- read.csv("../data/MS_sample/data_train.csv")[,-1]
ms_test <- read.csv("../data/MS_sample/data_test.csv")[,-1]
ms_train_mat <- ms_mat(ms_train)
save(ms_train_mat, file="../output/ms_train_mat.RData")
ms_test_mat <- ms_mat(ms_test)
save(ms_test_mat, file="../output/ms_test_mat.RData")



# movie
## zero-to-five star ratings are recorded as integers 1-6
movie_mat <- function(df){
  movie <- sort(unique(df$Movie))
  user <- unique(df$User)
  mat <- matrix(NA, nrow=length(user), ncol=length(movie))
  rownames(mat) <- as.character(user)
  colnames(mat) <- as.character(movie)
  for (i in user){
    idx <- which(df$User == i)
    movies <- df$Movie[idx]
    scores <- df$Score[idx]
    movie_idx <- which(movie %in% movies)
    mat[as.character(i), movie_idx] = scores
  }
  return(mat)
}

movie_train <- read.csv("../data/eachmovie_sample/data_train.csv")[,-1]
movie_test <- read.csv("../data/eachmovie_sample/data_test.csv")[,-1]
movie_train_mat <- movie_mat(movie_train)
save(movie_train_mat, file="../output/movie_train_mat.RData")
movie_test_mat <- movie_mat(movie_test)
save(movie_test_mat, file="../output/movie_test_mat.RData")