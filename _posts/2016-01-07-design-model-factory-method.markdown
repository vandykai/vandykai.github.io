---

layout: post
title:  Design Pattern - Factory Method
date:   2016-01-07 19:50:00
categories: [Design-Pattern]
tags: [design-pattern, factory-method]

---
## 工厂方法模式

1. **适用范围**：当一个对象的创建和初始化工作比较复杂或者一个对象会被反复创建时，采用工厂方法模式是一个很好的选择。
2. 工厂方法模式的思想是每个产品的创建都有一个具体的工厂类来实现，由此可能会想到为什么不在产品类里面提供一个创建自己的方法，这是由于不同的使用者可能创建时需要的参数不同，这时用工厂方法模式就可以直接再新建（符合开闭原则，只增加不修改）一些工厂来区分不同的参数，而由产品类自己创建就势必要提供很多创建方法，不符合开闭原则。

2. 工厂方法模式的实现方式  

    ~~~Java
    public class Product {

        public void commonMethod() {
            return;
        }

    }
    ~~~

    ~~~Java
    public class ProductOne extends Product{
        // empty
    }
    ~~~

    ~~~Java
    public class ProductTwo extends Product{
        //empty
    }
    ~~~
    ~~~Java
    public abstract class Creator {

        public abstract Product getProduct();

    }
    ~~~
    ~~~Java
    public class ProductOneCreator extends Creator {

        @Override
        public ProductOne getProduct() {
            ProductOne productOne = new ProductOne();
            // Initial productOne here
            return productOne;
        }

    }
    ~~~
    ~~~Java
    public class ProductTwoCreator extends Creator {

        @Override
        public ProductTwo getProduct() {
            ProductTwo productTwo = new ProductTwo();
            // Initial productTwo here
            return productTwo;
        }

    }
    ~~~
    ~~~Java
    public class Client {

        public static void main(String args[]) {
            Product productOne = new ProductOneCreator().getProduct();
            Product productTwo = new ProductTwoCreator().getProduct();
            productOne.commonMethod();
            productTwo.commonMethod();
        }
    }
    ~~~
    窃以为实现工厂方法模式时如需要则可以把工厂做成单例，或工厂中产生对象的方法做成静态方法，当然静态方法可能是不妥的，待以后想到再来修改此处。
4. 与工厂方法模式类似的还有一种叫做简单工厂的模式，这种模式通过一个工厂类来根据传入的参数来选择生成不同的产品对象，所有的产品都继承一个公共的产品抽象类，这种模式的缺点是当生产的产品过多时，将导致工厂类较复杂，不利于后期维护，这种模式不属于经典的二十三种模式之一。工厂方法模式就是把简单工厂的一个大工厂创建所有的类的形式拆分成许多小工厂，并抽象出一个抽象工厂类，这个抽象工厂类只负责定义创建的方式，具体创建的内容有继承它的小工厂类来实现。
