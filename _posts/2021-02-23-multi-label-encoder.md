---

layout: post
title:   Multi Label Encoder
date:   2021-02-23 17:00:00
categories: [AI]
tags: [AI， NLP]

---

### Multi-Hot 编码效率对比

```python
import random
import torch

n_class = 800
arr = [[random.randint(0,n_class-1) for _ in range(random.randint(5,10))] for _ in range(random.randint(100,1000))]
def f1(arr, n_class):
    arr = [[0 if i not in ex else 1 for i in range(n_class)] for ex in arr]
    var = torch.tensor(arr, dtype=torch.float)
    return var

def f2(arr, n_class):
    var = torch.zeros(len(arr), n_class)
    for i in range(len(arr)):
        var[i, arr[i]] = 1
    return var

def f3(arr, n_class):
    arr = [torch.LongTensor([ex]) for ex in arr]
    var = torch.cat([torch.nn.functional.one_hot(ex, num_classes=n_class).sum(dim=1).float() for ex in arr], dim=0)
    return var

%timeit f1(arr, n_class)
%timeit f2(arr, n_class)
%timeit f3(arr, n_class)
```

```python
# output
29.6 ms ± 403 µs per loop (mean ± std. dev. of 7 runs, 10 loops each)
2.76 ms ± 144 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)
8.25 ms ± 139 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)
```

# 结论
可以看出第二种方法最好
