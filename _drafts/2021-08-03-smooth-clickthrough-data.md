---

layout: post
title: Smooth Clickthrough Data
date: 2021-08-03 16:25:00
categories: [Rank]
tags: [AI，NLP，Rank, WebSearch]

---

## 点击数据问题

点击数据可以充分反映用户的意图，但使用起来也有一定的问题。

1. 点击数据稀疏（incomplete problem）-> 视为 confidence-weighted learning 
2. 点击数据缺失 (missing click problem) -> 视为 missing data problem

文档无点击的原因很多，不一定是文档不相关

## 两种平滑方法

### Random Walk

思想：co-clikcs，点击了同一个文档的query我们认为是相似的。我们就可以使用固定的公式来找到这些相似的query，当作是对改文档的点击数据。与使用固定的公式来找到相似的query不同的是，这里采用随机游走的方法。

具体如下：
假设数据中总的query有m个，文档有n个。那么可以构建一个query到document的转移矩阵 $A=A_{ij},\quad A_{ij}=p(d_{j}|q_{i})$， 同理可以构建一个document到query的转移矩阵$B=B_{ji},\quad B_{ij}=p(q_{i}|d_{j})$，那么query到query两步可达的转移矩阵为$AB$

### Discounting