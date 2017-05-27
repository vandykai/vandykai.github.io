---

layout: post
title:  Linux Kernel - 进程结构和进程的克隆
date:   2016-04-13 14:32:00
categories: [Linux-3.18.6]
tags: [linux, linux-kernel, experiment]

---

## 重点知识总结
- 进程结构定义struct [task_struct][1]
- `volatile long state;`记录进程的状态，进程状态的定义[**链接**][2]，值得注意的是操作系统进程状态概念中的就绪态和运行态在这里都表示为TASK_RUNNING状态，若获得CPU的执行就为运行态，否则为就绪态。
- Linux为每个进程分配一个8KB大小的内存区域，用于存放该进程两个不同的数据结构：`Thread_info`和进程的内核堆栈

    ``` C
    union thread_union {
    	struct thread_info thread_info;
    	unsigned long stack[THREAD_SIZE/sizeof(long)];
    };
    ```

    可能会有点奇怪，为什么这两个数据结构要共用一个内存空间呢，其实这是有原因的，早在以前，`thread_union`中存放的并不是`thread_info`,而是`thread_struct`，只是后来变成了新的数据结构`thread_info`，将`thread_struct`或`thread_info`放在内核栈的尾端（因为共用了一块内存）可以通过esp指针屏蔽末尾的若干位方便的得到当前运行进程的进程描述结构指针。

- `void *stack;`指向内核态堆栈。其实应该就是指向上面的8kb大小的共用内存区域。
- `struct list_head tasks;`所有进程的链表，将所有当前进程链接起来。`list_head`中有两个指针域`next`和`prev`，分别指向下一个和前一个进程。

    ``` C
    struct list_head {
        struct list_head *next, *prev;
    };
    ```

- `struct mm_struct *mm, *active_mm;`内存管理，进程的地址空间相关，如代码段，数据段等。
- `struct thread_struct thread;`执行进程的CPU相关的状态，定义[**链接**][3]，里面包括`sp`，`ip`等地址变量，。
- `struct fs_struct *fs;`文件系统相关。
- `struct files_struct *files;`打开的文件描述符列表。
- `sys_fork`，`sys_clone`，`sys_vfork`最终都是调用`do_fork`创建新进程。

### 创建一个新进程在内核中的执行过程
[`do_fork`源码][4]

[`copy_thread`源码][5]

[`ret_from_fork`源码][6]

``` C
long do_fork(...) {
    ...
    p = copy_process(clone_flags, stack_start, stack_size, child_tidptr, NULL, trace);
    ...
}

static struct task_struct *copy_process(...) {
    ...
    p = dup_task_struct(current);
    ...
    ... //修改task_struct
    retval = copy_thread(clone_flags, stack_start, stack_size, p);
    ...
    return p;
}

static struct task_struct *dup_task_struct(struct task_struct *orig) {
  ...
  tsk = alloc_task_struct_node(node);
  ...
  ti = alloc_thread_info_node(tsk, node);
  ...
  err = arch_dup_task_struct(tsk, orig);
  ...
  tsk->stack = ti;
  ...
  setup_thread_stack(tsk, orig);
}

#define task_pt_regs(tsk)	((struct pt_regs *)(tsk)->thread.sp0 - 1)

int copy_thread(unsigned long clone_flags, unsigned long sp,
                unsigned long arg, struct task_struct *p) {
    struct pt_regs *childregs = task_pt_regs(p);//子进程的内核态堆栈，pt_regs就是栈底内容的容器，这里是找到栈底内容的地址赋值给childregs。
    ...
    p->thread.sp = (unsigned long) childregs;
    p->thread.sp0 = (unsigned long) (childregs+1);
    ...
    *childregs = *current_pt_regs();//这里不懂为什么又要赋值？
    childregs->ax = 0;
    ...
    p->thread.ip = (unsigned long) ret_from_fork;

｝

static inline struct task_struct *alloc_task_struct_node(int node) {
    return kmem_cache_alloc_node(task_struct_cachep, GFP_KERNEL, node);
}

static struct thread_info *alloc_thread_info_node(struct task_struct *tsk, int node) {
    struct page *page = alloc_kmem_pages_node(node, THREADINFO_GFP, THREAD_SIZE_ORDER);
    return page ? page_address(page) : NULL;
}

int __weak arch_dup_task_struct(struct task_struct *dst, struct task_struct *src) {
    *dst = *src;
    return 0;
}

#define task_thread_info(task)	((struct thread_info *)(task)->stack)
...
static inline void setup_thread_stack(struct task_struct *p, struct task_struct *org) {
    *task_thread_info(p) = *task_thread_info(org);
    task_thread_info(p)->task = p;
}
```


wdk 原创作品转载请注明出处  
相关链接 [《Linux内核分析》MOOC课程http://mooc.study.163.com/course/USTC-1000029000]7]

[1]: http://codelab.shiyanlou.com/xref/linux-3.18.6/include/linux/sched.h#task_struct
[2]: http://codelab.shiyanlou.com/xref/linux-3.18.6/include/linux/sched.h#203
[3]: http://codelab.shiyanlou.com/xref/linux-3.18.6/arch/x86/include/asm/processor.h#thread_struct
[4]: http://codelab.shiyanlou.com/xref/linux-3.18.6/kernel/fork.c#do_fork
[5]: http://codelab.shiyanlou.com/xref/linux-3.18.6/arch/x86/kernel/process_32.c#copy_thread
[6]: http://codelab.shiyanlou.com/xref/linux-3.18.6/arch/x86/kernel/entry_32.S#290
[7]: http://mooc.study.163.com/course/USTC-1000029000
