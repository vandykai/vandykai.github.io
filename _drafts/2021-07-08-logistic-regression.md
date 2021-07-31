---

layout: post
title: Logistic Regression
date: 2021-07-01 16:25:00
categories: [AI]
tags: [AI，NLP，Sampler]

---
# 

$$
\begin{align}
logit \left(p \right) = \log \left(\frac{p}{1-p} \right)
&=\theta_{0}+\theta_{1}x_{1}+\dots+\theta_{n}x_{n}\\
&=\theta^{T}x
\end{align}
$$

即：

$$
\frac{p}{1-p} = \exp(\theta^{T}x)
$$

$$
\frac{1-p}{p} = \frac{1}{\exp(\theta^{T}x)}
$$

$$
\begin{align}
\frac{1}{p} &= 1 + \frac{1}{\exp(\theta^{T}x)}\\
&=\frac{\exp(\theta^{T}x)+1}{\exp(\theta^{T}x)}\\
\end{align}
$$

所以

$$
\begin{align}
p
&= \frac{\exp(\theta^{T}x)}{\exp(\theta^{T}x)+1}\\
&= \frac{1}{1+\exp(-\theta^{T}x)}\\
\end{align}
$$


