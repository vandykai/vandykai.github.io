---

layout: post
title:  Linux Kernel - 可执行程序的加载过程
date:   2016-05-14 20:31:00
categories: [Linux-3.18.6]
tags: [linux, linux-kernel, experiment]

---

## 重点知识总结
- 可执行文件的装载也是一个系统调用（`execve`），只不过和`fork`系统调用一样有一些特殊。
- Shell会调用execve将命令行参数和环境参数传递给可执行程序的main函数。
- 库函数exec*都是execve的封装例程。

### 可执行文件的文件格式，Shell环境，动态链接库。
- ([ELF文件格式][1])，ELF格式的文件默认加载到进程空间的0X804800处。
- Shell环境：加载一个新程序会覆盖当前进程的用户进程空间，所以Shell命令行要加载一个新程序时，先要fork一个新进程，在新进程中加载新程序，否则Shell进程就被覆盖了，那么命令行参数和环境变量是如何进入新程序堆栈的。通过`Shell程序` -> `execve` -> `sys_execve` 然后在初始化新程序堆栈时拷贝进去。即先函数调用参数传递，再系统调用参数传递将命令行参数和环境变量传递进新程序堆栈。
- 动态链接库：分为装载时动态链接和运行时动态链接，如何在64位环境下编译32位动态链接库参看下面链接。

    [动态链接][2]

### 可执行文件的文件格式的解析。
- 寻找文件格式对应的解析模块，如下：

    [`sys_execve`][3] -> [`do_execve`][4] -> [`do_execve_common`][5] -> [`exec_binprm`][6] -> [`search_binary_handler`][7]

    [`search_binary_handler`][7]根据文件头部信息寻找对应的文件格式解析模块。

    ``` C
    list_for_each_entry(fmt, &formats, lh) {
        if (!try_module_get(fmt->module))
          continue;
        read_unlock(&binfmt_lock);
        bprm->recursion_depth++;
        retval = fmt->load_binary(bprm);
        read_lock(&binfmt_lock);
        ...
      }
    ```

    对于ELF格式的可执行文件，语句`fmt->load_binary(bprm);`执行的应该是[`load_elf_binary(bprm);`][8]。
    `load_binary`是个函数指针。寻找对应的文件格式解析模块采用了设计模式中的**观察者模式**。如下为ELF格式的观察者初始化的过程：

    ``` C
    static struct linux_binfmt elf_format = {
        .module     = THIS_MODULE,
        .load_binary    = load_elf_binary,
        .load_shlib = load_elf_library,
        .core_dump  = elf_core_dump,
        .min_coredump   = ELF_EXEC_PAGESIZE,
    };
    ```
    ``` C
    static int __init init_elf_binfmt(void)
    {
        register_binfmt(&elf_format);
        return 0;
    }
    ```

    这里不同的文件格式解析模块就是观察者，可执行文件就是被观察者，`list_for_each_entry`遍历文件格式解析模块向其发送通知，通知文件格式解析模块来解析当前的可执行文件，只不过这里只通知对应的文件解析模块（对应的观察者），而不是所有的文件格式解析模块（所有的观察者）。

### 可执行文件的执行起点

- 上面已经说了，对于ELF格式的文件。执行到`fmt->load_binary(bprm);`,实际上执行的是[`load_elf_binary(bprm);`][8]，在[`load_elf_binary(bprm);`][8]函数中的`start_thread(regs, elf_entry, bprm->p);`语句指明了可执行文件的起点。函数原型[`start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)`][9]中的第二个参数就是新程序的起点，它通过修改内核堆栈中EIP的值作为新程序的起点，`execve`系统调用返回到用户态就从这里开始执行。

- 对于静态链接的可执行文件`elf_entry`就是ELF头中定义的起点，对于动态链接的可执行文件，先加载连接器ld，将CPU控制权交给ld来加载依赖库并完成动态链接，这部分不由内核完成，源代码如下：

    ``` C
    if (elf_interpreter) {//需要动态链接
        unsigned long interp_map_addr = 0;

        elf_entry = load_elf_interp(&loc->interp_elf_ex,
                interpreter, &interp_map_addr, load_bias);
        ...
    } else {//不需要动态链接
        elf_entry = loc->elf_ex.e_entry;
    ｝
    ```

wdk 原创作品转载请注明出处  
相关链接 [《Linux内核分析》MOOC课程http://mooc.study.163.com/course/USTC-1000029000][10]

[1]: http://www.xfocus.net/articles/200105/174.html
[2]: /mark/gramar/2016/05/13/c-dynamical-loading.html
[3]: http://codelab.shiyanlou.com/xref/linux-3.18.6/fs/exec.c#1604
[4]: http://codelab.shiyanlou.com/xref/linux-3.18.6/fs/exec.c#do_execve
[5]: http://codelab.shiyanlou.com/xref/linux-3.18.6/fs/exec.c#do_execve_common
[6]: http://codelab.shiyanlou.com/xref/linux-3.18.6/fs/exec.c#exec_binprm
[7]: http://codelab.shiyanlou.com/xref/linux-3.18.6/fs/exec.c#search_binary_handler
[8]: http://codelab.shiyanlou.com/xref/linux-3.18.6/fs/binfmt_elf.c#load_elf_binary
[9]: http://codelab.shiyanlou.com/xref/linux-3.18.6/arch/x86/kernel/process_32.c#start_thread
[10]: http://mooc.study.163.com/course/USTC-1000029000
