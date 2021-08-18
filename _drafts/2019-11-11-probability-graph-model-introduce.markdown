---

layout: post
title:  Probability Graph Model introduce
date:   2019-11-11 20:26:00
categories: [NLP]
tags: [probability, Graph-Model]

---
### 概率图模型简介
也可以叫概率模型，图是一种工具，概率模型关心多维的随机变量，或者说是联合概率分布。
条件概率用图的父节点和子节点的关系表示
#### 已知联合概率如何构建图
利用拓扑排序
#### 如何计算联合概率分布
困难点：纬度高，计算复杂\\(p _{\theta }\left ( x _{1}, x _{2}, ... x _{p}\right )\\)
简化：
相互独立：比如朴素贝叶斯(Navive Bayes)
(马尔可夫性质)Markov Property：比如HMM里面的齐次马尔可夫假设，观测独立假设
条件独立性假设，马氏性质的推广即：\\(x _{A} x _{B}\mid x _{C}\\) x _{A}, x _{B}, x _{C}是集合，且不相交
### D-Seperation 全局马尔科夫性
### 概率图模型分类

#### Representation
1. 有向图 Beyesian Network
2. 高斯图 连续
3. 无向图 Markov Network

#### Inference
1. 精确推断
2. 近似推断

   2.2 确定性近似 变分推断

   2.3 随机性近似 MCMC
#### Learning
1. 参数学习

   1.1 完备数据

   1.2 隐变量 EM
2. 结构学习
#### Decision



