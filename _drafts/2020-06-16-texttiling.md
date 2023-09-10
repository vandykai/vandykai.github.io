---

layout: post
title:  TextTiling
date:   2020-06-16 10:40:00
categories: [AI]
tags: [AI, MachineLearning]

---

### 作用
TextTiling 将一整个无段落的文章，分割成语意群。

### 具体英文输入实现算法

输入：句子的集合
1. 输入预处理
  1.1. 对句子进行分词，小写转换，过滤标点符号，删除非单词token
  1.2. 对token 进行stemmer 处理
  1.3. 删除停用词，将所有的句子合并成一个单一的干净的token列表
  1.4. 按照超参数w的大小对token列表重新分成等长的虚拟句子列表
2. 计算相似度
  2.1. 对步骤1得到的等长的虚拟句子列表，按照超参数k，从第一句开始以2*k大小进行滑窗，分别计算前k句和后k句的相似度。具体实现如下：
 
 ~~~python3
  import collections
  import numpy as np
  def calculate_sims(pseudosents):
      k=3
      l = len(pseudosents)
      bows = [collections.Counter(ps) for ps in pseudosents]
      sims = []
      i = 0
      mid = i + k
      end = i + 2*k
      while end <= l:
          bow_a = sum(bows[i:mid], collections.Counter())
          bow_b = sum(bows[mid:end], collections.Counter())
          union = bow_a | bow_b
          prod = [bow_a[tok] * bow_b[tok] for tok in union]
          numerator = sum(prod)
  
          sqsum_a = sum([bow_a[tok]**2 for tok in bow_a])
          sqsum_b = sum([bow_b[tok]**2 for tok in bow_b])
          denominator = math.sqrt(sqsum_a * sqsum_b)
          sims.append(numerator/denominator)
  
          i += 1
          mid = i + k
          end = i + 2*k
      return sims
  # pseudosents = np.random.randint(0,9,(10,5))
  # calculate_sims(pseudosents)
  ~~~

3. 切分点计算
  3.1.  通过步骤2 可以得到一个长度等于滑窗次数的一纬相似度列表，对于该相似度列表，寻找谷底或者叫局部最小值，即值小于左右两边数的位置。该位置就是切分点
  3.2. 步骤2.2得到的切分点是针对虚拟句子的，按照切分点距离哪个真实句子近选取哪个，就得到真实句子的切分点。

评估（`pk window_diff boundary_similarity`）:

> [https://blog.csdn.net/qq_35082030/article/details/105410478](https://blog.csdn.net/qq_35082030/article/details/105410478)