---

layout: post
title:  softmax logsoftmax logsumexp
date:   2020-11-02 20:45:00
categories: [AI]
tags: [AI， NLP]

---

# softmax

softmax定义为：
$$
softmax\left(x_{i}\right) = \frac{\exp\left(x_{i}\right)}{\sum  _{j} ^{n}\exp\left(x_{j}\right)}
$$

但是实际使用计算机计算时会有两个问题，一个是exp计算容易向上溢出，超出float的表达范围，一个是分母容易向下溢出，比如当$x _{j}$都是比较大的负数时，可能导致分母为0。一个简单的技巧是：
$$
x_{max} = \max(x)\\
softmax\left(x_{i}\right)= \frac{\exp\left(x_{i}-x_{max}\right)}{\sum  _{j} ^{n}\exp\left(x_{j}-x_{max}\right)}
$$

这样分子的额最大值就是1了，分母由于存在某个$x _{k}=x_{max}$，所以整个分母的值至少大于1，这样就解决了上溢出和下溢出的问题。

# logsoftmax
实际中多将softmax转换到log空间当作损失函数。
logsoftmax定义为：
$$
\begin{align}
logsoftmax\left(x_{i}\right) 
&= \log\frac{\exp\left(x_{i}\right)}{\sum  _{j} ^{n}\exp\left(x_{j}\right)} \\
&= x_{i} - \log\sum  _{j} ^{n}\exp\left(x_{j}\right) \\
\end{align}
$$
其中$\log\sum  _{j} ^{n}\exp\left(x_{j}\right)$ 的计算有上溢出的问题，同样可以使用上述的简单的技巧。
$$
x_{max} = \max(x)\\
\begin{align}
logsoftmax\left(x_{i}\right) 
&= \log\frac{\exp\left(x_{i}\right)}{\sum  _{j} ^{n}\exp\left(x_{j}\right)} \\
&= \log\frac{\exp\left(x_{i}-x_{max}\right)}{\sum  _{j} ^{n}\exp\left(x_{j}-x_{max}\right)} \\
&= x_{i}- x_{max} - \log\sum  _{j} ^{n}\exp\left(x_{j}-x_{max}\right) \\
\end{align}
$$

# logsumexp
logsumexp定义为：
$$
LSE(x)=logsumexp(x) = \log\sum  _{j} ^{n}\exp\left(x_{j}\right)
$$
可以看出其实就是logsoftmax的第二项，其计算技巧为：
$$
x_{max} = \max(x)\\
\begin{align}
LSE(x) 
&= \log\sum  _{j} ^{n}\exp\left(x_{j}\right) \\
&= x_{max} + \log\sum  _{j} ^{n}\exp\left(x_{j}-x_{max}\right) \\
\end{align}
$$

有一种比较有意思的想法，softmax其实是在求最大值的位置，其名字应该是softargmax，logsumexp其实是在类似于求最大值:
~~~python
x = torch.tensor([1.0,3.0,6.0])
torch.argmax(x),torch.softmax(x, dim=0)
# output
# (tensor(2), tensor([0.0064, 0.0471, 0.9465]))
torch.logsumexp(x, dim=0)
# output
# tensor(6.0550)
~~~

对于$log(X+\delta)$，若$\delta$远小于$X$，则根据泰勒展开到一阶：
$$
\log(X+\delta) \approx \log(X) + \frac{\delta}{X} \approx \log(X)
$$

同理：若$\exp\left(x_{max}\right)$ 远大于$\sum_{other} \exp\left(x_{j}\right)$，则：
$$
\begin{align}
LSE(x)
&= \log\sum  _{j} ^{n}\exp\left(x_{j}\right) \\
&= \log\left(\exp\left(x_{max}\right)\right) + \frac{\sum_{j\neq max} \exp\left(x_{j}\right)}{\exp\left(x_{max}\right)} \\
&\approx \log\left(\exp\left(x_{max}\right)\right) \\
&= x_{max}
\end{align}
$$

所以$LSE(x)$又叫smooth maximum，实际上
$$
\max\left\{x_{1}\dots,x_{n} \right\} < LSE(x) \leq \max\left\{x_{1}\dots,x_{n} \right\} + \log(n)
$$

简单证明下：
$$
\begin{align}
\max\left\{x_{1}\dots,x_{n} \right\} 
&= \log(\exp(x_{max})) \\
&\leq \log(\exp(x_{1})+\dots+\exp(x_{n})) \\
&= LSE(X) \\
&\leq \log(n\exp(x_{max})) \\
&= \max\left\{x_{1}\dots,x_{n} \right\} + \log(n)
\end{align}
$$

 下界当$n=1$时取得，上界当$x_{1}=x_{2}=\dots=x_{n}$时取得。
 此外：

