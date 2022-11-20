---

layout: post
title: 降维
date: 2021-11-22 00:07:00
categories: [AI]
tags: [AI]
typora-root-url: ../_site

---

我们知道，解决过拟合的问题除了正则化和添加数据之外，降维就是最好的方法。降维的思路来源于维度灾难的问题， $n$ 维球的体积为：
$$
kr^n
$$
其中$k$为常数系数，$r$是半径

设想半径非常接近的嵌套的两个球，内球体积和外球体积比为：
$$
\lim_{n \rightarrow 0}\frac{V_{inner}}{V_{outer}}=\lim_{n \rightarrow 0}\frac{k(r-\epsilon )^n}{kr^n} = \lim_{n \rightarrow 0}{(1-\frac{\epsilon}{r})^n}=0
$$




这就是所谓的维度灾难，在高维数据中，主要样本都分布在球体的边缘，所以数据集更加稀疏。

降维的算法分为：

1.  直接降维，特征选择
2.  线性降维，PCA，MDS等
3.  分线性，流形包括 Isomap，LLE 等

