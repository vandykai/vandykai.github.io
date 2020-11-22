
---

layout: post
title:  Improving Chinese Word Segmentation with Wordhood Memory Networks
date:   2020-09-02 20:45:00
categories: [AI]
tags: [AI， NLP]

---

# 如何从大量语料中获取词典
词语抽取方法：
1. AV (Accessor Variety)
2. PMI (Point-wise Mutual Information)
3. DLG (Description length gain)
4. SCP(Symmetrical Conditional Probability)
5. Branch Entropy
6. Word Overlap Ratio

### AV

$$
AV\left(s\right) = \min\left \{ L_{av}\left(s\right),R_{av}\left(s\right)\right \}
$$

\\(L_{av}\left(s\right)\\)是字\\(s\\)的左搭配多样性，\\(R_{av}\left(s\right)\\)是字\\(s\\)的右搭配多样性

##### 例子：
1. 门把手弄坏了
2. 小明修好了门把手
3. 这个门把手很漂亮
4. 这个门把手坏了

考虑门把手这个词，他有三个不同的左毗邻字，分别是['\\(S\\)','了','个']，\\(S\\)代表句子的开始，有四个不同的右毗邻字，分别是['弄','\\(E\\)','很','坏']，\\(E\\)代表句子的结束。
所以这里：

$$
AV\left(门把手\right) = \min\left \{ L_{av}\left(门把手\right),R_{av}\left(门把手\right)\right \}=\min\left \{ 3,4\right \}=3
$$

\\(L_{av}\left(s\right)\\)定义为字\\(s\\)的左搭配不同字的个数，若为\\(S\\)则重复计算。

\\(R_{av}\left(s\right)\\)定义为字\\(s\\)的右搭配不同字的个数，若为\\(E\\)则重复计算

之所以\\(S\\)和\\(E\\)重复计算，是因为有的词语是经常单独出现的，如‘突然’这个词，若不重复计算\\(S\\)和\\(E\\)，会导致‘突然’这个词的成词概率很低。

我们只要设定一个\\(AV\left(s\right)\\)的阈值，就可以分割出所有可能的词语。


### PMI

PMI称做点的互信息，点\\({x}',{x}''\\)的互信息定义为
$$
PMI\left({x}',{x}''\right) = \log \frac{p\left({x}',{x}''\right)}{p\left({x}'\right)p\left({x}''\right)}
$$

当\\(PMI\left({x}',{x}''\right)=0\\)是，代表点\\({x}'\\)和点\\({x}''\\)独立，\\(PMI\left({x}',{x}''\right)\\)的值越大，点\\({x}'\\)和点\\({x}''\\)的相关性就越强。我们可以用这个方法来判断字\\({x}'\\)和字\\({x}''\\)是否应该分隔开。

通过设置\\(PMI\\)的阈值(如\\(0\\))，就可以分割出所有可能的词语。

### DLG
DLG 是Description length gain的简写，定义为：

$$
DLG\left(s\right) = DL\left(D\right)-DL\left(D\left [r\rightarrow s\right ]\oplus s\right)
$$

\\(D\\) 代表原始语料数据，\\(D\left [r\rightarrow s\right ]\oplus s\\)代表把n-gram \\(r\\)当作一个词\\(s\\)后的语料数据。

\\(DL\\)指的是Shannon-Fano code length，历史上Shannon-Fano code length有两种含义，一种指 Shannon's code: predefined word lengths，一种指Fano's code: binary splitting，详细看[wiki](https://en.wikipedia.org/wiki/Shannon%25E2%2580%2593Fano_coding)，这里介绍第一种，定义为：

$$
DL\left(D\right) = - \sum _{x \in \nu} c\left(x\right)\log \frac{c\left(x\right)}{\left | D \right |}
$$

其中\\(\nu\\)代表D的词表，\\(c\left(x\right)\\)代表切割片段\\(x\\)在D中出现的次数，\\(DL\left(D\right)\\)就是语料数据编码所需要的总的编码长度。\\(DLG\left(s\right)\\)其实就是如果把n-gram \\(r\\)当作一个词\\(s\\)后总的编码长度减少的值。

通过设置\\(DLG\left(s\right)\\)的阈值(如\\(0\\))，就可以分割出所有可能的词语。