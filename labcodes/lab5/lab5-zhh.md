# Rerport: LAB5

计13，张宏辉，2011011237
 
## 练习0：填写已有实验
 - 已完成

## 练习1: 加载应用程序并执行（需要编码）

 - 简要说明你的设计实现过程
   - 按照注释内容进行设置实现即可。
   ```
    tf->tf_cs = USER_CS;
    tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
    tf->tf_esp = USTACKTOP;
    tf->tf_eip = elf->e_entry;
    tf->tf_eflags = FL_IF;
   ```
   
 - 描述当创建一个用户态进程并加载了应用程序后，CPU是如何让这个应用程序最终在用户态执行起来的。即这个用户态进程被ucore选择占用CPU执行（RUNNING态）到具体执行应用程序第一条指令的整个经过。
   - 执行execute系统调用。
   - 执行iret指令，将内核堆栈的esp, ss, eip, cs写入指定的寄存器（其中ss与cs相应的位已经设置为用户态）。
   - 跳转到用户态运行第一条指令。
 
## 练习2: 父进程复制自己的内存空间给子进程（需要编码）

 - 简要说明你的设计实现过程
   - 创建新进程时不复制内存，而是在页表中新增引用计数，记录当前有多少进程对该页进行引用。
   - 对于所有写操作，都不需要对页表或者内存进行复制。
   - 对于共享的写操作，为所有引用该页的进程创建独立的页表，并为每一个进程复制一份相应的内存。

## 练习3: 阅读分析源代码，理解进程执行 fork/exec/wait/exit 的实现，以及系统调用的实现（不需要编码）

 - 简要说明你对 fork/exec/wait/exit函数的分析
   - fork函数会复制当前进程到一个新的子进程。
   - exec函数在已经创建好的进程中加载指定可执行程序并且执行。
   - wait函数等待子进程执行结束。
   - exit为子进程执行完毕退出。
   
 - 请分析fork/exec/wait/exit在实现中是如何影响进程的执行状态的？
   - fork创建新进程。
   - exec使进程从创建状态变为就绪状态。
   - wait使进程从就绪状态或运行状态变为等待状态。
   - exit使进程退出。
   
 - 请给出ucore中一个用户态进程的执行状态生命周期图（包执行状态，执行状态之间的变换关系，以及产生变换的事件或函数调用）。（字符方式画即可）
   - 和代码注释中一致，图示如下：
   ```
   process state changing:
                                            
  alloc_proc                                 RUNNING
      +                                   +--<----<--+
      +                                   + proc_run +
      V                                   +-->---->--+ 
  PROC_UNINIT -- proc_init/wakeup_proc --> PROC_RUNNABLE -- try_free_pages/do_wait/do_sleep --> PROC_SLEEPING --
                                           A      +                                                           +
                                           |      +--- do_exit --> PROC_ZOMBIE                                +
                                           +                                                                  + 
                                           -----------------------wakeup_proc----------------------------------
   ```
 