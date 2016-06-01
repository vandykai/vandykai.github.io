---

layout: post
title:  Linux Kernel - Working Process Of Assembly Code
date:   2016-02-25 10:42:00
categories: [Linux]
tags: [linux, linux-kernel, experiment]

---

## 重点知识总结
- CS(code segment register)是代码段寄存器,CPU在实际取指令时根据cs:eip来准确定位一个指令。
- b，w，l，p，分别指8位，16位，32位，64位，如movl指移动32位的数据。
- **AT&T**汇编格式与**Intel**汇编格式略有不同，Linux使用的是**AT&T**汇编格式。
- eip寄存器不能被直接修改，只能通过特殊指令间接修改，如通过call与ret指令。
- 函数的返回值默认使用eax寄存器存储返回给上一级函数
- 汇编中对应的方法过程如下

    ``` C
    method:
        enter
        // Real Code Here
        leave
        ret
    ```

- 指令实际做的事情列表：

    ~~~ Java
    push %eax
        subl $4, %esp
        movl %eax, (%esp)
    pop %eax
        movl (%esp), %eax
        addl $4, %esp
    call 0x12345
        pushl %eip*
        movl $0x12345, %eip*
    ret
        popl %eip*
    enter
        pushl %ebp
        movl %esp, %ebp
    leave
        movl %ebp, %esp
        popl %ebp
    ~~~

###实验分析
C程序源代码如下图

![main.c][1]
汇编源代码如下图

![main.s][2]
从图中可以看出，C程序方法对应的汇编方法一般过程如下：

``` C
method:
        enter
        // Real Code Here
        leave
        ret
```
若方法中不再调用另一方法也即汇编代码中不调用call语句，那么`leave`语句可优化为`popl %ebp`
参数传递通过堆栈完成，一个参数，则通过`8(%ebp)`取参数，两个参数则通过`12(%ebp)`, `8(*ebp)`分别取出第一和第二个参数。

wdk 原创作品转载请注明出处  
相关链接 [《Linux内核分析》MOOC课程http://mooc.study.163.com/course/USTC-1000029000][3]

[1]: /mark/assets/images/2016-02-25-linux-kernel-working-process-of-assembly-code/main-c.png
[2]: /mark/assets/images/2016-02-25-linux-kernel-working-process-of-assembly-code/main-s.png
[3]: http://mooc.study.163.com/course/USTC-1000029000
