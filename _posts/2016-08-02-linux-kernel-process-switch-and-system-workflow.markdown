---

layout: post
title:  Linux Kernel - 进程的切换和系统的一般执行过程
date:   2016-08-02 21:16:00
categories: [Linux-3.18.6]
tags: [linux, linux-kernel, experiment]

---

### 进程的调度时机与进程的切换

#### 进程调度的时机
- 中断处理过程（包括时钟中断、I/O中断、系统调用和异常）中，直接调用`schedule()`,或者返回用户态时根据`need_resched`标记调用`schedule()`。
- 内核线程（只有内核态没有用户态的特殊进程）可以直接调用`schedule()`进行进程切换，也可以在中断处理过程中进行调度，也就是说内核线程作为一类特殊的进程可以主动调度，也可以被动调度。
- 用户态进程无法实现主动调度，仅能通过陷入内核态后的某个时机点进行调度，即在中断处理过程中进行调度。

#### 进程的切换
- 挂起正在CPU上执行的进程，与中断时保护现场是不同的，中断前后是在同一个进程上下文中，只是由用户态转向内核态执行。
- 进程上下文包含了进程执行需要的所有信息
    - 用户地址空间：包括程序代码，数据，用户堆栈等。
    - 控制信息：进程描述符，内核堆栈等。
    - 硬件上下文（注意中断也要保存硬件上下文只是保存的方法不同）

- [`schedule()`][1]函数选择一个新的进程来运行，并调用[`context_switch`][2]进行上下文的切换，其中的宏调用[`switch_to`][3]进行关键上下文切换。

    ~~~c
    asmlinkage __visible void __sched schedule(void) {
        struct task_struct *tsk = current;

        sched_submit_work(tsk);
        __schedule();
    }
    ~~~

    ~~~c
    static void __sched __schedule(void) {
        struct task_struct *prev, *next;
        unsigned long *switch_count;
        struct rq *rq;
        int cpu;
    need_resched:
        ...
        next = pick_next_task(rq, prev);
        ...
        if (likely(prev != next)) {
            ...
            context_switch(rq, prev, next); /* unlocks the rq */
            ...
        }
        ...
    }
    ~~~

    ~~~c
    static inline void context_switch(struct rq *rq, struct task_struct *prev, struct task_struct *next) {
        ...
        prepare_task_switch(rq, prev, next);
        ...
        context_tracking_task_switch(prev, next);
        /* Here we just switch the register state and the stack. */
        switch_to(prev, next, prev);
        ...
    }
    ~~~

    ~~~c
    #define switch_to(prev, next, last)
    do {                                                                        \
        /*                                                                      \
         * Context-switching clobbers all registers, so we clobber              \
         * them explicitly, via unused output variables.                        \
         * (EAX and EBP is not listed because EBP is saved/restored             \
         * explicitly for wchan access and EAX is the return value of           \
         * __switch_to())                                                       \
         */                                                                     \
        unsigned long ebx, ecx, edx, esi, edi;                                  \
                                                                                \
        asm volatile(                                                           \
                "pushfl\n\t"    /* save    flags */                             \
                "pushl %%ebp\n\t"    /* save    EBP   */                        \
                "movl %%esp,%[prev_sp]\n\t"  /* save    ESP   */                \
                "movl %[next_sp],%%esp\n\t"  /* restore ESP   */                \
                "movl $1f,%[prev_ip]\n\t"  /* save    EIP   */                  \
                "pushl %[next_ip]\n\t"  /* restore EIP   */                     \
                __switch_canary                                                 \
                "jmp __switch_to\n"  /* regparm call  */                        \
                "1:\t"                                                          \
                "popl %%ebp\n\t"    /* restore EBP   */                         \
                "popfl\n"      /* restore flags */                              \
                                                                                \
                /* output parameters */                                         \
                : [prev_sp] "=m" (prev->thread.sp),                             \
                  [prev_ip] "=m" (prev->thread.ip),                             \
                  "=a" (last),                                                  \
                                                                                \
                  /* clobbered output registers: */                             \
                  "=b" (ebx), "=c" (ecx), "=d" (edx),                           \
                  "=S" (esi), "=D" (edi)                                        \
                                                                                \
                  __switch_canary_oparam                                        \
                                                                                \
                  /* input parameters: */                                       \
                : [next_sp]  "m" (next->thread.sp),                             \
                  [next_ip]  "m" (next->thread.ip),                             \
                                                                                \
                  /* regparm parameters for __switch_to(): */                   \
                  [prev]     "a" (prev),                                        \
                  [next]     "d" (next)                                         \
                                                                                \
                  __switch_canary_iparam                                        \
                                                                                \
                : /* reloaded segment registers */                              \
                  "memory"                                                      \
        );                                                                      \
    } while (0)
    ~~~
    
    这里值得注意的是[`switch_to(prev, next, last)`][3]中的`jmp __switch_to`，实际上类似于函数，只不过参数通过寄存器传递，且因为没有`call`语句所以不`pushl %eip*`(*意在说明这条指令实际不存在，是伪指令)，但是`__switch_to`末尾任然有条`ret`语句，这样就把之前`pushl %[next_ip]`的`[next_ip]``popl`给了`eip`。

### Linux系统的一般运行过程。
#### 最一般的情况：正在运行的用户态进程X切换到运行X用户态进程Y的过程
1. 正在运行的用户态进程X
2. 发生中断——`save cs:eip/ss:esp/eflags(current) to kernel stack, then load cs:eip(entry of specific ISR) and ss:esp(point to kernel stack)`
3. SAVE_ALL //保存现场
4. 中断处理过程中或中断返回前调用了schedule()，其中的switch_to做了关键的进程上下文切换
5. 标号1之后开始开始运行用户态进程Y（这里Y曾经通过以上步骤被切换出去过，因此可以从标号1继续执行）
6. restore_all //恢复现场
7. `iret - pop cs:eip/ss:eip/eflags from kernel stack`
8. 继续运行用户态进程Y

#### Linux系统执行过程中的几个特殊情况
- 用户态进程与内核态线程之间互相切换，内核态线程不涉及到用户态到内核态的上下文切换，因为内核态线程没有用户态。
- 内核态线程之间互相切换。
- 内核线程主动调用schedule()（用户态进程不能主动调用schedule()），只有进程上下文的切换，没有发生中断上下文的切换。
- 创建子进程的系统调用在子进程中的执行起点及返回用户态，如fork，子进程从`ret_from_fork`开始执行，而不是从标号1开始执行。
- 加载一个新的可执行程序后返回到用户态的情况。

#### 注意
- 所有进程内核态空间是共享的。
- 内核态是各中断处理过程和内核线程的集合。

wdk 原创作品转载请注明出处  
相关链接 [《Linux内核分析》MOOC课程http://mooc.study.163.com/course/USTC-1000029000][4]

[1]: http://codelab.shiyanlou.com/xref/linux-3.18.6/kernel/sched/core.c#schedule
[2]: http://codelab.shiyanlou.com/xref/linux-3.18.6/kernel/sched/core.c#context_switch
[3]: http://codelab.shiyanlou.com/xref/linux-3.18.6/arch/x86/include/asm/switch_to.h#switch_to
[4]: http://mooc.study.163.com/course/USTC-1000029000
