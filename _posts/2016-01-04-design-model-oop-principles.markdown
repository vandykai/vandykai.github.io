---

layout: post
title:  Design Pattern - OOP Principles
date:   2016-01-04 17:07:00
categories: [Design-Pattern]
tags: [design-pattern, oop]

---
##面向对象的原则

**总的原则**-**高内聚，低耦合**

1. **单一职责原则（SRP，Single Responsibility Principle）**：一个类实现一种功能，引起类变化的原因只有一种。  
2. **开闭原则（OCP，Open for Extension，Closed for Modification Principle）**：对扩展（功能拓展）开放，对修改（指修改功能正常运行的代码）关闭。  
3. **依赖注入原则（DIP，Dependence Inversion Principle）**：要依赖抽象，不要依赖具体，通过注入的方法实现抽象转具体（可参考spring中的配置式注入）。  
4. **里式替换原则（LSP，Liskov Substitution Principle）**：抽象类出现的地方都可以用实现类来代替。  
5. **迪米特原则（LOD,Law of Demeter）**：一个对象应该对其他对象尽可能少的了解。  
6. **接口分离原则（ISP，Interface Segregation Principle）**：一个接口只提供一种对外的功能，典型的违背原则的例子是接口富余，也就是实现类中被强迫实现（或含有）自己不需要的接口中的方法。  
7. **组合优于继承（CARP，Composite/Aggregate Reuse Principle）**：组合一般能比继承要更能降低依赖关系。
