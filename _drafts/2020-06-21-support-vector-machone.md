---

layout: post
title:  Support Vector Machine
date:   2020-06-21 18:45:00
categories: [AI]
tags: [AI, MachineLearning]

---

SVM 有三宝间隔、对偶、核技巧

SVM 分类

hard-margin SVM
soft-margin SVM
kernal SVM

### 最大间隔思想
对于二分类问题，找到能分割空间中的点的最鲁棒的那个超平面。

具体来说，对于$n$维空间的$N$个样本点$\left \{x _{i}, y _{i} \right \} _{1} ^{N}$ ，$x _{i} \in R ^{n},y_{i} \in \left \{-1,+1 \right \}$ ,我们的目标是最大化离超平面最近的点到超平面的距离。即

$$
\max_{w,b}\min _{x_{i}}\frac{1}{\left \|w \right \|}\left|w^{T}x_{i}+b\right|=\max_{w,b}\frac{1}{\left \|w \right \|}\min _{x_{i}}y _{i}\left(w^{T}x_{i}+b\right)
$$

$$
s.t.
\left\{\begin{matrix}
 & w^{T}x_{i}+b > 0 & y=1\\ 
 & w^{T}x_{i}+b < 0 & y=-1
\end{matrix}\right.
\Rightarrow
y _{i}\left(w^{T}x_{i}+b\right) > 0
$$

假设
$$
\exists r>0 \quad s.t\quad \min _{x_{i}}y _{i}\left(w^{T}x_{i}+b\right)=r
$$
由于最小距离$r$的的大小可以由成倍的扩大或则缩小$w$和$b$来控制，而缩放系数和优化目标函数无关，因此不妨设$r=1$，所以上述优化目标可以转化为
$$
\max_{w,b}\frac{1}{\left \|w \right \|}
$$

$$
s.t.\quad \min _{x_{i}}y _{i}\left(w^{T}x_{i}+b\right)=1
$$

等价于
$$
\min_{w,b}\frac{1}{2}w_{T}w
$$

$$
s.t.\quad y _{i}\left(w^{T}x_{i}+b\right)\geqslant 1, \forall i \in \left (1,N\right)
$$

这是一个凸优化问题。

$$
s.t.\quad \text{L} \left(w,b,\lambda\right)=\frac{1}{2}w^{T}w + \sum _{i=1}^{N}\lambda_{i}\left(1-y _{i}\left(w^{T}x_{i}+b\right)\right)
$$
使用拉格朗日乘子法转化得：
$$
\min_{w,b}\max_{\lambda_{i}}\text{L} \left(w,b,\lambda\right)
$$

$$
s.t.\quad \lambda_{i}\geqslant 0, \forall i \in \left (1,N\right)
$$


### 对偶问题
上述问题的对偶问题为：
$$
\max_{\lambda_{i}}\min_{w,b}\text{L} \left(w,b,\lambda\right)
$$

$$
s.t.\quad \lambda_{i}\geqslant 0,\quad\forall i \in \left (1,N\right)
$$

原问题与其对偶问题天然存在弱对偶关系（鸡头凤尾）
$$
\min_{w,b}\max_{\lambda_{i}}\text{L} \left(w,b,\lambda\right) \geqslant \max_{\lambda_{i}}\min_{w,b}\text{L} \left(w,b,\lambda\right)
$$

若是凸优化，则满足强对偶关系：
$$
\min_{w,b}\max_{\lambda_{i}}\text{L} \left(w,b,\lambda\right) = \max_{\lambda_{i}}\min_{w,b}\text{L} \left(w,b,\lambda\right)
$$
所以对于凸优化问题，对偶问题与原问题有同样的解。

**为什么要转化为对偶问题呢，因为对偶问题比较好求解**
**对偶问题求解：**
先求解
$$
\min_{w,b}\text{L} \left(w,b,\lambda\right)
$$
他是个无约束的凸优化问题，直接求导使得等于$0$可求解

$$
\frac{\partial \text{L} \left(w,b,\lambda\right)}{\partial b}=0
\Rightarrow
\sum _{i=1}^{N}\lambda_{i}y_{i}=0
$$

$$
\frac{\partial \text{L} \left(w,b,\lambda\right)}{\partial w}=0
\Rightarrow
w=\sum _{i=1}^{N}\lambda_{i}y_{i}x_{i}
$$
代入 $\text{L} \left(w,b,\lambda\right)$得：


$$
\begin{align}
\text{L} \left(w,b,\lambda\right)
&=\frac{1}{2}w^{T}w + \sum _{i=1}^{N}\lambda_{i}\left(1-y _{i}\left(w^{T}x_{i}+b\right)\right)\\
&=\frac{1}{2}w^{T}w + \sum _{i=1}^{N}\lambda_{i}-\sum _{i=1}^{N}\lambda_{i}y _{i}w^{T}x_{i}-\sum _{i=1}^{N}\lambda_{i}y _{i}b\\
&=\frac{1}{2}w^{T}w-\sum _{i=1}^{N}\lambda_{i}y _{i}w^{T}x_{i}+ \sum _{i=1}^{N}\lambda_{i}\\
&=\frac{1}{2}\left(\sum _{i=1}^{N}\lambda_{i}y_{i}x_{i}\right)^{T}\left(\sum _{j=1}^{N}\lambda_{j}y_{j}x_{j}\right)-\sum _{i=1}^{N}\lambda_{i}y_{i}\left(\sum _{j=1}^{N}\lambda_{j}y_{j}x_{j}\right)^{T}x_{i}+\sum _{i=1}^{N}\lambda_{i}\\
&=\frac{1}{2}\left(\sum _{i=1}^{N}\lambda_{i}y_{i}x_{i}^{T}\right)\left(\sum _{j=1}^{N}\lambda_{j}y_{j}x_{j}\right)-\sum _{i=1}^{N}\lambda_{i}y_{i}\left(\sum _{j=1}^{N}\lambda_{j}y_{j}x_{j}^{T}\right)x_{i}+\sum _{i=1}^{N}\lambda_{i}\\
&=\frac{1}{2}\sum _{i=1}^{N}\sum _{j=1}^{N}\lambda_{i}\lambda_{j}y_{i}y_{j}x_{i}^{T}x_{j}-\sum _{i=1}^{N}\sum _{j=1}^{N}\lambda_{i}\lambda_{j}y_{i}y_{j}x_{i}^{T}x_{j}+\sum _{i=1}^{N}\lambda_{i}\\
&=-\frac{1}{2}\sum _{i=1}^{N}\sum _{j=1}^{N}\lambda_{i}\lambda_{j}y_{i}y_{j}x_{i}^{T}x_{j}+\sum _{i=1}^{N}\lambda_{i}
\end{align}
$$


所以：
$$
\min_{w,b}\text{L} \left(w,b,\lambda\right)=-\frac{1}{2}\sum _{i=1}^{N}\sum _{j=1}^{N}\lambda_{i}\lambda_{j}y_{i}y_{j}x_{i}^{T}x_{j}+\sum _{i=1}^{N}\lambda_{i}
$$

所以对偶问题化简为：

$$
\begin{align}
\max_{\lambda_{i}}\min_{w,b}\text{L} \left(w,b,\lambda\right)
&=\max_{\lambda_{i}}-\frac{1}{2}\sum _{i=1}^{N}\sum _{j=1}^{N}\lambda_{i}\lambda_{j}y_{i}y_{j}x_{i}^{T}x_{j}+\sum _{i=1}^{N}\lambda_{i}\\
\end{align}
$$

$$
s.t.\quad 
\left\{\begin{matrix}
 & \lambda_{i}\geqslant 0 ,\quad \forall i \in \left (1,N\right)\\ 
 & \sum _{i=1}^{N}\lambda_{i}y_{i}=0
\end{matrix}\right.
$$

**最后别忘了对$b$求导使得等于0也是$\lambda$的一个约束**

