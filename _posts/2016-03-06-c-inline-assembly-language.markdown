---

layout: post
title:  C Inline Assembly Language
date:   2016-03-06 08:45:00
categories: [Gramar]
tags: [gramar, c]

---

## C语言内嵌汇编语法

### GCC

~~~ C
 __asm__(
    汇编语句模版：
    输出部分：
    输入部分：
    破坏描述部分
);
~~~

即格式为`asm("statements":output_regs:input_regs:clobbered_regs);`


`__asm__`表示后面的代码为内嵌汇编，同时`__asm__`也可由`asm`来代替，`asm`是`__asm__`的别名。

在`__asm__`后面有时也会加上`__volatile__`表示编译器不要优化代码，后面的指令保留原样，同样`volatile`是它的别名，在这里值得注意的是无论`__asm__`还是"`__volatile__`"中的每个下划线都不是一个单独的下划线，而是两个短的下划线拼成的。再后面括号里面的便是汇编指令。


### Visual C++

```
__asm 汇编指令 [ ; ]
__asm { 汇编指令 } [ ; ]
```
同样asm前面是两条下划线，后面的方括号内容表示分号可有可无。

1. 组成一块地用

    ```
    __asm {
       mov al, 2
       mov dx, 0xD007
       out dx, al
    }
    ```
2. 分条的使用

    ```
    __asm mov al, 2
    __asm mov dx, 0xD007
    __asm out dx, al
    ```

    也可以写在同一行

    ```
    __asm mov al, 2   __asm mov dx, 0xD007   __asm out dx, al
    ```

### Turbo C

1. 使用预处理程序的伪指令#asm和#endasm,#asm用来开始一个汇编程序块，而#endasm指令用于该块的结
束。

    ```
    mul(a,b)
    int a,b;
    {
       #asm
           mov ax,word ptr 8[bp]
           imul ax word ptr 10[bp]
       #endasm
    }
    ```

2. 使用asm语句
格式：asm<汇编语句>

    ```
    mul(a,b)
    int a,b;
    {
        asm   mov ax,word ptr 8[bp]
        asm   imul ax word ptr 10[bp]
    }
    ```

> Visual C++ 和 Turbo C语法转自[http://bbs.51cto.com/thread-652061-1.html][1]

[1]: http://bbs.51cto.com/thread-652061-1.html
