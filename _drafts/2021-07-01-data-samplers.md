---

layout: post
title: DataSamplers
date: 2021-07-01 16:25:00
categories: [AI]
tags: [AI，NLP，Sampler]

---
# 

train和test有类别平衡，每个mini batch也可以做类别平衡

~~~
from torch.utils.data import Sampler,SequentialSampler,RandomSampler,SubsetRandomSampler

class weightedsampler(Sampler):

    def __init__(self,dataset):

        self.indices = list(range(len(dataset)))
        self.num_samples = len(dataset)
        self.label_to_count = dict(Counter(dataset.bins))
        weights = [1/self.label_to_count[i] for i in dataset.bins]
        self.weights = torch.tensor(weights,dtype=torch.double)

    def __iter__(self):
        count = 0
        index = [self.indices[i] for i in torch.multinomial(self.weights, self.num_samples, replacement=True)]
        while count < self.num_samples:
            yield index[count]
            count += 1

    def __len__(self):
        return self.num_samples
~~~
    



