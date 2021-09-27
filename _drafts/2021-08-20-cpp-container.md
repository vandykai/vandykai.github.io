---

layout: post
title: CPP 容器
date: 2021-07-01 16:25:00
categories: [CPP]
tags: [C++, CPP]

---

## 顺序容器
### vector

```cpp
#include <vector>
#include <iostream>
using namespace std;
int main() {
    vector<int> vVector;
    vVector.push_back(1); // vector尾添加元素
    vVector.push_back(2);
    vVector.insert(vVector.begin()+1, 4); // 第一个位置前插入1个4
    vVector.insert(vVector.begin()+1, 2, 5); // 第一个位置前插入2个5
    // vector now is [1 5 5 4 2]
    vVector.push_back(3);
    vVector.pop_back(); // 删除vector最后一个元素
    for(auto it:vVector) {
        cout<<it<<" ";
    }
    cout<<endl;
    cout<<vVector.size()<<endl; // vector大小
    cout<<vVector.front()<<endl; // 获取vector第一个元素，不删除
    cout<<vVector.back()<<endl; // 获取vector最后一个元素，不删除
    cout<<vVector.empty()<<endl; // 队列是否为空
    cout<<vVector[1]<<endl; // 获取任意位置元素
    cout<<vVector.at(1)<<endl; // 获取任意位置元素
}
```

### deque

### list

## 关联容器
### set
```cpp
#include <set>
#include <iostream>
using namespace std;
int main() {
    set<int> sSet;
    sSet.insert(1); // 集合添加元素
    sSet.insert(2);
    sSet.insert(2); // 重复添加无效
    sSet.insert(3);
    cout<<sSet.count(2)<<endl; // 集合中元素是否出现
    cout<<sSet.size()<<endl; // 集合大小
    cout<<sSet.empty()<<endl; // 集合是否为空
    cout << c.erase(2) <<endl; // 删除元素2，返回删除个数，这里是2，也可传入迭代器删除
    cout<<*sSet.begin()<<endl; // 集合中最小的值
    cout<<*sSet.rbegin()<<endl; // 集合中最大的值
}
```
### multiset
```cpp
#include <set>
#include <iostream>
using namespace std;
int main() {
    multiset<int> sSet;
    sSet.insert(1); // 集合添加元素
    sSet.insert(2);
    sSet.insert(2); // 可以重复添加
    sSet.insert(3);
    cout<<sSet.count(2)<<endl; // 集合中元素是否出现
    cout<<sSet.size()<<endl; // 集合大小
    cout<<sSet.empty()<<endl; // 集合是否为空
    cout<<*sSet.begin()<<endl; // 集合中最小的值
    cout<<*sSet.rbegin()<<endl; // 集合中最大的值
}
```
### map
### multimap

## 容器适配器
### stack
```cpp
#include <stack>
#include <iostream>
using namespace std;
int main() {
    stack<int> sStack;
    sStack.push(1); // 堆栈头添加元素
    sStack.push(2);
    cout<<sStack.size()<<endl; // 堆栈大小
    cout<<sStack.top()<<endl; // 获取堆栈首元素，不删除
    cout<<sStack.empty()<<endl; // 队列是否为空
    sStack.pop(); // 删除堆栈首元素
}
```

### queue

```cpp
#include  <queue>
#include  <iostream>
    using  namespace  std;
    int  main() {
    queue<int> qQueue;
    qQueue.push(1); // 队尾添加元素
    qQueue.push(2);
    cout<<qQueue.size()<<endl; // 队列大小
    cout<<qQueue.front()<<endl; // 获取队首元素，不删除
    cout<<qQueue.back()<<endl; // 获取队尾元素，不删除
    cout<<qQueue.empty()<<endl; // 队列是否为空
    qQueue.pop(); // 删除队首元素
}
```

### priority_queue (优先队列，大顶堆)

```cpp
#include <queue>
#include <iostream>
using namespace std;
int main() {
    priority_queue<int> pqQueue;
    pqQueue.push(1); // 大顶堆添加元素
    pqQueue.push(4);
    pqQueue.push(3);
    pqQueue.push(2);
    cout<<pqQueue.size()<<endl; // 大顶堆大小
    pqQueue.pop(); // 删除大顶堆最大元素
    cout<<pqQueue.top()<<endl; // 获取大顶堆最大元素，不删除
}
```
