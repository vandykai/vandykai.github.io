---

layout: post_pdf
title:  Word2Vec Introduce
date:   2018-05-23 13:30:00
categories: [NLP]
tags: [AI, NLP]

---

## 背景
**one hot编码缺点**：

* 编码没有将语义融入到词的表示当中
* 维数爆炸

**word embedding**

如何将语义融入到词的表示当中? Harris于1954年提出的分布假说（distributional hypothesis）为这一设想提供了理论基础：上下文相似的词，其语义也相似。而基于基于分布假说的词表示方法，根据建模的不同，主要可以分为三类：基于矩阵的分布表示、基于聚类的分布表示和基于神经网络的分布表示。而word embedding一般来说就是一种基于神经网络的分布表示。
