---

layout: post
title: Rank Metrics&Loss
date: 2021-07-28 16:19:00
categories: [AI]
tags: [AI，NLP，Rank]

---

## 排序评价
### Precision@K

$$
precision@k=\frac{count_{pos}}{k}
$$

其中$count_{pos}$为topk中正例个数，是否是正例使用threshold来判别。

$$
\begin{cases}
 & pos, &\text{if} & label >threshold \\ 
 & neg, &\text{if} & label<= threshold
\end{cases}
$$

取值范围$[0,1]$

### AveragePrecision

$$
AveragePrecision = \frac{1}{N}\sum_{k=1}^{N} precision@k
$$

取值范围$[0,1]$

### MeanAveragePrecision

$$
MeanAveragePrecision = \frac{1}{N}\sum_{k\in position_{label=pos}}^{N} precision@k
$$

其中$  position_{label>threshold} $为所有正例被排序的位置

含义：分别计算precision@k（k为推荐序列中正例被排序的位置）的平均值。
例如：排序了5个，其中1，3，5为正例，则
MeanAveragePrecision=mean([precision@1,precision@3,precision@5])

取值范围$[0,1]$

### MeanReciprocalRank

$$
MeanReciprocalRank=\frac{1}{k}
$$

k为排序中第一个正例位置

取值范围$(0,1]$
### CumulativeGain

$$
CG_{k} = \sum_{i=1}^{k}rel_{i}
$$

$rel_{i}$是第$ i $个位置的评分

取值范围$[0,+\propto)$

缺点：前后位置得分未做区分

### DiscountedCumulativeGain

$$
DCG_{k} = \sum_{i=1}^{k}\frac{2^{rel_{i}}-1}{\log_{2}\left(i+1\right)}
$$

$rel_{i}$是第$ i $个位置的评分

取值范围$[0,+\propto)$

缺点：不同算法得分不好做比较

### NormalizedDiscountedCumulativeGain

$$
nDCG_{k} = \frac{DCG_{k}}{IDCG_{k}}
$$

$IDCG_{k}$是按评分rank的理想得分，相当于做得分的归一化

$$
IDCG_{k} = \sum_{i=1}^{\left|  REL_{k}\right|}\frac{2^{rel_{i}}-1}{\log_{2}\left(i+1\right)}
$$

## 排序损失
### RankCrossEntropyLoss
example：一个正例样本1， 和多个负例样本0 label = [1,0,0,0...]

$$
RankCrossEntropyLoss = CrossEntropy(pred, label)
$$

注意：此处必须构造数据为一个正样本1和多个负样本0，这样才满足概率分布的形式。

### RankHingeLoss

$$
y = 
\begin{cases}
 & 1, &\text{if} & x_{1}^{\ast} >= x_{2}^{\ast} \\ 
 &-1, &\text{if} & x_{1}^{\ast} < x_{2}^{\ast}
\end{cases} \\
loss(x1,x2,y)=\max(0,−y∗(x1−x2)+margin)
$$

这里$x_{1}^{\ast}, x_{2}^{\ast}$表示实际的label得分，$x_{1}, x_{2}$表示预测得分


