---

layout: post
title:  Linux Kernel-System Call
date:   2016-03-18 12:13:00
categories: [linux]
tags: [linux, linux-kernel, experiment]

---

## 重点知识总结
- Intel X86 CPU 有四种不同的执行级别0-3，Linux只使用了其中的0级和3级，分别来表示内核态和用户态。
- 一般来说在32位X86机器上，Linux系统中，地址空间是一个显著的标志：0XC0000000以上的地址空间只能在内核态下访问，0X00000000-0XBFFFFFFF的地址空间在两种状态下都可以访问，这里所说的是逻辑地址而不是物理地址。所以寄存器的最低两位表明了当前代码所需的特权级。11代表需要内核态级别，否则只需要用户态级别。
- 中断处理是从用户态进入内核态主要的方式。系统调用是一种特殊的中断。
- 从用户态切换到内核态时，必须保存用户态的寄存器上下文。
- 中断/int指令会在堆栈上保存一些寄存器的值，如用户态栈顶指针，当时的状态字，当时的cs:eip的值，并恢复内核态的对应寄存器的值。
- 中断发生后第一件事就是保存现场到自己（内核态)的堆栈中,这就正好衔接了之前保存和恢复栈顶指针的动作，保护现场就是进入中断程序保存需要用到的寄存器的数据，也可以简单保存其他所有寄存器的值即定义一个SAVE_ALL的代码块供调用。恢复现场同理。
- iret指令与中断信号（包括int指令）发生时CPU做的动作正好相反
- 中断一般模版

    ```
    ;进入中断
    int指令进入到中断/系统调用
    ```

    ```
    ;中断处理程序一般步骤
    SAVE_ALL调用
    中断处理程序
    RESTORE_ALL调用
    iret指令
    ```

- Libc库定义的一些API引用了封装例程（wrapper routine，唯一的目的就是发布系统调用），一般每个系统调用对应一个封装例程，库再用这些封装例程定义出给用户的API
- 系统调用的三层皮xyz、system_call和sys_xyz,库函数中一般有trap指令或int指令，类似于一个系统中断，而系统调用是一个特殊的中断处理函数（inerrupt handler）。
- 在Linux中是通过执行`int $0x80`来执行系统调用的，这条汇编指令产生向量为128的编程异常，使用eax来传递系统调用号。Intel Pentium II中引入了sysenter指令（快速系统调用）。
- 寄存器传递参数具有如下限制：
    1. 每个参数的长度不能超过寄存器的长度，即32位
    2. 系统调用传递第一个参数用ebx，系统调用的返回值使用eax存储，和普通函数一样，在系统调用号（eax）之外，参数的个数不能超过6个（ebx，ecx，edx，esi，edi，ebp），超过6个可通过传递指向一块内存区域的指针的方法减少参数传递。

## 实验分析

**实验目的：**

实验选取某个系统调用，编码实现两种调用方法——C语言库函数调用和汇编中断达，并到相同的效果。

**实验步骤：**

系统调用列表[**链接**][1]

1. 本次实验选取mkdir系统调用
2. 首先查看mkdir的库函数用法
    1. 执行`man -f mkdir`

        ![man--f-mkdir][2]
    2. 发现有两种文档，执行`man 1 mkdir`查看第一种文档

        ![man-1-mkdir][3]
    3. 发现是mkdir命令相关的文档，不是我们要的库函数
    4. 执行`man 2 mkdir`

        ![man-2-mkdir][4]
    5. 正是我们需要的文档，查看用法,开始编程。
