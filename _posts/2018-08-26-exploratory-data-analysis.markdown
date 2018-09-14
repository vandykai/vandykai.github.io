---

layout: post_pdf
title:  Exploratory Data Analysis
date:   2018-08-26 14:30:00
categories: [Machine-Learning]
tags: [AI, machine-learning]

---

## 基本分析
```
root_path =r'/home/kesci/input/titanic/'
train = pd.read_csv(root_path + 'train.csv')
test = pd.read_excel(root_path + 'test.csv')
train.info()
train.describe()
train.count() != train.count().max() 看那些值有缺失
train.describe().loc['count']==train.describe().loc['count'].max() # 看那些数值属性值有缺失
train.describe().loc['min']==train.describe().loc['max'] # 查看那些数值属性是固定值
```
## 缺失值填充
１. 对于Category型数据用众数进行填充

２. 对于数值型数据用均值/中位数进行填充

## 散碎点
* 线上线下的效果差距却非常的大,这里面很大一部分原因在于,我们在做特征工程的时候,有一些特征在 训练集合上与label有很强的关系,但是却在测试集上却相对弱很多,我们将训练集进行拆分,分为训练集和验证机；用来模拟训练集和测试集的关系，如果在训练集和验证集上我们发现某特征与label的关系相差不大且都有一定的统计特性,我们就将其作为我们的好特征，即使它是弱特征也无所谓，因为即使过拟合也会在训练集和测试集上表现一致。