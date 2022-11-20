---

layout: post
title: ColBERT Introduce
date: 2021-07-01 16:25:00
categories: [Rank]
tags: [AI，NLP，Rank, IR]

---
## ColBERT

### 效果：
ColBert的效果可以媲美其它BERT-based的模型，但是执行比它们快两个数量级。每次query的查询少四个数量级的浮点运算。

### 主要亮点：
通过query和document向量的延迟而高效的交互。可以使得模型可以离线计算document的表示向量。

### Query & Document Encoders
$$
\begin{align}
& \rm E_{q} = Normalize(CNN(BERT("[CLS][Q]q_{0}q_{1}\dots q_{l}[MASK][MASK]\dots [MASK]"))) \\
& \rm E_{d} = Filter(Normalize(CNN(BERT("[CLS][Q]q_{0}q_{1}\dots q_{l}[PAD][PAD]\dots [PAD]"))))
\end{align}
$$

##### detail:
在query和document前分别放置特殊的符号[Q]、[D]，用以区分query和document。[Q]，[D]这两个符号都位于BERT的[CLS]之后。对于query，做pad时用[MASK]来填充不足的长度，用以增加query的多样性，相当于query扩展了，若长度过长则截取。对于document，过滤编码成id后的符号id，这些符号id对于模型作用不大，且可以间接增加document实际长度。