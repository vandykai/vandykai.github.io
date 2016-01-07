---

layout: post
title:  Design Pattern - Singleton
date:   2016-01-05 19:50:00
categories: [Design-Pattern]
tags: [design-pattern, singleton]

---
##单例模式

1. 单例模式可以分为**强制型单例**和**非强制型单例**（也有人叫管理上的单例），这两种单例是我自己命名的，前一种单例是让coder代码上不能轻易（Java中可以通过反射机制创建对象）创建对象，只能使用单例模式提供的获取对象的方法，非强制性单例代码上不对coder做强制性限制，要求自觉。
2. 多线程安全强制型单例的实现方式  
    饿汉式：

    ~~~ Java
    // 饿汉式
    public class Singleton {

        private static Singleton instance = new Singleton();
        private Singleton() {
            // empty
        }
        public static Singleton getInstance() {
            return instance;
        }
    }

    ~~~
    双检测锁机制的单例模式：

    ~~~ Java
    // 双检测锁机制的单例模式
    public class Singleton {

        private static Singleton instance = null;
        private Singleton() {
            // empty
        }
        public static Singleton getInstance() {
            if (instance == null) {
                synchronized (Singleton.class) {
                    if (instance == null) {
                        instance = new Singleton();
                    }
                }
            }
            return instance;
        }
    }
    ~~~

    还有一种懒汉式的实现方法，不过不满足多线程安全，只能在单线程下使用

3. 多线程安全非强制性单例的实现方式

    ~~~~ Java
    public class Singleton {
        // empty
    }

    ~~~~

    ~~~~ Java
    import java.util.HashMap;
    import java.util.Map;

    public class BeanFactory {

        public static Map<String, Object> beans = new HashMap<String, Object>();
        private static BeanFactory instance = new BeanFactory();

        private BeanFactory() {
            // empty
        }
        public static BeanFactory getInstance() {
            return instance;
        }

        public Object getBean(String id) {
            if (beans.containsKey(id)) {
                return beans.get(id);
            } else if (id.equals(Singleton.class.getSimpleName())) {
                synchronized (Singleton.class) {
                    if (!beans.containsKey(id)) {
                        beans.put(id, new Singleton());
                    }
                }
                return beans.get(id);
            }
            return null;
        }
    }

    ~~~~
4. 单例模式还有范围的概念，即在某一范围内才是单例，范围扩大了可能就不是单例了，常见的单例范围有application级别，session级别，request/response级别。  
**小技巧**：可以利用thread的thread号为关键字存入HashMap来实现thread级别的单例。
5. 利用单例模式的**通用规则**：并不是所有的类都适合做成单例，如果一个类含有数据（也即是有状态的类），那么将该类做成单例时可能会引发线程安全问题（多个线程同时对数据操作），此时的解决之道是要么将该数据做成只读（创建时写入数据），要么不做成单例，做成单例的类要尽量保证是无状态的。
