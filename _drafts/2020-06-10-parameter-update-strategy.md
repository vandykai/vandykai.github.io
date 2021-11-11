---

layout: post
title:  Parameter Update Strategy
date:   2020-06-24 00:47:00
categories: [AI]
tags: [AI]

---


在使用mini-batch梯度下降法进行目标函数的优化时，会碰到一个重要的需要设置的参数，那就是学习率，对于不同的模型，不同的损失函数，没有一个统一的学习率可以用来解决所有问题。

保守的选取很小的学习率，固然可以使得目标函数的值 降低到一个小的值，但可能陷入局部最优（相比局部最优，鞍点可能才是更加严重的问题），并且会参数收敛过慢，训练时长过长。

激进的选取一个大的学习率，可能会使得参数收敛困难，使得损失函数在最小值附近波动，甚至发散。上一个经典的图：![effect_of_various_learning_rates_on_convergence][1]

### 学习率动态调整
为了解决这个问题，可以使用一些退火算法来动态调整训练时候的学习率，也就是根据预先设定的表或者当损失函数多轮batch后仍然不在下降时降低学习率。
常用的一些退火策略有：

```python3
StepLR(optimizer, step_size, gamma=0.1, last_epoch=-1)
固定步长衰减，每隔一定epoch，学习率就减少为上一次的gamma分之一
```

