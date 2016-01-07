---

layout: post
title:  "Html拖放事件"
date:   2015-06-04 17:17:00
categories: [Html5]
tags: [html5]

---
为了使得元素能够被拖放首先要设置被拖动元素的 draggable="true"

**被拖动对象**

被拖动对象会触发三个事件如下，分别触发三个事件所指定的回调函数

  1. ondragstart-------->开始拖动时被触发
  2. drag--------------->拖动过程中一直被触发
  3. ondragend---------->松开拖动鼠标后被触发

**目标对象**

目标对象即被拖动对象所拖动到的对象，会触发如下事件

  1. dragenter---------->被拖动对象进入目标对象后被触发
  2. dragover----------->被拖动对象在目标对象上时一直被触发
  3. dragleave或drop---->dragleave事件在被拖动对象离开目标对象后被触发，drop事件在被拖动对象拖动到目标对象上松开鼠标后被触发，drop事件和dragleave事件为互斥事件，不能同时发生。

[**代码示例**][w3cschool demo]

[w3cschool demo]: http://www.w3school.com.cn/tiy/t.asp?f=html5_draganddrop
