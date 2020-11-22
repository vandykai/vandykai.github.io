---

layout: post
title:  Pointer Network
date:   2020-01-21 17:20:00
categories: [NLP]
tags: [AI, NLP]

---


# 背景

在seq2seq的模型中，decode端的target需要一个此词表来映射输出的词汇，词表的大小是固定的，输出端无法输出一个不在词汇表中的词汇，但是在许多应用场景下，输出端严重依赖输入，当输入的词汇不在词表中时，就会出现OOV问题。Pointer Network旨在解决这个问题。

# Point Network通过attention 机制，将attention的得分作为词语输出的概率和