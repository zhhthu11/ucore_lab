# Lab1 Rerport, 2011011237

##练习1：理解通过make生成执行文件的过程
1.操作系统镜像文件ucore.img是如何一步一步生成的？

在labcodes/lab1目录下运行
```
make "V=" > make_result.txt
```
make_result.txt文件可以在lab1根目录下找到。这里一系列命令非常类似的，只有两种类型。下面用典型例子详细解释这两类命令：

(类型 1)
```
+ cc kern/init/init.c
gcc -Ikern/init/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/init/init.c -o obj/kern/init/init.o
```
作用说明：编译 kern/init/init.c 成 obj/kern/init/init.o

参数说明：
- -Ixxx: 包含目录 xxx，该段中引用目录 kern/init/; libs/; kern/debug/; kern/diver/; kern/trap/ ;kern/mm/
- -fno-builtin: 禁止使用gcc的built in函数进行优化
- -Wall: 打开所有警告
- -ggdb: 添加供gdb调试的调试信息
- -m32: 产生32位代码
- -gstabs: 以stabs格式(如果支持)输出调试信息,不包括GDB扩展
- -nostdinc: 不检查系统默认目录以获取头文件
- -fno-stack-protector: 不产生多余代码检查栈溢出
- -c kern/init/init.c: 指定源文件为kern/init/init.c
- -o obj/kern/init/init.o: 指定生成目标文件为obj/kern/init/init.o
            
(类型 2)
```
+ ld bin/kernel
ld -m    elf_i386 -nostdlib -T tools/kernel.ld -o bin/kernel  obj/kern/init/init.o obj/kern/libs/readline.o obj/kern/libs/stdio.o obj/kern/debug/kdebug.o obj/kern/debug/kmonitor.o obj/kern/debug/panic.o obj/kern/driver/clock.o obj/kern/driver/console.o obj/kern/driver/intr.o obj/kern/driver/picirq.o obj/kern/trap/trap.o obj/kern/trap/trapentry.o obj/kern/trap/vectors.o obj/kern/mm/pmm.o  obj/libs/printfmt.o obj/libs/string.o
```
作用说明：链接生成命令中的一系列.o文件

参数说明：
- -m elf_i386：设置类型为elf_i386
- -nostdlib：使用库nostdlib
- -T tools/kernel.ld：使用可置换标签文件tools/kernel.ld
- -o xx.o：制定一系列生成目标文件xx.o

以此对照make_result.txt中的命令，即一步步生成ucore.img

2.一个被系统认为是符合规范的硬盘主引导扇区的特征是什么？

在主引导扇区的读取代码在`tools/sign.c`中可以发现，一个磁盘主引导扇区只有512字节，且第510个字节是0x55， 第511个字节是0xAA。所以符合规范的特征为不超过512字节，且0x55AA结束。




