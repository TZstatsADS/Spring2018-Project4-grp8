# Project 4: Collaborative Filtering

### [Project Description](doc/project4_desc.md)

Term: Spring 2018

+ Group 8
+ Project title: Application of Collaborative Filtering - Based on Different Algorithms
+ Team members
	+ Zheng, Jia jz2891@columbia.edu (Presenter)
	+ Chen, Mengqi mc4396@columbia.edu
	+ Huang, Yuexuan yh2966@columbia.edu
	+ Li, Xueyao xl2719@columbia.edu

+ Project summary: In this project, we applied two algorithms: memory-based algorithm, including Similarity Weight (Spearman Correlation, Mean-square-difference and SimRank), Variance Weight (Used or not) and Selecting Neighbours (Best-n-estimator) and model-based algorithm, including Cluster Models to conduct Collaborative Filtering. And we used two datasets, Anonymous Microsoft Web Data (MS) and EachMovie Dataset (Movie) to evaluate and compare a pair of algorithms. For evaluation part, we compared the performance for these different algorithms by ranked scoring for MS dataset and MAE for Movie dataset.

The following charts give an exhaustive visual understanding of the performance of all the algorithms we used on different datasets.

![Ranked Scoring for MSWEB dataset](/figs/ms_table.png)

![MAE for Eachmovie dataset](figs/movie_table.png)

**Contribution statement**: All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement. 
 
 + **Zheng, Jia**: Cluster models: EM algorithm, 5-fold cross validation, MAE evaluation; Testing report; Presentation
 
 + **Chen, Mengqi**:  
 
 + **Huang, Yuexuan**: 
 
 + **Li, Xueyao**: Data preprocessing for MS and movie data; Similarity Weight: Pearson Correlation, Spearman Correlation, Mean square difference and SimRank; Evaluation: rank score, MAE and ROC; Testing report
 
 
 References used: 
1. 
2.
3.

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
