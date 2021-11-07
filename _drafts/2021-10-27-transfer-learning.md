---

layout: post
title: 迁移学习
date: 2021-10-27 17:10:00
categories: [AI]
tags: [AI]
typora-root-url: ../_site
---

|           | labeled    |  unlabeled |
| --------- | :------: | :----: |
| labeled   | Model Fine-tuning<br>Multi-task Learning |Self-taught learning|
| unlabeled | Domain-adversarial training<br>Zero-shot Learning | Self-taught Clustering |

## Model Fine-tuning

#### 适用场景：

TargetData: $(x^{t},y^{t})$ 数据量少

SourceData: $(x^{s},y^{s})$  数据量多

### One-shot learning

只有非常少量的目标数据

典型场景：声纹识别。需要识别的人的说话数据可能非常少，只有几句话。

#### 问题：

当目标数据非常少的时候，直接Fine-tuning可能导致模型直接过拟合。
#### 方法：

#### Conservative Training

加上限制条件，使得源数据训练出的模型和目标数据训练出的模型接近。

这个接近可以是参数的距离小，也可以是源数据在Fine-tuning的模型上输出和原来比较接近。

#### Layer Transfer

复制某些层的参数，训练时冻结。不同的任务需要迁移的Layer位置是不一样的。
比如语音识别中，通常保留后面几层的参数，训练前面几层的参数。因为后几层是从发音方式到文字的转变。前几层是从声音讯号到发音方式的转变。
图像分类的话，通常是保留前面几层的参数，训练后面几层的参数。前几层的参数是在做模式匹配，比较通用。

## Multitask Learning

适用场景：

TargetData: $(x^{t},y^{t})$

SourceData: $(x^{s},y^{s})$ 

方法：

不同任务共享参数层

<img src="/mark/assets/images/2021-10-27-transfer-learning/multi-task-learn-share-input-5649614.png" alt="multi-task-learn-share-input" style="zoom:33%;" align="center"/>

<img src="/mark/assets/images/2021-10-27-transfer-learning/multi-task-learn-share-middle.png" alt="multi-task-learn-share-middle" style="zoom:33%;" align="center" />

典型例子：

Multilingual Speech Recognition

<img src="/mark/assets/images/2021-10-27-transfer-learning/multilingual-speech-recognition.png" alt="multilingual-speech-recognition" style="zoom:33%;" />

### 不知道能不能做transfer怎么办

progressive Neural Networks

<img src="/mark/assets/images/2021-10-27-transfer-learning/progressive-neural-networks.png" alt="progressive-neural-networks" style="zoom:33%;" />

## Domain-adversarial training

#### 适用场景：

TargetData: $(x^{t},y^{t})$

SourceData: $(x^{s})$ 

$y^{t}, y^{s}$相同，是同样的任务，但是$x^{t},x^{s}$分布不一样

<img src="/mark/assets/images/2021-10-27-transfer-learning/domain-adversarial-training.png" alt="image-20211107113936604" style="zoom: 67%;" />



![image-20211107121709824](/mark/assets/images/2021-10-27-transfer-learning/domain-adversarial-training-minist-result.png)

#### 问题：

1. feature extractor对domain classifier直接负梯度是否合适，负梯度意味着和原来的优化目标相反，即让domain classifier的损失最大，但损失最大的情况是刚好把source domain和target domain的标签预测为相反而不是我们希望的难以区分。

2. domain classifier难以区分的种类也有很多种，如若feature extractor能让提取到的特征更容易用于后续的label predictor，显然这样的feature extractor是更好的。

   ![image-20211107124132386](/../assets/images/2021-10-27-transfer-learning/image-20211107124132386.png)

   ![image-20211107123835381](/../assets/images/2021-10-27-transfer-learning/image-20211107123835381.png)

   A DIRT-T Approach To Unsupervised Domain Adaptation: https://arxiv.org/pdf/1802.08735.pdf

   Maximum Classifier Discrepancy for Unsupervised Domain Adaptation:https://arxiv.org/pdf/1712.02560.pdf

## Zero-shot Learning

#### 适用场景：

TargetData: $(x^{t},y^{t})$

SourceData: $(x^{s})$ 

$y^{t}, y^{s}$不同，任务不一样，$x^{t},x^{s}$分布一致



#### 方法：

思想:

找到一个中间$y^{m}$用来可以表示$y^{t}, y^{s}$，从而消除任务不一样的地方。具体：

不直接预测任务的标签，转而预测标签的属性，通过属性去和标签做映射。风控场景下，可以预测资金量，历史信用，等信息。

##### 标签embedding

当标签十分大的时候，标签可以做embedding，源数据的训练目标是$x^{s}$的embedding和$y^{\text{s\_attr}}$的embedding越接近越好，最后只要比较$x^{s}$的embedding和$y^{\text{s\_attr}}$的embedding哪个最接近就属于哪个类别。

寻找类别属性又个小技巧，可以直接用类别的word embedding来代替这个类别的属性embedding，比如猫、狗的属性embedding，用猫、狗的词汇vector来代替它的embedding。

$$f^{*}, g^{*}=argmin_{f,g}\sum {\left \|f(x^{n})-g(y^{n}) \right \|}_{2}$$

上面的损失函数只让$f(x^{n})-g(y^{n})$之间尽可能小，但是没有考虑到类间间隔

$$f^{*}, g^{*}=argmin_{f,g}\sum_{1}^{n} {0,k-f(x^{n})\cdot g(x^{n})+max_{n \neq m}f(x^{n})\cdot g(x^{m})}$$



## Domain Adaptation

TargetData: $(x^{t},y^{t})$

SourceData: $(x^{s},x^{t})$ 

Domain shift

$x^{t},x^{s}$分布不一样

$y^{t},y^{s}$分布不一样， 比如训练集上label(0):label(1) = 1:1，测试集上label(0):label(1) = 5:1，比如标签多了

https://openaccess.thecvf.com/content_CVPR_2019/html/You_Universal_Domain_Adaptation_CVPR_2019_paper.html





## Domain Generalization

训练集有许多domain https://ieeexplore.ieee.org/document/8578664

训练集只有一个domain https://arxiv.org/abs/2003.13216
