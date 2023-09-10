---

layout: post
title:  Machine Learning - 线性回归
date:   2017-06-14 15:06:00
categories: [Machine-Learning]
tags: [AI, machine-learning]

---


### 假设函数

$ h _ {\theta } \left ( x \right ) = \theta _ {0}x _ {0} + \theta _ {1}x _ {1} + \theta _ {2}x _ {2} + ... + \theta _ {n}x _ {n}$

这里$ x _{0} $恒等于1，表示为常数项。

### 损失函数

$ J \left ( \theta  \right )= \frac{1}{2m} \sum_{i=1}^{m} \left ( h _{\theta} \left ( x^{\left (i  \right )} \right ) - y^{\left (i  \right )} \right ) ^{2} $

其中`m`为样本数量

### 目标

$ \min J\left ( \theta  \right ) $

- 梯度下降法
    - 正统的方法是需要同步更新每个θ
    - $ \theta _ {j} = \theta _ {j} - \alpha \frac {1}{m} \sum_{i=1}^{m} \left ( h _ {\theta} \left ( x^{\left (i  \right )} \right ) - y^{\left (i  \right )} \right ) x _{j}^{\left (i  \right )} $
      其中$ \alpha $ 为学习率
    - matlab代码如下
      ~~~matlab
      theta=theta-(alpha/m*X'*(X*theta-y));
      ~~~
- 正规方程法
    - 也就是利用数学的方法，根据最小值在导数等于0的地方取得可直接求得结果，但是由于求n×n矩阵的逆运算复杂度为$ O\left ( n^{3} \right ) $,所以当特征很多时不宜用此方法，一般要求n小于10000
    - matlab代码如下
      ~~~matlab
      theta=pinv(X'*X)*X'*y;
      ~~~
    - 当矩阵X'*X的逆不存在时，一般是由于特征值之间具有线性相关性，提示我们重新选取特征值，或者是由于特征值太多而训练样本不足。