$$
\frac{\partial LSE(X)}{\partial x_{i}} =\frac{\exp\left(x_{i}\right)}{\sum  _{j} ^{n}\exp\left(x_{j}\right)}= softmax\left(x_{i}\right)
$$

# 求导：
## softmax求导
$$
S\left(x_{i}\right) = \frac{\exp\left(x_{i}\right)}{\sum  _{j} ^{n}\exp\left(x_{j}\right)}
$$

$$
\begin{align}
\frac{\partial S\left(x_{i}\right)}{\partial x_{j}}  
&= \frac{\frac{\partial \exp\left(x_{i}\right)}{\partial x_{j}}\sum-\exp\left(x_{i}\right)\exp\left(x_{j}\right)}{\sum ^{2}} \\
&= \frac{\frac{\partial \exp\left(x_{i}\right)}{\partial x_{j}}}{\sum}-\frac{\exp\left(x_{i}\right)}{\sum}\frac{\exp\left(x_{j}\right)}{\sum} \\
&= \frac{\frac{\partial \exp\left(x_{i}\right)}{\partial x_{j}}}{\sum} - S\left(x_{i}\right)S\left(x_{j}\right) \\
&=
\begin{cases}
S\left(x_{i}\right)(1-S\left(x_{j}\right)) & \text{if}\quad x_{i}=x_{j} \\ 
-S\left(x_{i}\right)S\left(x_{j}\right) & \text{if}\quad x_{i}\neq x_{j}
\end{cases}
\end{align}
$$

## logsoftmax求导
$$
\begin{align}
logS\left(x_{i}\right) 
&= \log\frac{\exp\left(x_{i}\right)}{\sum  _{j} ^{n}\exp\left(x_{j}\right)} \\
&= x_{i} - \log\sum  _{j} ^{n}\exp\left(x_{j}\right) \\
\end{align}
$$

利用softmax的结果间接求导：
$$
\begin{align}
\frac{\partial logS\left(x_{i}\right)}{\partial x_{j}}
&= \frac{1}{S\left(x_{i}\right)}\frac{\partial S\left(x_{i}\right)}{\partial x_{j}}\\
&=
\begin{cases}
\frac{1}{S\left(x_{i}\right)}S\left(x_{i}\right)(1-S\left(x_{j}\right)) & \text{if}\quad x_{i}=x_{j} \\ 
-\frac{1}{S\left(x_{i}\right)}S\left(x_{i}\right)S\left(x_{j}\right) & \text{if}\quad x_{i}\neq x_{j}
\end{cases}\\
&=
\begin{cases}
1-S\left(x_{j}\right) & \text{if}\quad x_{i}=x_{j} \\ 
-S\left(x_{j}\right) & \text{if}\quad x_{i}\neq x_{j}
\end{cases}
\end{align}
$$

也可利用上述化简式直接求导，结果一样

## logsumexp求导
$$
LSE(x)=logsumexp(x) = \log\sum  _{i} ^{n}\exp\left(x_{i}\right)
$$

$$
\begin{align}
\frac{\partial LSE(x)}{\partial x_{j}}
&= \frac{\exp\left(x_{j}\right)}{\sum  _{i} ^{n}\exp\left(x_{i}\right)}\\
&= S\left(x_{j}\right)
\end{align}
$$

## 附:交叉熵求导

$$
\begin{align}
loss(x)
& =-\sum _{i}^{K}y_{i}\log\frac{\exp\left(x_{i}\right)}{\sum  _{j} ^{K}\exp\left(x_{j}\right)} \\
&= -\sum _{i}^{K}y_{i}logS\left(x_{i}\right)
\end{align}
$$



其中$K$是多分类类别数


$$
\begin{align}
\frac{\partial loss(x)}{\partial x_{j}}
&= -\sum _{i}^{K}y_{i}\frac{\partial logS\left(x_{i}\right)}{\partial x_{j}} \\
&= -\sum _{i \neq j}y_{i}\left(-S\left(x_{j}\right)\right) -y_{j}\left(1-S\left(x_{j}\right)\right) \\
&=S\left(x_{j}\right)-y_{j}
\end{align}
$$

可以看出导数就是$S\left(x_{j}\right)$与$y_{j}$的距离