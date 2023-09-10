---

layout: post
title:  Twitter Structure
date:   2023-04-20 19:00:00
categories: [Recommend]
tags: [open, twitter, recommend]

---

## 整体框架
### 数据处理
unified-user-actions 实时用户行为流
user-signal-service 集中的信号处理平台，信号包括显示的信号如喜欢和回复，隐式的信号如详情页访问，twitter链接点击

### 模型
**SimClusters**：社区发现，社区的sparse embeddings
**TwHIN**：用户和推文的dense knowledge graph embeddings
**trust-and-safety-models**：内容审核
**real-graph**：预测用户之间交互的概率
**tweepcred**：用户page rank
**recos-injector**：Streaming event processor for building input streams for GraphJet based services.
**graph-feature-service**：协同推荐 --Serves graph features for a directed pair of Users (e.g. how many of User A's following liked Tweets from User B).
**topic-social-proof**：话题识别

### 软件框架
**navi**：机器学习服务部署
**product-mixer**：内容feed流
**twml**：老的TensorFlow v1框架