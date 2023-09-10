---

layout: post
title: numpy sigmoid implement
date: 2021-02-23 17:00:00
categories: [AI]
tags: [AI， NLP]

---

~~~python
import random
import numpy as np

arr = (np.random.randint(1, 1000000, size=(20,20,30))-500000)/100

def sigmoid_f1(x):
    x_shape = x.shape
    x = x.reshape(-1)
    return np.array([1. / (1. + np.exp(-i)) if i >= 0 else (np.exp(i) / (1. + np.exp(i))) for i in x], np.float).reshape(x_shape)

def _positive_sigmoid(x):
    return 1 / (1 + np.exp(-x))

def _negative_sigmoid(x):
    exp = np.exp(x)
    return exp / (exp + 1)

def sigmoid_f2(x):
    positive = x >= 0
    # Boolean array inversion is faster than another comparison
    negative = ~positive

    # empty contains junk hence will be faster to allocate
    # Zeros has to zero-out the array after allocation, no need for that
    result = np.empty_like(x)
    result[positive] = _positive_sigmoid(x[positive])
    result[negative] = _negative_sigmoid(x[negative])

    return result

def sigmoid_f3(x):
    return np.piecewise(
        x,
        [x > 0],
        [lambda i: 1 / (1 + np.exp(-i)), lambda i: np.exp(i) / (1 + np.exp(i))],
    )

def sigmoid_f4(x):
    return np.where(
            x >= 0, # condition
            1 / (1 + np.exp(-x)), # For positive values
            np.exp(x) / (1 + np.exp(x)) # For negative values
    )

%timeit sigmoid_f1(arr)
%timeit sigmoid_f2(arr)
%timeit sigmoid_f3(arr)
%timeit sigmoid_f4(arr)
~~~


~~~python
# output
45.9 ms ± 644 µs per loop (mean ± std. dev. of 7 runs, 10 loops each)
635 µs ± 11.7 µs per loop (mean ± std. dev. of 7 runs, 1000 loops each)
826 µs ± 18.7 µs per loop (mean ± std. dev. of 7 runs, 1000 loops each)
/lib/python3.6/site-packages/ipykernel_launcher.py:41: RuntimeWarning: overflow encountered in exp
/lib/python3.6/site-packages/ipykernel_launcher.py:42: RuntimeWarning: overflow encountered in exp
/lib/python3.6/site-packages/ipykernel_launcher.py:42: RuntimeWarning: invalid value encountered in true_divide
1.03 ms ± 14.5 µs per loop (mean ± std. dev. of 7 runs, 1000 loops each)
~~~

# 结论
可以看出第二种方法最好，且方法四由于`np.where`两个分支的值都会计算，所以会导致警告，虽然对结果没影响