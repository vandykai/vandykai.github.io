---

layout: post
title:  Linux Kernel - 编程起点和各模块简述
date:   2016-03-17 12:13:00
categories: [Linux]
tags: [linux, linux-kernel, experiment]

---

## 重点知识总结

### Linux内核源码简介

[内核源代码linux-3.18.6][1]

####各个文件夹模块的用途（部分）

**arch** -(archetecture)与具体cpu相关，其内的x86文件夹是目前重点关注的,若只是关注这一个文件夹，分析时可以把其它文件夹删除

**crypto** - 与加密解密相关

**Documentation** - 文档相关

**drivers** - 驱动相关

**fs** - （file system）文件系统相关

**init** - 初始化相关，内核启动相关的代码基本在此文件夹下，其中的main.c/start_kernel函数是内核启动的起点，相当于C程序的main函数

**ipc** - (Inter-Process Communication)进程间通信相关

**kernel** - linux内核的核心代码

**lib** - 公用的库文件

**mm** - (memory management)内存管理相关

**net** - 网络相关

**scripts** - 脚本

**security** - 安全相关

**sound** - 声音相关

**tools** - 工具

### 使用gdb跟踪调试内核，其中的rootfs.img 为自制的根文件系统

```
qemu -kernel linux-3.18.6/arch/x86/boot/bzImage -initrd rootfs.img -s -S # 关于-s和-S选项的说明：
# -S freeze CPU at startup (use ’c’ to start execution)
# -s shorthand for -gdb tcp::1234 若不想使用1234端口，则可以使用-gdb tcp:xxxx来取代-s选项
```

另开一个shell窗口

```
gdb
（gdb）file linux-3.18.6/vmlinux # 在gdb界面中targe remote之前加载符号表
（gdb）target remote:1234 # 建立gdb和gdbserver之间的连接,按c 让qemu上的Linux继续运行
（gdb）break start_kernel # 断点的设置可以在target remote之前，也可以在之后
```

## 实验分析
### main.c的部分代码如下（省略号为略去的代码）

``` C
asmlinkage __visible void __init start_kernel(void)
{
    ...
    set_task_stack_end_magic(&init_task);
    ...
    trap_init();
    mm_init();
    ...
    sched_init();
    ...
    rest_init();
}
```

### rest_init 函数代码如下

``` C
static noinline void __init_refok rest_init(void)
{
    int pid;

    rcu_scheduler_starting();
    /*
     * We need to spawn init first so that it obtains pid 1, however
     * the init task will end up wanting to create kthreads, which, if
     * we schedule it before we create kthreadd, will OOPS.
     */
    kernel_thread(kernel_init, NULL, CLONE_FS);
    numa_default_policy();
    pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
    rcu_read_lock();
    kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
    rcu_read_unlock();
    complete(&kthreadd_done);

    /*
     * The boot idle thread must execute schedule()
     * at least once to get things moving:
     */
    init_idle_bootup_task(current);
    schedule_preempt_disabled();
    /* Call into cpu_idle with preempt disabled */
    cpu_startup_entry(CPUHP_ONLINE);
}
```

### 代码分析

- `start_kernel/set_task_stack_end_magic(&init_task); init_task`即手工创建的PCB，即0号进程，即最终的idle进程
- 不管分析内核的哪一部分都会涉及到`start_kernel`
- `start_kernel/trap_init` 涉及到中断的初始化，其中的`set_system_trap_gate`是设置系统调用的
- `start_kernel/mm_init` 内存管理模块的初始化
- `start_kernel/sched_init` 调度模块的初始化
- `rest_init/kernel_thread(kernel_init, NULL, CLONE_FS);` 创建用户态1号进程
- `rest_init/kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);` 创建内核态2号进程
- 之后若没有其他事情做，就进入`cpu_startup_entry(CPUHP_ONLINE);`，此时0号进程就进入`while(1)`循环

这里面内核启动后通过`set_task_stack_end_magic(&init_task);`初始化了0号进程，0号进程通过`kernel_thread(kernel_init, NULL, CLONE_FS);`和`kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);`分别创建了1号进程（所有用户态进程的祖先）和2号进程（所有内核线程的祖先）。之后若无事做就进入`while(1)`循环保持运行。

wdk 原创作品转载请注明出处  
相关链接 [《Linux内核分析》MOOC课程http://mooc.study.163.com/course/USTC-1000029000][2]

[1]: http://codelab.shiyanlou.com/xref/linux-3.18.6/
[2]: http://mooc.study.163.com/course/USTC-1000029000
