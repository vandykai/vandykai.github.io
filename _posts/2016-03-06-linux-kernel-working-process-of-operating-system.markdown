---

layout: post
title:  Linux Kernel-Working Process Of Operating System
date:   2016-03-06 10:45:00
categories: [linux]
tags: [linux, linux-kernel, experiment]

---

## 重点知识总结

### C语言内嵌汇编语法

[C Inline Assembly Language][1]

## 实验分析
### 自定义进程定义的代码如下
```
#define MAX_TASK_NUM        4
#define KERNEL_STACK_SIZE   1024*8

/* CPU-specific state of this task */
struct Thread {
    unsigned long        ip;
    unsigned long        sp;
};

typedef struct PCB{
    int pid;
    volatile long state;    /* -1 unrunnable, 0 runnable, >0 stopped */
    char stack[KERNEL_STACK_SIZE];
    /* CPU-specific state of this task */
    struct Thread thread;
    unsigned long    task_entry;
    struct PCB *next;
}tPCB;
```
### 自定义进程切换的核心代码如下
```
if(next->state == 0) {
    /* -1 unrunnable, 0 runnable, >0 stopped */
    my_current_task = next;
    printk(KERN_NOTICE ">>>switch %d to %d<<<\n",prev->pid,next->pid);
    /* switch to next process */
    asm volatile(
            "pushl %%ebp\n\t" /* save ebp */
            "movl %%esp,%0\n\t" /* save esp */
            "movl %2,%%esp\n\t" /* restore  esp */
            "movl $1f,%1\n\t" /* save eip */
            "pushl %3\n\t"
            "ret\n\t" /* restore  eip */
            "1:\t" /* next process start here */
            "popl %%ebp\n\t"
            : "=m" (prev->thread.sp),"=m" (prev->thread.ip)
            : "m" (next->thread.sp),"m" (next->thread.ip)
    );
} else {
    next->state = 0;
    my_current_task = next;
    printk(KERN_NOTICE ">>>switch %d to %d<<<\n",prev->pid,next->pid);
    /* switch to new process */
    asm volatile(
            "pushl %%ebp\n\t" /* save ebp */
            "movl %%esp,%0\n\t" /* save esp */
            "movl %2,%%esp\n\t" /* restore  esp */
            "movl %2,%%ebp\n\t" /* restore  ebp */
            "movl $1f,%1\n\t" /* save eip */
            "pushl %3\n\t"
            "ret\n\t" /* restore  eip */
            : "=m" (prev->thread.sp),"=m" (prev->thread.ip)
            : "m" (next->thread.sp),"m" (next->thread.ip)
    );
}
```
### 自定义进程切换代码简析
计算机硬件三大法宝，存储程序计算机，函数调用堆栈，中断
操作系统的“两把剑”：中断上下文和进程上下文切换

这里进程切换主要是保存当前进程的运行栈和准备好下一个进程的运行栈。

1. 若下一个进程是可运行的,即状态码是0
先保存当前进程的运行栈，把当前进程的栈底ebp压入到该进程自己的堆栈，再将栈顶指针esp用该进程的sp指针保存，接着把下一个进程的sp指针恢复到保存栈顶的寄存器esp中去，保存当前进程运行的下一条指令的地址到该进程的ip指针中去，其中$1f是指接下来的标号1：的位置，接着再恢复下一个进程的ip指针到eip寄存器中去，由于eip寄存器不能被直接修改，只能通过ret，call等指令间接修改，于是便通过`"pushl %3\n\t" "ret\n\t"`两条指令间接修改，ret相当于`popl %eip*`,最后一条语句是当前进程下次再获得cpu运行时的第一条语句，也是下一进程需要运行的指令，用来恢复之前被压入各个进程自己的栈的ebp，这里巧妙地共用了这条指令。

2. 若下一个进程不是可运行的,即状态码不是0
同样先保存当前进程的运行栈，把当前进程的栈底ebp压入到该进程自己的堆栈，再将栈顶指针esp用该进程的sp指针保存，接着把下一个进程的sp指针恢复到保存栈顶的寄存器esp中去，由于下一个进程是不可运行的，所以下一个进程的原先栈里什么也没有，是空栈，所以esp和ebp相等，接着保存当前进程运行的下一条指令的地址到该进程的ip指针中去，同样是用两条语句恢复下一个进程的ip指针到eip寄存器中去。



wdk 原创作品转载请注明出处  
相关链接 [《Linux内核分析》MOOC课程http://mooc.study.163.com/course/USTC-1000029000][2]

[1]: /mark/gramar/2016/03/06/c-inline-assembly-language.html
[2]: http://mooc.study.163.com/course/USTC-1000029000
