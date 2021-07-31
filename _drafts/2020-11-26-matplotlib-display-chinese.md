---

layout: post
title:  matplotlib-display-chinese
date:   2020-11-26 12:00:00
categories: [AI]
tags: [AI， NLP]

---


### matplotlib 不显示中文解决办法
1. 下载Microsoft-Yahei-Mono字体 https://github.com/cheny-m/Microsoft-Yahei-Mono
2. `cp MSYHMONO.ttf .local/miniconda3/envs/art/lib/python3.6/site-packages/matplotlib/mpl-data/fonts/ttf/`
3. rm ~/.cache/matplotlib/
4.  修改配置
  4.1.  永久修改：
  修改文件 `.local/miniconda3/envs/art/lib/python3.6/site-packages/matplotlib/mpl-data/matplotlibrc `
  `#axes.unicode_minus: False #用来显示负号`
  `## 添加Microsoft YaHei Mono字体`
  `#font.sans-serif: Microsoft YaHei Mono, DejaVu Sans,.......`
  4.2.  临时修改：
  设置
  ```
    import matplotlib.pyplot as plt
    plt.rcParams['font.sans-serif'] = ['Microsoft YaHei Mono']
    plt.rcParams['axes.unicode_minus'] = False
  ```
