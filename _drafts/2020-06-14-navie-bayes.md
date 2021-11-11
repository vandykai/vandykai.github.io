---

layout: post
title:  navie bayes 的三种方法
date:   2020-06-13 17:09:00
categories: [AI]
tags: [AI, MachineLearning]

---

###  频率派 vs 贝叶斯派

频率学派认为世界是确定的，有一个本体，这个本体的真值是不变的，我们的目标就是要找到这个真值或真值所在的范围；而贝叶斯学派认为世界是不确定的，人们对世界先有一个预判，而后通过观测数据对这个预判做调整，我们的目标是要找到最优的描述这个世界的概率分布。

**设$X$为观察数据,服从独立同分布，$\theta$ 为 模型的参数，$x \sim p \left(x\mid \theta \right)$**

即$x$服从一个概率模型$p \left(x\mid \theta \right)$

**频率派**认为模型的参数$\theta$是一个常量，用最大似然估计(MLE)来估计参数$\theta$，
$$
\begin{align}
\theta _{MLE}
&= \arg\max_{\theta} p \left(x\mid \theta \right)\\
&\sim  \arg\max_{\theta}\log p \left(x\mid \theta \right)
\end{align}
$$

频率派衍生出来的方法就是**统计机器学习**，最终转化为一个**优化问题**，求解的一般步骤是：
1. 设计模型
2. 设计loss function
3. 最小化loss funciton

**贝叶斯派**认为参数$\theta$是随机变量，也服从一个概率分布$\theta \sim p \left(\theta \right)$，用最大后验概率（MAP）来估计 参数$\theta$
$$
\begin{align}
\theta _{MAP}
&= \arg\max_{\theta} p \left(\theta \mid x\right)\\
&= \arg\max_{\theta}\frac{p \left(x\mid \theta \right)p \left(\theta \right)}{p \left(x \right)}\\
&= \arg\max_{\theta}\frac{p \left(x\mid \theta \right)p \left(\theta \right)}{\int_{\theta}p \left(x\mid \theta \right)p \left(\theta \right)}
\end{align}
$$

标准的**贝叶斯估计**是直接求概率分布$p \left(\theta \mid x\right)$

**贝叶斯派**衍生出来的方法就是**概率图模型**，最终转化为一个**求积分问题**

贝叶斯分类器有三种，分别是Multinomial Naive Bayes， Binarized Multinomial Naive Bayes以及Bernoulli Naive Bayes.

