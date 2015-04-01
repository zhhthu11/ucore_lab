# Rerport: LAB1

计13，张宏辉，2011011237


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


##练习2：使用qemu执行并调试lab1中的软件

(1) 修改labcodes/lab1目录下的Makefile，注意这里要将第208、209行注释掉，不然第一条不是0xfff0开始的(为了方便在练习2之外的练习中都没有注释)。在labcodes/lab1目录下运行make debug启动qemu，并将其与gdb链接。

(2) 设置显示反汇编结果。

```
(gdb)define hook-stop
>x/i $pc
>end
```

此外，gdb默认情况下反汇编指令地址是错的，手动计算正确的地址进行反汇编：

```
(gdb) set architecture i8086
```

(3) 使用stepi单步执行，单步跟踪BIOS的执行

(4) 在0x7c00处设置断点：

```
(gdb) b*0x7c00
```

运行c继续执行：

```
(gdb) c
=> 0x7c00: cli
```
[显示测试断点正确]

(5) 使用c继续执行，在断点0x7c00中断后单步执行

```
(gdb) x/16i 0x7c00
0x7c00:	cli
0x7c01:	cld
...
0x7c1c:	out    %al,$0x60
```

[代码和bootasm.S、bootblock.asm相同]

(6) 选择自己测试kern_init()部分代码，设置断点并测试

```
(gdb) b kern_init
(gdb) c
```

操作类似(4)(5)

##练习3：分析bootloader进入保护模式的过程

bootloader从实模式进入保护模式的实现在bootasm.S代码段的49—52与57行。

下面通过代码段来分析主要步骤：
- lgdt gdtdesc             #读取gdtdesc地址的内容保存到gdt寄存器中
- movl %cr0, %eax          #将原%cr0寄存器的值赋值到%eax寄存器
- orl $CR0_PE_ON, %eax     #通过或操作设置保护模式标志
- movl %eax, %cr0          #将保护模式标志存入%cr0寄存器，打开保护模式
- ljmp $PROT_MODE_CSEG, $protcseg 	#跳转进入保护模式下的第一条指令

##练习4：分析bootloader加载ELF格式的OS的过程

1、bootloader读取磁盘扇区的实现在bootmain.c代码段的44—61行，即函数readsect。

分析其主要步骤：
- 调用函数waitdisk()，等待硬盘空闲；
- 调用一系列函数outb()，设置读取的扇区：发送读取扇区数值1到0x1F2端口；发送读取扇区编号的7-0位，15-8位，23-16位，27-24位分别到0x1F3,0x1F4,0x1F5端口以及0x1F6的低4位，并将0x1F6端口的高4位置为0xE0，表示指定主盘并使用LBA模式。向命令寄存器发送操作码0x20，表示要读取；
- 调用函数waitdisk()，再次等待硬盘空闲；
- 调用函数insl()，从0x1F0端口读取硬盘数据。

2、bootloader加载ELF格式的OS实现在bootmain.c代码段的86-115行，即函数bootmain。

分析其主要步骤：
- 通过调用函数readseg()从磁盘中读取ELF头文件；
- 判断ELF头文件是否合法，不合法直接跳转到bad部分，退出；
- 根据EFL头文件信息，将kernel中的每个problem载入内存；
- 调用ELFHDR->e_entry作为入口地址执行内核代码。

##练习5：实现函数调用堆栈跟踪函数

实现：按照kdebug.c中print_stackframe函数的注释流程实现即可。需要注意的是当ebp == 0时即跳出循环，这是在函数前的注释里有提到。

输出结果：

```
ebp:0x00007b28 eip:0x001009c6 args:0x00010094 0x00010094 0x00007b58 0x00100094
    kern/debug/kdebug.c:306: print_stackframe+22
ebp:0x00007b38 eip:0x00100cab args:0x00000000 0x00000000 0x00000000 0x00007ba8
    kern/debug/kmonitor.c:125: mon_backtrace+10
ebp:0x00007b58 eip:0x00100094 args:0x00000000 0x00007b80 0xffff0000 0x00007b84
    kern/init/init.c:48: grade_backtrace2+33
ebp:0x00007b78 eip:0x001000bd args:0x00000000 0xffff0000 0x00007ba4 0x00000029
    kern/init/init.c:53: grade_backtrace1+38
ebp:0x00007b98 eip:0x001000db args:0x00000000 0x00100000 0xffff0000 0x0000001d
    kern/init/init.c:58: grade_backtrace0+23
ebp:0x00007bb8 eip:0x00100100 args:0x0010365c 0x00103640 0x00001328 0x00000000
    kern/init/init.c:63: grade_backtrace+34
ebp:0x00007be8 eip:0x00100057 args:0x00000000 0x00000000 0x00000000 0x00007c53
    kern/init/init.c:28: kern_init+86
ebp:0x00007bf8 eip:0x00007d6f args:0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8
    <unknow>: -- 0x00007d6e --
```

结果比较：与实验指导书中基本一致解释最后一行：

<unknow>: -- 0x00007d6e -- 表示无法找到函数域，数值"0x00007d6e"为指令地址。

##练习6：完善中断初始化和处理

1、中断向量表中一个表项占8个字节。中断处理代码的入口：63-48位表示段内偏移的高16位，31-16位表示16位段选择子，15-0位表示段内偏移的低16位。

2、按照注释代码要求，并查阅实验指导书中以及所提示的相关代码来完成实现：用宏SETGATE依次设置idt[i],i=0...255，并特殊设置idt[T_SYSCALL]。初始化完成后再调用lidt封装函数载入中断描述符表，参数为&idt_pd。具体参见代码kdebug.c

3、这部分相当简单。定义static int ticks_time(注意必须在swith语句外面定义)，每次触发后ticks_time++进行计数，每达到100的倍数调用函数print_ticks即可。具体参见代码trap.c
