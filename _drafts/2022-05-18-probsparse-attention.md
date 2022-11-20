layout: post
title:  ProbSparse SelfAttention
date:   2022-05-18 12:30:00
categories: [AI]
tags: [self-attention,transformer]

### 目的

Transformer在序列增长是，计算的复杂度也层平方级提升，ProbSparse SelfAttention的目的是为了降低这种复杂度

### 相关工作

**Sparse Transformer**, **LogSparse**, **Transformer**, **Longformer**

### 介绍

##### 经典的self-attention：

$$
\mathcal{A}(\mathbf{q}_{i},\mathbf{K},\mathbf{V}) = \sum_{j}\frac{k(\mathbf{q}_{i},\mathbf{k}_{j})}{\sum_{l}k(\mathbf{q}_{i}\mathbf{k}_{l})}\mathbf{v}_{j}=\mathbb{E}_{p(\mathbf{k}_{j}|\mathbf{q}_{i})}[\mathbf{v}_{j}]
$$

其中$p(\mathbf{k}_{j}|\mathbf{q}_{i})=k(\mathbf{q}_{i},\mathbf{k}_{j})/\sum_{l}k(\mathbf{q}_{i}\mathbf{k}_{l})$，$k(\mathbf{q}_{i},\mathbf{k}_{j})=\mathrm{exp}(\mathbf{q}_{i}\mathbf{k}^{T}_{j}/\sqrt{d})$

实际上$p(\mathbf{k}_{j}|\mathbf{q}_{i})$的得分呈现长尾分布的属性，即少数点积对主要注意力有巨大贡献。

对于一个$q_{i}$来说，如果它的得分分布$p(\mathbf{k}_{j}|\mathbf{q}_{i})$接近均匀分布，那么$\mathcal{A}(\mathbf{q}_{i},\mathbf{K},\mathbf{V})$就退化为求$V$的均值，这对于其他的输入来说其实是冗余的。也就是说这个$q_{i}$不重要。那么如何找到重要的$q_{i}$呢，有一种方法是衡量下面两个分布：
$$
p(\mathbf{k}_{j}|\mathbf{q}_{i})=\frac{k(\mathbf{q}_{i},\mathbf{k}_{j})}{\sum_{l}k(\mathbf{q}_{i}\mathbf{k}_{l})}
$$

$$
q(\mathbf{k}_{j}|\mathbf{q}_{i})=\frac{1}{L_{k}}
$$

其中$L_{k}$是key的长度。然后求他们之间的KL散度，KL散度越大的，表示注意力分布越远离均匀分布，即是重要的$q_{i}$。
$$
\begin{align}
\mathbf{KL}(q\parallel p)&=\sum_{j} q(\mathbf{k}_{j}|\mathbf{q}_{i})\mathbf{ln}\frac{q(\mathbf{k}_{j}|\mathbf{q}_{i})}{p(\mathbf{k}_{j}|\mathbf{q}_{i})}\\
&=\sum_{j} (\frac{1}{L_{k}}\mathbf{ln}\frac{1}{L_{k}}-\frac{1}{L_{k}}(\mathbf{ln}k(\mathbf{q}_{i},\mathbf{k}_{j})-\mathbf{ln}\sum_{l}k(\mathbf{q}_{i}\mathbf{k}_{l})))\\
&=-\mathbf{ln}L_{k}-\sum_{j}\frac{1}{L_{k}}(\mathbf{ln}\;\mathrm{exp}(\mathbf{q}_{i}\mathbf{k}^{T}_{j}/\sqrt{d})-\mathbf{ln}\sum_{l}\;\mathrm{exp}(\mathbf{q}_{i}\mathbf{k}^{T}_{l}/\sqrt{d}))\\
&=\mathbf{ln}\sum_{l}\;\mathrm{exp}(\mathbf{q}_{i}\mathbf{k}^{T}_{l}/\sqrt{d}))-\frac{1}{L_{k}}\sum_{j}(\mathbf{q}_{i}\mathbf{k}^{T}_{j}/\sqrt{d})-\mathbf{ln}L_{k}\\
\end{align}
$$
把$\mathbf{KL}(q\parallel p)$中的常数项$-\mathbf{ln}L_{k}$舍弃，我们就可以得到$q_{i}$的重要性度量：
$$
\mathbf{M}(\mathbf{q}_{i},\mathbf{K})=\mathbf{ln}\sum_{j}\;\mathrm{exp}(\mathbf{q}_{i}\mathbf{k}^{T}_{j}/\sqrt{d}))-\frac{1}{L_{k}}\sum_{j}(\mathbf{q}_{i}\mathbf{k}^{T}_{j}/\sqrt{d})\\
$$
所以：
$$
\mathcal{A}(\mathbf{Q},\mathbf{K},\mathbf{V}) = \mathrm{softmax}\frac{\mathbf{\bar{Q}K^{T}}}{\sqrt{d}}\mathbf{V}
$$
其中$\mathrm{\bar{Q}}$是重要性度量$\mathbf{M}(\mathbf{q}_{i},\mathbf{K})$最大的Top-$u$个query，$u$ 在文中取值$u=c\cdot\mathbf{ln}L_{Q}$，$c$是常数。

问题的关键是怎么求$\mathbf{M}(\mathbf{q}_{i},\mathbf{K})$，直接求的话计算量不比计算全量的$\mathcal{A}(\mathbf{Q},\mathbf{K},\mathbf{V})$少。所以得想办法减少计算量。一种办法是求近似。
$$
\begin{align}
\mathbf{M}(\mathbf{q}_{i},\mathbf{K})&=\mathbf{ln}\sum_{j}\;\mathrm{exp}(\mathbf{q}_{i}\mathbf{k}^{T}_{j}/\sqrt{d}))-\frac{1}{L_{k}}\sum_{j}(\mathbf{q}_{i}\mathbf{k}^{T}_{j}/\sqrt{d})\\
&\leq \mathbf{ln}(L_{k}\;\mathrm{exp}\max_{j}(\frac{\mathbf{q}_{i}\mathbf{k}^{T}_{j}}{\sqrt{d}}))-\frac{1}{L_{k}}\sum_{j}(\frac{\mathbf{q}_{i}\mathbf{k}^{T}_{j}}{\sqrt{d}})\\
&= \mathbf{ln}L_{k}+\max_{j}(\frac{\mathbf{q}_{i}\mathbf{k}^{T}_{j}}{\sqrt{d}})-\frac{1}{L_{k}}\sum_{j}(\frac{\mathbf{q}_{i}\mathbf{k}^{T}_{j}}{\sqrt{d}})\\
\end{align}
$$

$$
\Rightarrow
\mathbf{ln}L_{k} \leq \mathbf{M}(\mathbf{q}_{i},\mathbf{K}) \leq \max_{j}(\frac{\mathbf{q}_{i}\mathbf{k}^{T}_{j}}{\sqrt{d}})-\frac{1}{L_{k}}\sum_{j}(\frac{\mathbf{q}_{i}\mathbf{k}^{T}_{j}}{\sqrt{d}}) + \mathbf{ln}L_{k}
$$