3. 源代码如下

    **mkdir.c**

    ```
    #include <sys/stat.h>
    #include <sys/types.h>
    #include <stdio.h>
    int main() {
       int result =  mkdir("test", 0777);
       if (result == 0) {
           printf("dirtory test make success");
       } else {
           printf("dirtory test make failture");
       }
    }
    ```

    **mkdir-asm.c**

    ```
    #include <sys/stat.h>
    #include <sys/types.h>
    #include <stdio.h>
    int main() {
        int result = 0;
        const char *filePath = "test";
        mode_t mode = 0777;
        asm volatile(
                "movl $0X27,%%eax\n\t"
                "movl %1,%%ebx\n\t"
                "movl %2,%%ecx\n\t"
                "int $0X80\n\t"
                "movl %%eax,%0\n\t"
                :"=m"(result)
                :"r"(filePath),"r"(mode)
                :"%eax","%ebx","%ecx"
                );
       if (result == 0) {
           printf("dirtory test make success");
       } else {
           printf("dirtory test make failture");
       }
    }
```
mkdir.c 和 mkdir-asm.c 功能一致都是在当前目录下创建test文件夹，mkdir.c是通过调用库函数`int mkdir(const char *pathname,mode_t mode);`创建test文件夹，而mkdir-asm.c是通过中断程序创建test文件夹。

## 后记
### fork系统调用分析
在查找系统调用列表时发现了fork系统调用，fork系统调用是用来创建一个与本进程基本相同的子进程。

分析下面的代码

**fork-test.c**

```
#include <unistd.h>
#include <stdio.h>
int main() {
    pid_t sonPid = 0;
    sonPid = fork();
    if (sonPid == 0) {
        printf("process %d -> parent pid: %d\n", getpid(), getppid());
        printf("process %d -> before excute fork's fork pid: %d\n", getpid(), sonPid);
        sonPid = fork();
        if (sonPid == 0) {
            sleep(5);
            printf("process %d -> parent pid: %d\n", getpid(), getppid());
            printf("process %d -> fork pid: %d\n", getpid(), sonPid);
        } else {
            printf("process %d -> after excute fork's fork pid: %d\n", getpid(), sonPid);
        }
    } else {
        printf("process %d -> parent pid: %d\n", getpid(), getppid());
        printf("process %d -> fork pid: %d\n", getpid(), sonPid);
        while(1);
    }
}
```

运行结果为

![fork-test-result][5]

**分析**

`pid_t fork(void);`库函数会创建一个与当前进程相同的子进程并返回子进程的pid，从这一行开始（包括），会有两个进程执行相同的后续代码，变量不共享，分别保持着自己的变量，子进程在`pid_t fork(void);`这行代码的结果与父进程不同，返回的是0，表示没有自己的子进程。也就是说父进程和子进程在`pid_t fork(void);`这行代码处都会有返回值，但返回值不同。`getpid()`是用来返回当前进程的pid，`getppid()`是用来返回父进程的pid。

fork-test.c意在创建3个进程，即父进程A，子进程B，孙子进程C，让父进程A一直执行不结束，子进程B执行完结束，孙子进程C睡眠5秒，待子进程B执行完后打印出孙子进程C的父进程pid，当孙子进程C的父进程B没有结束时`getppid()`返回的应当是孙子进程C的父进程B的pid，当父进程结束时，从运行结果可以看出，返回的是1号进程的pid，即1号进程变成了孙子进程C的父进程。所有的用户进程都是由1号进程派生出来的，所有的内核态进程都是由2号进程派生出来的。

### systmm_call特殊中断处理函数分析
1. system_call 源代码[**链接**][7]
1. system_call 工作流程图

    ![system-call-flow][8]

wdk 原创作品转载请注明出处  
相关链接 [《Linux内核分析》MOOC课程http://mooc.study.163.com/course/USTC-1000029000][6]

[1]: http://codelab.shiyanlou.com/xref/linux-3.18.6/arch/x86/syscalls/syscall_32.tbl
[2]: /mark/assets/images/2016-03-18-linux-kernel-system-call/man--f-mkdir.png
[3]: /mark/assets/images/2016-03-18-linux-kernel-system-call/man-1-mkdir.png
[4]: /mark/assets/images/2016-03-18-linux-kernel-system-call/man-2-mkdir.png
[5]: /mark/assets/images/2016-03-18-linux-kernel-system-call/fork-test-result.png
[6]: http://mooc.study.163.com/course/USTC-1000029000
[7]: http://codelab.shiyanlou.com/xref/linux-3.18.6/arch/x86/kernel/entry_32.S#490
[8]: /mark/assets/images/2016-03-18-linux-kernel-system-call/system-call-flow.png
