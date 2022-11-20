---

layout: post
title:  Probabilistic Graphical Models - 简介
date:   2017-06-14 15:06:00
categories: [Probabilistic-Graphical-Models]
tags: [AI, probabilistic-graphical-models]

---

## 如何计算联合概率分布
困难点：联合概率分布$p \left ( x _{1}, x _{2}, ... x _{p}\right )$纬度高，计算复杂，所以一般要对其进行简化。

## 简化：

- **相互独立**：

    $p \left ( x _{1}, x _{2}, ... x _{p} \right ) = \prod _{1} ^{p} p \left ( x _{i}\right )$

    比如朴素贝叶斯(Navive Bayes)给定标签的情况下，各属性相互独立

- **Markov Property(马尔可夫性质)**：

    比如HMM里面的齐次马尔可夫假设，观测独立假设，马尔可夫链有1阶，2阶，n阶

- **条件独立性假设**:

    条件独立性假设是马氏性质的推广，即：$x _{A} \perp x _{B} \mid x _{C}$ 其中$x _{A}, x _{B}, x _{C}$是集合，且不相交

## 概率图模型简介
概率图模型从字面来说分为两部分，一个是概率，一个是图，图是一种工具，因此也可以叫概率模型。

概率模型关心多维的随机变量，或者说是联合概率分布$p \left ( x _{1}, x _{2}, ... x _{p}\right )$。

条件独立性假设是概率图模型中的一个核心概念，无论是有向图还是无向图都要有效表达出条件独立性。

概率图模型的

- Representation
- Inference
- Learning

## Representation

1. 有向图 **Beyesian Network**
2. 无向图 **Markov Network**
3. 高斯图 连续

这两种表示都给出了独立关系和因子分解的对偶型

### Bayesian Network

链式法则：$p \left ( x _{1}, x _{2}, ... x _{p}\right ) = p \left ( x _{1} \right ) \prod _{2} ^{p} p \left ( x _{i} \mid x _{1 \cdots i-1}\right )$

因子分解：$p \left ( x _{1}, x _{2}, ... x _{p}\right ) = \prod _{1} ^{p} p \left ( x _{i} \mid x _{pa(i)}\right )$

如何从联合概率分布构建图：利用拓扑排序，若联合概率中存在$p \left (x _{i} \mid x _{j} \right )$则$j$是$i$父节点， 即在图中，条件概率用图的父节点和子节点的关系表示

#### 如何从图中看出条件独立性
#### D Seperation
#### Markov Blanket(马尔可夫毯)
三种结构了解一下

#### HMM 

1. 齐次马尔科夫性假设：即假设隐藏的马尔科夫链在任意时刻t的状态只依赖于其前一时刻的状态，与其他时刻的状态及观测无关，也与时刻t无关；齐次的意思是每一个状态和前一个状态之间服从同一个离散分布
2. 观测独立性假设：即假设任意时刻的观测只依赖于该时刻的马尔科夫链的状态，与其他观测即状态无关。

### Markov Network

因子分解：$p \left ( x _{1}, x _{2}, ... x _{p}\right ) = \frac{1}{Z}\prod _{c} \varphi _{c} \left ( x _{c}\right )$ 其中$Z = \sum _{x}\prod _{c} \varphi _{c} \left ( x _{c}\right )$

在CRF中势函数为：

$$w\varphi _{c} \left ( x _{c}\right ) = exp\left \{-E(x _{c})\right \}$$

其中c是无向图的最大团
- 全局马尔可夫性
- 局部马尔可夫性
- 成对马尔可夫性

Hammersley-Clifford定理证明了一个无向图模型的概率可以表示为定义在图上所有最大团上的势函数的乘积

## Inference

1. 精确推断
    - Variable Elimanation(VE)
    - Belief Propagation(BP) ->sum-product algorithm->针对树的结构
    - Junction Tree Algorithm ->普通图的结构
2. 近似推断

    2.2 确定性近似 Variational Inference(变分推断)

    2.3 随机性近似 Monte Carlo Inference Sampling ->Importance Sampling ->MCMC

推断的目标：

- 求边缘概率
- 求条件概率
- MAP Inference

## Learning
1. 参数学习

    1.1 完备数据

    1.2 隐变量 EM

2. 结构学习

## 道德图
$p(a,b,c)=p(a)p(b \mid a)p(c \mid b)$

$p(a,b,c)=p(c)p(c \mid a)p(c \mid b)$

$p(a,b,c)=p(a)p(b)p(c \mid a,b)$