$$
new\_lr = init\_lr\times \gamma^{epoch//step\_size}
$$

```python3
MultiStepLR(optimizer, milestones, gamma=0.1, last_epoch=-1)
多步长衰减，_milestones_ 为数组，是衰减的epoch节点，如[30,50,80],每到一个设定的epoch节点，学习率就减少为上一次的gamma分之一
```

$$
new\_lr = init\_lr*\times \gamma^{bisect\_right\left(milestones,epoch\right)}
$$

```python3
CosineAnnealingLR(optimizer, T_max, eta_min=0, last_epoch=-1)
余弦退火：
```

$$
new\_lr = \eta _{min} + \frac{1}{2} \left(init\_lr-\eta _{min}\right)\left(1+\cos\left(\frac{T_{cur}}{T_{max}}\pi\right)\right)
$$

```python3
ReduceLROnPlateau(optimizer, mode='min', factor=0.1, patience=10, verbose=False, threshold=0.0001, threshold_mode='rel', cooldown=0, min_lr=0, eps=1e-08)
当性能指标_patience次不再提升后，学习率就减少为上一次的factor分之一
```

```python3
CyclicLR(optimizer, base_lr, max_lr, step_size_up=2000, step_size_down=None, mode='triangular', gamma=1.0, scale_fn=None, scale_mode='cycle', cycle_momentum=True, base_momentum=0.8, max_momentum=0.9, last_epoch=-1)
类似于余弦退火，从cos变成在最大最小值之间折线来回震荡，且可以设置震荡越来越小
```

如下图所示：
![CyclicLR][2]

### 优化方法中的学习率调整
为了跨过鞍点和局部最小值点，将物理中冲量的概念引入到了参数更新方法中。应用比较广泛的有Momentum，Nesterov accelerated gradient，Adagrad，RMSprop，Adadelta，Adam之类的算法。
#### Momentum
Momentum是较基础的版本，其表达式如下：
$$
\mu_{t}=\gamma\mu_{t-1}+\eta \nabla J\left(\theta\right)
$$

$$
\theta_{t}=\theta_{t-1}-\mu_{t}
$$
其中$\theta$为神经网络模型参数，$\gamma$是衰减系数，$\eta$是学习率，$J\left(\theta\right)$为该批次误差的和。

#### Nesterov accelerated gradient
Nesterov accelerated gradient算法对Momentum做了微小的改进，使得它能提前一步感知参数变化的方向，其表达式如下：

$$
\mu_{t}=\gamma\mu_{t-1}+\eta \nabla J\left(\theta-\gamma\mu_{t-1}\right)
$$

$$
\theta_{t}=\theta_{t-1}-\mu_{t}
$$

#### Adagrad
所有参数使用同一个学习率会不会有点粗糙？在数据量比较稀疏，各个特征出现的频率又比较不一致时，给出现频率较低的特征以更大的学习率可能更加合适一点。Adagrad针对每一个参数的不同特点，做了差异化的更新策略，使得学习率可以适应数据的特点，其表达式如下：
$$
\theta_{t}=\theta_{t-1}-\frac{\eta}{\sqrt{G_{t-1}+\epsilon }}\otimes \nabla _{\theta_{t-1}}J\left(\theta_{t-1}\right)
$$

$\nabla _{\theta_{t-1}}J\left(\theta_{t-1}\right)$是时刻$t-1$参数$\theta$的微分，这里的关键是$G_{t-1}$，他是一个累加的梯度平方和，通过这个历史记录，使得对于历史梯度比较大的参数，降低其学习率，历史梯度比较小的参数，增大其学习率。

#### RMSprop
Adagrad一个很显然的问题是累加的梯度平方和会越来越大，导致学习率越来越小，参数更新就会越来越慢甚至无法学习。一个比较容易想到的办法就是采用滑动窗口的形式，固定累加梯度窗口大小，这就是RMSprop的思想，不过把滑动窗口变为类似于冲量的形似了，公式如下：
$$
g_{t}=\nabla _{\theta_{t}}J\left(\theta_{t}\right)
$$

$$
E\left[g^{2}\right]_{t}=\gamma E\left[g^{2}\right]_{t-1} + \left(1-\gamma\right)g_{t}^{2}
$$

$$
\theta_{t}=\theta_{t-1}-\frac{\eta}{\sqrt{E\left[g^{2}\right]_{t}+\epsilon }}\odot g_{t-1}
$$

#### Adadelta
Adadelta 与RMSprop 较为类似，其把超参数$\eta$也用与分母类似的方法做处理了，只不过针对的是参数更新量。
$$
g_{t}=\nabla _{\theta_{t}}J\left(\theta_{t}\right)
$$

$$
E\left[g^{2}\right]_{t}=\gamma E\left[g^{2}\right]_{t-1} + \left(1-\gamma\right)g_{t}^{2}
$$

$$
E\left[\nabla \theta^{2}\right]_{t}=\gamma E\left[\nabla \theta^{2}\right]_{t-1} + \left(1-\gamma\right)\nabla \theta^{2}
$$

$$
\nabla \theta_{t}=-\frac{\sqrt{E\left[\nabla \theta^{2}\right]_{t-1}}}{\sqrt{E\left[g^{2}\right]_{t}+\epsilon }} g_{t}
$$


$$
\theta_{t+1}=\theta_{t}+\nabla \theta_{t}
$$

#### Adam
Adam算法是另一种提供自适应学习率的算法，它构造了两个类似于冲量的表达式，分别代表均值和方差
$$
m_{t}=\beta_{1}m_{t-1}+\left(1-\beta_{1}\right)g_{t}
$$

$$
v_{t}=\beta_{2}v_{t-1}+\left(1-\beta_{2}\right)g_{t}^{2}
$$

$$
\hat{m_{t}}=\frac{m_{t}}{1-\beta_{1}^{t}}
$$

$$
\hat{v_{t}}=\frac{v_{t}}{1-\beta_{2}^{t}}
$$


$$
\theta_{t+1}=\theta_{t}-\frac{\eta}{\sqrt{\hat{v_{t}}}+\epsilon }\hat{m_{t}}
$$

由于$m_{0}$和$v_{0}$都被初始化为0，所以$\hat{m_{t}}$和$\hat{v_{t}}$其实是在做纠偏，详见[adam][5]论文第3节
#### AdamW
权重衰减算法和$L_{2}$正则并不是同一个算法，虽然在SGD中，二者具有等价的形似，但是放在Adam优化算法中来说，二者区别较大，对于$L_{2}$正则的系数，Adam算法中除以了$\sqrt{\hat{v_{t}}}+\epsilon$，这可能导致大的参数值（大的参数值很可能对应大的梯度）反而正则化系数更小，所以可能权重衰减算法会在Adam优化算法中表现更好。在这之前，主流深度学习库实现的都是$L_{2}$正则，为了正确的修正使用权重衰减，提出了AdamW，此外AdamW对衰减系数也做了一定的优化。
### batch_size 和lr 的关系
增大batch_size可以加快模型的训练时间，但batch_size并不是越大越好，太大batch_size会导致模型容易陷入尖锐的局部最优，且训练的模型泛化能力差。下图是某张batch_size和验证损失的关系图。
![batch_size_effect][3]
可以看到在这次实验中超过8k大小的batch_size会使得性能急剧降低。
那么$batch_size$和$lr$有什么关系呢，先给出论文中得出的经验结论：
1. 如果要保证同样数量的样本更新的权重相等，那么$batch\_size$增大$k$倍，$lr$增大$k$倍
2. 如果要保证权重的方差不变，那么$batch\_size$增大$k$倍，$lr$增大$\sqrt{k}$倍

这两个都是可以的。
**结论1的解释：**
定义损失函数：
$$
L\left(w\right)=\frac{1}{\left|X \right|}\sum_{x \in X}l\left(x,w\right)
$$

那么参数$w$更新如下：
$$
w_{t+1}=w_{t}-\eta \frac{1}{n}\sum_{x\in  B}\nabla l\left(x,w_{t}\right)
$$

$B$是$minibatch$的集合，$n=\left|B\right|$，$\eta$是学习率，$t$是迭代次数。
假如累积$k$次迭代，那么

$$
w_{t+k}=w_{t}-\eta \frac{1}{n}\sum_{j<k}\sum_{x\in  B_{j}}\nabla l\left(x,w_{t+j}\right)
$$

如果直接增大$batch\_size$的值为原来的$k$倍，那么：
$$
\hat{w}_{t+1}=w_{t}-\hat{\eta} \frac{1}{kn}\sum_{j<k}\sum_{x\in  B_{j}}\nabla l\left(x,w_{t}\right)
$$

假设$\nabla l\left(x,w_{t}\right)\approx\nabla l\left(x,w_{t+j}\right)$，那么可以看出只要令$\hat{\eta}=k\eta$，就有$w_{t+k}\approx \hat{w}_{t+1}$。

实际中在训练开始是参数变化比较剧烈，会有$\nabla l\left(x,w_{t}\right)\not\approx\nabla l\left(x,w_{t+j}\right)$，所以在开始训练时，增大$batch\_size$，$\hat{\eta}$需要一个warmup
的过程缓慢增加到$k\eta$。
**结论2的解释：**
详细可以看[该论文](https://arxiv.org/abs/1705.08741)，主要思想是保证**权重的方差不变**。

### 寻找较优的初始学习率
自动寻找较优的初始$lr$的方法的思想是，在模型训练时，从一个非常小初始$lr$开始，例如$1e-7$，逐渐加大$lr$，此时由于初始$lr$非常小，模型的loss是下降的，当随着$lr$的增加，模型的loss开始发散或者大于loss最好值的若干倍时，停止增大$lr$的探索过程。一个实际的探索过程如下图所示
![lr_finder][3]
此时较优的$lr$就可以选取为loss开始急剧上升前一小段的$lr$。
逐渐加大$lr$的方法既可以是线性增加，也可以是指数级别增加。



[1]: /mark/assets/images/2020-06-10-parameter-update-strategy/effect_of_various_learning_rates_on_convergence.png
[2]: /mark/assets/images/2020-06-10-parameter-update-strategy/cyclical_learning_rates.png
[3]: /mark/assets/images/2020-06-10-parameter-update-strategy/batch_size_effect.png
[4]: /mark/assets/images/2020-06-10-parameter-update-strategy/lr_finder.png
[5]: https://arxiv.org/pdf/1412.6980.pdf


