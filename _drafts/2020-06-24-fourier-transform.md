---

layout: post
title:  Fourier Transform
date:   2020-06-24 00:47:00
categories: [AI]
tags: [AI]

---

**傅里叶分析**可分为**傅里叶级数**（Fourier Serie）和**傅里叶变换**(Fourier Transformation)
二者都旨在将函数转为正弦函数来表达。
**任何连续周期信号都可以由一组适当的正弦曲线组合而成**
对于周期函数，这个过程就是**傅立叶级数**的展开。
对非周期信号，可以想象成信号的周期趋近于无穷大，广意成**傅里叶变换**，就是**傅里叶变换**。

通常会固定这么一组适当的正弦曲线组合，使得他们作为正交基，然后就可以用幅度和频率作为坐标系来表达这个信号了，与时域相对应的是，这就是频域的坐标系。

$$
\begin{align}
s_{N}\left(x\right)
&=\frac{a_{0}}{2}+\sum_{n=1}^{N}A\sin\left(2\pi fx+\theta\right)\\
&=\frac{a_{0}}{2}+\sum_{n=1}^{N}\left(A_{n}\sin\left(\phi_{n}\right)\cos\left(2\pi fnx \right)+A_{n}\cos\left(\phi_{n}\right)\sin\left(2\pi fnx \right)\right)\\
&=\frac{a_{0}}{2}+\sum_{n=1}^{N}\left(a_{n}\cos\left(2\pi fnx \right)+b_{n}\sin\left(2\pi fnx \right)\right)
\end{align}
$$

参考：
> [https://www.zhihu.com/question/19714540](https://www.zhihu.com/question/19714540)
