---

layout: post
title: ColBert Introduce
date: 2021-07-01 16:25:00
categories: [Rank]
tags: [AI，NLP，Rank, IR]

---

效果：
ColBert的效果可以媲美其它BERT-based的模型，但是执行比它们快两个数量级。每次query的查询少四个数量级的浮点运算。

主要亮点：
通过query和document向量的延迟而高效的交互。可以使得模型可以离线计算document的表示向量。