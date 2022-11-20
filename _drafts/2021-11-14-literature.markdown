---

layout: post
title:  文献管理
date:   2021-11-14 11:32:00
categories: [Essay]
tags: [mind]

---
* DivideMix: Learning with Noisy Labels as Semi-supervised Learning
  * https://openreview.net/pdf?id=HJgExaVtwr

* Informer: Beyond Efficient Transformer for Long Sequence Time-Series Forecasting

  *  https://arxiv.org/pdf/2012.07436v2.pdf
  *  引入ProbSparse Self-attention mechanism
  
* Applying word2vec to Recommenders and Advertising
  
  * https://mccormickml.com/2018/06/15/applying-word2vec-to-recommenders-and-advertising/
  * [推荐，基于上下文共现]
  
* Preventing Posterior Collapse Induced by Oversmoothing in Gaussian VAE
  
  * https://arxiv.org/pdf/2102.08663.pdf
  * [Yuhta Takida](https://arxiv.org/search/cs?searchtype=author&query=Takida%2C+Y), [Wei-Hsiang Liao](https://arxiv.org/search/cs?searchtype=author&query=Liao%2C+W), [Toshimitsu Uesaka](https://arxiv.org/search/cs?searchtype=author&query=Uesaka%2C+T), [Shusuke Takahashi](https://arxiv.org/search/cs?searchtype=author&query=Takahashi%2C+S), [Yuki Mitsufuji](https://arxiv.org/search/cs?searchtype=author&query=Mitsufuji%2C+Y)
  * [VAE, Posterior Collapse]
  
* Bilateral Variational Autoencoder for Collaborative Filtering
  
  * https://ink.library.smu.edu.sg/cgi/viewcontent.cgi?article=6955&context=sis_research
  * [推荐，协同过滤]
  * sparse CF data给基于神经网络的的方法带来很大的困难
  * VAE和neural networks不同的是VAE是学习一个不确定的表示，而neural networks是学习确定的表示
  
* Masked Autoencoders Are Scalable Vision Learners 
  
  * https://arxiv.org/pdf/2111.06377.pdf
  * [Kaiming He](https://arxiv.org/search/cs?searchtype=author&query=He%2C+K), [Xinlei Chen](https://arxiv.org/search/cs?searchtype=author&query=Chen%2C+X), [Saining Xie](https://arxiv.org/search/cs?searchtype=author&query=Xie%2C+S), [Yanghao Li](https://arxiv.org/search/cs?searchtype=author&query=Li%2C+Y), [Piotr Dollár](https://arxiv.org/search/cs?searchtype=author&query=Dollár%2C+P), [Ross Girshick](https://arxiv.org/search/cs?searchtype=author&query=Girshick%2C+R)
  * [迁移学习，预训练]
  * 图片和语言是两种不同的信号。图片仅仅是光信号的记录，不能分解为类似于语言中有语意的词汇。Bert中mask的是语意单元，图片要做随机mask像素的话，一般来说被mask的像素不会构成语义单元。但是MAE（本文的方法）依然可以很好的重建被masked的部分图片。
  * 语言单元
  * <img src="/mark/assets/images/2021-11-14-literature/image-20211118141001551.png" alt="image-20211118141001551" style="zoom: 33%;" />
  
* Self-taught Learning: Transfer Learning from Unlabeled Data

  * http://ai.stanford.edu/~hllee/icml07-selftaughtlearning.pdf

  * Rajat Raina rajatr@cs.stanford.edu Alexis Battle ajbattle@cs.stanford.edu Honglak Lee hllee@cs.stanford.edu Benjamin Packer bpacker@cs.stanford.edu Andrew Y. Ng ang@cs.stanford.edu

  * [迁移学习]

  * 在SourceData上建立优化目标：

    $$
    minimize_{V,w} \quad \sum_{i}\left \|x^{(i)}_{u} - \sum_{j}w^{(i)}_{j}V_{j} \right \| + \beta\left \|w^{(i)} \right \|_{1}
    $$

    $$
    s.t. \quad \left \|V_{j} \right \|_2 \leq  1, \forall j \in 1,\dots,s
    $$

    其中$V_{j}$是$n$维的基向量，$V=\{V_{1}, V_{2},\dots,V_{s}\}$

    

    对TargetData数据，求出对应的$w$作为新的表示，优化目标如下：

    $$
    \hat{w}(x^{(i)}_{l}) = argmin_{w^{(i)}} \quad \left \|x^{(i)}_{l} - \sum_{j}w^{(i)}_{j}V_{j} \right \| + \beta\left \|w^{(i)} \right \|_{1}
    $$

* How transferable are features in deep neural networks?
  * https://arxiv.org/pdf/1411.1792.pdf
  * [Jason Yosinski](https://arxiv.org/search/cs?searchtype=author&query=Yosinski%2C+J), [Jeff Clune](https://arxiv.org/search/cs?searchtype=author&query=Clune%2C+J), [Yoshua Bengio](https://arxiv.org/search/cs?searchtype=author&query=Bengio%2C+Y), [Hod Lipson](https://arxiv.org/search/cs?searchtype=author&query=Lipson%2C+H)
  * [迁移学习]
  * 对比了ImageNet数据集上不同层的迁移效果
  * <img src="/mark/assets/images/2021-11-14-literature/image-20211115163606742.png" alt="image-20211115163606742" style="zoom:33%;" />
