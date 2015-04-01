
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 88 89 11 00       	mov    $0x118988,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 2c 5c 00 00       	call   105c82 <memset>

    cons_init();                // init the console
  100056:	e8 74 15 00 00       	call   1015cf <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 20 5e 10 00 	movl   $0x105e20,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 3c 5e 10 00 	movl   $0x105e3c,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 a9 42 00 00       	call   10432d <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 af 16 00 00       	call   101738 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 01 18 00 00       	call   10188f <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 f2 0c 00 00       	call   100d85 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 0e 16 00 00       	call   1016a6 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 fb 0b 00 00       	call   100cb7 <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 41 5e 10 00 	movl   $0x105e41,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 4f 5e 10 00 	movl   $0x105e4f,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 5d 5e 10 00 	movl   $0x105e5d,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 6b 5e 10 00 	movl   $0x105e6b,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 79 5e 10 00 	movl   $0x105e79,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 88 5e 10 00 	movl   $0x105e88,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 a8 5e 10 00 	movl   $0x105ea8,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 c7 5e 10 00 	movl   $0x105ec7,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 01 13 00 00       	call   1015fb <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 64 51 00 00       	call   10549b <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 88 12 00 00       	call   1015fb <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 68 12 00 00       	call   101637 <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 cc 5e 10 00    	movl   $0x105ecc,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 cc 5e 10 00 	movl   $0x105ecc,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 20 71 10 00 	movl   $0x107120,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 88 1a 11 00 	movl   $0x111a88,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec 89 1a 11 00 	movl   $0x111a89,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 b2 44 11 00 	movl   $0x1144b2,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 0a 54 00 00       	call   105af6 <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 d6 5e 10 00 	movl   $0x105ed6,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 ef 5e 10 00 	movl   $0x105eef,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 0b 5e 10 	movl   $0x105e0b,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 07 5f 10 00 	movl   $0x105f07,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 1f 5f 10 00 	movl   $0x105f1f,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 88 89 11 	movl   $0x118988,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 37 5f 10 00 	movl   $0x105f37,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 88 89 11 00       	mov    $0x118988,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 50 5f 10 00 	movl   $0x105f50,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 7a 5f 10 00 	movl   $0x105f7a,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 96 5f 10 00 	movl   $0x105f96,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	53                   	push   %ebx
  1009be:	83 ec 44             	sub    $0x44,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009c1:	89 e8                	mov    %ebp,%eax
  1009c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  1009c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
      uint32_t ebp = read_ebp();
  1009c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      uint32_t eip = read_eip();
  1009cc:	e8 d8 ff ff ff       	call   1009a9 <read_eip>
  1009d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
      int i;
      for (i = 0; i < STACKFRAME_DEPTH; i++)
  1009d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009db:	e9 8c 00 00 00       	jmp    100a6c <print_stackframe+0xb2>
      {
            if (ebp == 0) break;
  1009e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1009e4:	75 05                	jne    1009eb <print_stackframe+0x31>
  1009e6:	e9 8b 00 00 00       	jmp    100a76 <print_stackframe+0xbc>
            cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
  1009eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f9:	c7 04 24 a8 5f 10 00 	movl   $0x105fa8,(%esp)
  100a00:	e8 37 f9 ff ff       	call   10033c <cprintf>
            uint32_t* args = ((uint32_t*)ebp) + 2;
  100a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a08:	83 c0 08             	add    $0x8,%eax
  100a0b:	89 45 e8             	mov    %eax,-0x18(%ebp)
            cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x\n", args[0], args[1], args[2], args[3]);
  100a0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a11:	83 c0 0c             	add    $0xc,%eax
  100a14:	8b 18                	mov    (%eax),%ebx
  100a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a19:	83 c0 08             	add    $0x8,%eax
  100a1c:	8b 08                	mov    (%eax),%ecx
  100a1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a21:	83 c0 04             	add    $0x4,%eax
  100a24:	8b 10                	mov    (%eax),%edx
  100a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a29:	8b 00                	mov    (%eax),%eax
  100a2b:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100a2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a33:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a37:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a3b:	c7 04 24 c0 5f 10 00 	movl   $0x105fc0,(%esp)
  100a42:	e8 f5 f8 ff ff       	call   10033c <cprintf>
            print_debuginfo(eip-1);
  100a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a4a:	83 e8 01             	sub    $0x1,%eax
  100a4d:	89 04 24             	mov    %eax,(%esp)
  100a50:	e8 b1 fe ff ff       	call   100906 <print_debuginfo>
            eip = *(uint32_t*)(ebp + 4);
  100a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a58:	83 c0 04             	add    $0x4,%eax
  100a5b:	8b 00                	mov    (%eax),%eax
  100a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
            ebp = *(uint32_t*)ebp;
  100a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a63:	8b 00                	mov    (%eax),%eax
  100a65:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
      uint32_t ebp = read_ebp();
      uint32_t eip = read_eip();
      int i;
      for (i = 0; i < STACKFRAME_DEPTH; i++)
  100a68:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a6c:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a70:	0f 8e 6a ff ff ff    	jle    1009e0 <print_stackframe+0x26>
            cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x\n", args[0], args[1], args[2], args[3]);
            print_debuginfo(eip-1);
            eip = *(uint32_t*)(ebp + 4);
            ebp = *(uint32_t*)ebp;
      }
}
  100a76:	83 c4 44             	add    $0x44,%esp
  100a79:	5b                   	pop    %ebx
  100a7a:	5d                   	pop    %ebp
  100a7b:	c3                   	ret    

00100a7c <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a7c:	55                   	push   %ebp
  100a7d:	89 e5                	mov    %esp,%ebp
  100a7f:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a89:	eb 0c                	jmp    100a97 <parse+0x1b>
            *buf ++ = '\0';
  100a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a8e:	8d 50 01             	lea    0x1(%eax),%edx
  100a91:	89 55 08             	mov    %edx,0x8(%ebp)
  100a94:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a97:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9a:	0f b6 00             	movzbl (%eax),%eax
  100a9d:	84 c0                	test   %al,%al
  100a9f:	74 1d                	je     100abe <parse+0x42>
  100aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa4:	0f b6 00             	movzbl (%eax),%eax
  100aa7:	0f be c0             	movsbl %al,%eax
  100aaa:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aae:	c7 04 24 64 60 10 00 	movl   $0x106064,(%esp)
  100ab5:	e8 09 50 00 00       	call   105ac3 <strchr>
  100aba:	85 c0                	test   %eax,%eax
  100abc:	75 cd                	jne    100a8b <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100abe:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac1:	0f b6 00             	movzbl (%eax),%eax
  100ac4:	84 c0                	test   %al,%al
  100ac6:	75 02                	jne    100aca <parse+0x4e>
            break;
  100ac8:	eb 67                	jmp    100b31 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100aca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ace:	75 14                	jne    100ae4 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ad0:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ad7:	00 
  100ad8:	c7 04 24 69 60 10 00 	movl   $0x106069,(%esp)
  100adf:	e8 58 f8 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae7:	8d 50 01             	lea    0x1(%eax),%edx
  100aea:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100aed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100af4:	8b 45 0c             	mov    0xc(%ebp),%eax
  100af7:	01 c2                	add    %eax,%edx
  100af9:	8b 45 08             	mov    0x8(%ebp),%eax
  100afc:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100afe:	eb 04                	jmp    100b04 <parse+0x88>
            buf ++;
  100b00:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b04:	8b 45 08             	mov    0x8(%ebp),%eax
  100b07:	0f b6 00             	movzbl (%eax),%eax
  100b0a:	84 c0                	test   %al,%al
  100b0c:	74 1d                	je     100b2b <parse+0xaf>
  100b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b11:	0f b6 00             	movzbl (%eax),%eax
  100b14:	0f be c0             	movsbl %al,%eax
  100b17:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b1b:	c7 04 24 64 60 10 00 	movl   $0x106064,(%esp)
  100b22:	e8 9c 4f 00 00       	call   105ac3 <strchr>
  100b27:	85 c0                	test   %eax,%eax
  100b29:	74 d5                	je     100b00 <parse+0x84>
            buf ++;
        }
    }
  100b2b:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b2c:	e9 66 ff ff ff       	jmp    100a97 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b34:	c9                   	leave  
  100b35:	c3                   	ret    

00100b36 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b36:	55                   	push   %ebp
  100b37:	89 e5                	mov    %esp,%ebp
  100b39:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b3c:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b43:	8b 45 08             	mov    0x8(%ebp),%eax
  100b46:	89 04 24             	mov    %eax,(%esp)
  100b49:	e8 2e ff ff ff       	call   100a7c <parse>
  100b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b55:	75 0a                	jne    100b61 <runcmd+0x2b>
        return 0;
  100b57:	b8 00 00 00 00       	mov    $0x0,%eax
  100b5c:	e9 85 00 00 00       	jmp    100be6 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b68:	eb 5c                	jmp    100bc6 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b6a:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b70:	89 d0                	mov    %edx,%eax
  100b72:	01 c0                	add    %eax,%eax
  100b74:	01 d0                	add    %edx,%eax
  100b76:	c1 e0 02             	shl    $0x2,%eax
  100b79:	05 20 70 11 00       	add    $0x117020,%eax
  100b7e:	8b 00                	mov    (%eax),%eax
  100b80:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b84:	89 04 24             	mov    %eax,(%esp)
  100b87:	e8 98 4e 00 00       	call   105a24 <strcmp>
  100b8c:	85 c0                	test   %eax,%eax
  100b8e:	75 32                	jne    100bc2 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b93:	89 d0                	mov    %edx,%eax
  100b95:	01 c0                	add    %eax,%eax
  100b97:	01 d0                	add    %edx,%eax
  100b99:	c1 e0 02             	shl    $0x2,%eax
  100b9c:	05 20 70 11 00       	add    $0x117020,%eax
  100ba1:	8b 40 08             	mov    0x8(%eax),%eax
  100ba4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100ba7:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100baa:	8b 55 0c             	mov    0xc(%ebp),%edx
  100bad:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bb1:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bb4:	83 c2 04             	add    $0x4,%edx
  100bb7:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bbb:	89 0c 24             	mov    %ecx,(%esp)
  100bbe:	ff d0                	call   *%eax
  100bc0:	eb 24                	jmp    100be6 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bc2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bc9:	83 f8 02             	cmp    $0x2,%eax
  100bcc:	76 9c                	jbe    100b6a <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bce:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd5:	c7 04 24 87 60 10 00 	movl   $0x106087,(%esp)
  100bdc:	e8 5b f7 ff ff       	call   10033c <cprintf>
    return 0;
  100be1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100be6:	c9                   	leave  
  100be7:	c3                   	ret    

00100be8 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100be8:	55                   	push   %ebp
  100be9:	89 e5                	mov    %esp,%ebp
  100beb:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bee:	c7 04 24 a0 60 10 00 	movl   $0x1060a0,(%esp)
  100bf5:	e8 42 f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bfa:	c7 04 24 c8 60 10 00 	movl   $0x1060c8,(%esp)
  100c01:	e8 36 f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100c06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c0a:	74 0b                	je     100c17 <kmonitor+0x2f>
        print_trapframe(tf);
  100c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  100c0f:	89 04 24             	mov    %eax,(%esp)
  100c12:	e8 2c 0e 00 00       	call   101a43 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c17:	c7 04 24 ed 60 10 00 	movl   $0x1060ed,(%esp)
  100c1e:	e8 10 f6 ff ff       	call   100233 <readline>
  100c23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c2a:	74 18                	je     100c44 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  100c2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c36:	89 04 24             	mov    %eax,(%esp)
  100c39:	e8 f8 fe ff ff       	call   100b36 <runcmd>
  100c3e:	85 c0                	test   %eax,%eax
  100c40:	79 02                	jns    100c44 <kmonitor+0x5c>
                break;
  100c42:	eb 02                	jmp    100c46 <kmonitor+0x5e>
            }
        }
    }
  100c44:	eb d1                	jmp    100c17 <kmonitor+0x2f>
}
  100c46:	c9                   	leave  
  100c47:	c3                   	ret    

00100c48 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c48:	55                   	push   %ebp
  100c49:	89 e5                	mov    %esp,%ebp
  100c4b:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c55:	eb 3f                	jmp    100c96 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c5a:	89 d0                	mov    %edx,%eax
  100c5c:	01 c0                	add    %eax,%eax
  100c5e:	01 d0                	add    %edx,%eax
  100c60:	c1 e0 02             	shl    $0x2,%eax
  100c63:	05 20 70 11 00       	add    $0x117020,%eax
  100c68:	8b 48 04             	mov    0x4(%eax),%ecx
  100c6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c6e:	89 d0                	mov    %edx,%eax
  100c70:	01 c0                	add    %eax,%eax
  100c72:	01 d0                	add    %edx,%eax
  100c74:	c1 e0 02             	shl    $0x2,%eax
  100c77:	05 20 70 11 00       	add    $0x117020,%eax
  100c7c:	8b 00                	mov    (%eax),%eax
  100c7e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c82:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c86:	c7 04 24 f1 60 10 00 	movl   $0x1060f1,(%esp)
  100c8d:	e8 aa f6 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c92:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c99:	83 f8 02             	cmp    $0x2,%eax
  100c9c:	76 b9                	jbe    100c57 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca3:	c9                   	leave  
  100ca4:	c3                   	ret    

00100ca5 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100ca5:	55                   	push   %ebp
  100ca6:	89 e5                	mov    %esp,%ebp
  100ca8:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cab:	e8 c0 fb ff ff       	call   100870 <print_kerninfo>
    return 0;
  100cb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb5:	c9                   	leave  
  100cb6:	c3                   	ret    

00100cb7 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cb7:	55                   	push   %ebp
  100cb8:	89 e5                	mov    %esp,%ebp
  100cba:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cbd:	e8 f8 fc ff ff       	call   1009ba <print_stackframe>
    return 0;
  100cc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cc7:	c9                   	leave  
  100cc8:	c3                   	ret    

00100cc9 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cc9:	55                   	push   %ebp
  100cca:	89 e5                	mov    %esp,%ebp
  100ccc:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100ccf:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100cd4:	85 c0                	test   %eax,%eax
  100cd6:	74 02                	je     100cda <__panic+0x11>
        goto panic_dead;
  100cd8:	eb 48                	jmp    100d22 <__panic+0x59>
    }
    is_panic = 1;
  100cda:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100ce1:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ce4:	8d 45 14             	lea    0x14(%ebp),%eax
  100ce7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ced:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  100cf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf8:	c7 04 24 fa 60 10 00 	movl   $0x1060fa,(%esp)
  100cff:	e8 38 f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d07:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d0b:	8b 45 10             	mov    0x10(%ebp),%eax
  100d0e:	89 04 24             	mov    %eax,(%esp)
  100d11:	e8 f3 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d16:	c7 04 24 16 61 10 00 	movl   $0x106116,(%esp)
  100d1d:	e8 1a f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d22:	e8 85 09 00 00       	call   1016ac <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d27:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d2e:	e8 b5 fe ff ff       	call   100be8 <kmonitor>
    }
  100d33:	eb f2                	jmp    100d27 <__panic+0x5e>

00100d35 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d35:	55                   	push   %ebp
  100d36:	89 e5                	mov    %esp,%ebp
  100d38:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d3b:	8d 45 14             	lea    0x14(%ebp),%eax
  100d3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d44:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d48:	8b 45 08             	mov    0x8(%ebp),%eax
  100d4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d4f:	c7 04 24 18 61 10 00 	movl   $0x106118,(%esp)
  100d56:	e8 e1 f5 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d62:	8b 45 10             	mov    0x10(%ebp),%eax
  100d65:	89 04 24             	mov    %eax,(%esp)
  100d68:	e8 9c f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d6d:	c7 04 24 16 61 10 00 	movl   $0x106116,(%esp)
  100d74:	e8 c3 f5 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100d79:	c9                   	leave  
  100d7a:	c3                   	ret    

00100d7b <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d7b:	55                   	push   %ebp
  100d7c:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d7e:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d83:	5d                   	pop    %ebp
  100d84:	c3                   	ret    

00100d85 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d85:	55                   	push   %ebp
  100d86:	89 e5                	mov    %esp,%ebp
  100d88:	83 ec 28             	sub    $0x28,%esp
  100d8b:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d91:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d95:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d99:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d9d:	ee                   	out    %al,(%dx)
  100d9e:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100da4:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100da8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dac:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100db0:	ee                   	out    %al,(%dx)
  100db1:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100db7:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dbb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dbf:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dc3:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dc4:	c7 05 6c 89 11 00 00 	movl   $0x0,0x11896c
  100dcb:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dce:	c7 04 24 36 61 10 00 	movl   $0x106136,(%esp)
  100dd5:	e8 62 f5 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100dda:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100de1:	e8 24 09 00 00       	call   10170a <pic_enable>
}
  100de6:	c9                   	leave  
  100de7:	c3                   	ret    

00100de8 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100de8:	55                   	push   %ebp
  100de9:	89 e5                	mov    %esp,%ebp
  100deb:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100dee:	9c                   	pushf  
  100def:	58                   	pop    %eax
  100df0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100df6:	25 00 02 00 00       	and    $0x200,%eax
  100dfb:	85 c0                	test   %eax,%eax
  100dfd:	74 0c                	je     100e0b <__intr_save+0x23>
        intr_disable();
  100dff:	e8 a8 08 00 00       	call   1016ac <intr_disable>
        return 1;
  100e04:	b8 01 00 00 00       	mov    $0x1,%eax
  100e09:	eb 05                	jmp    100e10 <__intr_save+0x28>
    }
    return 0;
  100e0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e10:	c9                   	leave  
  100e11:	c3                   	ret    

00100e12 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e12:	55                   	push   %ebp
  100e13:	89 e5                	mov    %esp,%ebp
  100e15:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e1c:	74 05                	je     100e23 <__intr_restore+0x11>
        intr_enable();
  100e1e:	e8 83 08 00 00       	call   1016a6 <intr_enable>
    }
}
  100e23:	c9                   	leave  
  100e24:	c3                   	ret    

00100e25 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e25:	55                   	push   %ebp
  100e26:	89 e5                	mov    %esp,%ebp
  100e28:	83 ec 10             	sub    $0x10,%esp
  100e2b:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e31:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e35:	89 c2                	mov    %eax,%edx
  100e37:	ec                   	in     (%dx),%al
  100e38:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e3b:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e41:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e45:	89 c2                	mov    %eax,%edx
  100e47:	ec                   	in     (%dx),%al
  100e48:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e4b:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e51:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e55:	89 c2                	mov    %eax,%edx
  100e57:	ec                   	in     (%dx),%al
  100e58:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e5b:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e61:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e65:	89 c2                	mov    %eax,%edx
  100e67:	ec                   	in     (%dx),%al
  100e68:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e6b:	c9                   	leave  
  100e6c:	c3                   	ret    

00100e6d <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e6d:	55                   	push   %ebp
  100e6e:	89 e5                	mov    %esp,%ebp
  100e70:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e73:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e7d:	0f b7 00             	movzwl (%eax),%eax
  100e80:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e87:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8f:	0f b7 00             	movzwl (%eax),%eax
  100e92:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e96:	74 12                	je     100eaa <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e98:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e9f:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100ea6:	b4 03 
  100ea8:	eb 13                	jmp    100ebd <cga_init+0x50>
    } else {
        *cp = was;
  100eaa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ead:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eb1:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eb4:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100ebb:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ebd:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ec4:	0f b7 c0             	movzwl %ax,%eax
  100ec7:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ecb:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ecf:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ed3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ed7:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ed8:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100edf:	83 c0 01             	add    $0x1,%eax
  100ee2:	0f b7 c0             	movzwl %ax,%eax
  100ee5:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ee9:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100eed:	89 c2                	mov    %eax,%edx
  100eef:	ec                   	in     (%dx),%al
  100ef0:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ef3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ef7:	0f b6 c0             	movzbl %al,%eax
  100efa:	c1 e0 08             	shl    $0x8,%eax
  100efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f00:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f07:	0f b7 c0             	movzwl %ax,%eax
  100f0a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f0e:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f12:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f16:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f1a:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f1b:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f22:	83 c0 01             	add    $0x1,%eax
  100f25:	0f b7 c0             	movzwl %ax,%eax
  100f28:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f2c:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f30:	89 c2                	mov    %eax,%edx
  100f32:	ec                   	in     (%dx),%al
  100f33:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f36:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f3a:	0f b6 c0             	movzbl %al,%eax
  100f3d:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f43:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f4b:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f51:	c9                   	leave  
  100f52:	c3                   	ret    

00100f53 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f53:	55                   	push   %ebp
  100f54:	89 e5                	mov    %esp,%ebp
  100f56:	83 ec 48             	sub    $0x48,%esp
  100f59:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f5f:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f63:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f67:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f6b:	ee                   	out    %al,(%dx)
  100f6c:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f72:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f76:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f7a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f7e:	ee                   	out    %al,(%dx)
  100f7f:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f85:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f89:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f8d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f91:	ee                   	out    %al,(%dx)
  100f92:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f98:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f9c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fa0:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fa4:	ee                   	out    %al,(%dx)
  100fa5:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fab:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100faf:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fb3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fb7:	ee                   	out    %al,(%dx)
  100fb8:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fbe:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fc2:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fc6:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fca:	ee                   	out    %al,(%dx)
  100fcb:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fd1:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fd5:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fd9:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fdd:	ee                   	out    %al,(%dx)
  100fde:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fe4:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fe8:	89 c2                	mov    %eax,%edx
  100fea:	ec                   	in     (%dx),%al
  100feb:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100fee:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100ff2:	3c ff                	cmp    $0xff,%al
  100ff4:	0f 95 c0             	setne  %al
  100ff7:	0f b6 c0             	movzbl %al,%eax
  100ffa:	a3 88 7e 11 00       	mov    %eax,0x117e88
  100fff:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101005:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101009:	89 c2                	mov    %eax,%edx
  10100b:	ec                   	in     (%dx),%al
  10100c:	88 45 d5             	mov    %al,-0x2b(%ebp)
  10100f:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101015:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101019:	89 c2                	mov    %eax,%edx
  10101b:	ec                   	in     (%dx),%al
  10101c:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10101f:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101024:	85 c0                	test   %eax,%eax
  101026:	74 0c                	je     101034 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101028:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10102f:	e8 d6 06 00 00       	call   10170a <pic_enable>
    }
}
  101034:	c9                   	leave  
  101035:	c3                   	ret    

00101036 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101036:	55                   	push   %ebp
  101037:	89 e5                	mov    %esp,%ebp
  101039:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10103c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101043:	eb 09                	jmp    10104e <lpt_putc_sub+0x18>
        delay();
  101045:	e8 db fd ff ff       	call   100e25 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10104a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10104e:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101054:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101058:	89 c2                	mov    %eax,%edx
  10105a:	ec                   	in     (%dx),%al
  10105b:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10105e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101062:	84 c0                	test   %al,%al
  101064:	78 09                	js     10106f <lpt_putc_sub+0x39>
  101066:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10106d:	7e d6                	jle    101045 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10106f:	8b 45 08             	mov    0x8(%ebp),%eax
  101072:	0f b6 c0             	movzbl %al,%eax
  101075:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  10107b:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10107e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101082:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101086:	ee                   	out    %al,(%dx)
  101087:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10108d:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101091:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101095:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101099:	ee                   	out    %al,(%dx)
  10109a:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010a0:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010a4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010a8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010ac:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010ad:	c9                   	leave  
  1010ae:	c3                   	ret    

001010af <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010af:	55                   	push   %ebp
  1010b0:	89 e5                	mov    %esp,%ebp
  1010b2:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010b5:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010b9:	74 0d                	je     1010c8 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1010be:	89 04 24             	mov    %eax,(%esp)
  1010c1:	e8 70 ff ff ff       	call   101036 <lpt_putc_sub>
  1010c6:	eb 24                	jmp    1010ec <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010c8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010cf:	e8 62 ff ff ff       	call   101036 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010d4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010db:	e8 56 ff ff ff       	call   101036 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010e0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010e7:	e8 4a ff ff ff       	call   101036 <lpt_putc_sub>
    }
}
  1010ec:	c9                   	leave  
  1010ed:	c3                   	ret    

001010ee <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010ee:	55                   	push   %ebp
  1010ef:	89 e5                	mov    %esp,%ebp
  1010f1:	53                   	push   %ebx
  1010f2:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f8:	b0 00                	mov    $0x0,%al
  1010fa:	85 c0                	test   %eax,%eax
  1010fc:	75 07                	jne    101105 <cga_putc+0x17>
        c |= 0x0700;
  1010fe:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101105:	8b 45 08             	mov    0x8(%ebp),%eax
  101108:	0f b6 c0             	movzbl %al,%eax
  10110b:	83 f8 0a             	cmp    $0xa,%eax
  10110e:	74 4c                	je     10115c <cga_putc+0x6e>
  101110:	83 f8 0d             	cmp    $0xd,%eax
  101113:	74 57                	je     10116c <cga_putc+0x7e>
  101115:	83 f8 08             	cmp    $0x8,%eax
  101118:	0f 85 88 00 00 00    	jne    1011a6 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  10111e:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101125:	66 85 c0             	test   %ax,%ax
  101128:	74 30                	je     10115a <cga_putc+0x6c>
            crt_pos --;
  10112a:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101131:	83 e8 01             	sub    $0x1,%eax
  101134:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10113a:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10113f:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  101146:	0f b7 d2             	movzwl %dx,%edx
  101149:	01 d2                	add    %edx,%edx
  10114b:	01 c2                	add    %eax,%edx
  10114d:	8b 45 08             	mov    0x8(%ebp),%eax
  101150:	b0 00                	mov    $0x0,%al
  101152:	83 c8 20             	or     $0x20,%eax
  101155:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101158:	eb 72                	jmp    1011cc <cga_putc+0xde>
  10115a:	eb 70                	jmp    1011cc <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  10115c:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101163:	83 c0 50             	add    $0x50,%eax
  101166:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10116c:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  101173:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  10117a:	0f b7 c1             	movzwl %cx,%eax
  10117d:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101183:	c1 e8 10             	shr    $0x10,%eax
  101186:	89 c2                	mov    %eax,%edx
  101188:	66 c1 ea 06          	shr    $0x6,%dx
  10118c:	89 d0                	mov    %edx,%eax
  10118e:	c1 e0 02             	shl    $0x2,%eax
  101191:	01 d0                	add    %edx,%eax
  101193:	c1 e0 04             	shl    $0x4,%eax
  101196:	29 c1                	sub    %eax,%ecx
  101198:	89 ca                	mov    %ecx,%edx
  10119a:	89 d8                	mov    %ebx,%eax
  10119c:	29 d0                	sub    %edx,%eax
  10119e:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1011a4:	eb 26                	jmp    1011cc <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011a6:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1011ac:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011b3:	8d 50 01             	lea    0x1(%eax),%edx
  1011b6:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011bd:	0f b7 c0             	movzwl %ax,%eax
  1011c0:	01 c0                	add    %eax,%eax
  1011c2:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1011c8:	66 89 02             	mov    %ax,(%edx)
        break;
  1011cb:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011cc:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011d3:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011d7:	76 5b                	jbe    101234 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011d9:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011de:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011e4:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011e9:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011f0:	00 
  1011f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011f5:	89 04 24             	mov    %eax,(%esp)
  1011f8:	e8 c4 4a 00 00       	call   105cc1 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011fd:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101204:	eb 15                	jmp    10121b <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101206:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10120b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10120e:	01 d2                	add    %edx,%edx
  101210:	01 d0                	add    %edx,%eax
  101212:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101217:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10121b:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101222:	7e e2                	jle    101206 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101224:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10122b:	83 e8 50             	sub    $0x50,%eax
  10122e:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101234:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10123b:	0f b7 c0             	movzwl %ax,%eax
  10123e:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101242:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101246:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10124a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10124e:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10124f:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101256:	66 c1 e8 08          	shr    $0x8,%ax
  10125a:	0f b6 c0             	movzbl %al,%eax
  10125d:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101264:	83 c2 01             	add    $0x1,%edx
  101267:	0f b7 d2             	movzwl %dx,%edx
  10126a:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  10126e:	88 45 ed             	mov    %al,-0x13(%ebp)
  101271:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101275:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101279:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10127a:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101281:	0f b7 c0             	movzwl %ax,%eax
  101284:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101288:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  10128c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101290:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101294:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101295:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10129c:	0f b6 c0             	movzbl %al,%eax
  10129f:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012a6:	83 c2 01             	add    $0x1,%edx
  1012a9:	0f b7 d2             	movzwl %dx,%edx
  1012ac:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012b0:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012b3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012b7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012bb:	ee                   	out    %al,(%dx)
}
  1012bc:	83 c4 34             	add    $0x34,%esp
  1012bf:	5b                   	pop    %ebx
  1012c0:	5d                   	pop    %ebp
  1012c1:	c3                   	ret    

001012c2 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012c2:	55                   	push   %ebp
  1012c3:	89 e5                	mov    %esp,%ebp
  1012c5:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012cf:	eb 09                	jmp    1012da <serial_putc_sub+0x18>
        delay();
  1012d1:	e8 4f fb ff ff       	call   100e25 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012da:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012e0:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012e4:	89 c2                	mov    %eax,%edx
  1012e6:	ec                   	in     (%dx),%al
  1012e7:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012ea:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012ee:	0f b6 c0             	movzbl %al,%eax
  1012f1:	83 e0 20             	and    $0x20,%eax
  1012f4:	85 c0                	test   %eax,%eax
  1012f6:	75 09                	jne    101301 <serial_putc_sub+0x3f>
  1012f8:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012ff:	7e d0                	jle    1012d1 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101301:	8b 45 08             	mov    0x8(%ebp),%eax
  101304:	0f b6 c0             	movzbl %al,%eax
  101307:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10130d:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101310:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101314:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101318:	ee                   	out    %al,(%dx)
}
  101319:	c9                   	leave  
  10131a:	c3                   	ret    

0010131b <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10131b:	55                   	push   %ebp
  10131c:	89 e5                	mov    %esp,%ebp
  10131e:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101321:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101325:	74 0d                	je     101334 <serial_putc+0x19>
        serial_putc_sub(c);
  101327:	8b 45 08             	mov    0x8(%ebp),%eax
  10132a:	89 04 24             	mov    %eax,(%esp)
  10132d:	e8 90 ff ff ff       	call   1012c2 <serial_putc_sub>
  101332:	eb 24                	jmp    101358 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101334:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10133b:	e8 82 ff ff ff       	call   1012c2 <serial_putc_sub>
        serial_putc_sub(' ');
  101340:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101347:	e8 76 ff ff ff       	call   1012c2 <serial_putc_sub>
        serial_putc_sub('\b');
  10134c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101353:	e8 6a ff ff ff       	call   1012c2 <serial_putc_sub>
    }
}
  101358:	c9                   	leave  
  101359:	c3                   	ret    

0010135a <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10135a:	55                   	push   %ebp
  10135b:	89 e5                	mov    %esp,%ebp
  10135d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101360:	eb 33                	jmp    101395 <cons_intr+0x3b>
        if (c != 0) {
  101362:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101366:	74 2d                	je     101395 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101368:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10136d:	8d 50 01             	lea    0x1(%eax),%edx
  101370:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  101376:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101379:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10137f:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101384:	3d 00 02 00 00       	cmp    $0x200,%eax
  101389:	75 0a                	jne    101395 <cons_intr+0x3b>
                cons.wpos = 0;
  10138b:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  101392:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101395:	8b 45 08             	mov    0x8(%ebp),%eax
  101398:	ff d0                	call   *%eax
  10139a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10139d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013a1:	75 bf                	jne    101362 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013a3:	c9                   	leave  
  1013a4:	c3                   	ret    

001013a5 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013a5:	55                   	push   %ebp
  1013a6:	89 e5                	mov    %esp,%ebp
  1013a8:	83 ec 10             	sub    $0x10,%esp
  1013ab:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013b1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013b5:	89 c2                	mov    %eax,%edx
  1013b7:	ec                   	in     (%dx),%al
  1013b8:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013bb:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013bf:	0f b6 c0             	movzbl %al,%eax
  1013c2:	83 e0 01             	and    $0x1,%eax
  1013c5:	85 c0                	test   %eax,%eax
  1013c7:	75 07                	jne    1013d0 <serial_proc_data+0x2b>
        return -1;
  1013c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013ce:	eb 2a                	jmp    1013fa <serial_proc_data+0x55>
  1013d0:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013d6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013da:	89 c2                	mov    %eax,%edx
  1013dc:	ec                   	in     (%dx),%al
  1013dd:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013e0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013e4:	0f b6 c0             	movzbl %al,%eax
  1013e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013ea:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013ee:	75 07                	jne    1013f7 <serial_proc_data+0x52>
        c = '\b';
  1013f0:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013fa:	c9                   	leave  
  1013fb:	c3                   	ret    

001013fc <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013fc:	55                   	push   %ebp
  1013fd:	89 e5                	mov    %esp,%ebp
  1013ff:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101402:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101407:	85 c0                	test   %eax,%eax
  101409:	74 0c                	je     101417 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10140b:	c7 04 24 a5 13 10 00 	movl   $0x1013a5,(%esp)
  101412:	e8 43 ff ff ff       	call   10135a <cons_intr>
    }
}
  101417:	c9                   	leave  
  101418:	c3                   	ret    

00101419 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101419:	55                   	push   %ebp
  10141a:	89 e5                	mov    %esp,%ebp
  10141c:	83 ec 38             	sub    $0x38,%esp
  10141f:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101425:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101429:	89 c2                	mov    %eax,%edx
  10142b:	ec                   	in     (%dx),%al
  10142c:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10142f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101433:	0f b6 c0             	movzbl %al,%eax
  101436:	83 e0 01             	and    $0x1,%eax
  101439:	85 c0                	test   %eax,%eax
  10143b:	75 0a                	jne    101447 <kbd_proc_data+0x2e>
        return -1;
  10143d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101442:	e9 59 01 00 00       	jmp    1015a0 <kbd_proc_data+0x187>
  101447:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10144d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101451:	89 c2                	mov    %eax,%edx
  101453:	ec                   	in     (%dx),%al
  101454:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101457:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10145b:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10145e:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101462:	75 17                	jne    10147b <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101464:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101469:	83 c8 40             	or     $0x40,%eax
  10146c:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101471:	b8 00 00 00 00       	mov    $0x0,%eax
  101476:	e9 25 01 00 00       	jmp    1015a0 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10147b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147f:	84 c0                	test   %al,%al
  101481:	79 47                	jns    1014ca <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101483:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101488:	83 e0 40             	and    $0x40,%eax
  10148b:	85 c0                	test   %eax,%eax
  10148d:	75 09                	jne    101498 <kbd_proc_data+0x7f>
  10148f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101493:	83 e0 7f             	and    $0x7f,%eax
  101496:	eb 04                	jmp    10149c <kbd_proc_data+0x83>
  101498:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149c:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10149f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a3:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014aa:	83 c8 40             	or     $0x40,%eax
  1014ad:	0f b6 c0             	movzbl %al,%eax
  1014b0:	f7 d0                	not    %eax
  1014b2:	89 c2                	mov    %eax,%edx
  1014b4:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014b9:	21 d0                	and    %edx,%eax
  1014bb:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014c0:	b8 00 00 00 00       	mov    $0x0,%eax
  1014c5:	e9 d6 00 00 00       	jmp    1015a0 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014ca:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014cf:	83 e0 40             	and    $0x40,%eax
  1014d2:	85 c0                	test   %eax,%eax
  1014d4:	74 11                	je     1014e7 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014d6:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014da:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014df:	83 e0 bf             	and    $0xffffffbf,%eax
  1014e2:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014e7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014eb:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014f2:	0f b6 d0             	movzbl %al,%edx
  1014f5:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014fa:	09 d0                	or     %edx,%eax
  1014fc:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  101501:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101505:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  10150c:	0f b6 d0             	movzbl %al,%edx
  10150f:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101514:	31 d0                	xor    %edx,%eax
  101516:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  10151b:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101520:	83 e0 03             	and    $0x3,%eax
  101523:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  10152a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152e:	01 d0                	add    %edx,%eax
  101530:	0f b6 00             	movzbl (%eax),%eax
  101533:	0f b6 c0             	movzbl %al,%eax
  101536:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101539:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10153e:	83 e0 08             	and    $0x8,%eax
  101541:	85 c0                	test   %eax,%eax
  101543:	74 22                	je     101567 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101545:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101549:	7e 0c                	jle    101557 <kbd_proc_data+0x13e>
  10154b:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10154f:	7f 06                	jg     101557 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101551:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101555:	eb 10                	jmp    101567 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101557:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10155b:	7e 0a                	jle    101567 <kbd_proc_data+0x14e>
  10155d:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101561:	7f 04                	jg     101567 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101563:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101567:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10156c:	f7 d0                	not    %eax
  10156e:	83 e0 06             	and    $0x6,%eax
  101571:	85 c0                	test   %eax,%eax
  101573:	75 28                	jne    10159d <kbd_proc_data+0x184>
  101575:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10157c:	75 1f                	jne    10159d <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10157e:	c7 04 24 51 61 10 00 	movl   $0x106151,(%esp)
  101585:	e8 b2 ed ff ff       	call   10033c <cprintf>
  10158a:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101590:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101594:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101598:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10159c:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10159d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015a0:	c9                   	leave  
  1015a1:	c3                   	ret    

001015a2 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015a2:	55                   	push   %ebp
  1015a3:	89 e5                	mov    %esp,%ebp
  1015a5:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015a8:	c7 04 24 19 14 10 00 	movl   $0x101419,(%esp)
  1015af:	e8 a6 fd ff ff       	call   10135a <cons_intr>
}
  1015b4:	c9                   	leave  
  1015b5:	c3                   	ret    

001015b6 <kbd_init>:

static void
kbd_init(void) {
  1015b6:	55                   	push   %ebp
  1015b7:	89 e5                	mov    %esp,%ebp
  1015b9:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015bc:	e8 e1 ff ff ff       	call   1015a2 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015c8:	e8 3d 01 00 00       	call   10170a <pic_enable>
}
  1015cd:	c9                   	leave  
  1015ce:	c3                   	ret    

001015cf <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015cf:	55                   	push   %ebp
  1015d0:	89 e5                	mov    %esp,%ebp
  1015d2:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015d5:	e8 93 f8 ff ff       	call   100e6d <cga_init>
    serial_init();
  1015da:	e8 74 f9 ff ff       	call   100f53 <serial_init>
    kbd_init();
  1015df:	e8 d2 ff ff ff       	call   1015b6 <kbd_init>
    if (!serial_exists) {
  1015e4:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015e9:	85 c0                	test   %eax,%eax
  1015eb:	75 0c                	jne    1015f9 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015ed:	c7 04 24 5d 61 10 00 	movl   $0x10615d,(%esp)
  1015f4:	e8 43 ed ff ff       	call   10033c <cprintf>
    }
}
  1015f9:	c9                   	leave  
  1015fa:	c3                   	ret    

001015fb <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015fb:	55                   	push   %ebp
  1015fc:	89 e5                	mov    %esp,%ebp
  1015fe:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101601:	e8 e2 f7 ff ff       	call   100de8 <__intr_save>
  101606:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101609:	8b 45 08             	mov    0x8(%ebp),%eax
  10160c:	89 04 24             	mov    %eax,(%esp)
  10160f:	e8 9b fa ff ff       	call   1010af <lpt_putc>
        cga_putc(c);
  101614:	8b 45 08             	mov    0x8(%ebp),%eax
  101617:	89 04 24             	mov    %eax,(%esp)
  10161a:	e8 cf fa ff ff       	call   1010ee <cga_putc>
        serial_putc(c);
  10161f:	8b 45 08             	mov    0x8(%ebp),%eax
  101622:	89 04 24             	mov    %eax,(%esp)
  101625:	e8 f1 fc ff ff       	call   10131b <serial_putc>
    }
    local_intr_restore(intr_flag);
  10162a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10162d:	89 04 24             	mov    %eax,(%esp)
  101630:	e8 dd f7 ff ff       	call   100e12 <__intr_restore>
}
  101635:	c9                   	leave  
  101636:	c3                   	ret    

00101637 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101637:	55                   	push   %ebp
  101638:	89 e5                	mov    %esp,%ebp
  10163a:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  10163d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101644:	e8 9f f7 ff ff       	call   100de8 <__intr_save>
  101649:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10164c:	e8 ab fd ff ff       	call   1013fc <serial_intr>
        kbd_intr();
  101651:	e8 4c ff ff ff       	call   1015a2 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101656:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  10165c:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101661:	39 c2                	cmp    %eax,%edx
  101663:	74 31                	je     101696 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101665:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  10166a:	8d 50 01             	lea    0x1(%eax),%edx
  10166d:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  101673:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  10167a:	0f b6 c0             	movzbl %al,%eax
  10167d:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101680:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101685:	3d 00 02 00 00       	cmp    $0x200,%eax
  10168a:	75 0a                	jne    101696 <cons_getc+0x5f>
                cons.rpos = 0;
  10168c:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  101693:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101696:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101699:	89 04 24             	mov    %eax,(%esp)
  10169c:	e8 71 f7 ff ff       	call   100e12 <__intr_restore>
    return c;
  1016a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016a4:	c9                   	leave  
  1016a5:	c3                   	ret    

001016a6 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016a6:	55                   	push   %ebp
  1016a7:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016a9:	fb                   	sti    
    sti();
}
  1016aa:	5d                   	pop    %ebp
  1016ab:	c3                   	ret    

001016ac <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016ac:	55                   	push   %ebp
  1016ad:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016af:	fa                   	cli    
    cli();
}
  1016b0:	5d                   	pop    %ebp
  1016b1:	c3                   	ret    

001016b2 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016b2:	55                   	push   %ebp
  1016b3:	89 e5                	mov    %esp,%ebp
  1016b5:	83 ec 14             	sub    $0x14,%esp
  1016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1016bb:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016bf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c3:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016c9:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016ce:	85 c0                	test   %eax,%eax
  1016d0:	74 36                	je     101708 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016d2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d6:	0f b6 c0             	movzbl %al,%eax
  1016d9:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016df:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016e2:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016e6:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016ea:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016eb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016ef:	66 c1 e8 08          	shr    $0x8,%ax
  1016f3:	0f b6 c0             	movzbl %al,%eax
  1016f6:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016fc:	88 45 f9             	mov    %al,-0x7(%ebp)
  1016ff:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101703:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101707:	ee                   	out    %al,(%dx)
    }
}
  101708:	c9                   	leave  
  101709:	c3                   	ret    

0010170a <pic_enable>:

void
pic_enable(unsigned int irq) {
  10170a:	55                   	push   %ebp
  10170b:	89 e5                	mov    %esp,%ebp
  10170d:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101710:	8b 45 08             	mov    0x8(%ebp),%eax
  101713:	ba 01 00 00 00       	mov    $0x1,%edx
  101718:	89 c1                	mov    %eax,%ecx
  10171a:	d3 e2                	shl    %cl,%edx
  10171c:	89 d0                	mov    %edx,%eax
  10171e:	f7 d0                	not    %eax
  101720:	89 c2                	mov    %eax,%edx
  101722:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101729:	21 d0                	and    %edx,%eax
  10172b:	0f b7 c0             	movzwl %ax,%eax
  10172e:	89 04 24             	mov    %eax,(%esp)
  101731:	e8 7c ff ff ff       	call   1016b2 <pic_setmask>
}
  101736:	c9                   	leave  
  101737:	c3                   	ret    

00101738 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101738:	55                   	push   %ebp
  101739:	89 e5                	mov    %esp,%ebp
  10173b:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  10173e:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101745:	00 00 00 
  101748:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10174e:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101752:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101756:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10175a:	ee                   	out    %al,(%dx)
  10175b:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101761:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101765:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101769:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10176d:	ee                   	out    %al,(%dx)
  10176e:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101774:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101778:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10177c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101780:	ee                   	out    %al,(%dx)
  101781:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101787:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  10178b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10178f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101793:	ee                   	out    %al,(%dx)
  101794:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10179a:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  10179e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017a2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017a6:	ee                   	out    %al,(%dx)
  1017a7:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017ad:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017b1:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017b5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017b9:	ee                   	out    %al,(%dx)
  1017ba:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017c0:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017c4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017c8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017cc:	ee                   	out    %al,(%dx)
  1017cd:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017d3:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017d7:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017db:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017df:	ee                   	out    %al,(%dx)
  1017e0:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017e6:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017ea:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017ee:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017f2:	ee                   	out    %al,(%dx)
  1017f3:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017f9:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  1017fd:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101801:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101805:	ee                   	out    %al,(%dx)
  101806:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10180c:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101810:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101814:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101818:	ee                   	out    %al,(%dx)
  101819:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10181f:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101823:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101827:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10182b:	ee                   	out    %al,(%dx)
  10182c:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101832:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101836:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10183a:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  10183e:	ee                   	out    %al,(%dx)
  10183f:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101845:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101849:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10184d:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101851:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101852:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101859:	66 83 f8 ff          	cmp    $0xffff,%ax
  10185d:	74 12                	je     101871 <pic_init+0x139>
        pic_setmask(irq_mask);
  10185f:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101866:	0f b7 c0             	movzwl %ax,%eax
  101869:	89 04 24             	mov    %eax,(%esp)
  10186c:	e8 41 fe ff ff       	call   1016b2 <pic_setmask>
    }
}
  101871:	c9                   	leave  
  101872:	c3                   	ret    

00101873 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101873:	55                   	push   %ebp
  101874:	89 e5                	mov    %esp,%ebp
  101876:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101879:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101880:	00 
  101881:	c7 04 24 80 61 10 00 	movl   $0x106180,(%esp)
  101888:	e8 af ea ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10188d:	c9                   	leave  
  10188e:	c3                   	ret    

0010188f <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10188f:	55                   	push   %ebp
  101890:	89 e5                	mov    %esp,%ebp
  101892:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 256; i++)
  101895:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10189c:	e9 c3 00 00 00       	jmp    101964 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a4:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018ab:	89 c2                	mov    %eax,%edx
  1018ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b0:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018b7:	00 
  1018b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018bb:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018c2:	00 08 00 
  1018c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c8:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018cf:	00 
  1018d0:	83 e2 e0             	and    $0xffffffe0,%edx
  1018d3:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018dd:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018e4:	00 
  1018e5:	83 e2 1f             	and    $0x1f,%edx
  1018e8:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f2:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  1018f9:	00 
  1018fa:	83 e2 f0             	and    $0xfffffff0,%edx
  1018fd:	83 ca 0e             	or     $0xe,%edx
  101900:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101907:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10190a:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101911:	00 
  101912:	83 e2 ef             	and    $0xffffffef,%edx
  101915:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10191c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191f:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101926:	00 
  101927:	83 e2 9f             	and    $0xffffff9f,%edx
  10192a:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101931:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101934:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10193b:	00 
  10193c:	83 ca 80             	or     $0xffffff80,%edx
  10193f:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101946:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101949:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101950:	c1 e8 10             	shr    $0x10,%eax
  101953:	89 c2                	mov    %eax,%edx
  101955:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101958:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  10195f:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 256; i++)
  101960:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101964:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  10196b:	0f 8e 30 ff ff ff    	jle    1018a1 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    SETGATE(idt[T_SYSCALL], 1, GD_KTEXT, __vectors[T_SYSCALL], DPL_USER);
  101971:	a1 00 78 11 00       	mov    0x117800,%eax
  101976:	66 a3 c0 84 11 00    	mov    %ax,0x1184c0
  10197c:	66 c7 05 c2 84 11 00 	movw   $0x8,0x1184c2
  101983:	08 00 
  101985:	0f b6 05 c4 84 11 00 	movzbl 0x1184c4,%eax
  10198c:	83 e0 e0             	and    $0xffffffe0,%eax
  10198f:	a2 c4 84 11 00       	mov    %al,0x1184c4
  101994:	0f b6 05 c4 84 11 00 	movzbl 0x1184c4,%eax
  10199b:	83 e0 1f             	and    $0x1f,%eax
  10199e:	a2 c4 84 11 00       	mov    %al,0x1184c4
  1019a3:	0f b6 05 c5 84 11 00 	movzbl 0x1184c5,%eax
  1019aa:	83 c8 0f             	or     $0xf,%eax
  1019ad:	a2 c5 84 11 00       	mov    %al,0x1184c5
  1019b2:	0f b6 05 c5 84 11 00 	movzbl 0x1184c5,%eax
  1019b9:	83 e0 ef             	and    $0xffffffef,%eax
  1019bc:	a2 c5 84 11 00       	mov    %al,0x1184c5
  1019c1:	0f b6 05 c5 84 11 00 	movzbl 0x1184c5,%eax
  1019c8:	83 c8 60             	or     $0x60,%eax
  1019cb:	a2 c5 84 11 00       	mov    %al,0x1184c5
  1019d0:	0f b6 05 c5 84 11 00 	movzbl 0x1184c5,%eax
  1019d7:	83 c8 80             	or     $0xffffff80,%eax
  1019da:	a2 c5 84 11 00       	mov    %al,0x1184c5
  1019df:	a1 00 78 11 00       	mov    0x117800,%eax
  1019e4:	c1 e8 10             	shr    $0x10,%eax
  1019e7:	66 a3 c6 84 11 00    	mov    %ax,0x1184c6
  1019ed:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  1019f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019f7:	0f 01 18             	lidtl  (%eax)
    lidt(&idt_pd);
}
  1019fa:	c9                   	leave  
  1019fb:	c3                   	ret    

001019fc <trapname>:

static const char *
trapname(int trapno) {
  1019fc:	55                   	push   %ebp
  1019fd:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  101a02:	83 f8 13             	cmp    $0x13,%eax
  101a05:	77 0c                	ja     101a13 <trapname+0x17>
        return excnames[trapno];
  101a07:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0a:	8b 04 85 e0 64 10 00 	mov    0x1064e0(,%eax,4),%eax
  101a11:	eb 18                	jmp    101a2b <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a13:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a17:	7e 0d                	jle    101a26 <trapname+0x2a>
  101a19:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a1d:	7f 07                	jg     101a26 <trapname+0x2a>
        return "Hardware Interrupt";
  101a1f:	b8 8a 61 10 00       	mov    $0x10618a,%eax
  101a24:	eb 05                	jmp    101a2b <trapname+0x2f>
    }
    return "(unknown trap)";
  101a26:	b8 9d 61 10 00       	mov    $0x10619d,%eax
}
  101a2b:	5d                   	pop    %ebp
  101a2c:	c3                   	ret    

00101a2d <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a2d:	55                   	push   %ebp
  101a2e:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a30:	8b 45 08             	mov    0x8(%ebp),%eax
  101a33:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a37:	66 83 f8 08          	cmp    $0x8,%ax
  101a3b:	0f 94 c0             	sete   %al
  101a3e:	0f b6 c0             	movzbl %al,%eax
}
  101a41:	5d                   	pop    %ebp
  101a42:	c3                   	ret    

00101a43 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a43:	55                   	push   %ebp
  101a44:	89 e5                	mov    %esp,%ebp
  101a46:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a49:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a50:	c7 04 24 de 61 10 00 	movl   $0x1061de,(%esp)
  101a57:	e8 e0 e8 ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  101a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5f:	89 04 24             	mov    %eax,(%esp)
  101a62:	e8 a1 01 00 00       	call   101c08 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a67:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6a:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a6e:	0f b7 c0             	movzwl %ax,%eax
  101a71:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a75:	c7 04 24 ef 61 10 00 	movl   $0x1061ef,(%esp)
  101a7c:	e8 bb e8 ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a81:	8b 45 08             	mov    0x8(%ebp),%eax
  101a84:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a88:	0f b7 c0             	movzwl %ax,%eax
  101a8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a8f:	c7 04 24 02 62 10 00 	movl   $0x106202,(%esp)
  101a96:	e8 a1 e8 ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9e:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101aa2:	0f b7 c0             	movzwl %ax,%eax
  101aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa9:	c7 04 24 15 62 10 00 	movl   $0x106215,(%esp)
  101ab0:	e8 87 e8 ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab8:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101abc:	0f b7 c0             	movzwl %ax,%eax
  101abf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac3:	c7 04 24 28 62 10 00 	movl   $0x106228,(%esp)
  101aca:	e8 6d e8 ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101acf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad2:	8b 40 30             	mov    0x30(%eax),%eax
  101ad5:	89 04 24             	mov    %eax,(%esp)
  101ad8:	e8 1f ff ff ff       	call   1019fc <trapname>
  101add:	8b 55 08             	mov    0x8(%ebp),%edx
  101ae0:	8b 52 30             	mov    0x30(%edx),%edx
  101ae3:	89 44 24 08          	mov    %eax,0x8(%esp)
  101ae7:	89 54 24 04          	mov    %edx,0x4(%esp)
  101aeb:	c7 04 24 3b 62 10 00 	movl   $0x10623b,(%esp)
  101af2:	e8 45 e8 ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101af7:	8b 45 08             	mov    0x8(%ebp),%eax
  101afa:	8b 40 34             	mov    0x34(%eax),%eax
  101afd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b01:	c7 04 24 4d 62 10 00 	movl   $0x10624d,(%esp)
  101b08:	e8 2f e8 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b10:	8b 40 38             	mov    0x38(%eax),%eax
  101b13:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b17:	c7 04 24 5c 62 10 00 	movl   $0x10625c,(%esp)
  101b1e:	e8 19 e8 ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b23:	8b 45 08             	mov    0x8(%ebp),%eax
  101b26:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b2a:	0f b7 c0             	movzwl %ax,%eax
  101b2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b31:	c7 04 24 6b 62 10 00 	movl   $0x10626b,(%esp)
  101b38:	e8 ff e7 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b40:	8b 40 40             	mov    0x40(%eax),%eax
  101b43:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b47:	c7 04 24 7e 62 10 00 	movl   $0x10627e,(%esp)
  101b4e:	e8 e9 e7 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b5a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b61:	eb 3e                	jmp    101ba1 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b63:	8b 45 08             	mov    0x8(%ebp),%eax
  101b66:	8b 50 40             	mov    0x40(%eax),%edx
  101b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b6c:	21 d0                	and    %edx,%eax
  101b6e:	85 c0                	test   %eax,%eax
  101b70:	74 28                	je     101b9a <print_trapframe+0x157>
  101b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b75:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b7c:	85 c0                	test   %eax,%eax
  101b7e:	74 1a                	je     101b9a <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b83:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8e:	c7 04 24 8d 62 10 00 	movl   $0x10628d,(%esp)
  101b95:	e8 a2 e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b9a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b9e:	d1 65 f0             	shll   -0x10(%ebp)
  101ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ba4:	83 f8 17             	cmp    $0x17,%eax
  101ba7:	76 ba                	jbe    101b63 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bac:	8b 40 40             	mov    0x40(%eax),%eax
  101baf:	25 00 30 00 00       	and    $0x3000,%eax
  101bb4:	c1 e8 0c             	shr    $0xc,%eax
  101bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbb:	c7 04 24 91 62 10 00 	movl   $0x106291,(%esp)
  101bc2:	e8 75 e7 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  101bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bca:	89 04 24             	mov    %eax,(%esp)
  101bcd:	e8 5b fe ff ff       	call   101a2d <trap_in_kernel>
  101bd2:	85 c0                	test   %eax,%eax
  101bd4:	75 30                	jne    101c06 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd9:	8b 40 44             	mov    0x44(%eax),%eax
  101bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be0:	c7 04 24 9a 62 10 00 	movl   $0x10629a,(%esp)
  101be7:	e8 50 e7 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101bec:	8b 45 08             	mov    0x8(%ebp),%eax
  101bef:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bf3:	0f b7 c0             	movzwl %ax,%eax
  101bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfa:	c7 04 24 a9 62 10 00 	movl   $0x1062a9,(%esp)
  101c01:	e8 36 e7 ff ff       	call   10033c <cprintf>
    }
}
  101c06:	c9                   	leave  
  101c07:	c3                   	ret    

00101c08 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c08:	55                   	push   %ebp
  101c09:	89 e5                	mov    %esp,%ebp
  101c0b:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c11:	8b 00                	mov    (%eax),%eax
  101c13:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c17:	c7 04 24 bc 62 10 00 	movl   $0x1062bc,(%esp)
  101c1e:	e8 19 e7 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c23:	8b 45 08             	mov    0x8(%ebp),%eax
  101c26:	8b 40 04             	mov    0x4(%eax),%eax
  101c29:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c2d:	c7 04 24 cb 62 10 00 	movl   $0x1062cb,(%esp)
  101c34:	e8 03 e7 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c39:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3c:	8b 40 08             	mov    0x8(%eax),%eax
  101c3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c43:	c7 04 24 da 62 10 00 	movl   $0x1062da,(%esp)
  101c4a:	e8 ed e6 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c52:	8b 40 0c             	mov    0xc(%eax),%eax
  101c55:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c59:	c7 04 24 e9 62 10 00 	movl   $0x1062e9,(%esp)
  101c60:	e8 d7 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c65:	8b 45 08             	mov    0x8(%ebp),%eax
  101c68:	8b 40 10             	mov    0x10(%eax),%eax
  101c6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c6f:	c7 04 24 f8 62 10 00 	movl   $0x1062f8,(%esp)
  101c76:	e8 c1 e6 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7e:	8b 40 14             	mov    0x14(%eax),%eax
  101c81:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c85:	c7 04 24 07 63 10 00 	movl   $0x106307,(%esp)
  101c8c:	e8 ab e6 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c91:	8b 45 08             	mov    0x8(%ebp),%eax
  101c94:	8b 40 18             	mov    0x18(%eax),%eax
  101c97:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9b:	c7 04 24 16 63 10 00 	movl   $0x106316,(%esp)
  101ca2:	e8 95 e6 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  101caa:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cad:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb1:	c7 04 24 25 63 10 00 	movl   $0x106325,(%esp)
  101cb8:	e8 7f e6 ff ff       	call   10033c <cprintf>
}
  101cbd:	c9                   	leave  
  101cbe:	c3                   	ret    

00101cbf <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cbf:	55                   	push   %ebp
  101cc0:	89 e5                	mov    %esp,%ebp
  101cc2:	83 ec 28             	sub    $0x28,%esp
    char c;
    static int ticks_time;
    switch (tf->tf_trapno) {
  101cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc8:	8b 40 30             	mov    0x30(%eax),%eax
  101ccb:	83 f8 2f             	cmp    $0x2f,%eax
  101cce:	77 21                	ja     101cf1 <trap_dispatch+0x32>
  101cd0:	83 f8 2e             	cmp    $0x2e,%eax
  101cd3:	0f 83 0b 01 00 00    	jae    101de4 <trap_dispatch+0x125>
  101cd9:	83 f8 21             	cmp    $0x21,%eax
  101cdc:	0f 84 88 00 00 00    	je     101d6a <trap_dispatch+0xab>
  101ce2:	83 f8 24             	cmp    $0x24,%eax
  101ce5:	74 5d                	je     101d44 <trap_dispatch+0x85>
  101ce7:	83 f8 20             	cmp    $0x20,%eax
  101cea:	74 16                	je     101d02 <trap_dispatch+0x43>
  101cec:	e9 bb 00 00 00       	jmp    101dac <trap_dispatch+0xed>
  101cf1:	83 e8 78             	sub    $0x78,%eax
  101cf4:	83 f8 01             	cmp    $0x1,%eax
  101cf7:	0f 87 af 00 00 00    	ja     101dac <trap_dispatch+0xed>
  101cfd:	e9 8e 00 00 00       	jmp    101d90 <trap_dispatch+0xd1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks_time++;
  101d02:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  101d07:	83 c0 01             	add    $0x1,%eax
  101d0a:	a3 c0 88 11 00       	mov    %eax,0x1188c0
	    if (ticks_time % TICK_NUM == 0)
  101d0f:	8b 0d c0 88 11 00    	mov    0x1188c0,%ecx
  101d15:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d1a:	89 c8                	mov    %ecx,%eax
  101d1c:	f7 ea                	imul   %edx
  101d1e:	c1 fa 05             	sar    $0x5,%edx
  101d21:	89 c8                	mov    %ecx,%eax
  101d23:	c1 f8 1f             	sar    $0x1f,%eax
  101d26:	29 c2                	sub    %eax,%edx
  101d28:	89 d0                	mov    %edx,%eax
  101d2a:	6b c0 64             	imul   $0x64,%eax,%eax
  101d2d:	29 c1                	sub    %eax,%ecx
  101d2f:	89 c8                	mov    %ecx,%eax
  101d31:	85 c0                	test   %eax,%eax
  101d33:	75 0a                	jne    101d3f <trap_dispatch+0x80>
	        print_ticks();
  101d35:	e8 39 fb ff ff       	call   101873 <print_ticks>
        break;
  101d3a:	e9 a6 00 00 00       	jmp    101de5 <trap_dispatch+0x126>
  101d3f:	e9 a1 00 00 00       	jmp    101de5 <trap_dispatch+0x126>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d44:	e8 ee f8 ff ff       	call   101637 <cons_getc>
  101d49:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d4c:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d50:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d54:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d58:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d5c:	c7 04 24 34 63 10 00 	movl   $0x106334,(%esp)
  101d63:	e8 d4 e5 ff ff       	call   10033c <cprintf>
        break;
  101d68:	eb 7b                	jmp    101de5 <trap_dispatch+0x126>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d6a:	e8 c8 f8 ff ff       	call   101637 <cons_getc>
  101d6f:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d72:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d76:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d7a:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d82:	c7 04 24 46 63 10 00 	movl   $0x106346,(%esp)
  101d89:	e8 ae e5 ff ff       	call   10033c <cprintf>
        break;
  101d8e:	eb 55                	jmp    101de5 <trap_dispatch+0x126>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d90:	c7 44 24 08 55 63 10 	movl   $0x106355,0x8(%esp)
  101d97:	00 
  101d98:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  101d9f:	00 
  101da0:	c7 04 24 65 63 10 00 	movl   $0x106365,(%esp)
  101da7:	e8 1d ef ff ff       	call   100cc9 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101dac:	8b 45 08             	mov    0x8(%ebp),%eax
  101daf:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101db3:	0f b7 c0             	movzwl %ax,%eax
  101db6:	83 e0 03             	and    $0x3,%eax
  101db9:	85 c0                	test   %eax,%eax
  101dbb:	75 28                	jne    101de5 <trap_dispatch+0x126>
            print_trapframe(tf);
  101dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc0:	89 04 24             	mov    %eax,(%esp)
  101dc3:	e8 7b fc ff ff       	call   101a43 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101dc8:	c7 44 24 08 76 63 10 	movl   $0x106376,0x8(%esp)
  101dcf:	00 
  101dd0:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  101dd7:	00 
  101dd8:	c7 04 24 65 63 10 00 	movl   $0x106365,(%esp)
  101ddf:	e8 e5 ee ff ff       	call   100cc9 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101de4:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101de5:	c9                   	leave  
  101de6:	c3                   	ret    

00101de7 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101de7:	55                   	push   %ebp
  101de8:	89 e5                	mov    %esp,%ebp
  101dea:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101ded:	8b 45 08             	mov    0x8(%ebp),%eax
  101df0:	89 04 24             	mov    %eax,(%esp)
  101df3:	e8 c7 fe ff ff       	call   101cbf <trap_dispatch>
}
  101df8:	c9                   	leave  
  101df9:	c3                   	ret    

00101dfa <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101dfa:	1e                   	push   %ds
    pushl %es
  101dfb:	06                   	push   %es
    pushl %fs
  101dfc:	0f a0                	push   %fs
    pushl %gs
  101dfe:	0f a8                	push   %gs
    pushal
  101e00:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e01:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e06:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e08:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e0a:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e0b:	e8 d7 ff ff ff       	call   101de7 <trap>

    # pop the pushed stack pointer
    popl %esp
  101e10:	5c                   	pop    %esp

00101e11 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e11:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e12:	0f a9                	pop    %gs
    popl %fs
  101e14:	0f a1                	pop    %fs
    popl %es
  101e16:	07                   	pop    %es
    popl %ds
  101e17:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e18:	83 c4 08             	add    $0x8,%esp
    iret
  101e1b:	cf                   	iret   

00101e1c <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e1c:	6a 00                	push   $0x0
  pushl $0
  101e1e:	6a 00                	push   $0x0
  jmp __alltraps
  101e20:	e9 d5 ff ff ff       	jmp    101dfa <__alltraps>

00101e25 <vector1>:
.globl vector1
vector1:
  pushl $0
  101e25:	6a 00                	push   $0x0
  pushl $1
  101e27:	6a 01                	push   $0x1
  jmp __alltraps
  101e29:	e9 cc ff ff ff       	jmp    101dfa <__alltraps>

00101e2e <vector2>:
.globl vector2
vector2:
  pushl $0
  101e2e:	6a 00                	push   $0x0
  pushl $2
  101e30:	6a 02                	push   $0x2
  jmp __alltraps
  101e32:	e9 c3 ff ff ff       	jmp    101dfa <__alltraps>

00101e37 <vector3>:
.globl vector3
vector3:
  pushl $0
  101e37:	6a 00                	push   $0x0
  pushl $3
  101e39:	6a 03                	push   $0x3
  jmp __alltraps
  101e3b:	e9 ba ff ff ff       	jmp    101dfa <__alltraps>

00101e40 <vector4>:
.globl vector4
vector4:
  pushl $0
  101e40:	6a 00                	push   $0x0
  pushl $4
  101e42:	6a 04                	push   $0x4
  jmp __alltraps
  101e44:	e9 b1 ff ff ff       	jmp    101dfa <__alltraps>

00101e49 <vector5>:
.globl vector5
vector5:
  pushl $0
  101e49:	6a 00                	push   $0x0
  pushl $5
  101e4b:	6a 05                	push   $0x5
  jmp __alltraps
  101e4d:	e9 a8 ff ff ff       	jmp    101dfa <__alltraps>

00101e52 <vector6>:
.globl vector6
vector6:
  pushl $0
  101e52:	6a 00                	push   $0x0
  pushl $6
  101e54:	6a 06                	push   $0x6
  jmp __alltraps
  101e56:	e9 9f ff ff ff       	jmp    101dfa <__alltraps>

00101e5b <vector7>:
.globl vector7
vector7:
  pushl $0
  101e5b:	6a 00                	push   $0x0
  pushl $7
  101e5d:	6a 07                	push   $0x7
  jmp __alltraps
  101e5f:	e9 96 ff ff ff       	jmp    101dfa <__alltraps>

00101e64 <vector8>:
.globl vector8
vector8:
  pushl $8
  101e64:	6a 08                	push   $0x8
  jmp __alltraps
  101e66:	e9 8f ff ff ff       	jmp    101dfa <__alltraps>

00101e6b <vector9>:
.globl vector9
vector9:
  pushl $9
  101e6b:	6a 09                	push   $0x9
  jmp __alltraps
  101e6d:	e9 88 ff ff ff       	jmp    101dfa <__alltraps>

00101e72 <vector10>:
.globl vector10
vector10:
  pushl $10
  101e72:	6a 0a                	push   $0xa
  jmp __alltraps
  101e74:	e9 81 ff ff ff       	jmp    101dfa <__alltraps>

00101e79 <vector11>:
.globl vector11
vector11:
  pushl $11
  101e79:	6a 0b                	push   $0xb
  jmp __alltraps
  101e7b:	e9 7a ff ff ff       	jmp    101dfa <__alltraps>

00101e80 <vector12>:
.globl vector12
vector12:
  pushl $12
  101e80:	6a 0c                	push   $0xc
  jmp __alltraps
  101e82:	e9 73 ff ff ff       	jmp    101dfa <__alltraps>

00101e87 <vector13>:
.globl vector13
vector13:
  pushl $13
  101e87:	6a 0d                	push   $0xd
  jmp __alltraps
  101e89:	e9 6c ff ff ff       	jmp    101dfa <__alltraps>

00101e8e <vector14>:
.globl vector14
vector14:
  pushl $14
  101e8e:	6a 0e                	push   $0xe
  jmp __alltraps
  101e90:	e9 65 ff ff ff       	jmp    101dfa <__alltraps>

00101e95 <vector15>:
.globl vector15
vector15:
  pushl $0
  101e95:	6a 00                	push   $0x0
  pushl $15
  101e97:	6a 0f                	push   $0xf
  jmp __alltraps
  101e99:	e9 5c ff ff ff       	jmp    101dfa <__alltraps>

00101e9e <vector16>:
.globl vector16
vector16:
  pushl $0
  101e9e:	6a 00                	push   $0x0
  pushl $16
  101ea0:	6a 10                	push   $0x10
  jmp __alltraps
  101ea2:	e9 53 ff ff ff       	jmp    101dfa <__alltraps>

00101ea7 <vector17>:
.globl vector17
vector17:
  pushl $17
  101ea7:	6a 11                	push   $0x11
  jmp __alltraps
  101ea9:	e9 4c ff ff ff       	jmp    101dfa <__alltraps>

00101eae <vector18>:
.globl vector18
vector18:
  pushl $0
  101eae:	6a 00                	push   $0x0
  pushl $18
  101eb0:	6a 12                	push   $0x12
  jmp __alltraps
  101eb2:	e9 43 ff ff ff       	jmp    101dfa <__alltraps>

00101eb7 <vector19>:
.globl vector19
vector19:
  pushl $0
  101eb7:	6a 00                	push   $0x0
  pushl $19
  101eb9:	6a 13                	push   $0x13
  jmp __alltraps
  101ebb:	e9 3a ff ff ff       	jmp    101dfa <__alltraps>

00101ec0 <vector20>:
.globl vector20
vector20:
  pushl $0
  101ec0:	6a 00                	push   $0x0
  pushl $20
  101ec2:	6a 14                	push   $0x14
  jmp __alltraps
  101ec4:	e9 31 ff ff ff       	jmp    101dfa <__alltraps>

00101ec9 <vector21>:
.globl vector21
vector21:
  pushl $0
  101ec9:	6a 00                	push   $0x0
  pushl $21
  101ecb:	6a 15                	push   $0x15
  jmp __alltraps
  101ecd:	e9 28 ff ff ff       	jmp    101dfa <__alltraps>

00101ed2 <vector22>:
.globl vector22
vector22:
  pushl $0
  101ed2:	6a 00                	push   $0x0
  pushl $22
  101ed4:	6a 16                	push   $0x16
  jmp __alltraps
  101ed6:	e9 1f ff ff ff       	jmp    101dfa <__alltraps>

00101edb <vector23>:
.globl vector23
vector23:
  pushl $0
  101edb:	6a 00                	push   $0x0
  pushl $23
  101edd:	6a 17                	push   $0x17
  jmp __alltraps
  101edf:	e9 16 ff ff ff       	jmp    101dfa <__alltraps>

00101ee4 <vector24>:
.globl vector24
vector24:
  pushl $0
  101ee4:	6a 00                	push   $0x0
  pushl $24
  101ee6:	6a 18                	push   $0x18
  jmp __alltraps
  101ee8:	e9 0d ff ff ff       	jmp    101dfa <__alltraps>

00101eed <vector25>:
.globl vector25
vector25:
  pushl $0
  101eed:	6a 00                	push   $0x0
  pushl $25
  101eef:	6a 19                	push   $0x19
  jmp __alltraps
  101ef1:	e9 04 ff ff ff       	jmp    101dfa <__alltraps>

00101ef6 <vector26>:
.globl vector26
vector26:
  pushl $0
  101ef6:	6a 00                	push   $0x0
  pushl $26
  101ef8:	6a 1a                	push   $0x1a
  jmp __alltraps
  101efa:	e9 fb fe ff ff       	jmp    101dfa <__alltraps>

00101eff <vector27>:
.globl vector27
vector27:
  pushl $0
  101eff:	6a 00                	push   $0x0
  pushl $27
  101f01:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f03:	e9 f2 fe ff ff       	jmp    101dfa <__alltraps>

00101f08 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f08:	6a 00                	push   $0x0
  pushl $28
  101f0a:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f0c:	e9 e9 fe ff ff       	jmp    101dfa <__alltraps>

00101f11 <vector29>:
.globl vector29
vector29:
  pushl $0
  101f11:	6a 00                	push   $0x0
  pushl $29
  101f13:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f15:	e9 e0 fe ff ff       	jmp    101dfa <__alltraps>

00101f1a <vector30>:
.globl vector30
vector30:
  pushl $0
  101f1a:	6a 00                	push   $0x0
  pushl $30
  101f1c:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f1e:	e9 d7 fe ff ff       	jmp    101dfa <__alltraps>

00101f23 <vector31>:
.globl vector31
vector31:
  pushl $0
  101f23:	6a 00                	push   $0x0
  pushl $31
  101f25:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f27:	e9 ce fe ff ff       	jmp    101dfa <__alltraps>

00101f2c <vector32>:
.globl vector32
vector32:
  pushl $0
  101f2c:	6a 00                	push   $0x0
  pushl $32
  101f2e:	6a 20                	push   $0x20
  jmp __alltraps
  101f30:	e9 c5 fe ff ff       	jmp    101dfa <__alltraps>

00101f35 <vector33>:
.globl vector33
vector33:
  pushl $0
  101f35:	6a 00                	push   $0x0
  pushl $33
  101f37:	6a 21                	push   $0x21
  jmp __alltraps
  101f39:	e9 bc fe ff ff       	jmp    101dfa <__alltraps>

00101f3e <vector34>:
.globl vector34
vector34:
  pushl $0
  101f3e:	6a 00                	push   $0x0
  pushl $34
  101f40:	6a 22                	push   $0x22
  jmp __alltraps
  101f42:	e9 b3 fe ff ff       	jmp    101dfa <__alltraps>

00101f47 <vector35>:
.globl vector35
vector35:
  pushl $0
  101f47:	6a 00                	push   $0x0
  pushl $35
  101f49:	6a 23                	push   $0x23
  jmp __alltraps
  101f4b:	e9 aa fe ff ff       	jmp    101dfa <__alltraps>

00101f50 <vector36>:
.globl vector36
vector36:
  pushl $0
  101f50:	6a 00                	push   $0x0
  pushl $36
  101f52:	6a 24                	push   $0x24
  jmp __alltraps
  101f54:	e9 a1 fe ff ff       	jmp    101dfa <__alltraps>

00101f59 <vector37>:
.globl vector37
vector37:
  pushl $0
  101f59:	6a 00                	push   $0x0
  pushl $37
  101f5b:	6a 25                	push   $0x25
  jmp __alltraps
  101f5d:	e9 98 fe ff ff       	jmp    101dfa <__alltraps>

00101f62 <vector38>:
.globl vector38
vector38:
  pushl $0
  101f62:	6a 00                	push   $0x0
  pushl $38
  101f64:	6a 26                	push   $0x26
  jmp __alltraps
  101f66:	e9 8f fe ff ff       	jmp    101dfa <__alltraps>

00101f6b <vector39>:
.globl vector39
vector39:
  pushl $0
  101f6b:	6a 00                	push   $0x0
  pushl $39
  101f6d:	6a 27                	push   $0x27
  jmp __alltraps
  101f6f:	e9 86 fe ff ff       	jmp    101dfa <__alltraps>

00101f74 <vector40>:
.globl vector40
vector40:
  pushl $0
  101f74:	6a 00                	push   $0x0
  pushl $40
  101f76:	6a 28                	push   $0x28
  jmp __alltraps
  101f78:	e9 7d fe ff ff       	jmp    101dfa <__alltraps>

00101f7d <vector41>:
.globl vector41
vector41:
  pushl $0
  101f7d:	6a 00                	push   $0x0
  pushl $41
  101f7f:	6a 29                	push   $0x29
  jmp __alltraps
  101f81:	e9 74 fe ff ff       	jmp    101dfa <__alltraps>

00101f86 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f86:	6a 00                	push   $0x0
  pushl $42
  101f88:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f8a:	e9 6b fe ff ff       	jmp    101dfa <__alltraps>

00101f8f <vector43>:
.globl vector43
vector43:
  pushl $0
  101f8f:	6a 00                	push   $0x0
  pushl $43
  101f91:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f93:	e9 62 fe ff ff       	jmp    101dfa <__alltraps>

00101f98 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f98:	6a 00                	push   $0x0
  pushl $44
  101f9a:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f9c:	e9 59 fe ff ff       	jmp    101dfa <__alltraps>

00101fa1 <vector45>:
.globl vector45
vector45:
  pushl $0
  101fa1:	6a 00                	push   $0x0
  pushl $45
  101fa3:	6a 2d                	push   $0x2d
  jmp __alltraps
  101fa5:	e9 50 fe ff ff       	jmp    101dfa <__alltraps>

00101faa <vector46>:
.globl vector46
vector46:
  pushl $0
  101faa:	6a 00                	push   $0x0
  pushl $46
  101fac:	6a 2e                	push   $0x2e
  jmp __alltraps
  101fae:	e9 47 fe ff ff       	jmp    101dfa <__alltraps>

00101fb3 <vector47>:
.globl vector47
vector47:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $47
  101fb5:	6a 2f                	push   $0x2f
  jmp __alltraps
  101fb7:	e9 3e fe ff ff       	jmp    101dfa <__alltraps>

00101fbc <vector48>:
.globl vector48
vector48:
  pushl $0
  101fbc:	6a 00                	push   $0x0
  pushl $48
  101fbe:	6a 30                	push   $0x30
  jmp __alltraps
  101fc0:	e9 35 fe ff ff       	jmp    101dfa <__alltraps>

00101fc5 <vector49>:
.globl vector49
vector49:
  pushl $0
  101fc5:	6a 00                	push   $0x0
  pushl $49
  101fc7:	6a 31                	push   $0x31
  jmp __alltraps
  101fc9:	e9 2c fe ff ff       	jmp    101dfa <__alltraps>

00101fce <vector50>:
.globl vector50
vector50:
  pushl $0
  101fce:	6a 00                	push   $0x0
  pushl $50
  101fd0:	6a 32                	push   $0x32
  jmp __alltraps
  101fd2:	e9 23 fe ff ff       	jmp    101dfa <__alltraps>

00101fd7 <vector51>:
.globl vector51
vector51:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $51
  101fd9:	6a 33                	push   $0x33
  jmp __alltraps
  101fdb:	e9 1a fe ff ff       	jmp    101dfa <__alltraps>

00101fe0 <vector52>:
.globl vector52
vector52:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $52
  101fe2:	6a 34                	push   $0x34
  jmp __alltraps
  101fe4:	e9 11 fe ff ff       	jmp    101dfa <__alltraps>

00101fe9 <vector53>:
.globl vector53
vector53:
  pushl $0
  101fe9:	6a 00                	push   $0x0
  pushl $53
  101feb:	6a 35                	push   $0x35
  jmp __alltraps
  101fed:	e9 08 fe ff ff       	jmp    101dfa <__alltraps>

00101ff2 <vector54>:
.globl vector54
vector54:
  pushl $0
  101ff2:	6a 00                	push   $0x0
  pushl $54
  101ff4:	6a 36                	push   $0x36
  jmp __alltraps
  101ff6:	e9 ff fd ff ff       	jmp    101dfa <__alltraps>

00101ffb <vector55>:
.globl vector55
vector55:
  pushl $0
  101ffb:	6a 00                	push   $0x0
  pushl $55
  101ffd:	6a 37                	push   $0x37
  jmp __alltraps
  101fff:	e9 f6 fd ff ff       	jmp    101dfa <__alltraps>

00102004 <vector56>:
.globl vector56
vector56:
  pushl $0
  102004:	6a 00                	push   $0x0
  pushl $56
  102006:	6a 38                	push   $0x38
  jmp __alltraps
  102008:	e9 ed fd ff ff       	jmp    101dfa <__alltraps>

0010200d <vector57>:
.globl vector57
vector57:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $57
  10200f:	6a 39                	push   $0x39
  jmp __alltraps
  102011:	e9 e4 fd ff ff       	jmp    101dfa <__alltraps>

00102016 <vector58>:
.globl vector58
vector58:
  pushl $0
  102016:	6a 00                	push   $0x0
  pushl $58
  102018:	6a 3a                	push   $0x3a
  jmp __alltraps
  10201a:	e9 db fd ff ff       	jmp    101dfa <__alltraps>

0010201f <vector59>:
.globl vector59
vector59:
  pushl $0
  10201f:	6a 00                	push   $0x0
  pushl $59
  102021:	6a 3b                	push   $0x3b
  jmp __alltraps
  102023:	e9 d2 fd ff ff       	jmp    101dfa <__alltraps>

00102028 <vector60>:
.globl vector60
vector60:
  pushl $0
  102028:	6a 00                	push   $0x0
  pushl $60
  10202a:	6a 3c                	push   $0x3c
  jmp __alltraps
  10202c:	e9 c9 fd ff ff       	jmp    101dfa <__alltraps>

00102031 <vector61>:
.globl vector61
vector61:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $61
  102033:	6a 3d                	push   $0x3d
  jmp __alltraps
  102035:	e9 c0 fd ff ff       	jmp    101dfa <__alltraps>

0010203a <vector62>:
.globl vector62
vector62:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $62
  10203c:	6a 3e                	push   $0x3e
  jmp __alltraps
  10203e:	e9 b7 fd ff ff       	jmp    101dfa <__alltraps>

00102043 <vector63>:
.globl vector63
vector63:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $63
  102045:	6a 3f                	push   $0x3f
  jmp __alltraps
  102047:	e9 ae fd ff ff       	jmp    101dfa <__alltraps>

0010204c <vector64>:
.globl vector64
vector64:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $64
  10204e:	6a 40                	push   $0x40
  jmp __alltraps
  102050:	e9 a5 fd ff ff       	jmp    101dfa <__alltraps>

00102055 <vector65>:
.globl vector65
vector65:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $65
  102057:	6a 41                	push   $0x41
  jmp __alltraps
  102059:	e9 9c fd ff ff       	jmp    101dfa <__alltraps>

0010205e <vector66>:
.globl vector66
vector66:
  pushl $0
  10205e:	6a 00                	push   $0x0
  pushl $66
  102060:	6a 42                	push   $0x42
  jmp __alltraps
  102062:	e9 93 fd ff ff       	jmp    101dfa <__alltraps>

00102067 <vector67>:
.globl vector67
vector67:
  pushl $0
  102067:	6a 00                	push   $0x0
  pushl $67
  102069:	6a 43                	push   $0x43
  jmp __alltraps
  10206b:	e9 8a fd ff ff       	jmp    101dfa <__alltraps>

00102070 <vector68>:
.globl vector68
vector68:
  pushl $0
  102070:	6a 00                	push   $0x0
  pushl $68
  102072:	6a 44                	push   $0x44
  jmp __alltraps
  102074:	e9 81 fd ff ff       	jmp    101dfa <__alltraps>

00102079 <vector69>:
.globl vector69
vector69:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $69
  10207b:	6a 45                	push   $0x45
  jmp __alltraps
  10207d:	e9 78 fd ff ff       	jmp    101dfa <__alltraps>

00102082 <vector70>:
.globl vector70
vector70:
  pushl $0
  102082:	6a 00                	push   $0x0
  pushl $70
  102084:	6a 46                	push   $0x46
  jmp __alltraps
  102086:	e9 6f fd ff ff       	jmp    101dfa <__alltraps>

0010208b <vector71>:
.globl vector71
vector71:
  pushl $0
  10208b:	6a 00                	push   $0x0
  pushl $71
  10208d:	6a 47                	push   $0x47
  jmp __alltraps
  10208f:	e9 66 fd ff ff       	jmp    101dfa <__alltraps>

00102094 <vector72>:
.globl vector72
vector72:
  pushl $0
  102094:	6a 00                	push   $0x0
  pushl $72
  102096:	6a 48                	push   $0x48
  jmp __alltraps
  102098:	e9 5d fd ff ff       	jmp    101dfa <__alltraps>

0010209d <vector73>:
.globl vector73
vector73:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $73
  10209f:	6a 49                	push   $0x49
  jmp __alltraps
  1020a1:	e9 54 fd ff ff       	jmp    101dfa <__alltraps>

001020a6 <vector74>:
.globl vector74
vector74:
  pushl $0
  1020a6:	6a 00                	push   $0x0
  pushl $74
  1020a8:	6a 4a                	push   $0x4a
  jmp __alltraps
  1020aa:	e9 4b fd ff ff       	jmp    101dfa <__alltraps>

001020af <vector75>:
.globl vector75
vector75:
  pushl $0
  1020af:	6a 00                	push   $0x0
  pushl $75
  1020b1:	6a 4b                	push   $0x4b
  jmp __alltraps
  1020b3:	e9 42 fd ff ff       	jmp    101dfa <__alltraps>

001020b8 <vector76>:
.globl vector76
vector76:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $76
  1020ba:	6a 4c                	push   $0x4c
  jmp __alltraps
  1020bc:	e9 39 fd ff ff       	jmp    101dfa <__alltraps>

001020c1 <vector77>:
.globl vector77
vector77:
  pushl $0
  1020c1:	6a 00                	push   $0x0
  pushl $77
  1020c3:	6a 4d                	push   $0x4d
  jmp __alltraps
  1020c5:	e9 30 fd ff ff       	jmp    101dfa <__alltraps>

001020ca <vector78>:
.globl vector78
vector78:
  pushl $0
  1020ca:	6a 00                	push   $0x0
  pushl $78
  1020cc:	6a 4e                	push   $0x4e
  jmp __alltraps
  1020ce:	e9 27 fd ff ff       	jmp    101dfa <__alltraps>

001020d3 <vector79>:
.globl vector79
vector79:
  pushl $0
  1020d3:	6a 00                	push   $0x0
  pushl $79
  1020d5:	6a 4f                	push   $0x4f
  jmp __alltraps
  1020d7:	e9 1e fd ff ff       	jmp    101dfa <__alltraps>

001020dc <vector80>:
.globl vector80
vector80:
  pushl $0
  1020dc:	6a 00                	push   $0x0
  pushl $80
  1020de:	6a 50                	push   $0x50
  jmp __alltraps
  1020e0:	e9 15 fd ff ff       	jmp    101dfa <__alltraps>

001020e5 <vector81>:
.globl vector81
vector81:
  pushl $0
  1020e5:	6a 00                	push   $0x0
  pushl $81
  1020e7:	6a 51                	push   $0x51
  jmp __alltraps
  1020e9:	e9 0c fd ff ff       	jmp    101dfa <__alltraps>

001020ee <vector82>:
.globl vector82
vector82:
  pushl $0
  1020ee:	6a 00                	push   $0x0
  pushl $82
  1020f0:	6a 52                	push   $0x52
  jmp __alltraps
  1020f2:	e9 03 fd ff ff       	jmp    101dfa <__alltraps>

001020f7 <vector83>:
.globl vector83
vector83:
  pushl $0
  1020f7:	6a 00                	push   $0x0
  pushl $83
  1020f9:	6a 53                	push   $0x53
  jmp __alltraps
  1020fb:	e9 fa fc ff ff       	jmp    101dfa <__alltraps>

00102100 <vector84>:
.globl vector84
vector84:
  pushl $0
  102100:	6a 00                	push   $0x0
  pushl $84
  102102:	6a 54                	push   $0x54
  jmp __alltraps
  102104:	e9 f1 fc ff ff       	jmp    101dfa <__alltraps>

00102109 <vector85>:
.globl vector85
vector85:
  pushl $0
  102109:	6a 00                	push   $0x0
  pushl $85
  10210b:	6a 55                	push   $0x55
  jmp __alltraps
  10210d:	e9 e8 fc ff ff       	jmp    101dfa <__alltraps>

00102112 <vector86>:
.globl vector86
vector86:
  pushl $0
  102112:	6a 00                	push   $0x0
  pushl $86
  102114:	6a 56                	push   $0x56
  jmp __alltraps
  102116:	e9 df fc ff ff       	jmp    101dfa <__alltraps>

0010211b <vector87>:
.globl vector87
vector87:
  pushl $0
  10211b:	6a 00                	push   $0x0
  pushl $87
  10211d:	6a 57                	push   $0x57
  jmp __alltraps
  10211f:	e9 d6 fc ff ff       	jmp    101dfa <__alltraps>

00102124 <vector88>:
.globl vector88
vector88:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $88
  102126:	6a 58                	push   $0x58
  jmp __alltraps
  102128:	e9 cd fc ff ff       	jmp    101dfa <__alltraps>

0010212d <vector89>:
.globl vector89
vector89:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $89
  10212f:	6a 59                	push   $0x59
  jmp __alltraps
  102131:	e9 c4 fc ff ff       	jmp    101dfa <__alltraps>

00102136 <vector90>:
.globl vector90
vector90:
  pushl $0
  102136:	6a 00                	push   $0x0
  pushl $90
  102138:	6a 5a                	push   $0x5a
  jmp __alltraps
  10213a:	e9 bb fc ff ff       	jmp    101dfa <__alltraps>

0010213f <vector91>:
.globl vector91
vector91:
  pushl $0
  10213f:	6a 00                	push   $0x0
  pushl $91
  102141:	6a 5b                	push   $0x5b
  jmp __alltraps
  102143:	e9 b2 fc ff ff       	jmp    101dfa <__alltraps>

00102148 <vector92>:
.globl vector92
vector92:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $92
  10214a:	6a 5c                	push   $0x5c
  jmp __alltraps
  10214c:	e9 a9 fc ff ff       	jmp    101dfa <__alltraps>

00102151 <vector93>:
.globl vector93
vector93:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $93
  102153:	6a 5d                	push   $0x5d
  jmp __alltraps
  102155:	e9 a0 fc ff ff       	jmp    101dfa <__alltraps>

0010215a <vector94>:
.globl vector94
vector94:
  pushl $0
  10215a:	6a 00                	push   $0x0
  pushl $94
  10215c:	6a 5e                	push   $0x5e
  jmp __alltraps
  10215e:	e9 97 fc ff ff       	jmp    101dfa <__alltraps>

00102163 <vector95>:
.globl vector95
vector95:
  pushl $0
  102163:	6a 00                	push   $0x0
  pushl $95
  102165:	6a 5f                	push   $0x5f
  jmp __alltraps
  102167:	e9 8e fc ff ff       	jmp    101dfa <__alltraps>

0010216c <vector96>:
.globl vector96
vector96:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $96
  10216e:	6a 60                	push   $0x60
  jmp __alltraps
  102170:	e9 85 fc ff ff       	jmp    101dfa <__alltraps>

00102175 <vector97>:
.globl vector97
vector97:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $97
  102177:	6a 61                	push   $0x61
  jmp __alltraps
  102179:	e9 7c fc ff ff       	jmp    101dfa <__alltraps>

0010217e <vector98>:
.globl vector98
vector98:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $98
  102180:	6a 62                	push   $0x62
  jmp __alltraps
  102182:	e9 73 fc ff ff       	jmp    101dfa <__alltraps>

00102187 <vector99>:
.globl vector99
vector99:
  pushl $0
  102187:	6a 00                	push   $0x0
  pushl $99
  102189:	6a 63                	push   $0x63
  jmp __alltraps
  10218b:	e9 6a fc ff ff       	jmp    101dfa <__alltraps>

00102190 <vector100>:
.globl vector100
vector100:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $100
  102192:	6a 64                	push   $0x64
  jmp __alltraps
  102194:	e9 61 fc ff ff       	jmp    101dfa <__alltraps>

00102199 <vector101>:
.globl vector101
vector101:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $101
  10219b:	6a 65                	push   $0x65
  jmp __alltraps
  10219d:	e9 58 fc ff ff       	jmp    101dfa <__alltraps>

001021a2 <vector102>:
.globl vector102
vector102:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $102
  1021a4:	6a 66                	push   $0x66
  jmp __alltraps
  1021a6:	e9 4f fc ff ff       	jmp    101dfa <__alltraps>

001021ab <vector103>:
.globl vector103
vector103:
  pushl $0
  1021ab:	6a 00                	push   $0x0
  pushl $103
  1021ad:	6a 67                	push   $0x67
  jmp __alltraps
  1021af:	e9 46 fc ff ff       	jmp    101dfa <__alltraps>

001021b4 <vector104>:
.globl vector104
vector104:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $104
  1021b6:	6a 68                	push   $0x68
  jmp __alltraps
  1021b8:	e9 3d fc ff ff       	jmp    101dfa <__alltraps>

001021bd <vector105>:
.globl vector105
vector105:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $105
  1021bf:	6a 69                	push   $0x69
  jmp __alltraps
  1021c1:	e9 34 fc ff ff       	jmp    101dfa <__alltraps>

001021c6 <vector106>:
.globl vector106
vector106:
  pushl $0
  1021c6:	6a 00                	push   $0x0
  pushl $106
  1021c8:	6a 6a                	push   $0x6a
  jmp __alltraps
  1021ca:	e9 2b fc ff ff       	jmp    101dfa <__alltraps>

001021cf <vector107>:
.globl vector107
vector107:
  pushl $0
  1021cf:	6a 00                	push   $0x0
  pushl $107
  1021d1:	6a 6b                	push   $0x6b
  jmp __alltraps
  1021d3:	e9 22 fc ff ff       	jmp    101dfa <__alltraps>

001021d8 <vector108>:
.globl vector108
vector108:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $108
  1021da:	6a 6c                	push   $0x6c
  jmp __alltraps
  1021dc:	e9 19 fc ff ff       	jmp    101dfa <__alltraps>

001021e1 <vector109>:
.globl vector109
vector109:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $109
  1021e3:	6a 6d                	push   $0x6d
  jmp __alltraps
  1021e5:	e9 10 fc ff ff       	jmp    101dfa <__alltraps>

001021ea <vector110>:
.globl vector110
vector110:
  pushl $0
  1021ea:	6a 00                	push   $0x0
  pushl $110
  1021ec:	6a 6e                	push   $0x6e
  jmp __alltraps
  1021ee:	e9 07 fc ff ff       	jmp    101dfa <__alltraps>

001021f3 <vector111>:
.globl vector111
vector111:
  pushl $0
  1021f3:	6a 00                	push   $0x0
  pushl $111
  1021f5:	6a 6f                	push   $0x6f
  jmp __alltraps
  1021f7:	e9 fe fb ff ff       	jmp    101dfa <__alltraps>

001021fc <vector112>:
.globl vector112
vector112:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $112
  1021fe:	6a 70                	push   $0x70
  jmp __alltraps
  102200:	e9 f5 fb ff ff       	jmp    101dfa <__alltraps>

00102205 <vector113>:
.globl vector113
vector113:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $113
  102207:	6a 71                	push   $0x71
  jmp __alltraps
  102209:	e9 ec fb ff ff       	jmp    101dfa <__alltraps>

0010220e <vector114>:
.globl vector114
vector114:
  pushl $0
  10220e:	6a 00                	push   $0x0
  pushl $114
  102210:	6a 72                	push   $0x72
  jmp __alltraps
  102212:	e9 e3 fb ff ff       	jmp    101dfa <__alltraps>

00102217 <vector115>:
.globl vector115
vector115:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $115
  102219:	6a 73                	push   $0x73
  jmp __alltraps
  10221b:	e9 da fb ff ff       	jmp    101dfa <__alltraps>

00102220 <vector116>:
.globl vector116
vector116:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $116
  102222:	6a 74                	push   $0x74
  jmp __alltraps
  102224:	e9 d1 fb ff ff       	jmp    101dfa <__alltraps>

00102229 <vector117>:
.globl vector117
vector117:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $117
  10222b:	6a 75                	push   $0x75
  jmp __alltraps
  10222d:	e9 c8 fb ff ff       	jmp    101dfa <__alltraps>

00102232 <vector118>:
.globl vector118
vector118:
  pushl $0
  102232:	6a 00                	push   $0x0
  pushl $118
  102234:	6a 76                	push   $0x76
  jmp __alltraps
  102236:	e9 bf fb ff ff       	jmp    101dfa <__alltraps>

0010223b <vector119>:
.globl vector119
vector119:
  pushl $0
  10223b:	6a 00                	push   $0x0
  pushl $119
  10223d:	6a 77                	push   $0x77
  jmp __alltraps
  10223f:	e9 b6 fb ff ff       	jmp    101dfa <__alltraps>

00102244 <vector120>:
.globl vector120
vector120:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $120
  102246:	6a 78                	push   $0x78
  jmp __alltraps
  102248:	e9 ad fb ff ff       	jmp    101dfa <__alltraps>

0010224d <vector121>:
.globl vector121
vector121:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $121
  10224f:	6a 79                	push   $0x79
  jmp __alltraps
  102251:	e9 a4 fb ff ff       	jmp    101dfa <__alltraps>

00102256 <vector122>:
.globl vector122
vector122:
  pushl $0
  102256:	6a 00                	push   $0x0
  pushl $122
  102258:	6a 7a                	push   $0x7a
  jmp __alltraps
  10225a:	e9 9b fb ff ff       	jmp    101dfa <__alltraps>

0010225f <vector123>:
.globl vector123
vector123:
  pushl $0
  10225f:	6a 00                	push   $0x0
  pushl $123
  102261:	6a 7b                	push   $0x7b
  jmp __alltraps
  102263:	e9 92 fb ff ff       	jmp    101dfa <__alltraps>

00102268 <vector124>:
.globl vector124
vector124:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $124
  10226a:	6a 7c                	push   $0x7c
  jmp __alltraps
  10226c:	e9 89 fb ff ff       	jmp    101dfa <__alltraps>

00102271 <vector125>:
.globl vector125
vector125:
  pushl $0
  102271:	6a 00                	push   $0x0
  pushl $125
  102273:	6a 7d                	push   $0x7d
  jmp __alltraps
  102275:	e9 80 fb ff ff       	jmp    101dfa <__alltraps>

0010227a <vector126>:
.globl vector126
vector126:
  pushl $0
  10227a:	6a 00                	push   $0x0
  pushl $126
  10227c:	6a 7e                	push   $0x7e
  jmp __alltraps
  10227e:	e9 77 fb ff ff       	jmp    101dfa <__alltraps>

00102283 <vector127>:
.globl vector127
vector127:
  pushl $0
  102283:	6a 00                	push   $0x0
  pushl $127
  102285:	6a 7f                	push   $0x7f
  jmp __alltraps
  102287:	e9 6e fb ff ff       	jmp    101dfa <__alltraps>

0010228c <vector128>:
.globl vector128
vector128:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $128
  10228e:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102293:	e9 62 fb ff ff       	jmp    101dfa <__alltraps>

00102298 <vector129>:
.globl vector129
vector129:
  pushl $0
  102298:	6a 00                	push   $0x0
  pushl $129
  10229a:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10229f:	e9 56 fb ff ff       	jmp    101dfa <__alltraps>

001022a4 <vector130>:
.globl vector130
vector130:
  pushl $0
  1022a4:	6a 00                	push   $0x0
  pushl $130
  1022a6:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1022ab:	e9 4a fb ff ff       	jmp    101dfa <__alltraps>

001022b0 <vector131>:
.globl vector131
vector131:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $131
  1022b2:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1022b7:	e9 3e fb ff ff       	jmp    101dfa <__alltraps>

001022bc <vector132>:
.globl vector132
vector132:
  pushl $0
  1022bc:	6a 00                	push   $0x0
  pushl $132
  1022be:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1022c3:	e9 32 fb ff ff       	jmp    101dfa <__alltraps>

001022c8 <vector133>:
.globl vector133
vector133:
  pushl $0
  1022c8:	6a 00                	push   $0x0
  pushl $133
  1022ca:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1022cf:	e9 26 fb ff ff       	jmp    101dfa <__alltraps>

001022d4 <vector134>:
.globl vector134
vector134:
  pushl $0
  1022d4:	6a 00                	push   $0x0
  pushl $134
  1022d6:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1022db:	e9 1a fb ff ff       	jmp    101dfa <__alltraps>

001022e0 <vector135>:
.globl vector135
vector135:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $135
  1022e2:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1022e7:	e9 0e fb ff ff       	jmp    101dfa <__alltraps>

001022ec <vector136>:
.globl vector136
vector136:
  pushl $0
  1022ec:	6a 00                	push   $0x0
  pushl $136
  1022ee:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1022f3:	e9 02 fb ff ff       	jmp    101dfa <__alltraps>

001022f8 <vector137>:
.globl vector137
vector137:
  pushl $0
  1022f8:	6a 00                	push   $0x0
  pushl $137
  1022fa:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1022ff:	e9 f6 fa ff ff       	jmp    101dfa <__alltraps>

00102304 <vector138>:
.globl vector138
vector138:
  pushl $0
  102304:	6a 00                	push   $0x0
  pushl $138
  102306:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10230b:	e9 ea fa ff ff       	jmp    101dfa <__alltraps>

00102310 <vector139>:
.globl vector139
vector139:
  pushl $0
  102310:	6a 00                	push   $0x0
  pushl $139
  102312:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102317:	e9 de fa ff ff       	jmp    101dfa <__alltraps>

0010231c <vector140>:
.globl vector140
vector140:
  pushl $0
  10231c:	6a 00                	push   $0x0
  pushl $140
  10231e:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102323:	e9 d2 fa ff ff       	jmp    101dfa <__alltraps>

00102328 <vector141>:
.globl vector141
vector141:
  pushl $0
  102328:	6a 00                	push   $0x0
  pushl $141
  10232a:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10232f:	e9 c6 fa ff ff       	jmp    101dfa <__alltraps>

00102334 <vector142>:
.globl vector142
vector142:
  pushl $0
  102334:	6a 00                	push   $0x0
  pushl $142
  102336:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10233b:	e9 ba fa ff ff       	jmp    101dfa <__alltraps>

00102340 <vector143>:
.globl vector143
vector143:
  pushl $0
  102340:	6a 00                	push   $0x0
  pushl $143
  102342:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102347:	e9 ae fa ff ff       	jmp    101dfa <__alltraps>

0010234c <vector144>:
.globl vector144
vector144:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $144
  10234e:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102353:	e9 a2 fa ff ff       	jmp    101dfa <__alltraps>

00102358 <vector145>:
.globl vector145
vector145:
  pushl $0
  102358:	6a 00                	push   $0x0
  pushl $145
  10235a:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10235f:	e9 96 fa ff ff       	jmp    101dfa <__alltraps>

00102364 <vector146>:
.globl vector146
vector146:
  pushl $0
  102364:	6a 00                	push   $0x0
  pushl $146
  102366:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10236b:	e9 8a fa ff ff       	jmp    101dfa <__alltraps>

00102370 <vector147>:
.globl vector147
vector147:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $147
  102372:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102377:	e9 7e fa ff ff       	jmp    101dfa <__alltraps>

0010237c <vector148>:
.globl vector148
vector148:
  pushl $0
  10237c:	6a 00                	push   $0x0
  pushl $148
  10237e:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102383:	e9 72 fa ff ff       	jmp    101dfa <__alltraps>

00102388 <vector149>:
.globl vector149
vector149:
  pushl $0
  102388:	6a 00                	push   $0x0
  pushl $149
  10238a:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10238f:	e9 66 fa ff ff       	jmp    101dfa <__alltraps>

00102394 <vector150>:
.globl vector150
vector150:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $150
  102396:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10239b:	e9 5a fa ff ff       	jmp    101dfa <__alltraps>

001023a0 <vector151>:
.globl vector151
vector151:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $151
  1023a2:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1023a7:	e9 4e fa ff ff       	jmp    101dfa <__alltraps>

001023ac <vector152>:
.globl vector152
vector152:
  pushl $0
  1023ac:	6a 00                	push   $0x0
  pushl $152
  1023ae:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1023b3:	e9 42 fa ff ff       	jmp    101dfa <__alltraps>

001023b8 <vector153>:
.globl vector153
vector153:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $153
  1023ba:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1023bf:	e9 36 fa ff ff       	jmp    101dfa <__alltraps>

001023c4 <vector154>:
.globl vector154
vector154:
  pushl $0
  1023c4:	6a 00                	push   $0x0
  pushl $154
  1023c6:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1023cb:	e9 2a fa ff ff       	jmp    101dfa <__alltraps>

001023d0 <vector155>:
.globl vector155
vector155:
  pushl $0
  1023d0:	6a 00                	push   $0x0
  pushl $155
  1023d2:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1023d7:	e9 1e fa ff ff       	jmp    101dfa <__alltraps>

001023dc <vector156>:
.globl vector156
vector156:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $156
  1023de:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1023e3:	e9 12 fa ff ff       	jmp    101dfa <__alltraps>

001023e8 <vector157>:
.globl vector157
vector157:
  pushl $0
  1023e8:	6a 00                	push   $0x0
  pushl $157
  1023ea:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1023ef:	e9 06 fa ff ff       	jmp    101dfa <__alltraps>

001023f4 <vector158>:
.globl vector158
vector158:
  pushl $0
  1023f4:	6a 00                	push   $0x0
  pushl $158
  1023f6:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1023fb:	e9 fa f9 ff ff       	jmp    101dfa <__alltraps>

00102400 <vector159>:
.globl vector159
vector159:
  pushl $0
  102400:	6a 00                	push   $0x0
  pushl $159
  102402:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102407:	e9 ee f9 ff ff       	jmp    101dfa <__alltraps>

0010240c <vector160>:
.globl vector160
vector160:
  pushl $0
  10240c:	6a 00                	push   $0x0
  pushl $160
  10240e:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102413:	e9 e2 f9 ff ff       	jmp    101dfa <__alltraps>

00102418 <vector161>:
.globl vector161
vector161:
  pushl $0
  102418:	6a 00                	push   $0x0
  pushl $161
  10241a:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10241f:	e9 d6 f9 ff ff       	jmp    101dfa <__alltraps>

00102424 <vector162>:
.globl vector162
vector162:
  pushl $0
  102424:	6a 00                	push   $0x0
  pushl $162
  102426:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10242b:	e9 ca f9 ff ff       	jmp    101dfa <__alltraps>

00102430 <vector163>:
.globl vector163
vector163:
  pushl $0
  102430:	6a 00                	push   $0x0
  pushl $163
  102432:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102437:	e9 be f9 ff ff       	jmp    101dfa <__alltraps>

0010243c <vector164>:
.globl vector164
vector164:
  pushl $0
  10243c:	6a 00                	push   $0x0
  pushl $164
  10243e:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102443:	e9 b2 f9 ff ff       	jmp    101dfa <__alltraps>

00102448 <vector165>:
.globl vector165
vector165:
  pushl $0
  102448:	6a 00                	push   $0x0
  pushl $165
  10244a:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10244f:	e9 a6 f9 ff ff       	jmp    101dfa <__alltraps>

00102454 <vector166>:
.globl vector166
vector166:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $166
  102456:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10245b:	e9 9a f9 ff ff       	jmp    101dfa <__alltraps>

00102460 <vector167>:
.globl vector167
vector167:
  pushl $0
  102460:	6a 00                	push   $0x0
  pushl $167
  102462:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102467:	e9 8e f9 ff ff       	jmp    101dfa <__alltraps>

0010246c <vector168>:
.globl vector168
vector168:
  pushl $0
  10246c:	6a 00                	push   $0x0
  pushl $168
  10246e:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102473:	e9 82 f9 ff ff       	jmp    101dfa <__alltraps>

00102478 <vector169>:
.globl vector169
vector169:
  pushl $0
  102478:	6a 00                	push   $0x0
  pushl $169
  10247a:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10247f:	e9 76 f9 ff ff       	jmp    101dfa <__alltraps>

00102484 <vector170>:
.globl vector170
vector170:
  pushl $0
  102484:	6a 00                	push   $0x0
  pushl $170
  102486:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10248b:	e9 6a f9 ff ff       	jmp    101dfa <__alltraps>

00102490 <vector171>:
.globl vector171
vector171:
  pushl $0
  102490:	6a 00                	push   $0x0
  pushl $171
  102492:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102497:	e9 5e f9 ff ff       	jmp    101dfa <__alltraps>

0010249c <vector172>:
.globl vector172
vector172:
  pushl $0
  10249c:	6a 00                	push   $0x0
  pushl $172
  10249e:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1024a3:	e9 52 f9 ff ff       	jmp    101dfa <__alltraps>

001024a8 <vector173>:
.globl vector173
vector173:
  pushl $0
  1024a8:	6a 00                	push   $0x0
  pushl $173
  1024aa:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1024af:	e9 46 f9 ff ff       	jmp    101dfa <__alltraps>

001024b4 <vector174>:
.globl vector174
vector174:
  pushl $0
  1024b4:	6a 00                	push   $0x0
  pushl $174
  1024b6:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1024bb:	e9 3a f9 ff ff       	jmp    101dfa <__alltraps>

001024c0 <vector175>:
.globl vector175
vector175:
  pushl $0
  1024c0:	6a 00                	push   $0x0
  pushl $175
  1024c2:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1024c7:	e9 2e f9 ff ff       	jmp    101dfa <__alltraps>

001024cc <vector176>:
.globl vector176
vector176:
  pushl $0
  1024cc:	6a 00                	push   $0x0
  pushl $176
  1024ce:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1024d3:	e9 22 f9 ff ff       	jmp    101dfa <__alltraps>

001024d8 <vector177>:
.globl vector177
vector177:
  pushl $0
  1024d8:	6a 00                	push   $0x0
  pushl $177
  1024da:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1024df:	e9 16 f9 ff ff       	jmp    101dfa <__alltraps>

001024e4 <vector178>:
.globl vector178
vector178:
  pushl $0
  1024e4:	6a 00                	push   $0x0
  pushl $178
  1024e6:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1024eb:	e9 0a f9 ff ff       	jmp    101dfa <__alltraps>

001024f0 <vector179>:
.globl vector179
vector179:
  pushl $0
  1024f0:	6a 00                	push   $0x0
  pushl $179
  1024f2:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1024f7:	e9 fe f8 ff ff       	jmp    101dfa <__alltraps>

001024fc <vector180>:
.globl vector180
vector180:
  pushl $0
  1024fc:	6a 00                	push   $0x0
  pushl $180
  1024fe:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102503:	e9 f2 f8 ff ff       	jmp    101dfa <__alltraps>

00102508 <vector181>:
.globl vector181
vector181:
  pushl $0
  102508:	6a 00                	push   $0x0
  pushl $181
  10250a:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10250f:	e9 e6 f8 ff ff       	jmp    101dfa <__alltraps>

00102514 <vector182>:
.globl vector182
vector182:
  pushl $0
  102514:	6a 00                	push   $0x0
  pushl $182
  102516:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10251b:	e9 da f8 ff ff       	jmp    101dfa <__alltraps>

00102520 <vector183>:
.globl vector183
vector183:
  pushl $0
  102520:	6a 00                	push   $0x0
  pushl $183
  102522:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102527:	e9 ce f8 ff ff       	jmp    101dfa <__alltraps>

0010252c <vector184>:
.globl vector184
vector184:
  pushl $0
  10252c:	6a 00                	push   $0x0
  pushl $184
  10252e:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102533:	e9 c2 f8 ff ff       	jmp    101dfa <__alltraps>

00102538 <vector185>:
.globl vector185
vector185:
  pushl $0
  102538:	6a 00                	push   $0x0
  pushl $185
  10253a:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10253f:	e9 b6 f8 ff ff       	jmp    101dfa <__alltraps>

00102544 <vector186>:
.globl vector186
vector186:
  pushl $0
  102544:	6a 00                	push   $0x0
  pushl $186
  102546:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10254b:	e9 aa f8 ff ff       	jmp    101dfa <__alltraps>

00102550 <vector187>:
.globl vector187
vector187:
  pushl $0
  102550:	6a 00                	push   $0x0
  pushl $187
  102552:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102557:	e9 9e f8 ff ff       	jmp    101dfa <__alltraps>

0010255c <vector188>:
.globl vector188
vector188:
  pushl $0
  10255c:	6a 00                	push   $0x0
  pushl $188
  10255e:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102563:	e9 92 f8 ff ff       	jmp    101dfa <__alltraps>

00102568 <vector189>:
.globl vector189
vector189:
  pushl $0
  102568:	6a 00                	push   $0x0
  pushl $189
  10256a:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10256f:	e9 86 f8 ff ff       	jmp    101dfa <__alltraps>

00102574 <vector190>:
.globl vector190
vector190:
  pushl $0
  102574:	6a 00                	push   $0x0
  pushl $190
  102576:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10257b:	e9 7a f8 ff ff       	jmp    101dfa <__alltraps>

00102580 <vector191>:
.globl vector191
vector191:
  pushl $0
  102580:	6a 00                	push   $0x0
  pushl $191
  102582:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102587:	e9 6e f8 ff ff       	jmp    101dfa <__alltraps>

0010258c <vector192>:
.globl vector192
vector192:
  pushl $0
  10258c:	6a 00                	push   $0x0
  pushl $192
  10258e:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102593:	e9 62 f8 ff ff       	jmp    101dfa <__alltraps>

00102598 <vector193>:
.globl vector193
vector193:
  pushl $0
  102598:	6a 00                	push   $0x0
  pushl $193
  10259a:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10259f:	e9 56 f8 ff ff       	jmp    101dfa <__alltraps>

001025a4 <vector194>:
.globl vector194
vector194:
  pushl $0
  1025a4:	6a 00                	push   $0x0
  pushl $194
  1025a6:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1025ab:	e9 4a f8 ff ff       	jmp    101dfa <__alltraps>

001025b0 <vector195>:
.globl vector195
vector195:
  pushl $0
  1025b0:	6a 00                	push   $0x0
  pushl $195
  1025b2:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1025b7:	e9 3e f8 ff ff       	jmp    101dfa <__alltraps>

001025bc <vector196>:
.globl vector196
vector196:
  pushl $0
  1025bc:	6a 00                	push   $0x0
  pushl $196
  1025be:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1025c3:	e9 32 f8 ff ff       	jmp    101dfa <__alltraps>

001025c8 <vector197>:
.globl vector197
vector197:
  pushl $0
  1025c8:	6a 00                	push   $0x0
  pushl $197
  1025ca:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1025cf:	e9 26 f8 ff ff       	jmp    101dfa <__alltraps>

001025d4 <vector198>:
.globl vector198
vector198:
  pushl $0
  1025d4:	6a 00                	push   $0x0
  pushl $198
  1025d6:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1025db:	e9 1a f8 ff ff       	jmp    101dfa <__alltraps>

001025e0 <vector199>:
.globl vector199
vector199:
  pushl $0
  1025e0:	6a 00                	push   $0x0
  pushl $199
  1025e2:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1025e7:	e9 0e f8 ff ff       	jmp    101dfa <__alltraps>

001025ec <vector200>:
.globl vector200
vector200:
  pushl $0
  1025ec:	6a 00                	push   $0x0
  pushl $200
  1025ee:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1025f3:	e9 02 f8 ff ff       	jmp    101dfa <__alltraps>

001025f8 <vector201>:
.globl vector201
vector201:
  pushl $0
  1025f8:	6a 00                	push   $0x0
  pushl $201
  1025fa:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1025ff:	e9 f6 f7 ff ff       	jmp    101dfa <__alltraps>

00102604 <vector202>:
.globl vector202
vector202:
  pushl $0
  102604:	6a 00                	push   $0x0
  pushl $202
  102606:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10260b:	e9 ea f7 ff ff       	jmp    101dfa <__alltraps>

00102610 <vector203>:
.globl vector203
vector203:
  pushl $0
  102610:	6a 00                	push   $0x0
  pushl $203
  102612:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102617:	e9 de f7 ff ff       	jmp    101dfa <__alltraps>

0010261c <vector204>:
.globl vector204
vector204:
  pushl $0
  10261c:	6a 00                	push   $0x0
  pushl $204
  10261e:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102623:	e9 d2 f7 ff ff       	jmp    101dfa <__alltraps>

00102628 <vector205>:
.globl vector205
vector205:
  pushl $0
  102628:	6a 00                	push   $0x0
  pushl $205
  10262a:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10262f:	e9 c6 f7 ff ff       	jmp    101dfa <__alltraps>

00102634 <vector206>:
.globl vector206
vector206:
  pushl $0
  102634:	6a 00                	push   $0x0
  pushl $206
  102636:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10263b:	e9 ba f7 ff ff       	jmp    101dfa <__alltraps>

00102640 <vector207>:
.globl vector207
vector207:
  pushl $0
  102640:	6a 00                	push   $0x0
  pushl $207
  102642:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102647:	e9 ae f7 ff ff       	jmp    101dfa <__alltraps>

0010264c <vector208>:
.globl vector208
vector208:
  pushl $0
  10264c:	6a 00                	push   $0x0
  pushl $208
  10264e:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102653:	e9 a2 f7 ff ff       	jmp    101dfa <__alltraps>

00102658 <vector209>:
.globl vector209
vector209:
  pushl $0
  102658:	6a 00                	push   $0x0
  pushl $209
  10265a:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10265f:	e9 96 f7 ff ff       	jmp    101dfa <__alltraps>

00102664 <vector210>:
.globl vector210
vector210:
  pushl $0
  102664:	6a 00                	push   $0x0
  pushl $210
  102666:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10266b:	e9 8a f7 ff ff       	jmp    101dfa <__alltraps>

00102670 <vector211>:
.globl vector211
vector211:
  pushl $0
  102670:	6a 00                	push   $0x0
  pushl $211
  102672:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102677:	e9 7e f7 ff ff       	jmp    101dfa <__alltraps>

0010267c <vector212>:
.globl vector212
vector212:
  pushl $0
  10267c:	6a 00                	push   $0x0
  pushl $212
  10267e:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102683:	e9 72 f7 ff ff       	jmp    101dfa <__alltraps>

00102688 <vector213>:
.globl vector213
vector213:
  pushl $0
  102688:	6a 00                	push   $0x0
  pushl $213
  10268a:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10268f:	e9 66 f7 ff ff       	jmp    101dfa <__alltraps>

00102694 <vector214>:
.globl vector214
vector214:
  pushl $0
  102694:	6a 00                	push   $0x0
  pushl $214
  102696:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10269b:	e9 5a f7 ff ff       	jmp    101dfa <__alltraps>

001026a0 <vector215>:
.globl vector215
vector215:
  pushl $0
  1026a0:	6a 00                	push   $0x0
  pushl $215
  1026a2:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1026a7:	e9 4e f7 ff ff       	jmp    101dfa <__alltraps>

001026ac <vector216>:
.globl vector216
vector216:
  pushl $0
  1026ac:	6a 00                	push   $0x0
  pushl $216
  1026ae:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1026b3:	e9 42 f7 ff ff       	jmp    101dfa <__alltraps>

001026b8 <vector217>:
.globl vector217
vector217:
  pushl $0
  1026b8:	6a 00                	push   $0x0
  pushl $217
  1026ba:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1026bf:	e9 36 f7 ff ff       	jmp    101dfa <__alltraps>

001026c4 <vector218>:
.globl vector218
vector218:
  pushl $0
  1026c4:	6a 00                	push   $0x0
  pushl $218
  1026c6:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1026cb:	e9 2a f7 ff ff       	jmp    101dfa <__alltraps>

001026d0 <vector219>:
.globl vector219
vector219:
  pushl $0
  1026d0:	6a 00                	push   $0x0
  pushl $219
  1026d2:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1026d7:	e9 1e f7 ff ff       	jmp    101dfa <__alltraps>

001026dc <vector220>:
.globl vector220
vector220:
  pushl $0
  1026dc:	6a 00                	push   $0x0
  pushl $220
  1026de:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1026e3:	e9 12 f7 ff ff       	jmp    101dfa <__alltraps>

001026e8 <vector221>:
.globl vector221
vector221:
  pushl $0
  1026e8:	6a 00                	push   $0x0
  pushl $221
  1026ea:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1026ef:	e9 06 f7 ff ff       	jmp    101dfa <__alltraps>

001026f4 <vector222>:
.globl vector222
vector222:
  pushl $0
  1026f4:	6a 00                	push   $0x0
  pushl $222
  1026f6:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1026fb:	e9 fa f6 ff ff       	jmp    101dfa <__alltraps>

00102700 <vector223>:
.globl vector223
vector223:
  pushl $0
  102700:	6a 00                	push   $0x0
  pushl $223
  102702:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102707:	e9 ee f6 ff ff       	jmp    101dfa <__alltraps>

0010270c <vector224>:
.globl vector224
vector224:
  pushl $0
  10270c:	6a 00                	push   $0x0
  pushl $224
  10270e:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102713:	e9 e2 f6 ff ff       	jmp    101dfa <__alltraps>

00102718 <vector225>:
.globl vector225
vector225:
  pushl $0
  102718:	6a 00                	push   $0x0
  pushl $225
  10271a:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10271f:	e9 d6 f6 ff ff       	jmp    101dfa <__alltraps>

00102724 <vector226>:
.globl vector226
vector226:
  pushl $0
  102724:	6a 00                	push   $0x0
  pushl $226
  102726:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10272b:	e9 ca f6 ff ff       	jmp    101dfa <__alltraps>

00102730 <vector227>:
.globl vector227
vector227:
  pushl $0
  102730:	6a 00                	push   $0x0
  pushl $227
  102732:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102737:	e9 be f6 ff ff       	jmp    101dfa <__alltraps>

0010273c <vector228>:
.globl vector228
vector228:
  pushl $0
  10273c:	6a 00                	push   $0x0
  pushl $228
  10273e:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102743:	e9 b2 f6 ff ff       	jmp    101dfa <__alltraps>

00102748 <vector229>:
.globl vector229
vector229:
  pushl $0
  102748:	6a 00                	push   $0x0
  pushl $229
  10274a:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10274f:	e9 a6 f6 ff ff       	jmp    101dfa <__alltraps>

00102754 <vector230>:
.globl vector230
vector230:
  pushl $0
  102754:	6a 00                	push   $0x0
  pushl $230
  102756:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10275b:	e9 9a f6 ff ff       	jmp    101dfa <__alltraps>

00102760 <vector231>:
.globl vector231
vector231:
  pushl $0
  102760:	6a 00                	push   $0x0
  pushl $231
  102762:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102767:	e9 8e f6 ff ff       	jmp    101dfa <__alltraps>

0010276c <vector232>:
.globl vector232
vector232:
  pushl $0
  10276c:	6a 00                	push   $0x0
  pushl $232
  10276e:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102773:	e9 82 f6 ff ff       	jmp    101dfa <__alltraps>

00102778 <vector233>:
.globl vector233
vector233:
  pushl $0
  102778:	6a 00                	push   $0x0
  pushl $233
  10277a:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10277f:	e9 76 f6 ff ff       	jmp    101dfa <__alltraps>

00102784 <vector234>:
.globl vector234
vector234:
  pushl $0
  102784:	6a 00                	push   $0x0
  pushl $234
  102786:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10278b:	e9 6a f6 ff ff       	jmp    101dfa <__alltraps>

00102790 <vector235>:
.globl vector235
vector235:
  pushl $0
  102790:	6a 00                	push   $0x0
  pushl $235
  102792:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102797:	e9 5e f6 ff ff       	jmp    101dfa <__alltraps>

0010279c <vector236>:
.globl vector236
vector236:
  pushl $0
  10279c:	6a 00                	push   $0x0
  pushl $236
  10279e:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1027a3:	e9 52 f6 ff ff       	jmp    101dfa <__alltraps>

001027a8 <vector237>:
.globl vector237
vector237:
  pushl $0
  1027a8:	6a 00                	push   $0x0
  pushl $237
  1027aa:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1027af:	e9 46 f6 ff ff       	jmp    101dfa <__alltraps>

001027b4 <vector238>:
.globl vector238
vector238:
  pushl $0
  1027b4:	6a 00                	push   $0x0
  pushl $238
  1027b6:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1027bb:	e9 3a f6 ff ff       	jmp    101dfa <__alltraps>

001027c0 <vector239>:
.globl vector239
vector239:
  pushl $0
  1027c0:	6a 00                	push   $0x0
  pushl $239
  1027c2:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1027c7:	e9 2e f6 ff ff       	jmp    101dfa <__alltraps>

001027cc <vector240>:
.globl vector240
vector240:
  pushl $0
  1027cc:	6a 00                	push   $0x0
  pushl $240
  1027ce:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1027d3:	e9 22 f6 ff ff       	jmp    101dfa <__alltraps>

001027d8 <vector241>:
.globl vector241
vector241:
  pushl $0
  1027d8:	6a 00                	push   $0x0
  pushl $241
  1027da:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1027df:	e9 16 f6 ff ff       	jmp    101dfa <__alltraps>

001027e4 <vector242>:
.globl vector242
vector242:
  pushl $0
  1027e4:	6a 00                	push   $0x0
  pushl $242
  1027e6:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1027eb:	e9 0a f6 ff ff       	jmp    101dfa <__alltraps>

001027f0 <vector243>:
.globl vector243
vector243:
  pushl $0
  1027f0:	6a 00                	push   $0x0
  pushl $243
  1027f2:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1027f7:	e9 fe f5 ff ff       	jmp    101dfa <__alltraps>

001027fc <vector244>:
.globl vector244
vector244:
  pushl $0
  1027fc:	6a 00                	push   $0x0
  pushl $244
  1027fe:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102803:	e9 f2 f5 ff ff       	jmp    101dfa <__alltraps>

00102808 <vector245>:
.globl vector245
vector245:
  pushl $0
  102808:	6a 00                	push   $0x0
  pushl $245
  10280a:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10280f:	e9 e6 f5 ff ff       	jmp    101dfa <__alltraps>

00102814 <vector246>:
.globl vector246
vector246:
  pushl $0
  102814:	6a 00                	push   $0x0
  pushl $246
  102816:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10281b:	e9 da f5 ff ff       	jmp    101dfa <__alltraps>

00102820 <vector247>:
.globl vector247
vector247:
  pushl $0
  102820:	6a 00                	push   $0x0
  pushl $247
  102822:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102827:	e9 ce f5 ff ff       	jmp    101dfa <__alltraps>

0010282c <vector248>:
.globl vector248
vector248:
  pushl $0
  10282c:	6a 00                	push   $0x0
  pushl $248
  10282e:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102833:	e9 c2 f5 ff ff       	jmp    101dfa <__alltraps>

00102838 <vector249>:
.globl vector249
vector249:
  pushl $0
  102838:	6a 00                	push   $0x0
  pushl $249
  10283a:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10283f:	e9 b6 f5 ff ff       	jmp    101dfa <__alltraps>

00102844 <vector250>:
.globl vector250
vector250:
  pushl $0
  102844:	6a 00                	push   $0x0
  pushl $250
  102846:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10284b:	e9 aa f5 ff ff       	jmp    101dfa <__alltraps>

00102850 <vector251>:
.globl vector251
vector251:
  pushl $0
  102850:	6a 00                	push   $0x0
  pushl $251
  102852:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102857:	e9 9e f5 ff ff       	jmp    101dfa <__alltraps>

0010285c <vector252>:
.globl vector252
vector252:
  pushl $0
  10285c:	6a 00                	push   $0x0
  pushl $252
  10285e:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102863:	e9 92 f5 ff ff       	jmp    101dfa <__alltraps>

00102868 <vector253>:
.globl vector253
vector253:
  pushl $0
  102868:	6a 00                	push   $0x0
  pushl $253
  10286a:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10286f:	e9 86 f5 ff ff       	jmp    101dfa <__alltraps>

00102874 <vector254>:
.globl vector254
vector254:
  pushl $0
  102874:	6a 00                	push   $0x0
  pushl $254
  102876:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10287b:	e9 7a f5 ff ff       	jmp    101dfa <__alltraps>

00102880 <vector255>:
.globl vector255
vector255:
  pushl $0
  102880:	6a 00                	push   $0x0
  pushl $255
  102882:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102887:	e9 6e f5 ff ff       	jmp    101dfa <__alltraps>

0010288c <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  10288c:	55                   	push   %ebp
  10288d:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10288f:	8b 55 08             	mov    0x8(%ebp),%edx
  102892:	a1 84 89 11 00       	mov    0x118984,%eax
  102897:	29 c2                	sub    %eax,%edx
  102899:	89 d0                	mov    %edx,%eax
  10289b:	c1 f8 02             	sar    $0x2,%eax
  10289e:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1028a4:	5d                   	pop    %ebp
  1028a5:	c3                   	ret    

001028a6 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1028a6:	55                   	push   %ebp
  1028a7:	89 e5                	mov    %esp,%ebp
  1028a9:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1028ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1028af:	89 04 24             	mov    %eax,(%esp)
  1028b2:	e8 d5 ff ff ff       	call   10288c <page2ppn>
  1028b7:	c1 e0 0c             	shl    $0xc,%eax
}
  1028ba:	c9                   	leave  
  1028bb:	c3                   	ret    

001028bc <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1028bc:	55                   	push   %ebp
  1028bd:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1028bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1028c2:	8b 00                	mov    (%eax),%eax
}
  1028c4:	5d                   	pop    %ebp
  1028c5:	c3                   	ret    

001028c6 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  1028c6:	55                   	push   %ebp
  1028c7:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1028c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1028cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  1028cf:	89 10                	mov    %edx,(%eax)
}
  1028d1:	5d                   	pop    %ebp
  1028d2:	c3                   	ret    

001028d3 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  1028d3:	55                   	push   %ebp
  1028d4:	89 e5                	mov    %esp,%ebp
  1028d6:	83 ec 10             	sub    $0x10,%esp
  1028d9:	c7 45 fc 70 89 11 00 	movl   $0x118970,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1028e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1028e6:	89 50 04             	mov    %edx,0x4(%eax)
  1028e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028ec:	8b 50 04             	mov    0x4(%eax),%edx
  1028ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028f2:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  1028f4:	c7 05 78 89 11 00 00 	movl   $0x0,0x118978
  1028fb:	00 00 00 
}
  1028fe:	c9                   	leave  
  1028ff:	c3                   	ret    

00102900 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  102900:	55                   	push   %ebp
  102901:	89 e5                	mov    %esp,%ebp
  102903:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  102906:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10290a:	75 24                	jne    102930 <default_init_memmap+0x30>
  10290c:	c7 44 24 0c 30 65 10 	movl   $0x106530,0xc(%esp)
  102913:	00 
  102914:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  10291b:	00 
  10291c:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  102923:	00 
  102924:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  10292b:	e8 99 e3 ff ff       	call   100cc9 <__panic>
    struct Page *p = base;
  102930:	8b 45 08             	mov    0x8(%ebp),%eax
  102933:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102936:	eb 7d                	jmp    1029b5 <default_init_memmap+0xb5>
        assert(PageReserved(p));
  102938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10293b:	83 c0 04             	add    $0x4,%eax
  10293e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102945:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102948:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10294b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10294e:	0f a3 10             	bt     %edx,(%eax)
  102951:	19 c0                	sbb    %eax,%eax
  102953:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102956:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10295a:	0f 95 c0             	setne  %al
  10295d:	0f b6 c0             	movzbl %al,%eax
  102960:	85 c0                	test   %eax,%eax
  102962:	75 24                	jne    102988 <default_init_memmap+0x88>
  102964:	c7 44 24 0c 61 65 10 	movl   $0x106561,0xc(%esp)
  10296b:	00 
  10296c:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  102973:	00 
  102974:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  10297b:	00 
  10297c:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  102983:	e8 41 e3 ff ff       	call   100cc9 <__panic>
        p->flags = p->property = 0;
  102988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10298b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  102992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102995:	8b 50 08             	mov    0x8(%eax),%edx
  102998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10299b:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  10299e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1029a5:	00 
  1029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029a9:	89 04 24             	mov    %eax,(%esp)
  1029ac:	e8 15 ff ff ff       	call   1028c6 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  1029b1:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1029b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029b8:	89 d0                	mov    %edx,%eax
  1029ba:	c1 e0 02             	shl    $0x2,%eax
  1029bd:	01 d0                	add    %edx,%eax
  1029bf:	c1 e0 02             	shl    $0x2,%eax
  1029c2:	89 c2                	mov    %eax,%edx
  1029c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1029c7:	01 d0                	add    %edx,%eax
  1029c9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1029cc:	0f 85 66 ff ff ff    	jne    102938 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  1029d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1029d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029d8:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  1029db:	8b 45 08             	mov    0x8(%ebp),%eax
  1029de:	83 c0 04             	add    $0x4,%eax
  1029e1:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  1029e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1029eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1029f1:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  1029f4:	8b 15 78 89 11 00    	mov    0x118978,%edx
  1029fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029fd:	01 d0                	add    %edx,%eax
  1029ff:	a3 78 89 11 00       	mov    %eax,0x118978
    list_add(&free_list, &(base->page_link));
  102a04:	8b 45 08             	mov    0x8(%ebp),%eax
  102a07:	83 c0 0c             	add    $0xc,%eax
  102a0a:	c7 45 dc 70 89 11 00 	movl   $0x118970,-0x24(%ebp)
  102a11:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102a14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a17:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  102a1a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a1d:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102a20:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a23:	8b 40 04             	mov    0x4(%eax),%eax
  102a26:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102a29:	89 55 cc             	mov    %edx,-0x34(%ebp)
  102a2c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a2f:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102a32:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102a35:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102a38:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102a3b:	89 10                	mov    %edx,(%eax)
  102a3d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102a40:	8b 10                	mov    (%eax),%edx
  102a42:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102a45:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102a48:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a4b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102a4e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102a51:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a54:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102a57:	89 10                	mov    %edx,(%eax)
}
  102a59:	c9                   	leave  
  102a5a:	c3                   	ret    

00102a5b <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102a5b:	55                   	push   %ebp
  102a5c:	89 e5                	mov    %esp,%ebp
  102a5e:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102a61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102a65:	75 24                	jne    102a8b <default_alloc_pages+0x30>
  102a67:	c7 44 24 0c 30 65 10 	movl   $0x106530,0xc(%esp)
  102a6e:	00 
  102a6f:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  102a76:	00 
  102a77:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  102a7e:	00 
  102a7f:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  102a86:	e8 3e e2 ff ff       	call   100cc9 <__panic>
    if (n > nr_free) {
  102a8b:	a1 78 89 11 00       	mov    0x118978,%eax
  102a90:	3b 45 08             	cmp    0x8(%ebp),%eax
  102a93:	73 0a                	jae    102a9f <default_alloc_pages+0x44>
        return NULL;
  102a95:	b8 00 00 00 00       	mov    $0x0,%eax
  102a9a:	e9 2a 01 00 00       	jmp    102bc9 <default_alloc_pages+0x16e>
    }
    struct Page *page = NULL;
  102a9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102aa6:	c7 45 f0 70 89 11 00 	movl   $0x118970,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102aad:	eb 1c                	jmp    102acb <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  102aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ab2:	83 e8 0c             	sub    $0xc,%eax
  102ab5:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  102ab8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102abb:	8b 40 08             	mov    0x8(%eax),%eax
  102abe:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ac1:	72 08                	jb     102acb <default_alloc_pages+0x70>
            page = p;
  102ac3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ac6:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102ac9:	eb 18                	jmp    102ae3 <default_alloc_pages+0x88>
  102acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ace:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102ad1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ad4:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  102ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ada:	81 7d f0 70 89 11 00 	cmpl   $0x118970,-0x10(%ebp)
  102ae1:	75 cc                	jne    102aaf <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
  102ae3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102ae7:	0f 84 d9 00 00 00    	je     102bc6 <default_alloc_pages+0x16b>
        list_del(&(page->page_link));
  102aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102af0:	83 c0 0c             	add    $0xc,%eax
  102af3:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102af6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102af9:	8b 40 04             	mov    0x4(%eax),%eax
  102afc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102aff:	8b 12                	mov    (%edx),%edx
  102b01:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102b04:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102b07:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b0a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102b0d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102b10:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b13:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102b16:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
  102b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b1b:	8b 40 08             	mov    0x8(%eax),%eax
  102b1e:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b21:	76 7d                	jbe    102ba0 <default_alloc_pages+0x145>
            struct Page *p = page + n;
  102b23:	8b 55 08             	mov    0x8(%ebp),%edx
  102b26:	89 d0                	mov    %edx,%eax
  102b28:	c1 e0 02             	shl    $0x2,%eax
  102b2b:	01 d0                	add    %edx,%eax
  102b2d:	c1 e0 02             	shl    $0x2,%eax
  102b30:	89 c2                	mov    %eax,%edx
  102b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b35:	01 d0                	add    %edx,%eax
  102b37:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  102b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b3d:	8b 40 08             	mov    0x8(%eax),%eax
  102b40:	2b 45 08             	sub    0x8(%ebp),%eax
  102b43:	89 c2                	mov    %eax,%edx
  102b45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b48:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
  102b4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b4e:	83 c0 0c             	add    $0xc,%eax
  102b51:	c7 45 d4 70 89 11 00 	movl   $0x118970,-0x2c(%ebp)
  102b58:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102b5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102b5e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  102b61:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b64:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102b67:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b6a:	8b 40 04             	mov    0x4(%eax),%eax
  102b6d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102b70:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102b73:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102b76:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102b79:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102b7c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102b7f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102b82:	89 10                	mov    %edx,(%eax)
  102b84:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102b87:	8b 10                	mov    (%eax),%edx
  102b89:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102b8c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102b8f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102b92:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102b95:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102b98:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102b9b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102b9e:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
  102ba0:	a1 78 89 11 00       	mov    0x118978,%eax
  102ba5:	2b 45 08             	sub    0x8(%ebp),%eax
  102ba8:	a3 78 89 11 00       	mov    %eax,0x118978
        ClearPageProperty(page);
  102bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bb0:	83 c0 04             	add    $0x4,%eax
  102bb3:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102bba:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102bbd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102bc0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102bc3:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  102bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102bc9:	c9                   	leave  
  102bca:	c3                   	ret    

00102bcb <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102bcb:	55                   	push   %ebp
  102bcc:	89 e5                	mov    %esp,%ebp
  102bce:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  102bd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102bd8:	75 24                	jne    102bfe <default_free_pages+0x33>
  102bda:	c7 44 24 0c 30 65 10 	movl   $0x106530,0xc(%esp)
  102be1:	00 
  102be2:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  102be9:	00 
  102bea:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  102bf1:	00 
  102bf2:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  102bf9:	e8 cb e0 ff ff       	call   100cc9 <__panic>
    struct Page *p = base;
  102bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  102c01:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102c04:	e9 9d 00 00 00       	jmp    102ca6 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  102c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c0c:	83 c0 04             	add    $0x4,%eax
  102c0f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102c16:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c1f:	0f a3 10             	bt     %edx,(%eax)
  102c22:	19 c0                	sbb    %eax,%eax
  102c24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102c27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102c2b:	0f 95 c0             	setne  %al
  102c2e:	0f b6 c0             	movzbl %al,%eax
  102c31:	85 c0                	test   %eax,%eax
  102c33:	75 2c                	jne    102c61 <default_free_pages+0x96>
  102c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c38:	83 c0 04             	add    $0x4,%eax
  102c3b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102c42:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c45:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c48:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102c4b:	0f a3 10             	bt     %edx,(%eax)
  102c4e:	19 c0                	sbb    %eax,%eax
  102c50:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  102c53:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  102c57:	0f 95 c0             	setne  %al
  102c5a:	0f b6 c0             	movzbl %al,%eax
  102c5d:	85 c0                	test   %eax,%eax
  102c5f:	74 24                	je     102c85 <default_free_pages+0xba>
  102c61:	c7 44 24 0c 74 65 10 	movl   $0x106574,0xc(%esp)
  102c68:	00 
  102c69:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  102c70:	00 
  102c71:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
  102c78:	00 
  102c79:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  102c80:	e8 44 e0 ff ff       	call   100cc9 <__panic>
        p->flags = 0;
  102c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102c8f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102c96:	00 
  102c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c9a:	89 04 24             	mov    %eax,(%esp)
  102c9d:	e8 24 fc ff ff       	call   1028c6 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102ca2:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ca9:	89 d0                	mov    %edx,%eax
  102cab:	c1 e0 02             	shl    $0x2,%eax
  102cae:	01 d0                	add    %edx,%eax
  102cb0:	c1 e0 02             	shl    $0x2,%eax
  102cb3:	89 c2                	mov    %eax,%edx
  102cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb8:	01 d0                	add    %edx,%eax
  102cba:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102cbd:	0f 85 46 ff ff ff    	jne    102c09 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  102cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cc9:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  102ccf:	83 c0 04             	add    $0x4,%eax
  102cd2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102cd9:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102cdc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102cdf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102ce2:	0f ab 10             	bts    %edx,(%eax)
  102ce5:	c7 45 cc 70 89 11 00 	movl   $0x118970,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102cec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102cef:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  102cf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  102cf5:	e9 08 01 00 00       	jmp    102e02 <default_free_pages+0x237>
        p = le2page(le, page_link);
  102cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cfd:	83 e8 0c             	sub    $0xc,%eax
  102d00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d06:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102d09:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102d0c:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  102d0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  102d12:	8b 45 08             	mov    0x8(%ebp),%eax
  102d15:	8b 50 08             	mov    0x8(%eax),%edx
  102d18:	89 d0                	mov    %edx,%eax
  102d1a:	c1 e0 02             	shl    $0x2,%eax
  102d1d:	01 d0                	add    %edx,%eax
  102d1f:	c1 e0 02             	shl    $0x2,%eax
  102d22:	89 c2                	mov    %eax,%edx
  102d24:	8b 45 08             	mov    0x8(%ebp),%eax
  102d27:	01 d0                	add    %edx,%eax
  102d29:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102d2c:	75 5a                	jne    102d88 <default_free_pages+0x1bd>
            base->property += p->property;
  102d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d31:	8b 50 08             	mov    0x8(%eax),%edx
  102d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d37:	8b 40 08             	mov    0x8(%eax),%eax
  102d3a:	01 c2                	add    %eax,%edx
  102d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d3f:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d45:	83 c0 04             	add    $0x4,%eax
  102d48:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  102d4f:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d52:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102d55:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102d58:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  102d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d5e:	83 c0 0c             	add    $0xc,%eax
  102d61:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102d64:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102d67:	8b 40 04             	mov    0x4(%eax),%eax
  102d6a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102d6d:	8b 12                	mov    (%edx),%edx
  102d6f:	89 55 b8             	mov    %edx,-0x48(%ebp)
  102d72:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102d75:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102d78:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102d7b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102d7e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102d81:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102d84:	89 10                	mov    %edx,(%eax)
  102d86:	eb 7a                	jmp    102e02 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
  102d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d8b:	8b 50 08             	mov    0x8(%eax),%edx
  102d8e:	89 d0                	mov    %edx,%eax
  102d90:	c1 e0 02             	shl    $0x2,%eax
  102d93:	01 d0                	add    %edx,%eax
  102d95:	c1 e0 02             	shl    $0x2,%eax
  102d98:	89 c2                	mov    %eax,%edx
  102d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d9d:	01 d0                	add    %edx,%eax
  102d9f:	3b 45 08             	cmp    0x8(%ebp),%eax
  102da2:	75 5e                	jne    102e02 <default_free_pages+0x237>
            p->property += base->property;
  102da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102da7:	8b 50 08             	mov    0x8(%eax),%edx
  102daa:	8b 45 08             	mov    0x8(%ebp),%eax
  102dad:	8b 40 08             	mov    0x8(%eax),%eax
  102db0:	01 c2                	add    %eax,%edx
  102db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102db5:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  102db8:	8b 45 08             	mov    0x8(%ebp),%eax
  102dbb:	83 c0 04             	add    $0x4,%eax
  102dbe:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  102dc5:	89 45 ac             	mov    %eax,-0x54(%ebp)
  102dc8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102dcb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102dce:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  102dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dd4:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  102dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dda:	83 c0 0c             	add    $0xc,%eax
  102ddd:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102de0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102de3:	8b 40 04             	mov    0x4(%eax),%eax
  102de6:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102de9:	8b 12                	mov    (%edx),%edx
  102deb:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102dee:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102df1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102df4:	8b 55 a0             	mov    -0x60(%ebp),%edx
  102df7:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102dfa:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102dfd:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102e00:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
  102e02:	81 7d f0 70 89 11 00 	cmpl   $0x118970,-0x10(%ebp)
  102e09:	0f 85 eb fe ff ff    	jne    102cfa <default_free_pages+0x12f>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
  102e0f:	8b 15 78 89 11 00    	mov    0x118978,%edx
  102e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e18:	01 d0                	add    %edx,%eax
  102e1a:	a3 78 89 11 00       	mov    %eax,0x118978
    list_add(&free_list, &(base->page_link));
  102e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e22:	83 c0 0c             	add    $0xc,%eax
  102e25:	c7 45 9c 70 89 11 00 	movl   $0x118970,-0x64(%ebp)
  102e2c:	89 45 98             	mov    %eax,-0x68(%ebp)
  102e2f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102e32:	89 45 94             	mov    %eax,-0x6c(%ebp)
  102e35:	8b 45 98             	mov    -0x68(%ebp),%eax
  102e38:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102e3b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102e3e:	8b 40 04             	mov    0x4(%eax),%eax
  102e41:	8b 55 90             	mov    -0x70(%ebp),%edx
  102e44:	89 55 8c             	mov    %edx,-0x74(%ebp)
  102e47:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102e4a:	89 55 88             	mov    %edx,-0x78(%ebp)
  102e4d:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102e50:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102e53:	8b 55 8c             	mov    -0x74(%ebp),%edx
  102e56:	89 10                	mov    %edx,(%eax)
  102e58:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102e5b:	8b 10                	mov    (%eax),%edx
  102e5d:	8b 45 88             	mov    -0x78(%ebp),%eax
  102e60:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102e63:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102e66:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102e69:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102e6c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102e6f:	8b 55 88             	mov    -0x78(%ebp),%edx
  102e72:	89 10                	mov    %edx,(%eax)
}
  102e74:	c9                   	leave  
  102e75:	c3                   	ret    

00102e76 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102e76:	55                   	push   %ebp
  102e77:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102e79:	a1 78 89 11 00       	mov    0x118978,%eax
}
  102e7e:	5d                   	pop    %ebp
  102e7f:	c3                   	ret    

00102e80 <basic_check>:

static void
basic_check(void) {
  102e80:	55                   	push   %ebp
  102e81:	89 e5                	mov    %esp,%ebp
  102e83:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102e86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e96:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102e99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102ea0:	e8 78 0e 00 00       	call   103d1d <alloc_pages>
  102ea5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102ea8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102eac:	75 24                	jne    102ed2 <basic_check+0x52>
  102eae:	c7 44 24 0c 99 65 10 	movl   $0x106599,0xc(%esp)
  102eb5:	00 
  102eb6:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  102ebd:	00 
  102ebe:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
  102ec5:	00 
  102ec6:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  102ecd:	e8 f7 dd ff ff       	call   100cc9 <__panic>
    assert((p1 = alloc_page()) != NULL);
  102ed2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102ed9:	e8 3f 0e 00 00       	call   103d1d <alloc_pages>
  102ede:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ee1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102ee5:	75 24                	jne    102f0b <basic_check+0x8b>
  102ee7:	c7 44 24 0c b5 65 10 	movl   $0x1065b5,0xc(%esp)
  102eee:	00 
  102eef:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  102ef6:	00 
  102ef7:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
  102efe:	00 
  102eff:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  102f06:	e8 be dd ff ff       	call   100cc9 <__panic>
    assert((p2 = alloc_page()) != NULL);
  102f0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f12:	e8 06 0e 00 00       	call   103d1d <alloc_pages>
  102f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102f1e:	75 24                	jne    102f44 <basic_check+0xc4>
  102f20:	c7 44 24 0c d1 65 10 	movl   $0x1065d1,0xc(%esp)
  102f27:	00 
  102f28:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  102f2f:	00 
  102f30:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
  102f37:	00 
  102f38:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  102f3f:	e8 85 dd ff ff       	call   100cc9 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102f44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f47:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102f4a:	74 10                	je     102f5c <basic_check+0xdc>
  102f4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f4f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f52:	74 08                	je     102f5c <basic_check+0xdc>
  102f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f57:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f5a:	75 24                	jne    102f80 <basic_check+0x100>
  102f5c:	c7 44 24 0c f0 65 10 	movl   $0x1065f0,0xc(%esp)
  102f63:	00 
  102f64:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  102f6b:	00 
  102f6c:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  102f73:	00 
  102f74:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  102f7b:	e8 49 dd ff ff       	call   100cc9 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102f80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f83:	89 04 24             	mov    %eax,(%esp)
  102f86:	e8 31 f9 ff ff       	call   1028bc <page_ref>
  102f8b:	85 c0                	test   %eax,%eax
  102f8d:	75 1e                	jne    102fad <basic_check+0x12d>
  102f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f92:	89 04 24             	mov    %eax,(%esp)
  102f95:	e8 22 f9 ff ff       	call   1028bc <page_ref>
  102f9a:	85 c0                	test   %eax,%eax
  102f9c:	75 0f                	jne    102fad <basic_check+0x12d>
  102f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fa1:	89 04 24             	mov    %eax,(%esp)
  102fa4:	e8 13 f9 ff ff       	call   1028bc <page_ref>
  102fa9:	85 c0                	test   %eax,%eax
  102fab:	74 24                	je     102fd1 <basic_check+0x151>
  102fad:	c7 44 24 0c 14 66 10 	movl   $0x106614,0xc(%esp)
  102fb4:	00 
  102fb5:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  102fbc:	00 
  102fbd:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  102fc4:	00 
  102fc5:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  102fcc:	e8 f8 dc ff ff       	call   100cc9 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102fd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fd4:	89 04 24             	mov    %eax,(%esp)
  102fd7:	e8 ca f8 ff ff       	call   1028a6 <page2pa>
  102fdc:	8b 15 e0 88 11 00    	mov    0x1188e0,%edx
  102fe2:	c1 e2 0c             	shl    $0xc,%edx
  102fe5:	39 d0                	cmp    %edx,%eax
  102fe7:	72 24                	jb     10300d <basic_check+0x18d>
  102fe9:	c7 44 24 0c 50 66 10 	movl   $0x106650,0xc(%esp)
  102ff0:	00 
  102ff1:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  102ff8:	00 
  102ff9:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  103000:	00 
  103001:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  103008:	e8 bc dc ff ff       	call   100cc9 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  10300d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103010:	89 04 24             	mov    %eax,(%esp)
  103013:	e8 8e f8 ff ff       	call   1028a6 <page2pa>
  103018:	8b 15 e0 88 11 00    	mov    0x1188e0,%edx
  10301e:	c1 e2 0c             	shl    $0xc,%edx
  103021:	39 d0                	cmp    %edx,%eax
  103023:	72 24                	jb     103049 <basic_check+0x1c9>
  103025:	c7 44 24 0c 6d 66 10 	movl   $0x10666d,0xc(%esp)
  10302c:	00 
  10302d:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  103034:	00 
  103035:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
  10303c:	00 
  10303d:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  103044:	e8 80 dc ff ff       	call   100cc9 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  103049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10304c:	89 04 24             	mov    %eax,(%esp)
  10304f:	e8 52 f8 ff ff       	call   1028a6 <page2pa>
  103054:	8b 15 e0 88 11 00    	mov    0x1188e0,%edx
  10305a:	c1 e2 0c             	shl    $0xc,%edx
  10305d:	39 d0                	cmp    %edx,%eax
  10305f:	72 24                	jb     103085 <basic_check+0x205>
  103061:	c7 44 24 0c 8a 66 10 	movl   $0x10668a,0xc(%esp)
  103068:	00 
  103069:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  103070:	00 
  103071:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
  103078:	00 
  103079:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  103080:	e8 44 dc ff ff       	call   100cc9 <__panic>

    list_entry_t free_list_store = free_list;
  103085:	a1 70 89 11 00       	mov    0x118970,%eax
  10308a:	8b 15 74 89 11 00    	mov    0x118974,%edx
  103090:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103093:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103096:	c7 45 e0 70 89 11 00 	movl   $0x118970,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10309d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1030a3:	89 50 04             	mov    %edx,0x4(%eax)
  1030a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030a9:	8b 50 04             	mov    0x4(%eax),%edx
  1030ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030af:	89 10                	mov    %edx,(%eax)
  1030b1:	c7 45 dc 70 89 11 00 	movl   $0x118970,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1030b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1030bb:	8b 40 04             	mov    0x4(%eax),%eax
  1030be:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1030c1:	0f 94 c0             	sete   %al
  1030c4:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1030c7:	85 c0                	test   %eax,%eax
  1030c9:	75 24                	jne    1030ef <basic_check+0x26f>
  1030cb:	c7 44 24 0c a7 66 10 	movl   $0x1066a7,0xc(%esp)
  1030d2:	00 
  1030d3:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  1030da:	00 
  1030db:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
  1030e2:	00 
  1030e3:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  1030ea:	e8 da db ff ff       	call   100cc9 <__panic>

    unsigned int nr_free_store = nr_free;
  1030ef:	a1 78 89 11 00       	mov    0x118978,%eax
  1030f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  1030f7:	c7 05 78 89 11 00 00 	movl   $0x0,0x118978
  1030fe:	00 00 00 

    assert(alloc_page() == NULL);
  103101:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103108:	e8 10 0c 00 00       	call   103d1d <alloc_pages>
  10310d:	85 c0                	test   %eax,%eax
  10310f:	74 24                	je     103135 <basic_check+0x2b5>
  103111:	c7 44 24 0c be 66 10 	movl   $0x1066be,0xc(%esp)
  103118:	00 
  103119:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  103120:	00 
  103121:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  103128:	00 
  103129:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  103130:	e8 94 db ff ff       	call   100cc9 <__panic>

    free_page(p0);
  103135:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10313c:	00 
  10313d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103140:	89 04 24             	mov    %eax,(%esp)
  103143:	e8 0d 0c 00 00       	call   103d55 <free_pages>
    free_page(p1);
  103148:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10314f:	00 
  103150:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103153:	89 04 24             	mov    %eax,(%esp)
  103156:	e8 fa 0b 00 00       	call   103d55 <free_pages>
    free_page(p2);
  10315b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103162:	00 
  103163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103166:	89 04 24             	mov    %eax,(%esp)
  103169:	e8 e7 0b 00 00       	call   103d55 <free_pages>
    assert(nr_free == 3);
  10316e:	a1 78 89 11 00       	mov    0x118978,%eax
  103173:	83 f8 03             	cmp    $0x3,%eax
  103176:	74 24                	je     10319c <basic_check+0x31c>
  103178:	c7 44 24 0c d3 66 10 	movl   $0x1066d3,0xc(%esp)
  10317f:	00 
  103180:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  103187:	00 
  103188:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  10318f:	00 
  103190:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  103197:	e8 2d db ff ff       	call   100cc9 <__panic>

    assert((p0 = alloc_page()) != NULL);
  10319c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031a3:	e8 75 0b 00 00       	call   103d1d <alloc_pages>
  1031a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1031ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1031af:	75 24                	jne    1031d5 <basic_check+0x355>
  1031b1:	c7 44 24 0c 99 65 10 	movl   $0x106599,0xc(%esp)
  1031b8:	00 
  1031b9:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  1031c0:	00 
  1031c1:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  1031c8:	00 
  1031c9:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  1031d0:	e8 f4 da ff ff       	call   100cc9 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1031d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031dc:	e8 3c 0b 00 00       	call   103d1d <alloc_pages>
  1031e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1031e8:	75 24                	jne    10320e <basic_check+0x38e>
  1031ea:	c7 44 24 0c b5 65 10 	movl   $0x1065b5,0xc(%esp)
  1031f1:	00 
  1031f2:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  1031f9:	00 
  1031fa:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  103201:	00 
  103202:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  103209:	e8 bb da ff ff       	call   100cc9 <__panic>
    assert((p2 = alloc_page()) != NULL);
  10320e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103215:	e8 03 0b 00 00       	call   103d1d <alloc_pages>
  10321a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10321d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103221:	75 24                	jne    103247 <basic_check+0x3c7>
  103223:	c7 44 24 0c d1 65 10 	movl   $0x1065d1,0xc(%esp)
  10322a:	00 
  10322b:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  103232:	00 
  103233:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
  10323a:	00 
  10323b:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  103242:	e8 82 da ff ff       	call   100cc9 <__panic>

    assert(alloc_page() == NULL);
  103247:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10324e:	e8 ca 0a 00 00       	call   103d1d <alloc_pages>
  103253:	85 c0                	test   %eax,%eax
  103255:	74 24                	je     10327b <basic_check+0x3fb>
  103257:	c7 44 24 0c be 66 10 	movl   $0x1066be,0xc(%esp)
  10325e:	00 
  10325f:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  103266:	00 
  103267:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
  10326e:	00 
  10326f:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  103276:	e8 4e da ff ff       	call   100cc9 <__panic>

    free_page(p0);
  10327b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103282:	00 
  103283:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103286:	89 04 24             	mov    %eax,(%esp)
  103289:	e8 c7 0a 00 00       	call   103d55 <free_pages>
  10328e:	c7 45 d8 70 89 11 00 	movl   $0x118970,-0x28(%ebp)
  103295:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103298:	8b 40 04             	mov    0x4(%eax),%eax
  10329b:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  10329e:	0f 94 c0             	sete   %al
  1032a1:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  1032a4:	85 c0                	test   %eax,%eax
  1032a6:	74 24                	je     1032cc <basic_check+0x44c>
  1032a8:	c7 44 24 0c e0 66 10 	movl   $0x1066e0,0xc(%esp)
  1032af:	00 
  1032b0:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  1032b7:	00 
  1032b8:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  1032bf:	00 
  1032c0:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  1032c7:	e8 fd d9 ff ff       	call   100cc9 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1032cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032d3:	e8 45 0a 00 00       	call   103d1d <alloc_pages>
  1032d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1032db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032de:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1032e1:	74 24                	je     103307 <basic_check+0x487>
  1032e3:	c7 44 24 0c f8 66 10 	movl   $0x1066f8,0xc(%esp)
  1032ea:	00 
  1032eb:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  1032f2:	00 
  1032f3:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  1032fa:	00 
  1032fb:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  103302:	e8 c2 d9 ff ff       	call   100cc9 <__panic>
    assert(alloc_page() == NULL);
  103307:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10330e:	e8 0a 0a 00 00       	call   103d1d <alloc_pages>
  103313:	85 c0                	test   %eax,%eax
  103315:	74 24                	je     10333b <basic_check+0x4bb>
  103317:	c7 44 24 0c be 66 10 	movl   $0x1066be,0xc(%esp)
  10331e:	00 
  10331f:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  103326:	00 
  103327:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
  10332e:	00 
  10332f:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  103336:	e8 8e d9 ff ff       	call   100cc9 <__panic>

    assert(nr_free == 0);
  10333b:	a1 78 89 11 00       	mov    0x118978,%eax
  103340:	85 c0                	test   %eax,%eax
  103342:	74 24                	je     103368 <basic_check+0x4e8>
  103344:	c7 44 24 0c 11 67 10 	movl   $0x106711,0xc(%esp)
  10334b:	00 
  10334c:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  103353:	00 
  103354:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
  10335b:	00 
  10335c:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  103363:	e8 61 d9 ff ff       	call   100cc9 <__panic>
    free_list = free_list_store;
  103368:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10336b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10336e:	a3 70 89 11 00       	mov    %eax,0x118970
  103373:	89 15 74 89 11 00    	mov    %edx,0x118974
    nr_free = nr_free_store;
  103379:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10337c:	a3 78 89 11 00       	mov    %eax,0x118978

    free_page(p);
  103381:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103388:	00 
  103389:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10338c:	89 04 24             	mov    %eax,(%esp)
  10338f:	e8 c1 09 00 00       	call   103d55 <free_pages>
    free_page(p1);
  103394:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10339b:	00 
  10339c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10339f:	89 04 24             	mov    %eax,(%esp)
  1033a2:	e8 ae 09 00 00       	call   103d55 <free_pages>
    free_page(p2);
  1033a7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1033ae:	00 
  1033af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033b2:	89 04 24             	mov    %eax,(%esp)
  1033b5:	e8 9b 09 00 00       	call   103d55 <free_pages>
}
  1033ba:	c9                   	leave  
  1033bb:	c3                   	ret    

001033bc <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  1033bc:	55                   	push   %ebp
  1033bd:	89 e5                	mov    %esp,%ebp
  1033bf:	53                   	push   %ebx
  1033c0:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  1033c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1033cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1033d4:	c7 45 ec 70 89 11 00 	movl   $0x118970,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1033db:	eb 6b                	jmp    103448 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  1033dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033e0:	83 e8 0c             	sub    $0xc,%eax
  1033e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  1033e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033e9:	83 c0 04             	add    $0x4,%eax
  1033ec:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1033f3:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1033f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1033f9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1033fc:	0f a3 10             	bt     %edx,(%eax)
  1033ff:	19 c0                	sbb    %eax,%eax
  103401:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  103404:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  103408:	0f 95 c0             	setne  %al
  10340b:	0f b6 c0             	movzbl %al,%eax
  10340e:	85 c0                	test   %eax,%eax
  103410:	75 24                	jne    103436 <default_check+0x7a>
  103412:	c7 44 24 0c 1e 67 10 	movl   $0x10671e,0xc(%esp)
  103419:	00 
  10341a:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  103421:	00 
  103422:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
  103429:	00 
  10342a:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  103431:	e8 93 d8 ff ff       	call   100cc9 <__panic>
        count ++, total += p->property;
  103436:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10343a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10343d:	8b 50 08             	mov    0x8(%eax),%edx
  103440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103443:	01 d0                	add    %edx,%eax
  103445:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103448:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10344b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  10344e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103451:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103454:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103457:	81 7d ec 70 89 11 00 	cmpl   $0x118970,-0x14(%ebp)
  10345e:	0f 85 79 ff ff ff    	jne    1033dd <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  103464:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  103467:	e8 1b 09 00 00       	call   103d87 <nr_free_pages>
  10346c:	39 c3                	cmp    %eax,%ebx
  10346e:	74 24                	je     103494 <default_check+0xd8>
  103470:	c7 44 24 0c 2e 67 10 	movl   $0x10672e,0xc(%esp)
  103477:	00 
  103478:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  10347f:	00 
  103480:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
  103487:	00 
  103488:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  10348f:	e8 35 d8 ff ff       	call   100cc9 <__panic>

    basic_check();
  103494:	e8 e7 f9 ff ff       	call   102e80 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103499:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1034a0:	e8 78 08 00 00       	call   103d1d <alloc_pages>
  1034a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  1034a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1034ac:	75 24                	jne    1034d2 <default_check+0x116>
  1034ae:	c7 44 24 0c 47 67 10 	movl   $0x106747,0xc(%esp)
  1034b5:	00 
  1034b6:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  1034bd:	00 
  1034be:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
  1034c5:	00 
  1034c6:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  1034cd:	e8 f7 d7 ff ff       	call   100cc9 <__panic>
    assert(!PageProperty(p0));
  1034d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034d5:	83 c0 04             	add    $0x4,%eax
  1034d8:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1034df:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1034e2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1034e5:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1034e8:	0f a3 10             	bt     %edx,(%eax)
  1034eb:	19 c0                	sbb    %eax,%eax
  1034ed:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1034f0:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1034f4:	0f 95 c0             	setne  %al
  1034f7:	0f b6 c0             	movzbl %al,%eax
  1034fa:	85 c0                	test   %eax,%eax
  1034fc:	74 24                	je     103522 <default_check+0x166>
  1034fe:	c7 44 24 0c 52 67 10 	movl   $0x106752,0xc(%esp)
  103505:	00 
  103506:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  10350d:	00 
  10350e:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  103515:	00 
  103516:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  10351d:	e8 a7 d7 ff ff       	call   100cc9 <__panic>

    list_entry_t free_list_store = free_list;
  103522:	a1 70 89 11 00       	mov    0x118970,%eax
  103527:	8b 15 74 89 11 00    	mov    0x118974,%edx
  10352d:	89 45 80             	mov    %eax,-0x80(%ebp)
  103530:	89 55 84             	mov    %edx,-0x7c(%ebp)
  103533:	c7 45 b4 70 89 11 00 	movl   $0x118970,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10353a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10353d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103540:	89 50 04             	mov    %edx,0x4(%eax)
  103543:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103546:	8b 50 04             	mov    0x4(%eax),%edx
  103549:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10354c:	89 10                	mov    %edx,(%eax)
  10354e:	c7 45 b0 70 89 11 00 	movl   $0x118970,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103555:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103558:	8b 40 04             	mov    0x4(%eax),%eax
  10355b:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  10355e:	0f 94 c0             	sete   %al
  103561:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103564:	85 c0                	test   %eax,%eax
  103566:	75 24                	jne    10358c <default_check+0x1d0>
  103568:	c7 44 24 0c a7 66 10 	movl   $0x1066a7,0xc(%esp)
  10356f:	00 
  103570:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  103577:	00 
  103578:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  10357f:	00 
  103580:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  103587:	e8 3d d7 ff ff       	call   100cc9 <__panic>
    assert(alloc_page() == NULL);
  10358c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103593:	e8 85 07 00 00       	call   103d1d <alloc_pages>
  103598:	85 c0                	test   %eax,%eax
  10359a:	74 24                	je     1035c0 <default_check+0x204>
  10359c:	c7 44 24 0c be 66 10 	movl   $0x1066be,0xc(%esp)
  1035a3:	00 
  1035a4:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  1035ab:	00 
  1035ac:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  1035b3:	00 
  1035b4:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  1035bb:	e8 09 d7 ff ff       	call   100cc9 <__panic>

    unsigned int nr_free_store = nr_free;
  1035c0:	a1 78 89 11 00       	mov    0x118978,%eax
  1035c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  1035c8:	c7 05 78 89 11 00 00 	movl   $0x0,0x118978
  1035cf:	00 00 00 

    free_pages(p0 + 2, 3);
  1035d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035d5:	83 c0 28             	add    $0x28,%eax
  1035d8:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1035df:	00 
  1035e0:	89 04 24             	mov    %eax,(%esp)
  1035e3:	e8 6d 07 00 00       	call   103d55 <free_pages>
    assert(alloc_pages(4) == NULL);
  1035e8:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1035ef:	e8 29 07 00 00       	call   103d1d <alloc_pages>
  1035f4:	85 c0                	test   %eax,%eax
  1035f6:	74 24                	je     10361c <default_check+0x260>
  1035f8:	c7 44 24 0c 64 67 10 	movl   $0x106764,0xc(%esp)
  1035ff:	00 
  103600:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  103607:	00 
  103608:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  10360f:	00 
  103610:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  103617:	e8 ad d6 ff ff       	call   100cc9 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  10361c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10361f:	83 c0 28             	add    $0x28,%eax
  103622:	83 c0 04             	add    $0x4,%eax
  103625:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  10362c:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10362f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103632:	8b 55 ac             	mov    -0x54(%ebp),%edx
  103635:	0f a3 10             	bt     %edx,(%eax)
  103638:	19 c0                	sbb    %eax,%eax
  10363a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  10363d:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  103641:	0f 95 c0             	setne  %al
  103644:	0f b6 c0             	movzbl %al,%eax
  103647:	85 c0                	test   %eax,%eax
  103649:	74 0e                	je     103659 <default_check+0x29d>
  10364b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10364e:	83 c0 28             	add    $0x28,%eax
  103651:	8b 40 08             	mov    0x8(%eax),%eax
  103654:	83 f8 03             	cmp    $0x3,%eax
  103657:	74 24                	je     10367d <default_check+0x2c1>
  103659:	c7 44 24 0c 7c 67 10 	movl   $0x10677c,0xc(%esp)
  103660:	00 
  103661:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  103668:	00 
  103669:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  103670:	00 
  103671:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  103678:	e8 4c d6 ff ff       	call   100cc9 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  10367d:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  103684:	e8 94 06 00 00       	call   103d1d <alloc_pages>
  103689:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10368c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103690:	75 24                	jne    1036b6 <default_check+0x2fa>
  103692:	c7 44 24 0c a8 67 10 	movl   $0x1067a8,0xc(%esp)
  103699:	00 
  10369a:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  1036a1:	00 
  1036a2:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  1036a9:	00 
  1036aa:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  1036b1:	e8 13 d6 ff ff       	call   100cc9 <__panic>
    assert(alloc_page() == NULL);
  1036b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1036bd:	e8 5b 06 00 00       	call   103d1d <alloc_pages>
  1036c2:	85 c0                	test   %eax,%eax
  1036c4:	74 24                	je     1036ea <default_check+0x32e>
  1036c6:	c7 44 24 0c be 66 10 	movl   $0x1066be,0xc(%esp)
  1036cd:	00 
  1036ce:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  1036d5:	00 
  1036d6:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  1036dd:	00 
  1036de:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  1036e5:	e8 df d5 ff ff       	call   100cc9 <__panic>
    assert(p0 + 2 == p1);
  1036ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036ed:	83 c0 28             	add    $0x28,%eax
  1036f0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1036f3:	74 24                	je     103719 <default_check+0x35d>
  1036f5:	c7 44 24 0c c6 67 10 	movl   $0x1067c6,0xc(%esp)
  1036fc:	00 
  1036fd:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  103704:	00 
  103705:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  10370c:	00 
  10370d:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  103714:	e8 b0 d5 ff ff       	call   100cc9 <__panic>

    p2 = p0 + 1;
  103719:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10371c:	83 c0 14             	add    $0x14,%eax
  10371f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  103722:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103729:	00 
  10372a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10372d:	89 04 24             	mov    %eax,(%esp)
  103730:	e8 20 06 00 00       	call   103d55 <free_pages>
    free_pages(p1, 3);
  103735:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10373c:	00 
  10373d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103740:	89 04 24             	mov    %eax,(%esp)
  103743:	e8 0d 06 00 00       	call   103d55 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  103748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10374b:	83 c0 04             	add    $0x4,%eax
  10374e:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  103755:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103758:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10375b:	8b 55 a0             	mov    -0x60(%ebp),%edx
  10375e:	0f a3 10             	bt     %edx,(%eax)
  103761:	19 c0                	sbb    %eax,%eax
  103763:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  103766:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  10376a:	0f 95 c0             	setne  %al
  10376d:	0f b6 c0             	movzbl %al,%eax
  103770:	85 c0                	test   %eax,%eax
  103772:	74 0b                	je     10377f <default_check+0x3c3>
  103774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103777:	8b 40 08             	mov    0x8(%eax),%eax
  10377a:	83 f8 01             	cmp    $0x1,%eax
  10377d:	74 24                	je     1037a3 <default_check+0x3e7>
  10377f:	c7 44 24 0c d4 67 10 	movl   $0x1067d4,0xc(%esp)
  103786:	00 
  103787:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  10378e:	00 
  10378f:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  103796:	00 
  103797:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  10379e:	e8 26 d5 ff ff       	call   100cc9 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  1037a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1037a6:	83 c0 04             	add    $0x4,%eax
  1037a9:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  1037b0:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1037b3:	8b 45 90             	mov    -0x70(%ebp),%eax
  1037b6:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1037b9:	0f a3 10             	bt     %edx,(%eax)
  1037bc:	19 c0                	sbb    %eax,%eax
  1037be:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  1037c1:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1037c5:	0f 95 c0             	setne  %al
  1037c8:	0f b6 c0             	movzbl %al,%eax
  1037cb:	85 c0                	test   %eax,%eax
  1037cd:	74 0b                	je     1037da <default_check+0x41e>
  1037cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1037d2:	8b 40 08             	mov    0x8(%eax),%eax
  1037d5:	83 f8 03             	cmp    $0x3,%eax
  1037d8:	74 24                	je     1037fe <default_check+0x442>
  1037da:	c7 44 24 0c fc 67 10 	movl   $0x1067fc,0xc(%esp)
  1037e1:	00 
  1037e2:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  1037e9:	00 
  1037ea:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  1037f1:	00 
  1037f2:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  1037f9:	e8 cb d4 ff ff       	call   100cc9 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1037fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103805:	e8 13 05 00 00       	call   103d1d <alloc_pages>
  10380a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10380d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103810:	83 e8 14             	sub    $0x14,%eax
  103813:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103816:	74 24                	je     10383c <default_check+0x480>
  103818:	c7 44 24 0c 22 68 10 	movl   $0x106822,0xc(%esp)
  10381f:	00 
  103820:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  103827:	00 
  103828:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  10382f:	00 
  103830:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  103837:	e8 8d d4 ff ff       	call   100cc9 <__panic>
    free_page(p0);
  10383c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103843:	00 
  103844:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103847:	89 04 24             	mov    %eax,(%esp)
  10384a:	e8 06 05 00 00       	call   103d55 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  10384f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103856:	e8 c2 04 00 00       	call   103d1d <alloc_pages>
  10385b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10385e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103861:	83 c0 14             	add    $0x14,%eax
  103864:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103867:	74 24                	je     10388d <default_check+0x4d1>
  103869:	c7 44 24 0c 40 68 10 	movl   $0x106840,0xc(%esp)
  103870:	00 
  103871:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  103878:	00 
  103879:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
  103880:	00 
  103881:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  103888:	e8 3c d4 ff ff       	call   100cc9 <__panic>

    free_pages(p0, 2);
  10388d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103894:	00 
  103895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103898:	89 04 24             	mov    %eax,(%esp)
  10389b:	e8 b5 04 00 00       	call   103d55 <free_pages>
    free_page(p2);
  1038a0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1038a7:	00 
  1038a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1038ab:	89 04 24             	mov    %eax,(%esp)
  1038ae:	e8 a2 04 00 00       	call   103d55 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  1038b3:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1038ba:	e8 5e 04 00 00       	call   103d1d <alloc_pages>
  1038bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1038c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1038c6:	75 24                	jne    1038ec <default_check+0x530>
  1038c8:	c7 44 24 0c 60 68 10 	movl   $0x106860,0xc(%esp)
  1038cf:	00 
  1038d0:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  1038d7:	00 
  1038d8:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
  1038df:	00 
  1038e0:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  1038e7:	e8 dd d3 ff ff       	call   100cc9 <__panic>
    assert(alloc_page() == NULL);
  1038ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1038f3:	e8 25 04 00 00       	call   103d1d <alloc_pages>
  1038f8:	85 c0                	test   %eax,%eax
  1038fa:	74 24                	je     103920 <default_check+0x564>
  1038fc:	c7 44 24 0c be 66 10 	movl   $0x1066be,0xc(%esp)
  103903:	00 
  103904:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  10390b:	00 
  10390c:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  103913:	00 
  103914:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  10391b:	e8 a9 d3 ff ff       	call   100cc9 <__panic>

    assert(nr_free == 0);
  103920:	a1 78 89 11 00       	mov    0x118978,%eax
  103925:	85 c0                	test   %eax,%eax
  103927:	74 24                	je     10394d <default_check+0x591>
  103929:	c7 44 24 0c 11 67 10 	movl   $0x106711,0xc(%esp)
  103930:	00 
  103931:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  103938:	00 
  103939:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  103940:	00 
  103941:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  103948:	e8 7c d3 ff ff       	call   100cc9 <__panic>
    nr_free = nr_free_store;
  10394d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103950:	a3 78 89 11 00       	mov    %eax,0x118978

    free_list = free_list_store;
  103955:	8b 45 80             	mov    -0x80(%ebp),%eax
  103958:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10395b:	a3 70 89 11 00       	mov    %eax,0x118970
  103960:	89 15 74 89 11 00    	mov    %edx,0x118974
    free_pages(p0, 5);
  103966:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  10396d:	00 
  10396e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103971:	89 04 24             	mov    %eax,(%esp)
  103974:	e8 dc 03 00 00       	call   103d55 <free_pages>

    le = &free_list;
  103979:	c7 45 ec 70 89 11 00 	movl   $0x118970,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103980:	eb 1d                	jmp    10399f <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  103982:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103985:	83 e8 0c             	sub    $0xc,%eax
  103988:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  10398b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10398f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103992:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103995:	8b 40 08             	mov    0x8(%eax),%eax
  103998:	29 c2                	sub    %eax,%edx
  10399a:	89 d0                	mov    %edx,%eax
  10399c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10399f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039a2:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1039a5:	8b 45 88             	mov    -0x78(%ebp),%eax
  1039a8:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1039ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1039ae:	81 7d ec 70 89 11 00 	cmpl   $0x118970,-0x14(%ebp)
  1039b5:	75 cb                	jne    103982 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  1039b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1039bb:	74 24                	je     1039e1 <default_check+0x625>
  1039bd:	c7 44 24 0c 7e 68 10 	movl   $0x10687e,0xc(%esp)
  1039c4:	00 
  1039c5:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  1039cc:	00 
  1039cd:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  1039d4:	00 
  1039d5:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  1039dc:	e8 e8 d2 ff ff       	call   100cc9 <__panic>
    assert(total == 0);
  1039e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1039e5:	74 24                	je     103a0b <default_check+0x64f>
  1039e7:	c7 44 24 0c 89 68 10 	movl   $0x106889,0xc(%esp)
  1039ee:	00 
  1039ef:	c7 44 24 08 36 65 10 	movl   $0x106536,0x8(%esp)
  1039f6:	00 
  1039f7:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  1039fe:	00 
  1039ff:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  103a06:	e8 be d2 ff ff       	call   100cc9 <__panic>
}
  103a0b:	81 c4 94 00 00 00    	add    $0x94,%esp
  103a11:	5b                   	pop    %ebx
  103a12:	5d                   	pop    %ebp
  103a13:	c3                   	ret    

00103a14 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103a14:	55                   	push   %ebp
  103a15:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103a17:	8b 55 08             	mov    0x8(%ebp),%edx
  103a1a:	a1 84 89 11 00       	mov    0x118984,%eax
  103a1f:	29 c2                	sub    %eax,%edx
  103a21:	89 d0                	mov    %edx,%eax
  103a23:	c1 f8 02             	sar    $0x2,%eax
  103a26:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103a2c:	5d                   	pop    %ebp
  103a2d:	c3                   	ret    

00103a2e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103a2e:	55                   	push   %ebp
  103a2f:	89 e5                	mov    %esp,%ebp
  103a31:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103a34:	8b 45 08             	mov    0x8(%ebp),%eax
  103a37:	89 04 24             	mov    %eax,(%esp)
  103a3a:	e8 d5 ff ff ff       	call   103a14 <page2ppn>
  103a3f:	c1 e0 0c             	shl    $0xc,%eax
}
  103a42:	c9                   	leave  
  103a43:	c3                   	ret    

00103a44 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103a44:	55                   	push   %ebp
  103a45:	89 e5                	mov    %esp,%ebp
  103a47:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  103a4d:	c1 e8 0c             	shr    $0xc,%eax
  103a50:	89 c2                	mov    %eax,%edx
  103a52:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  103a57:	39 c2                	cmp    %eax,%edx
  103a59:	72 1c                	jb     103a77 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103a5b:	c7 44 24 08 c4 68 10 	movl   $0x1068c4,0x8(%esp)
  103a62:	00 
  103a63:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103a6a:	00 
  103a6b:	c7 04 24 e3 68 10 00 	movl   $0x1068e3,(%esp)
  103a72:	e8 52 d2 ff ff       	call   100cc9 <__panic>
    }
    return &pages[PPN(pa)];
  103a77:	8b 0d 84 89 11 00    	mov    0x118984,%ecx
  103a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  103a80:	c1 e8 0c             	shr    $0xc,%eax
  103a83:	89 c2                	mov    %eax,%edx
  103a85:	89 d0                	mov    %edx,%eax
  103a87:	c1 e0 02             	shl    $0x2,%eax
  103a8a:	01 d0                	add    %edx,%eax
  103a8c:	c1 e0 02             	shl    $0x2,%eax
  103a8f:	01 c8                	add    %ecx,%eax
}
  103a91:	c9                   	leave  
  103a92:	c3                   	ret    

00103a93 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103a93:	55                   	push   %ebp
  103a94:	89 e5                	mov    %esp,%ebp
  103a96:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103a99:	8b 45 08             	mov    0x8(%ebp),%eax
  103a9c:	89 04 24             	mov    %eax,(%esp)
  103a9f:	e8 8a ff ff ff       	call   103a2e <page2pa>
  103aa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103aaa:	c1 e8 0c             	shr    $0xc,%eax
  103aad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103ab0:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  103ab5:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103ab8:	72 23                	jb     103add <page2kva+0x4a>
  103aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103abd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103ac1:	c7 44 24 08 f4 68 10 	movl   $0x1068f4,0x8(%esp)
  103ac8:	00 
  103ac9:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103ad0:	00 
  103ad1:	c7 04 24 e3 68 10 00 	movl   $0x1068e3,(%esp)
  103ad8:	e8 ec d1 ff ff       	call   100cc9 <__panic>
  103add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ae0:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103ae5:	c9                   	leave  
  103ae6:	c3                   	ret    

00103ae7 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103ae7:	55                   	push   %ebp
  103ae8:	89 e5                	mov    %esp,%ebp
  103aea:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103aed:	8b 45 08             	mov    0x8(%ebp),%eax
  103af0:	83 e0 01             	and    $0x1,%eax
  103af3:	85 c0                	test   %eax,%eax
  103af5:	75 1c                	jne    103b13 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103af7:	c7 44 24 08 18 69 10 	movl   $0x106918,0x8(%esp)
  103afe:	00 
  103aff:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103b06:	00 
  103b07:	c7 04 24 e3 68 10 00 	movl   $0x1068e3,(%esp)
  103b0e:	e8 b6 d1 ff ff       	call   100cc9 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103b13:	8b 45 08             	mov    0x8(%ebp),%eax
  103b16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103b1b:	89 04 24             	mov    %eax,(%esp)
  103b1e:	e8 21 ff ff ff       	call   103a44 <pa2page>
}
  103b23:	c9                   	leave  
  103b24:	c3                   	ret    

00103b25 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103b25:	55                   	push   %ebp
  103b26:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103b28:	8b 45 08             	mov    0x8(%ebp),%eax
  103b2b:	8b 00                	mov    (%eax),%eax
}
  103b2d:	5d                   	pop    %ebp
  103b2e:	c3                   	ret    

00103b2f <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
  103b2f:	55                   	push   %ebp
  103b30:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103b32:	8b 45 08             	mov    0x8(%ebp),%eax
  103b35:	8b 00                	mov    (%eax),%eax
  103b37:	8d 50 01             	lea    0x1(%eax),%edx
  103b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  103b3d:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  103b42:	8b 00                	mov    (%eax),%eax
}
  103b44:	5d                   	pop    %ebp
  103b45:	c3                   	ret    

00103b46 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103b46:	55                   	push   %ebp
  103b47:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103b49:	8b 45 08             	mov    0x8(%ebp),%eax
  103b4c:	8b 00                	mov    (%eax),%eax
  103b4e:	8d 50 ff             	lea    -0x1(%eax),%edx
  103b51:	8b 45 08             	mov    0x8(%ebp),%eax
  103b54:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103b56:	8b 45 08             	mov    0x8(%ebp),%eax
  103b59:	8b 00                	mov    (%eax),%eax
}
  103b5b:	5d                   	pop    %ebp
  103b5c:	c3                   	ret    

00103b5d <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103b5d:	55                   	push   %ebp
  103b5e:	89 e5                	mov    %esp,%ebp
  103b60:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103b63:	9c                   	pushf  
  103b64:	58                   	pop    %eax
  103b65:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103b6b:	25 00 02 00 00       	and    $0x200,%eax
  103b70:	85 c0                	test   %eax,%eax
  103b72:	74 0c                	je     103b80 <__intr_save+0x23>
        intr_disable();
  103b74:	e8 33 db ff ff       	call   1016ac <intr_disable>
        return 1;
  103b79:	b8 01 00 00 00       	mov    $0x1,%eax
  103b7e:	eb 05                	jmp    103b85 <__intr_save+0x28>
    }
    return 0;
  103b80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103b85:	c9                   	leave  
  103b86:	c3                   	ret    

00103b87 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103b87:	55                   	push   %ebp
  103b88:	89 e5                	mov    %esp,%ebp
  103b8a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103b8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103b91:	74 05                	je     103b98 <__intr_restore+0x11>
        intr_enable();
  103b93:	e8 0e db ff ff       	call   1016a6 <intr_enable>
    }
}
  103b98:	c9                   	leave  
  103b99:	c3                   	ret    

00103b9a <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103b9a:	55                   	push   %ebp
  103b9b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  103ba0:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103ba3:	b8 23 00 00 00       	mov    $0x23,%eax
  103ba8:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103baa:	b8 23 00 00 00       	mov    $0x23,%eax
  103baf:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103bb1:	b8 10 00 00 00       	mov    $0x10,%eax
  103bb6:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103bb8:	b8 10 00 00 00       	mov    $0x10,%eax
  103bbd:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103bbf:	b8 10 00 00 00       	mov    $0x10,%eax
  103bc4:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103bc6:	ea cd 3b 10 00 08 00 	ljmp   $0x8,$0x103bcd
}
  103bcd:	5d                   	pop    %ebp
  103bce:	c3                   	ret    

00103bcf <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103bcf:	55                   	push   %ebp
  103bd0:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  103bd5:	a3 04 89 11 00       	mov    %eax,0x118904
}
  103bda:	5d                   	pop    %ebp
  103bdb:	c3                   	ret    

00103bdc <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103bdc:	55                   	push   %ebp
  103bdd:	89 e5                	mov    %esp,%ebp
  103bdf:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103be2:	b8 00 70 11 00       	mov    $0x117000,%eax
  103be7:	89 04 24             	mov    %eax,(%esp)
  103bea:	e8 e0 ff ff ff       	call   103bcf <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103bef:	66 c7 05 08 89 11 00 	movw   $0x10,0x118908
  103bf6:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103bf8:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103bff:	68 00 
  103c01:	b8 00 89 11 00       	mov    $0x118900,%eax
  103c06:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103c0c:	b8 00 89 11 00       	mov    $0x118900,%eax
  103c11:	c1 e8 10             	shr    $0x10,%eax
  103c14:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103c19:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c20:	83 e0 f0             	and    $0xfffffff0,%eax
  103c23:	83 c8 09             	or     $0x9,%eax
  103c26:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c2b:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c32:	83 e0 ef             	and    $0xffffffef,%eax
  103c35:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c3a:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c41:	83 e0 9f             	and    $0xffffff9f,%eax
  103c44:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c49:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c50:	83 c8 80             	or     $0xffffff80,%eax
  103c53:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c58:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c5f:	83 e0 f0             	and    $0xfffffff0,%eax
  103c62:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c67:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c6e:	83 e0 ef             	and    $0xffffffef,%eax
  103c71:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c76:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c7d:	83 e0 df             	and    $0xffffffdf,%eax
  103c80:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c85:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c8c:	83 c8 40             	or     $0x40,%eax
  103c8f:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c94:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c9b:	83 e0 7f             	and    $0x7f,%eax
  103c9e:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103ca3:	b8 00 89 11 00       	mov    $0x118900,%eax
  103ca8:	c1 e8 18             	shr    $0x18,%eax
  103cab:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103cb0:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103cb7:	e8 de fe ff ff       	call   103b9a <lgdt>
  103cbc:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103cc2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103cc6:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103cc9:	c9                   	leave  
  103cca:	c3                   	ret    

00103ccb <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103ccb:	55                   	push   %ebp
  103ccc:	89 e5                	mov    %esp,%ebp
  103cce:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103cd1:	c7 05 7c 89 11 00 a8 	movl   $0x1068a8,0x11897c
  103cd8:	68 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103cdb:	a1 7c 89 11 00       	mov    0x11897c,%eax
  103ce0:	8b 00                	mov    (%eax),%eax
  103ce2:	89 44 24 04          	mov    %eax,0x4(%esp)
  103ce6:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  103ced:	e8 4a c6 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103cf2:	a1 7c 89 11 00       	mov    0x11897c,%eax
  103cf7:	8b 40 04             	mov    0x4(%eax),%eax
  103cfa:	ff d0                	call   *%eax
}
  103cfc:	c9                   	leave  
  103cfd:	c3                   	ret    

00103cfe <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103cfe:	55                   	push   %ebp
  103cff:	89 e5                	mov    %esp,%ebp
  103d01:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103d04:	a1 7c 89 11 00       	mov    0x11897c,%eax
  103d09:	8b 40 08             	mov    0x8(%eax),%eax
  103d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d0f:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d13:	8b 55 08             	mov    0x8(%ebp),%edx
  103d16:	89 14 24             	mov    %edx,(%esp)
  103d19:	ff d0                	call   *%eax
}
  103d1b:	c9                   	leave  
  103d1c:	c3                   	ret    

00103d1d <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103d1d:	55                   	push   %ebp
  103d1e:	89 e5                	mov    %esp,%ebp
  103d20:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103d23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103d2a:	e8 2e fe ff ff       	call   103b5d <__intr_save>
  103d2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103d32:	a1 7c 89 11 00       	mov    0x11897c,%eax
  103d37:	8b 40 0c             	mov    0xc(%eax),%eax
  103d3a:	8b 55 08             	mov    0x8(%ebp),%edx
  103d3d:	89 14 24             	mov    %edx,(%esp)
  103d40:	ff d0                	call   *%eax
  103d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d48:	89 04 24             	mov    %eax,(%esp)
  103d4b:	e8 37 fe ff ff       	call   103b87 <__intr_restore>
    return page;
  103d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103d53:	c9                   	leave  
  103d54:	c3                   	ret    

00103d55 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103d55:	55                   	push   %ebp
  103d56:	89 e5                	mov    %esp,%ebp
  103d58:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103d5b:	e8 fd fd ff ff       	call   103b5d <__intr_save>
  103d60:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103d63:	a1 7c 89 11 00       	mov    0x11897c,%eax
  103d68:	8b 40 10             	mov    0x10(%eax),%eax
  103d6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d6e:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d72:	8b 55 08             	mov    0x8(%ebp),%edx
  103d75:	89 14 24             	mov    %edx,(%esp)
  103d78:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d7d:	89 04 24             	mov    %eax,(%esp)
  103d80:	e8 02 fe ff ff       	call   103b87 <__intr_restore>
}
  103d85:	c9                   	leave  
  103d86:	c3                   	ret    

00103d87 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103d87:	55                   	push   %ebp
  103d88:	89 e5                	mov    %esp,%ebp
  103d8a:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103d8d:	e8 cb fd ff ff       	call   103b5d <__intr_save>
  103d92:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103d95:	a1 7c 89 11 00       	mov    0x11897c,%eax
  103d9a:	8b 40 14             	mov    0x14(%eax),%eax
  103d9d:	ff d0                	call   *%eax
  103d9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103da5:	89 04 24             	mov    %eax,(%esp)
  103da8:	e8 da fd ff ff       	call   103b87 <__intr_restore>
    return ret;
  103dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103db0:	c9                   	leave  
  103db1:	c3                   	ret    

00103db2 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103db2:	55                   	push   %ebp
  103db3:	89 e5                	mov    %esp,%ebp
  103db5:	57                   	push   %edi
  103db6:	56                   	push   %esi
  103db7:	53                   	push   %ebx
  103db8:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103dbe:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103dc5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103dcc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103dd3:	c7 04 24 5b 69 10 00 	movl   $0x10695b,(%esp)
  103dda:	e8 5d c5 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103ddf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103de6:	e9 15 01 00 00       	jmp    103f00 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103deb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dee:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103df1:	89 d0                	mov    %edx,%eax
  103df3:	c1 e0 02             	shl    $0x2,%eax
  103df6:	01 d0                	add    %edx,%eax
  103df8:	c1 e0 02             	shl    $0x2,%eax
  103dfb:	01 c8                	add    %ecx,%eax
  103dfd:	8b 50 08             	mov    0x8(%eax),%edx
  103e00:	8b 40 04             	mov    0x4(%eax),%eax
  103e03:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103e06:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103e09:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e0f:	89 d0                	mov    %edx,%eax
  103e11:	c1 e0 02             	shl    $0x2,%eax
  103e14:	01 d0                	add    %edx,%eax
  103e16:	c1 e0 02             	shl    $0x2,%eax
  103e19:	01 c8                	add    %ecx,%eax
  103e1b:	8b 48 0c             	mov    0xc(%eax),%ecx
  103e1e:	8b 58 10             	mov    0x10(%eax),%ebx
  103e21:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e24:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e27:	01 c8                	add    %ecx,%eax
  103e29:	11 da                	adc    %ebx,%edx
  103e2b:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103e2e:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103e31:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e34:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e37:	89 d0                	mov    %edx,%eax
  103e39:	c1 e0 02             	shl    $0x2,%eax
  103e3c:	01 d0                	add    %edx,%eax
  103e3e:	c1 e0 02             	shl    $0x2,%eax
  103e41:	01 c8                	add    %ecx,%eax
  103e43:	83 c0 14             	add    $0x14,%eax
  103e46:	8b 00                	mov    (%eax),%eax
  103e48:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103e4e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103e51:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103e54:	83 c0 ff             	add    $0xffffffff,%eax
  103e57:	83 d2 ff             	adc    $0xffffffff,%edx
  103e5a:	89 c6                	mov    %eax,%esi
  103e5c:	89 d7                	mov    %edx,%edi
  103e5e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e61:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e64:	89 d0                	mov    %edx,%eax
  103e66:	c1 e0 02             	shl    $0x2,%eax
  103e69:	01 d0                	add    %edx,%eax
  103e6b:	c1 e0 02             	shl    $0x2,%eax
  103e6e:	01 c8                	add    %ecx,%eax
  103e70:	8b 48 0c             	mov    0xc(%eax),%ecx
  103e73:	8b 58 10             	mov    0x10(%eax),%ebx
  103e76:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103e7c:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103e80:	89 74 24 14          	mov    %esi,0x14(%esp)
  103e84:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103e88:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e8b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e8e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103e92:	89 54 24 10          	mov    %edx,0x10(%esp)
  103e96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103e9a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103e9e:	c7 04 24 68 69 10 00 	movl   $0x106968,(%esp)
  103ea5:	e8 92 c4 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103eaa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103ead:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103eb0:	89 d0                	mov    %edx,%eax
  103eb2:	c1 e0 02             	shl    $0x2,%eax
  103eb5:	01 d0                	add    %edx,%eax
  103eb7:	c1 e0 02             	shl    $0x2,%eax
  103eba:	01 c8                	add    %ecx,%eax
  103ebc:	83 c0 14             	add    $0x14,%eax
  103ebf:	8b 00                	mov    (%eax),%eax
  103ec1:	83 f8 01             	cmp    $0x1,%eax
  103ec4:	75 36                	jne    103efc <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103ec6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103ec9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103ecc:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103ecf:	77 2b                	ja     103efc <page_init+0x14a>
  103ed1:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103ed4:	72 05                	jb     103edb <page_init+0x129>
  103ed6:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103ed9:	73 21                	jae    103efc <page_init+0x14a>
  103edb:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103edf:	77 1b                	ja     103efc <page_init+0x14a>
  103ee1:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103ee5:	72 09                	jb     103ef0 <page_init+0x13e>
  103ee7:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103eee:	77 0c                	ja     103efc <page_init+0x14a>
                maxpa = end;
  103ef0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103ef3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103ef6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103ef9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103efc:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103f00:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103f03:	8b 00                	mov    (%eax),%eax
  103f05:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103f08:	0f 8f dd fe ff ff    	jg     103deb <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103f0e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103f12:	72 1d                	jb     103f31 <page_init+0x17f>
  103f14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103f18:	77 09                	ja     103f23 <page_init+0x171>
  103f1a:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103f21:	76 0e                	jbe    103f31 <page_init+0x17f>
        maxpa = KMEMSIZE;
  103f23:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103f2a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103f31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103f37:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103f3b:	c1 ea 0c             	shr    $0xc,%edx
  103f3e:	a3 e0 88 11 00       	mov    %eax,0x1188e0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103f43:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103f4a:	b8 88 89 11 00       	mov    $0x118988,%eax
  103f4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  103f52:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103f55:	01 d0                	add    %edx,%eax
  103f57:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103f5a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103f5d:	ba 00 00 00 00       	mov    $0x0,%edx
  103f62:	f7 75 ac             	divl   -0x54(%ebp)
  103f65:	89 d0                	mov    %edx,%eax
  103f67:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103f6a:	29 c2                	sub    %eax,%edx
  103f6c:	89 d0                	mov    %edx,%eax
  103f6e:	a3 84 89 11 00       	mov    %eax,0x118984

    for (i = 0; i < npage; i ++) {
  103f73:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103f7a:	eb 2f                	jmp    103fab <page_init+0x1f9>
        SetPageReserved(pages + i);
  103f7c:	8b 0d 84 89 11 00    	mov    0x118984,%ecx
  103f82:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f85:	89 d0                	mov    %edx,%eax
  103f87:	c1 e0 02             	shl    $0x2,%eax
  103f8a:	01 d0                	add    %edx,%eax
  103f8c:	c1 e0 02             	shl    $0x2,%eax
  103f8f:	01 c8                	add    %ecx,%eax
  103f91:	83 c0 04             	add    $0x4,%eax
  103f94:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103f9b:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103f9e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103fa1:	8b 55 90             	mov    -0x70(%ebp),%edx
  103fa4:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  103fa7:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103fab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fae:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  103fb3:	39 c2                	cmp    %eax,%edx
  103fb5:	72 c5                	jb     103f7c <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103fb7:	8b 15 e0 88 11 00    	mov    0x1188e0,%edx
  103fbd:	89 d0                	mov    %edx,%eax
  103fbf:	c1 e0 02             	shl    $0x2,%eax
  103fc2:	01 d0                	add    %edx,%eax
  103fc4:	c1 e0 02             	shl    $0x2,%eax
  103fc7:	89 c2                	mov    %eax,%edx
  103fc9:	a1 84 89 11 00       	mov    0x118984,%eax
  103fce:	01 d0                	add    %edx,%eax
  103fd0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  103fd3:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  103fda:	77 23                	ja     103fff <page_init+0x24d>
  103fdc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103fdf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103fe3:	c7 44 24 08 98 69 10 	movl   $0x106998,0x8(%esp)
  103fea:	00 
  103feb:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103ff2:	00 
  103ff3:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  103ffa:	e8 ca cc ff ff       	call   100cc9 <__panic>
  103fff:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104002:	05 00 00 00 40       	add    $0x40000000,%eax
  104007:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  10400a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104011:	e9 74 01 00 00       	jmp    10418a <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  104016:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104019:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10401c:	89 d0                	mov    %edx,%eax
  10401e:	c1 e0 02             	shl    $0x2,%eax
  104021:	01 d0                	add    %edx,%eax
  104023:	c1 e0 02             	shl    $0x2,%eax
  104026:	01 c8                	add    %ecx,%eax
  104028:	8b 50 08             	mov    0x8(%eax),%edx
  10402b:	8b 40 04             	mov    0x4(%eax),%eax
  10402e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104031:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104034:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104037:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10403a:	89 d0                	mov    %edx,%eax
  10403c:	c1 e0 02             	shl    $0x2,%eax
  10403f:	01 d0                	add    %edx,%eax
  104041:	c1 e0 02             	shl    $0x2,%eax
  104044:	01 c8                	add    %ecx,%eax
  104046:	8b 48 0c             	mov    0xc(%eax),%ecx
  104049:	8b 58 10             	mov    0x10(%eax),%ebx
  10404c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10404f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104052:	01 c8                	add    %ecx,%eax
  104054:	11 da                	adc    %ebx,%edx
  104056:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104059:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  10405c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10405f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104062:	89 d0                	mov    %edx,%eax
  104064:	c1 e0 02             	shl    $0x2,%eax
  104067:	01 d0                	add    %edx,%eax
  104069:	c1 e0 02             	shl    $0x2,%eax
  10406c:	01 c8                	add    %ecx,%eax
  10406e:	83 c0 14             	add    $0x14,%eax
  104071:	8b 00                	mov    (%eax),%eax
  104073:	83 f8 01             	cmp    $0x1,%eax
  104076:	0f 85 0a 01 00 00    	jne    104186 <page_init+0x3d4>
            if (begin < freemem) {
  10407c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10407f:	ba 00 00 00 00       	mov    $0x0,%edx
  104084:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104087:	72 17                	jb     1040a0 <page_init+0x2ee>
  104089:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10408c:	77 05                	ja     104093 <page_init+0x2e1>
  10408e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  104091:	76 0d                	jbe    1040a0 <page_init+0x2ee>
                begin = freemem;
  104093:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104096:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104099:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  1040a0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1040a4:	72 1d                	jb     1040c3 <page_init+0x311>
  1040a6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1040aa:	77 09                	ja     1040b5 <page_init+0x303>
  1040ac:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  1040b3:	76 0e                	jbe    1040c3 <page_init+0x311>
                end = KMEMSIZE;
  1040b5:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1040bc:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1040c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1040c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1040c9:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040cc:	0f 87 b4 00 00 00    	ja     104186 <page_init+0x3d4>
  1040d2:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040d5:	72 09                	jb     1040e0 <page_init+0x32e>
  1040d7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1040da:	0f 83 a6 00 00 00    	jae    104186 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  1040e0:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  1040e7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1040ea:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1040ed:	01 d0                	add    %edx,%eax
  1040ef:	83 e8 01             	sub    $0x1,%eax
  1040f2:	89 45 98             	mov    %eax,-0x68(%ebp)
  1040f5:	8b 45 98             	mov    -0x68(%ebp),%eax
  1040f8:	ba 00 00 00 00       	mov    $0x0,%edx
  1040fd:	f7 75 9c             	divl   -0x64(%ebp)
  104100:	89 d0                	mov    %edx,%eax
  104102:	8b 55 98             	mov    -0x68(%ebp),%edx
  104105:	29 c2                	sub    %eax,%edx
  104107:	89 d0                	mov    %edx,%eax
  104109:	ba 00 00 00 00       	mov    $0x0,%edx
  10410e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104111:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  104114:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104117:	89 45 94             	mov    %eax,-0x6c(%ebp)
  10411a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  10411d:	ba 00 00 00 00       	mov    $0x0,%edx
  104122:	89 c7                	mov    %eax,%edi
  104124:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  10412a:	89 7d 80             	mov    %edi,-0x80(%ebp)
  10412d:	89 d0                	mov    %edx,%eax
  10412f:	83 e0 00             	and    $0x0,%eax
  104132:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104135:	8b 45 80             	mov    -0x80(%ebp),%eax
  104138:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10413b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10413e:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  104141:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104144:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104147:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10414a:	77 3a                	ja     104186 <page_init+0x3d4>
  10414c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10414f:	72 05                	jb     104156 <page_init+0x3a4>
  104151:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104154:	73 30                	jae    104186 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  104156:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  104159:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  10415c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10415f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104162:	29 c8                	sub    %ecx,%eax
  104164:	19 da                	sbb    %ebx,%edx
  104166:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10416a:	c1 ea 0c             	shr    $0xc,%edx
  10416d:	89 c3                	mov    %eax,%ebx
  10416f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104172:	89 04 24             	mov    %eax,(%esp)
  104175:	e8 ca f8 ff ff       	call   103a44 <pa2page>
  10417a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10417e:	89 04 24             	mov    %eax,(%esp)
  104181:	e8 78 fb ff ff       	call   103cfe <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  104186:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  10418a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10418d:	8b 00                	mov    (%eax),%eax
  10418f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104192:	0f 8f 7e fe ff ff    	jg     104016 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  104198:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  10419e:	5b                   	pop    %ebx
  10419f:	5e                   	pop    %esi
  1041a0:	5f                   	pop    %edi
  1041a1:	5d                   	pop    %ebp
  1041a2:	c3                   	ret    

001041a3 <enable_paging>:

static void
enable_paging(void) {
  1041a3:	55                   	push   %ebp
  1041a4:	89 e5                	mov    %esp,%ebp
  1041a6:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  1041a9:	a1 80 89 11 00       	mov    0x118980,%eax
  1041ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  1041b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1041b4:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  1041b7:	0f 20 c0             	mov    %cr0,%eax
  1041ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  1041bd:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  1041c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  1041c3:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  1041ca:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  1041ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1041d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  1041d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041d7:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  1041da:	c9                   	leave  
  1041db:	c3                   	ret    

001041dc <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1041dc:	55                   	push   %ebp
  1041dd:	89 e5                	mov    %esp,%ebp
  1041df:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1041e2:	8b 45 14             	mov    0x14(%ebp),%eax
  1041e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1041e8:	31 d0                	xor    %edx,%eax
  1041ea:	25 ff 0f 00 00       	and    $0xfff,%eax
  1041ef:	85 c0                	test   %eax,%eax
  1041f1:	74 24                	je     104217 <boot_map_segment+0x3b>
  1041f3:	c7 44 24 0c ca 69 10 	movl   $0x1069ca,0xc(%esp)
  1041fa:	00 
  1041fb:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104202:	00 
  104203:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  10420a:	00 
  10420b:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104212:	e8 b2 ca ff ff       	call   100cc9 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  104217:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  10421e:	8b 45 0c             	mov    0xc(%ebp),%eax
  104221:	25 ff 0f 00 00       	and    $0xfff,%eax
  104226:	89 c2                	mov    %eax,%edx
  104228:	8b 45 10             	mov    0x10(%ebp),%eax
  10422b:	01 c2                	add    %eax,%edx
  10422d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104230:	01 d0                	add    %edx,%eax
  104232:	83 e8 01             	sub    $0x1,%eax
  104235:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104238:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10423b:	ba 00 00 00 00       	mov    $0x0,%edx
  104240:	f7 75 f0             	divl   -0x10(%ebp)
  104243:	89 d0                	mov    %edx,%eax
  104245:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104248:	29 c2                	sub    %eax,%edx
  10424a:	89 d0                	mov    %edx,%eax
  10424c:	c1 e8 0c             	shr    $0xc,%eax
  10424f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  104252:	8b 45 0c             	mov    0xc(%ebp),%eax
  104255:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104258:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10425b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104260:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104263:	8b 45 14             	mov    0x14(%ebp),%eax
  104266:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104269:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10426c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104271:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104274:	eb 6b                	jmp    1042e1 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  104276:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10427d:	00 
  10427e:	8b 45 0c             	mov    0xc(%ebp),%eax
  104281:	89 44 24 04          	mov    %eax,0x4(%esp)
  104285:	8b 45 08             	mov    0x8(%ebp),%eax
  104288:	89 04 24             	mov    %eax,(%esp)
  10428b:	e8 cc 01 00 00       	call   10445c <get_pte>
  104290:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  104293:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104297:	75 24                	jne    1042bd <boot_map_segment+0xe1>
  104299:	c7 44 24 0c f6 69 10 	movl   $0x1069f6,0xc(%esp)
  1042a0:	00 
  1042a1:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  1042a8:	00 
  1042a9:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  1042b0:	00 
  1042b1:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  1042b8:	e8 0c ca ff ff       	call   100cc9 <__panic>
        *ptep = pa | PTE_P | perm;
  1042bd:	8b 45 18             	mov    0x18(%ebp),%eax
  1042c0:	8b 55 14             	mov    0x14(%ebp),%edx
  1042c3:	09 d0                	or     %edx,%eax
  1042c5:	83 c8 01             	or     $0x1,%eax
  1042c8:	89 c2                	mov    %eax,%edx
  1042ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1042cd:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1042cf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1042d3:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1042da:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1042e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1042e5:	75 8f                	jne    104276 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  1042e7:	c9                   	leave  
  1042e8:	c3                   	ret    

001042e9 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1042e9:	55                   	push   %ebp
  1042ea:	89 e5                	mov    %esp,%ebp
  1042ec:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1042ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1042f6:	e8 22 fa ff ff       	call   103d1d <alloc_pages>
  1042fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1042fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104302:	75 1c                	jne    104320 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  104304:	c7 44 24 08 03 6a 10 	movl   $0x106a03,0x8(%esp)
  10430b:	00 
  10430c:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  104313:	00 
  104314:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  10431b:	e8 a9 c9 ff ff       	call   100cc9 <__panic>
    }
    return page2kva(p);
  104320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104323:	89 04 24             	mov    %eax,(%esp)
  104326:	e8 68 f7 ff ff       	call   103a93 <page2kva>
}
  10432b:	c9                   	leave  
  10432c:	c3                   	ret    

0010432d <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  10432d:	55                   	push   %ebp
  10432e:	89 e5                	mov    %esp,%ebp
  104330:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  104333:	e8 93 f9 ff ff       	call   103ccb <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  104338:	e8 75 fa ff ff       	call   103db2 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10433d:	e8 d7 02 00 00       	call   104619 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  104342:	e8 a2 ff ff ff       	call   1042e9 <boot_alloc_page>
  104347:	a3 e4 88 11 00       	mov    %eax,0x1188e4
    memset(boot_pgdir, 0, PGSIZE);
  10434c:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104351:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104358:	00 
  104359:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104360:	00 
  104361:	89 04 24             	mov    %eax,(%esp)
  104364:	e8 19 19 00 00       	call   105c82 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  104369:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  10436e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104371:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104378:	77 23                	ja     10439d <pmm_init+0x70>
  10437a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10437d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104381:	c7 44 24 08 98 69 10 	movl   $0x106998,0x8(%esp)
  104388:	00 
  104389:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  104390:	00 
  104391:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104398:	e8 2c c9 ff ff       	call   100cc9 <__panic>
  10439d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043a0:	05 00 00 00 40       	add    $0x40000000,%eax
  1043a5:	a3 80 89 11 00       	mov    %eax,0x118980

    check_pgdir();
  1043aa:	e8 88 02 00 00       	call   104637 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1043af:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1043b4:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  1043ba:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1043bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1043c2:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1043c9:	77 23                	ja     1043ee <pmm_init+0xc1>
  1043cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043ce:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1043d2:	c7 44 24 08 98 69 10 	movl   $0x106998,0x8(%esp)
  1043d9:	00 
  1043da:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  1043e1:	00 
  1043e2:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  1043e9:	e8 db c8 ff ff       	call   100cc9 <__panic>
  1043ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043f1:	05 00 00 00 40       	add    $0x40000000,%eax
  1043f6:	83 c8 03             	or     $0x3,%eax
  1043f9:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1043fb:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104400:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  104407:	00 
  104408:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10440f:	00 
  104410:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  104417:	38 
  104418:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  10441f:	c0 
  104420:	89 04 24             	mov    %eax,(%esp)
  104423:	e8 b4 fd ff ff       	call   1041dc <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  104428:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  10442d:	8b 15 e4 88 11 00    	mov    0x1188e4,%edx
  104433:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  104439:	89 10                	mov    %edx,(%eax)

    enable_paging();
  10443b:	e8 63 fd ff ff       	call   1041a3 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  104440:	e8 97 f7 ff ff       	call   103bdc <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  104445:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  10444a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  104450:	e8 7d 08 00 00       	call   104cd2 <check_boot_pgdir>

    print_pgdir();
  104455:	e8 0a 0d 00 00       	call   105164 <print_pgdir>

}
  10445a:	c9                   	leave  
  10445b:	c3                   	ret    

0010445c <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  10445c:	55                   	push   %ebp
  10445d:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  10445f:	5d                   	pop    %ebp
  104460:	c3                   	ret    

00104461 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  104461:	55                   	push   %ebp
  104462:	89 e5                	mov    %esp,%ebp
  104464:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104467:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10446e:	00 
  10446f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104472:	89 44 24 04          	mov    %eax,0x4(%esp)
  104476:	8b 45 08             	mov    0x8(%ebp),%eax
  104479:	89 04 24             	mov    %eax,(%esp)
  10447c:	e8 db ff ff ff       	call   10445c <get_pte>
  104481:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  104484:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104488:	74 08                	je     104492 <get_page+0x31>
        *ptep_store = ptep;
  10448a:	8b 45 10             	mov    0x10(%ebp),%eax
  10448d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104490:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  104492:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104496:	74 1b                	je     1044b3 <get_page+0x52>
  104498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10449b:	8b 00                	mov    (%eax),%eax
  10449d:	83 e0 01             	and    $0x1,%eax
  1044a0:	85 c0                	test   %eax,%eax
  1044a2:	74 0f                	je     1044b3 <get_page+0x52>
        return pa2page(*ptep);
  1044a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044a7:	8b 00                	mov    (%eax),%eax
  1044a9:	89 04 24             	mov    %eax,(%esp)
  1044ac:	e8 93 f5 ff ff       	call   103a44 <pa2page>
  1044b1:	eb 05                	jmp    1044b8 <get_page+0x57>
    }
    return NULL;
  1044b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1044b8:	c9                   	leave  
  1044b9:	c3                   	ret    

001044ba <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1044ba:	55                   	push   %ebp
  1044bb:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  1044bd:	5d                   	pop    %ebp
  1044be:	c3                   	ret    

001044bf <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1044bf:	55                   	push   %ebp
  1044c0:	89 e5                	mov    %esp,%ebp
  1044c2:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1044c5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1044cc:	00 
  1044cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1044d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1044d7:	89 04 24             	mov    %eax,(%esp)
  1044da:	e8 7d ff ff ff       	call   10445c <get_pte>
  1044df:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  1044e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1044e6:	74 19                	je     104501 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  1044e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1044eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1044ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1044f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1044f9:	89 04 24             	mov    %eax,(%esp)
  1044fc:	e8 b9 ff ff ff       	call   1044ba <page_remove_pte>
    }
}
  104501:	c9                   	leave  
  104502:	c3                   	ret    

00104503 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  104503:	55                   	push   %ebp
  104504:	89 e5                	mov    %esp,%ebp
  104506:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  104509:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104510:	00 
  104511:	8b 45 10             	mov    0x10(%ebp),%eax
  104514:	89 44 24 04          	mov    %eax,0x4(%esp)
  104518:	8b 45 08             	mov    0x8(%ebp),%eax
  10451b:	89 04 24             	mov    %eax,(%esp)
  10451e:	e8 39 ff ff ff       	call   10445c <get_pte>
  104523:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  104526:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10452a:	75 0a                	jne    104536 <page_insert+0x33>
        return -E_NO_MEM;
  10452c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  104531:	e9 84 00 00 00       	jmp    1045ba <page_insert+0xb7>
    }
    page_ref_inc(page);
  104536:	8b 45 0c             	mov    0xc(%ebp),%eax
  104539:	89 04 24             	mov    %eax,(%esp)
  10453c:	e8 ee f5 ff ff       	call   103b2f <page_ref_inc>
    if (*ptep & PTE_P) {
  104541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104544:	8b 00                	mov    (%eax),%eax
  104546:	83 e0 01             	and    $0x1,%eax
  104549:	85 c0                	test   %eax,%eax
  10454b:	74 3e                	je     10458b <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  10454d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104550:	8b 00                	mov    (%eax),%eax
  104552:	89 04 24             	mov    %eax,(%esp)
  104555:	e8 8d f5 ff ff       	call   103ae7 <pte2page>
  10455a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  10455d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104560:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104563:	75 0d                	jne    104572 <page_insert+0x6f>
            page_ref_dec(page);
  104565:	8b 45 0c             	mov    0xc(%ebp),%eax
  104568:	89 04 24             	mov    %eax,(%esp)
  10456b:	e8 d6 f5 ff ff       	call   103b46 <page_ref_dec>
  104570:	eb 19                	jmp    10458b <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  104572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104575:	89 44 24 08          	mov    %eax,0x8(%esp)
  104579:	8b 45 10             	mov    0x10(%ebp),%eax
  10457c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104580:	8b 45 08             	mov    0x8(%ebp),%eax
  104583:	89 04 24             	mov    %eax,(%esp)
  104586:	e8 2f ff ff ff       	call   1044ba <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  10458b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10458e:	89 04 24             	mov    %eax,(%esp)
  104591:	e8 98 f4 ff ff       	call   103a2e <page2pa>
  104596:	0b 45 14             	or     0x14(%ebp),%eax
  104599:	83 c8 01             	or     $0x1,%eax
  10459c:	89 c2                	mov    %eax,%edx
  10459e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045a1:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1045a3:	8b 45 10             	mov    0x10(%ebp),%eax
  1045a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1045ad:	89 04 24             	mov    %eax,(%esp)
  1045b0:	e8 07 00 00 00       	call   1045bc <tlb_invalidate>
    return 0;
  1045b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1045ba:	c9                   	leave  
  1045bb:	c3                   	ret    

001045bc <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1045bc:	55                   	push   %ebp
  1045bd:	89 e5                	mov    %esp,%ebp
  1045bf:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1045c2:	0f 20 d8             	mov    %cr3,%eax
  1045c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1045c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  1045cb:	89 c2                	mov    %eax,%edx
  1045cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1045d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1045d3:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1045da:	77 23                	ja     1045ff <tlb_invalidate+0x43>
  1045dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1045e3:	c7 44 24 08 98 69 10 	movl   $0x106998,0x8(%esp)
  1045ea:	00 
  1045eb:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
  1045f2:	00 
  1045f3:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  1045fa:	e8 ca c6 ff ff       	call   100cc9 <__panic>
  1045ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104602:	05 00 00 00 40       	add    $0x40000000,%eax
  104607:	39 c2                	cmp    %eax,%edx
  104609:	75 0c                	jne    104617 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  10460b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10460e:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  104611:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104614:	0f 01 38             	invlpg (%eax)
    }
}
  104617:	c9                   	leave  
  104618:	c3                   	ret    

00104619 <check_alloc_page>:

static void
check_alloc_page(void) {
  104619:	55                   	push   %ebp
  10461a:	89 e5                	mov    %esp,%ebp
  10461c:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  10461f:	a1 7c 89 11 00       	mov    0x11897c,%eax
  104624:	8b 40 18             	mov    0x18(%eax),%eax
  104627:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  104629:	c7 04 24 1c 6a 10 00 	movl   $0x106a1c,(%esp)
  104630:	e8 07 bd ff ff       	call   10033c <cprintf>
}
  104635:	c9                   	leave  
  104636:	c3                   	ret    

00104637 <check_pgdir>:

static void
check_pgdir(void) {
  104637:	55                   	push   %ebp
  104638:	89 e5                	mov    %esp,%ebp
  10463a:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  10463d:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  104642:	3d 00 80 03 00       	cmp    $0x38000,%eax
  104647:	76 24                	jbe    10466d <check_pgdir+0x36>
  104649:	c7 44 24 0c 3b 6a 10 	movl   $0x106a3b,0xc(%esp)
  104650:	00 
  104651:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104658:	00 
  104659:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  104660:	00 
  104661:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104668:	e8 5c c6 ff ff       	call   100cc9 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  10466d:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104672:	85 c0                	test   %eax,%eax
  104674:	74 0e                	je     104684 <check_pgdir+0x4d>
  104676:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  10467b:	25 ff 0f 00 00       	and    $0xfff,%eax
  104680:	85 c0                	test   %eax,%eax
  104682:	74 24                	je     1046a8 <check_pgdir+0x71>
  104684:	c7 44 24 0c 58 6a 10 	movl   $0x106a58,0xc(%esp)
  10468b:	00 
  10468c:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104693:	00 
  104694:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  10469b:	00 
  10469c:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  1046a3:	e8 21 c6 ff ff       	call   100cc9 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1046a8:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1046ad:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1046b4:	00 
  1046b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1046bc:	00 
  1046bd:	89 04 24             	mov    %eax,(%esp)
  1046c0:	e8 9c fd ff ff       	call   104461 <get_page>
  1046c5:	85 c0                	test   %eax,%eax
  1046c7:	74 24                	je     1046ed <check_pgdir+0xb6>
  1046c9:	c7 44 24 0c 90 6a 10 	movl   $0x106a90,0xc(%esp)
  1046d0:	00 
  1046d1:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  1046d8:	00 
  1046d9:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
  1046e0:	00 
  1046e1:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  1046e8:	e8 dc c5 ff ff       	call   100cc9 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1046ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1046f4:	e8 24 f6 ff ff       	call   103d1d <alloc_pages>
  1046f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1046fc:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104701:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104708:	00 
  104709:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104710:	00 
  104711:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104714:	89 54 24 04          	mov    %edx,0x4(%esp)
  104718:	89 04 24             	mov    %eax,(%esp)
  10471b:	e8 e3 fd ff ff       	call   104503 <page_insert>
  104720:	85 c0                	test   %eax,%eax
  104722:	74 24                	je     104748 <check_pgdir+0x111>
  104724:	c7 44 24 0c b8 6a 10 	movl   $0x106ab8,0xc(%esp)
  10472b:	00 
  10472c:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104733:	00 
  104734:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  10473b:	00 
  10473c:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104743:	e8 81 c5 ff ff       	call   100cc9 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104748:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  10474d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104754:	00 
  104755:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10475c:	00 
  10475d:	89 04 24             	mov    %eax,(%esp)
  104760:	e8 f7 fc ff ff       	call   10445c <get_pte>
  104765:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104768:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10476c:	75 24                	jne    104792 <check_pgdir+0x15b>
  10476e:	c7 44 24 0c e4 6a 10 	movl   $0x106ae4,0xc(%esp)
  104775:	00 
  104776:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  10477d:	00 
  10477e:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
  104785:	00 
  104786:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  10478d:	e8 37 c5 ff ff       	call   100cc9 <__panic>
    assert(pa2page(*ptep) == p1);
  104792:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104795:	8b 00                	mov    (%eax),%eax
  104797:	89 04 24             	mov    %eax,(%esp)
  10479a:	e8 a5 f2 ff ff       	call   103a44 <pa2page>
  10479f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1047a2:	74 24                	je     1047c8 <check_pgdir+0x191>
  1047a4:	c7 44 24 0c 11 6b 10 	movl   $0x106b11,0xc(%esp)
  1047ab:	00 
  1047ac:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  1047b3:	00 
  1047b4:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  1047bb:	00 
  1047bc:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  1047c3:	e8 01 c5 ff ff       	call   100cc9 <__panic>
    assert(page_ref(p1) == 1);
  1047c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047cb:	89 04 24             	mov    %eax,(%esp)
  1047ce:	e8 52 f3 ff ff       	call   103b25 <page_ref>
  1047d3:	83 f8 01             	cmp    $0x1,%eax
  1047d6:	74 24                	je     1047fc <check_pgdir+0x1c5>
  1047d8:	c7 44 24 0c 26 6b 10 	movl   $0x106b26,0xc(%esp)
  1047df:	00 
  1047e0:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  1047e7:	00 
  1047e8:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  1047ef:	00 
  1047f0:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  1047f7:	e8 cd c4 ff ff       	call   100cc9 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  1047fc:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104801:	8b 00                	mov    (%eax),%eax
  104803:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104808:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10480b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10480e:	c1 e8 0c             	shr    $0xc,%eax
  104811:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104814:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  104819:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10481c:	72 23                	jb     104841 <check_pgdir+0x20a>
  10481e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104821:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104825:	c7 44 24 08 f4 68 10 	movl   $0x1068f4,0x8(%esp)
  10482c:	00 
  10482d:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  104834:	00 
  104835:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  10483c:	e8 88 c4 ff ff       	call   100cc9 <__panic>
  104841:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104844:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104849:	83 c0 04             	add    $0x4,%eax
  10484c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  10484f:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104854:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10485b:	00 
  10485c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104863:	00 
  104864:	89 04 24             	mov    %eax,(%esp)
  104867:	e8 f0 fb ff ff       	call   10445c <get_pte>
  10486c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  10486f:	74 24                	je     104895 <check_pgdir+0x25e>
  104871:	c7 44 24 0c 38 6b 10 	movl   $0x106b38,0xc(%esp)
  104878:	00 
  104879:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104880:	00 
  104881:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
  104888:	00 
  104889:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104890:	e8 34 c4 ff ff       	call   100cc9 <__panic>

    p2 = alloc_page();
  104895:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10489c:	e8 7c f4 ff ff       	call   103d1d <alloc_pages>
  1048a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  1048a4:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1048a9:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  1048b0:	00 
  1048b1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1048b8:	00 
  1048b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1048bc:	89 54 24 04          	mov    %edx,0x4(%esp)
  1048c0:	89 04 24             	mov    %eax,(%esp)
  1048c3:	e8 3b fc ff ff       	call   104503 <page_insert>
  1048c8:	85 c0                	test   %eax,%eax
  1048ca:	74 24                	je     1048f0 <check_pgdir+0x2b9>
  1048cc:	c7 44 24 0c 60 6b 10 	movl   $0x106b60,0xc(%esp)
  1048d3:	00 
  1048d4:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  1048db:	00 
  1048dc:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  1048e3:	00 
  1048e4:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  1048eb:	e8 d9 c3 ff ff       	call   100cc9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1048f0:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1048f5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048fc:	00 
  1048fd:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104904:	00 
  104905:	89 04 24             	mov    %eax,(%esp)
  104908:	e8 4f fb ff ff       	call   10445c <get_pte>
  10490d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104910:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104914:	75 24                	jne    10493a <check_pgdir+0x303>
  104916:	c7 44 24 0c 98 6b 10 	movl   $0x106b98,0xc(%esp)
  10491d:	00 
  10491e:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104925:	00 
  104926:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  10492d:	00 
  10492e:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104935:	e8 8f c3 ff ff       	call   100cc9 <__panic>
    assert(*ptep & PTE_U);
  10493a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10493d:	8b 00                	mov    (%eax),%eax
  10493f:	83 e0 04             	and    $0x4,%eax
  104942:	85 c0                	test   %eax,%eax
  104944:	75 24                	jne    10496a <check_pgdir+0x333>
  104946:	c7 44 24 0c c8 6b 10 	movl   $0x106bc8,0xc(%esp)
  10494d:	00 
  10494e:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104955:	00 
  104956:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  10495d:	00 
  10495e:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104965:	e8 5f c3 ff ff       	call   100cc9 <__panic>
    assert(*ptep & PTE_W);
  10496a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10496d:	8b 00                	mov    (%eax),%eax
  10496f:	83 e0 02             	and    $0x2,%eax
  104972:	85 c0                	test   %eax,%eax
  104974:	75 24                	jne    10499a <check_pgdir+0x363>
  104976:	c7 44 24 0c d6 6b 10 	movl   $0x106bd6,0xc(%esp)
  10497d:	00 
  10497e:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104985:	00 
  104986:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  10498d:	00 
  10498e:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104995:	e8 2f c3 ff ff       	call   100cc9 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  10499a:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  10499f:	8b 00                	mov    (%eax),%eax
  1049a1:	83 e0 04             	and    $0x4,%eax
  1049a4:	85 c0                	test   %eax,%eax
  1049a6:	75 24                	jne    1049cc <check_pgdir+0x395>
  1049a8:	c7 44 24 0c e4 6b 10 	movl   $0x106be4,0xc(%esp)
  1049af:	00 
  1049b0:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  1049b7:	00 
  1049b8:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  1049bf:	00 
  1049c0:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  1049c7:	e8 fd c2 ff ff       	call   100cc9 <__panic>
    assert(page_ref(p2) == 1);
  1049cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1049cf:	89 04 24             	mov    %eax,(%esp)
  1049d2:	e8 4e f1 ff ff       	call   103b25 <page_ref>
  1049d7:	83 f8 01             	cmp    $0x1,%eax
  1049da:	74 24                	je     104a00 <check_pgdir+0x3c9>
  1049dc:	c7 44 24 0c fa 6b 10 	movl   $0x106bfa,0xc(%esp)
  1049e3:	00 
  1049e4:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  1049eb:	00 
  1049ec:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  1049f3:	00 
  1049f4:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  1049fb:	e8 c9 c2 ff ff       	call   100cc9 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104a00:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104a05:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104a0c:	00 
  104a0d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104a14:	00 
  104a15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104a18:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a1c:	89 04 24             	mov    %eax,(%esp)
  104a1f:	e8 df fa ff ff       	call   104503 <page_insert>
  104a24:	85 c0                	test   %eax,%eax
  104a26:	74 24                	je     104a4c <check_pgdir+0x415>
  104a28:	c7 44 24 0c 0c 6c 10 	movl   $0x106c0c,0xc(%esp)
  104a2f:	00 
  104a30:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104a37:	00 
  104a38:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  104a3f:	00 
  104a40:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104a47:	e8 7d c2 ff ff       	call   100cc9 <__panic>
    assert(page_ref(p1) == 2);
  104a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a4f:	89 04 24             	mov    %eax,(%esp)
  104a52:	e8 ce f0 ff ff       	call   103b25 <page_ref>
  104a57:	83 f8 02             	cmp    $0x2,%eax
  104a5a:	74 24                	je     104a80 <check_pgdir+0x449>
  104a5c:	c7 44 24 0c 38 6c 10 	movl   $0x106c38,0xc(%esp)
  104a63:	00 
  104a64:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104a6b:	00 
  104a6c:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  104a73:	00 
  104a74:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104a7b:	e8 49 c2 ff ff       	call   100cc9 <__panic>
    assert(page_ref(p2) == 0);
  104a80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a83:	89 04 24             	mov    %eax,(%esp)
  104a86:	e8 9a f0 ff ff       	call   103b25 <page_ref>
  104a8b:	85 c0                	test   %eax,%eax
  104a8d:	74 24                	je     104ab3 <check_pgdir+0x47c>
  104a8f:	c7 44 24 0c 4a 6c 10 	movl   $0x106c4a,0xc(%esp)
  104a96:	00 
  104a97:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104a9e:	00 
  104a9f:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  104aa6:	00 
  104aa7:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104aae:	e8 16 c2 ff ff       	call   100cc9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104ab3:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104ab8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104abf:	00 
  104ac0:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104ac7:	00 
  104ac8:	89 04 24             	mov    %eax,(%esp)
  104acb:	e8 8c f9 ff ff       	call   10445c <get_pte>
  104ad0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ad3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104ad7:	75 24                	jne    104afd <check_pgdir+0x4c6>
  104ad9:	c7 44 24 0c 98 6b 10 	movl   $0x106b98,0xc(%esp)
  104ae0:	00 
  104ae1:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104ae8:	00 
  104ae9:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  104af0:	00 
  104af1:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104af8:	e8 cc c1 ff ff       	call   100cc9 <__panic>
    assert(pa2page(*ptep) == p1);
  104afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b00:	8b 00                	mov    (%eax),%eax
  104b02:	89 04 24             	mov    %eax,(%esp)
  104b05:	e8 3a ef ff ff       	call   103a44 <pa2page>
  104b0a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104b0d:	74 24                	je     104b33 <check_pgdir+0x4fc>
  104b0f:	c7 44 24 0c 11 6b 10 	movl   $0x106b11,0xc(%esp)
  104b16:	00 
  104b17:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104b1e:	00 
  104b1f:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  104b26:	00 
  104b27:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104b2e:	e8 96 c1 ff ff       	call   100cc9 <__panic>
    assert((*ptep & PTE_U) == 0);
  104b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b36:	8b 00                	mov    (%eax),%eax
  104b38:	83 e0 04             	and    $0x4,%eax
  104b3b:	85 c0                	test   %eax,%eax
  104b3d:	74 24                	je     104b63 <check_pgdir+0x52c>
  104b3f:	c7 44 24 0c 5c 6c 10 	movl   $0x106c5c,0xc(%esp)
  104b46:	00 
  104b47:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104b4e:	00 
  104b4f:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  104b56:	00 
  104b57:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104b5e:	e8 66 c1 ff ff       	call   100cc9 <__panic>

    page_remove(boot_pgdir, 0x0);
  104b63:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104b68:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104b6f:	00 
  104b70:	89 04 24             	mov    %eax,(%esp)
  104b73:	e8 47 f9 ff ff       	call   1044bf <page_remove>
    assert(page_ref(p1) == 1);
  104b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b7b:	89 04 24             	mov    %eax,(%esp)
  104b7e:	e8 a2 ef ff ff       	call   103b25 <page_ref>
  104b83:	83 f8 01             	cmp    $0x1,%eax
  104b86:	74 24                	je     104bac <check_pgdir+0x575>
  104b88:	c7 44 24 0c 26 6b 10 	movl   $0x106b26,0xc(%esp)
  104b8f:	00 
  104b90:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104b97:	00 
  104b98:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  104b9f:	00 
  104ba0:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104ba7:	e8 1d c1 ff ff       	call   100cc9 <__panic>
    assert(page_ref(p2) == 0);
  104bac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104baf:	89 04 24             	mov    %eax,(%esp)
  104bb2:	e8 6e ef ff ff       	call   103b25 <page_ref>
  104bb7:	85 c0                	test   %eax,%eax
  104bb9:	74 24                	je     104bdf <check_pgdir+0x5a8>
  104bbb:	c7 44 24 0c 4a 6c 10 	movl   $0x106c4a,0xc(%esp)
  104bc2:	00 
  104bc3:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104bca:	00 
  104bcb:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  104bd2:	00 
  104bd3:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104bda:	e8 ea c0 ff ff       	call   100cc9 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104bdf:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104be4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104beb:	00 
  104bec:	89 04 24             	mov    %eax,(%esp)
  104bef:	e8 cb f8 ff ff       	call   1044bf <page_remove>
    assert(page_ref(p1) == 0);
  104bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bf7:	89 04 24             	mov    %eax,(%esp)
  104bfa:	e8 26 ef ff ff       	call   103b25 <page_ref>
  104bff:	85 c0                	test   %eax,%eax
  104c01:	74 24                	je     104c27 <check_pgdir+0x5f0>
  104c03:	c7 44 24 0c 71 6c 10 	movl   $0x106c71,0xc(%esp)
  104c0a:	00 
  104c0b:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104c12:	00 
  104c13:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104c1a:	00 
  104c1b:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104c22:	e8 a2 c0 ff ff       	call   100cc9 <__panic>
    assert(page_ref(p2) == 0);
  104c27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c2a:	89 04 24             	mov    %eax,(%esp)
  104c2d:	e8 f3 ee ff ff       	call   103b25 <page_ref>
  104c32:	85 c0                	test   %eax,%eax
  104c34:	74 24                	je     104c5a <check_pgdir+0x623>
  104c36:	c7 44 24 0c 4a 6c 10 	movl   $0x106c4a,0xc(%esp)
  104c3d:	00 
  104c3e:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104c45:	00 
  104c46:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  104c4d:	00 
  104c4e:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104c55:	e8 6f c0 ff ff       	call   100cc9 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  104c5a:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104c5f:	8b 00                	mov    (%eax),%eax
  104c61:	89 04 24             	mov    %eax,(%esp)
  104c64:	e8 db ed ff ff       	call   103a44 <pa2page>
  104c69:	89 04 24             	mov    %eax,(%esp)
  104c6c:	e8 b4 ee ff ff       	call   103b25 <page_ref>
  104c71:	83 f8 01             	cmp    $0x1,%eax
  104c74:	74 24                	je     104c9a <check_pgdir+0x663>
  104c76:	c7 44 24 0c 84 6c 10 	movl   $0x106c84,0xc(%esp)
  104c7d:	00 
  104c7e:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104c85:	00 
  104c86:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104c8d:	00 
  104c8e:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104c95:	e8 2f c0 ff ff       	call   100cc9 <__panic>
    free_page(pa2page(boot_pgdir[0]));
  104c9a:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104c9f:	8b 00                	mov    (%eax),%eax
  104ca1:	89 04 24             	mov    %eax,(%esp)
  104ca4:	e8 9b ed ff ff       	call   103a44 <pa2page>
  104ca9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104cb0:	00 
  104cb1:	89 04 24             	mov    %eax,(%esp)
  104cb4:	e8 9c f0 ff ff       	call   103d55 <free_pages>
    boot_pgdir[0] = 0;
  104cb9:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104cbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104cc4:	c7 04 24 aa 6c 10 00 	movl   $0x106caa,(%esp)
  104ccb:	e8 6c b6 ff ff       	call   10033c <cprintf>
}
  104cd0:	c9                   	leave  
  104cd1:	c3                   	ret    

00104cd2 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104cd2:	55                   	push   %ebp
  104cd3:	89 e5                	mov    %esp,%ebp
  104cd5:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104cd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104cdf:	e9 ca 00 00 00       	jmp    104dae <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ce7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ced:	c1 e8 0c             	shr    $0xc,%eax
  104cf0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104cf3:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  104cf8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104cfb:	72 23                	jb     104d20 <check_boot_pgdir+0x4e>
  104cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d00:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104d04:	c7 44 24 08 f4 68 10 	movl   $0x1068f4,0x8(%esp)
  104d0b:	00 
  104d0c:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104d13:	00 
  104d14:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104d1b:	e8 a9 bf ff ff       	call   100cc9 <__panic>
  104d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d23:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104d28:	89 c2                	mov    %eax,%edx
  104d2a:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104d2f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104d36:	00 
  104d37:	89 54 24 04          	mov    %edx,0x4(%esp)
  104d3b:	89 04 24             	mov    %eax,(%esp)
  104d3e:	e8 19 f7 ff ff       	call   10445c <get_pte>
  104d43:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104d46:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104d4a:	75 24                	jne    104d70 <check_boot_pgdir+0x9e>
  104d4c:	c7 44 24 0c c4 6c 10 	movl   $0x106cc4,0xc(%esp)
  104d53:	00 
  104d54:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104d5b:	00 
  104d5c:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104d63:	00 
  104d64:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104d6b:	e8 59 bf ff ff       	call   100cc9 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104d70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104d73:	8b 00                	mov    (%eax),%eax
  104d75:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104d7a:	89 c2                	mov    %eax,%edx
  104d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d7f:	39 c2                	cmp    %eax,%edx
  104d81:	74 24                	je     104da7 <check_boot_pgdir+0xd5>
  104d83:	c7 44 24 0c 01 6d 10 	movl   $0x106d01,0xc(%esp)
  104d8a:	00 
  104d8b:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104d92:	00 
  104d93:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104d9a:	00 
  104d9b:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104da2:	e8 22 bf ff ff       	call   100cc9 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104da7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104dae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104db1:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  104db6:	39 c2                	cmp    %eax,%edx
  104db8:	0f 82 26 ff ff ff    	jb     104ce4 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104dbe:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104dc3:	05 ac 0f 00 00       	add    $0xfac,%eax
  104dc8:	8b 00                	mov    (%eax),%eax
  104dca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104dcf:	89 c2                	mov    %eax,%edx
  104dd1:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104dd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104dd9:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104de0:	77 23                	ja     104e05 <check_boot_pgdir+0x133>
  104de2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104de5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104de9:	c7 44 24 08 98 69 10 	movl   $0x106998,0x8(%esp)
  104df0:	00 
  104df1:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104df8:	00 
  104df9:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104e00:	e8 c4 be ff ff       	call   100cc9 <__panic>
  104e05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e08:	05 00 00 00 40       	add    $0x40000000,%eax
  104e0d:	39 c2                	cmp    %eax,%edx
  104e0f:	74 24                	je     104e35 <check_boot_pgdir+0x163>
  104e11:	c7 44 24 0c 18 6d 10 	movl   $0x106d18,0xc(%esp)
  104e18:	00 
  104e19:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104e20:	00 
  104e21:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104e28:	00 
  104e29:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104e30:	e8 94 be ff ff       	call   100cc9 <__panic>

    assert(boot_pgdir[0] == 0);
  104e35:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104e3a:	8b 00                	mov    (%eax),%eax
  104e3c:	85 c0                	test   %eax,%eax
  104e3e:	74 24                	je     104e64 <check_boot_pgdir+0x192>
  104e40:	c7 44 24 0c 4c 6d 10 	movl   $0x106d4c,0xc(%esp)
  104e47:	00 
  104e48:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104e4f:	00 
  104e50:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104e57:	00 
  104e58:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104e5f:	e8 65 be ff ff       	call   100cc9 <__panic>

    struct Page *p;
    p = alloc_page();
  104e64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e6b:	e8 ad ee ff ff       	call   103d1d <alloc_pages>
  104e70:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104e73:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104e78:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104e7f:	00 
  104e80:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104e87:	00 
  104e88:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104e8b:	89 54 24 04          	mov    %edx,0x4(%esp)
  104e8f:	89 04 24             	mov    %eax,(%esp)
  104e92:	e8 6c f6 ff ff       	call   104503 <page_insert>
  104e97:	85 c0                	test   %eax,%eax
  104e99:	74 24                	je     104ebf <check_boot_pgdir+0x1ed>
  104e9b:	c7 44 24 0c 60 6d 10 	movl   $0x106d60,0xc(%esp)
  104ea2:	00 
  104ea3:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104eaa:	00 
  104eab:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  104eb2:	00 
  104eb3:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104eba:	e8 0a be ff ff       	call   100cc9 <__panic>
    assert(page_ref(p) == 1);
  104ebf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104ec2:	89 04 24             	mov    %eax,(%esp)
  104ec5:	e8 5b ec ff ff       	call   103b25 <page_ref>
  104eca:	83 f8 01             	cmp    $0x1,%eax
  104ecd:	74 24                	je     104ef3 <check_boot_pgdir+0x221>
  104ecf:	c7 44 24 0c 8e 6d 10 	movl   $0x106d8e,0xc(%esp)
  104ed6:	00 
  104ed7:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104ede:	00 
  104edf:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  104ee6:	00 
  104ee7:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104eee:	e8 d6 bd ff ff       	call   100cc9 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104ef3:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104ef8:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104eff:	00 
  104f00:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  104f07:	00 
  104f08:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104f0b:	89 54 24 04          	mov    %edx,0x4(%esp)
  104f0f:	89 04 24             	mov    %eax,(%esp)
  104f12:	e8 ec f5 ff ff       	call   104503 <page_insert>
  104f17:	85 c0                	test   %eax,%eax
  104f19:	74 24                	je     104f3f <check_boot_pgdir+0x26d>
  104f1b:	c7 44 24 0c a0 6d 10 	movl   $0x106da0,0xc(%esp)
  104f22:	00 
  104f23:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104f2a:	00 
  104f2b:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  104f32:	00 
  104f33:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104f3a:	e8 8a bd ff ff       	call   100cc9 <__panic>
    assert(page_ref(p) == 2);
  104f3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104f42:	89 04 24             	mov    %eax,(%esp)
  104f45:	e8 db eb ff ff       	call   103b25 <page_ref>
  104f4a:	83 f8 02             	cmp    $0x2,%eax
  104f4d:	74 24                	je     104f73 <check_boot_pgdir+0x2a1>
  104f4f:	c7 44 24 0c d7 6d 10 	movl   $0x106dd7,0xc(%esp)
  104f56:	00 
  104f57:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104f5e:	00 
  104f5f:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  104f66:	00 
  104f67:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104f6e:	e8 56 bd ff ff       	call   100cc9 <__panic>

    const char *str = "ucore: Hello world!!";
  104f73:	c7 45 dc e8 6d 10 00 	movl   $0x106de8,-0x24(%ebp)
    strcpy((void *)0x100, str);
  104f7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104f7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f81:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104f88:	e8 1e 0a 00 00       	call   1059ab <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  104f8d:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  104f94:	00 
  104f95:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104f9c:	e8 83 0a 00 00       	call   105a24 <strcmp>
  104fa1:	85 c0                	test   %eax,%eax
  104fa3:	74 24                	je     104fc9 <check_boot_pgdir+0x2f7>
  104fa5:	c7 44 24 0c 00 6e 10 	movl   $0x106e00,0xc(%esp)
  104fac:	00 
  104fad:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104fb4:	00 
  104fb5:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  104fbc:	00 
  104fbd:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  104fc4:	e8 00 bd ff ff       	call   100cc9 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  104fc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104fcc:	89 04 24             	mov    %eax,(%esp)
  104fcf:	e8 bf ea ff ff       	call   103a93 <page2kva>
  104fd4:	05 00 01 00 00       	add    $0x100,%eax
  104fd9:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  104fdc:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104fe3:	e8 6b 09 00 00       	call   105953 <strlen>
  104fe8:	85 c0                	test   %eax,%eax
  104fea:	74 24                	je     105010 <check_boot_pgdir+0x33e>
  104fec:	c7 44 24 0c 38 6e 10 	movl   $0x106e38,0xc(%esp)
  104ff3:	00 
  104ff4:	c7 44 24 08 e1 69 10 	movl   $0x1069e1,0x8(%esp)
  104ffb:	00 
  104ffc:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  105003:	00 
  105004:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  10500b:	e8 b9 bc ff ff       	call   100cc9 <__panic>

    free_page(p);
  105010:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105017:	00 
  105018:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10501b:	89 04 24             	mov    %eax,(%esp)
  10501e:	e8 32 ed ff ff       	call   103d55 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  105023:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  105028:	8b 00                	mov    (%eax),%eax
  10502a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10502f:	89 04 24             	mov    %eax,(%esp)
  105032:	e8 0d ea ff ff       	call   103a44 <pa2page>
  105037:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10503e:	00 
  10503f:	89 04 24             	mov    %eax,(%esp)
  105042:	e8 0e ed ff ff       	call   103d55 <free_pages>
    boot_pgdir[0] = 0;
  105047:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  10504c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  105052:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  105059:	e8 de b2 ff ff       	call   10033c <cprintf>
}
  10505e:	c9                   	leave  
  10505f:	c3                   	ret    

00105060 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  105060:	55                   	push   %ebp
  105061:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  105063:	8b 45 08             	mov    0x8(%ebp),%eax
  105066:	83 e0 04             	and    $0x4,%eax
  105069:	85 c0                	test   %eax,%eax
  10506b:	74 07                	je     105074 <perm2str+0x14>
  10506d:	b8 75 00 00 00       	mov    $0x75,%eax
  105072:	eb 05                	jmp    105079 <perm2str+0x19>
  105074:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105079:	a2 68 89 11 00       	mov    %al,0x118968
    str[1] = 'r';
  10507e:	c6 05 69 89 11 00 72 	movb   $0x72,0x118969
    str[2] = (perm & PTE_W) ? 'w' : '-';
  105085:	8b 45 08             	mov    0x8(%ebp),%eax
  105088:	83 e0 02             	and    $0x2,%eax
  10508b:	85 c0                	test   %eax,%eax
  10508d:	74 07                	je     105096 <perm2str+0x36>
  10508f:	b8 77 00 00 00       	mov    $0x77,%eax
  105094:	eb 05                	jmp    10509b <perm2str+0x3b>
  105096:	b8 2d 00 00 00       	mov    $0x2d,%eax
  10509b:	a2 6a 89 11 00       	mov    %al,0x11896a
    str[3] = '\0';
  1050a0:	c6 05 6b 89 11 00 00 	movb   $0x0,0x11896b
    return str;
  1050a7:	b8 68 89 11 00       	mov    $0x118968,%eax
}
  1050ac:	5d                   	pop    %ebp
  1050ad:	c3                   	ret    

001050ae <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1050ae:	55                   	push   %ebp
  1050af:	89 e5                	mov    %esp,%ebp
  1050b1:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1050b4:	8b 45 10             	mov    0x10(%ebp),%eax
  1050b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1050ba:	72 0a                	jb     1050c6 <get_pgtable_items+0x18>
        return 0;
  1050bc:	b8 00 00 00 00       	mov    $0x0,%eax
  1050c1:	e9 9c 00 00 00       	jmp    105162 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  1050c6:	eb 04                	jmp    1050cc <get_pgtable_items+0x1e>
        start ++;
  1050c8:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  1050cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1050cf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1050d2:	73 18                	jae    1050ec <get_pgtable_items+0x3e>
  1050d4:	8b 45 10             	mov    0x10(%ebp),%eax
  1050d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1050de:	8b 45 14             	mov    0x14(%ebp),%eax
  1050e1:	01 d0                	add    %edx,%eax
  1050e3:	8b 00                	mov    (%eax),%eax
  1050e5:	83 e0 01             	and    $0x1,%eax
  1050e8:	85 c0                	test   %eax,%eax
  1050ea:	74 dc                	je     1050c8 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  1050ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1050ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1050f2:	73 69                	jae    10515d <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  1050f4:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1050f8:	74 08                	je     105102 <get_pgtable_items+0x54>
            *left_store = start;
  1050fa:	8b 45 18             	mov    0x18(%ebp),%eax
  1050fd:	8b 55 10             	mov    0x10(%ebp),%edx
  105100:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  105102:	8b 45 10             	mov    0x10(%ebp),%eax
  105105:	8d 50 01             	lea    0x1(%eax),%edx
  105108:	89 55 10             	mov    %edx,0x10(%ebp)
  10510b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105112:	8b 45 14             	mov    0x14(%ebp),%eax
  105115:	01 d0                	add    %edx,%eax
  105117:	8b 00                	mov    (%eax),%eax
  105119:	83 e0 07             	and    $0x7,%eax
  10511c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  10511f:	eb 04                	jmp    105125 <get_pgtable_items+0x77>
            start ++;
  105121:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  105125:	8b 45 10             	mov    0x10(%ebp),%eax
  105128:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10512b:	73 1d                	jae    10514a <get_pgtable_items+0x9c>
  10512d:	8b 45 10             	mov    0x10(%ebp),%eax
  105130:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105137:	8b 45 14             	mov    0x14(%ebp),%eax
  10513a:	01 d0                	add    %edx,%eax
  10513c:	8b 00                	mov    (%eax),%eax
  10513e:	83 e0 07             	and    $0x7,%eax
  105141:	89 c2                	mov    %eax,%edx
  105143:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105146:	39 c2                	cmp    %eax,%edx
  105148:	74 d7                	je     105121 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  10514a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10514e:	74 08                	je     105158 <get_pgtable_items+0xaa>
            *right_store = start;
  105150:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105153:	8b 55 10             	mov    0x10(%ebp),%edx
  105156:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  105158:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10515b:	eb 05                	jmp    105162 <get_pgtable_items+0xb4>
    }
    return 0;
  10515d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105162:	c9                   	leave  
  105163:	c3                   	ret    

00105164 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  105164:	55                   	push   %ebp
  105165:	89 e5                	mov    %esp,%ebp
  105167:	57                   	push   %edi
  105168:	56                   	push   %esi
  105169:	53                   	push   %ebx
  10516a:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10516d:	c7 04 24 7c 6e 10 00 	movl   $0x106e7c,(%esp)
  105174:	e8 c3 b1 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  105179:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105180:	e9 fa 00 00 00       	jmp    10527f <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105185:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105188:	89 04 24             	mov    %eax,(%esp)
  10518b:	e8 d0 fe ff ff       	call   105060 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  105190:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105193:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105196:	29 d1                	sub    %edx,%ecx
  105198:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10519a:	89 d6                	mov    %edx,%esi
  10519c:	c1 e6 16             	shl    $0x16,%esi
  10519f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1051a2:	89 d3                	mov    %edx,%ebx
  1051a4:	c1 e3 16             	shl    $0x16,%ebx
  1051a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1051aa:	89 d1                	mov    %edx,%ecx
  1051ac:	c1 e1 16             	shl    $0x16,%ecx
  1051af:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1051b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1051b5:	29 d7                	sub    %edx,%edi
  1051b7:	89 fa                	mov    %edi,%edx
  1051b9:	89 44 24 14          	mov    %eax,0x14(%esp)
  1051bd:	89 74 24 10          	mov    %esi,0x10(%esp)
  1051c1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1051c5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1051c9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1051cd:	c7 04 24 ad 6e 10 00 	movl   $0x106ead,(%esp)
  1051d4:	e8 63 b1 ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  1051d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1051dc:	c1 e0 0a             	shl    $0xa,%eax
  1051df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1051e2:	eb 54                	jmp    105238 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1051e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1051e7:	89 04 24             	mov    %eax,(%esp)
  1051ea:	e8 71 fe ff ff       	call   105060 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1051ef:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1051f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1051f5:	29 d1                	sub    %edx,%ecx
  1051f7:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1051f9:	89 d6                	mov    %edx,%esi
  1051fb:	c1 e6 0c             	shl    $0xc,%esi
  1051fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105201:	89 d3                	mov    %edx,%ebx
  105203:	c1 e3 0c             	shl    $0xc,%ebx
  105206:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105209:	c1 e2 0c             	shl    $0xc,%edx
  10520c:	89 d1                	mov    %edx,%ecx
  10520e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  105211:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105214:	29 d7                	sub    %edx,%edi
  105216:	89 fa                	mov    %edi,%edx
  105218:	89 44 24 14          	mov    %eax,0x14(%esp)
  10521c:	89 74 24 10          	mov    %esi,0x10(%esp)
  105220:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105224:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105228:	89 54 24 04          	mov    %edx,0x4(%esp)
  10522c:	c7 04 24 cc 6e 10 00 	movl   $0x106ecc,(%esp)
  105233:	e8 04 b1 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105238:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  10523d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105240:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105243:	89 ce                	mov    %ecx,%esi
  105245:	c1 e6 0a             	shl    $0xa,%esi
  105248:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  10524b:	89 cb                	mov    %ecx,%ebx
  10524d:	c1 e3 0a             	shl    $0xa,%ebx
  105250:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  105253:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105257:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  10525a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10525e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105262:	89 44 24 08          	mov    %eax,0x8(%esp)
  105266:	89 74 24 04          	mov    %esi,0x4(%esp)
  10526a:	89 1c 24             	mov    %ebx,(%esp)
  10526d:	e8 3c fe ff ff       	call   1050ae <get_pgtable_items>
  105272:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105275:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105279:	0f 85 65 ff ff ff    	jne    1051e4 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10527f:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  105284:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105287:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  10528a:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  10528e:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  105291:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105295:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105299:	89 44 24 08          	mov    %eax,0x8(%esp)
  10529d:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1052a4:	00 
  1052a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1052ac:	e8 fd fd ff ff       	call   1050ae <get_pgtable_items>
  1052b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1052b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1052b8:	0f 85 c7 fe ff ff    	jne    105185 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1052be:	c7 04 24 f0 6e 10 00 	movl   $0x106ef0,(%esp)
  1052c5:	e8 72 b0 ff ff       	call   10033c <cprintf>
}
  1052ca:	83 c4 4c             	add    $0x4c,%esp
  1052cd:	5b                   	pop    %ebx
  1052ce:	5e                   	pop    %esi
  1052cf:	5f                   	pop    %edi
  1052d0:	5d                   	pop    %ebp
  1052d1:	c3                   	ret    

001052d2 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1052d2:	55                   	push   %ebp
  1052d3:	89 e5                	mov    %esp,%ebp
  1052d5:	83 ec 58             	sub    $0x58,%esp
  1052d8:	8b 45 10             	mov    0x10(%ebp),%eax
  1052db:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1052de:	8b 45 14             	mov    0x14(%ebp),%eax
  1052e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1052e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1052e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1052ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1052ed:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1052f0:	8b 45 18             	mov    0x18(%ebp),%eax
  1052f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1052f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1052fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1052ff:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105302:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105305:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105308:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10530c:	74 1c                	je     10532a <printnum+0x58>
  10530e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105311:	ba 00 00 00 00       	mov    $0x0,%edx
  105316:	f7 75 e4             	divl   -0x1c(%ebp)
  105319:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10531c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10531f:	ba 00 00 00 00       	mov    $0x0,%edx
  105324:	f7 75 e4             	divl   -0x1c(%ebp)
  105327:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10532a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10532d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105330:	f7 75 e4             	divl   -0x1c(%ebp)
  105333:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105336:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105339:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10533c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10533f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105342:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105345:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105348:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10534b:	8b 45 18             	mov    0x18(%ebp),%eax
  10534e:	ba 00 00 00 00       	mov    $0x0,%edx
  105353:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105356:	77 56                	ja     1053ae <printnum+0xdc>
  105358:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10535b:	72 05                	jb     105362 <printnum+0x90>
  10535d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  105360:	77 4c                	ja     1053ae <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  105362:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105365:	8d 50 ff             	lea    -0x1(%eax),%edx
  105368:	8b 45 20             	mov    0x20(%ebp),%eax
  10536b:	89 44 24 18          	mov    %eax,0x18(%esp)
  10536f:	89 54 24 14          	mov    %edx,0x14(%esp)
  105373:	8b 45 18             	mov    0x18(%ebp),%eax
  105376:	89 44 24 10          	mov    %eax,0x10(%esp)
  10537a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10537d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105380:	89 44 24 08          	mov    %eax,0x8(%esp)
  105384:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105388:	8b 45 0c             	mov    0xc(%ebp),%eax
  10538b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10538f:	8b 45 08             	mov    0x8(%ebp),%eax
  105392:	89 04 24             	mov    %eax,(%esp)
  105395:	e8 38 ff ff ff       	call   1052d2 <printnum>
  10539a:	eb 1c                	jmp    1053b8 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10539c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10539f:	89 44 24 04          	mov    %eax,0x4(%esp)
  1053a3:	8b 45 20             	mov    0x20(%ebp),%eax
  1053a6:	89 04 24             	mov    %eax,(%esp)
  1053a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1053ac:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1053ae:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1053b2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1053b6:	7f e4                	jg     10539c <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1053b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1053bb:	05 a4 6f 10 00       	add    $0x106fa4,%eax
  1053c0:	0f b6 00             	movzbl (%eax),%eax
  1053c3:	0f be c0             	movsbl %al,%eax
  1053c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1053c9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1053cd:	89 04 24             	mov    %eax,(%esp)
  1053d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1053d3:	ff d0                	call   *%eax
}
  1053d5:	c9                   	leave  
  1053d6:	c3                   	ret    

001053d7 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1053d7:	55                   	push   %ebp
  1053d8:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1053da:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1053de:	7e 14                	jle    1053f4 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1053e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1053e3:	8b 00                	mov    (%eax),%eax
  1053e5:	8d 48 08             	lea    0x8(%eax),%ecx
  1053e8:	8b 55 08             	mov    0x8(%ebp),%edx
  1053eb:	89 0a                	mov    %ecx,(%edx)
  1053ed:	8b 50 04             	mov    0x4(%eax),%edx
  1053f0:	8b 00                	mov    (%eax),%eax
  1053f2:	eb 30                	jmp    105424 <getuint+0x4d>
    }
    else if (lflag) {
  1053f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1053f8:	74 16                	je     105410 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1053fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1053fd:	8b 00                	mov    (%eax),%eax
  1053ff:	8d 48 04             	lea    0x4(%eax),%ecx
  105402:	8b 55 08             	mov    0x8(%ebp),%edx
  105405:	89 0a                	mov    %ecx,(%edx)
  105407:	8b 00                	mov    (%eax),%eax
  105409:	ba 00 00 00 00       	mov    $0x0,%edx
  10540e:	eb 14                	jmp    105424 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105410:	8b 45 08             	mov    0x8(%ebp),%eax
  105413:	8b 00                	mov    (%eax),%eax
  105415:	8d 48 04             	lea    0x4(%eax),%ecx
  105418:	8b 55 08             	mov    0x8(%ebp),%edx
  10541b:	89 0a                	mov    %ecx,(%edx)
  10541d:	8b 00                	mov    (%eax),%eax
  10541f:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105424:	5d                   	pop    %ebp
  105425:	c3                   	ret    

00105426 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105426:	55                   	push   %ebp
  105427:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105429:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10542d:	7e 14                	jle    105443 <getint+0x1d>
        return va_arg(*ap, long long);
  10542f:	8b 45 08             	mov    0x8(%ebp),%eax
  105432:	8b 00                	mov    (%eax),%eax
  105434:	8d 48 08             	lea    0x8(%eax),%ecx
  105437:	8b 55 08             	mov    0x8(%ebp),%edx
  10543a:	89 0a                	mov    %ecx,(%edx)
  10543c:	8b 50 04             	mov    0x4(%eax),%edx
  10543f:	8b 00                	mov    (%eax),%eax
  105441:	eb 28                	jmp    10546b <getint+0x45>
    }
    else if (lflag) {
  105443:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105447:	74 12                	je     10545b <getint+0x35>
        return va_arg(*ap, long);
  105449:	8b 45 08             	mov    0x8(%ebp),%eax
  10544c:	8b 00                	mov    (%eax),%eax
  10544e:	8d 48 04             	lea    0x4(%eax),%ecx
  105451:	8b 55 08             	mov    0x8(%ebp),%edx
  105454:	89 0a                	mov    %ecx,(%edx)
  105456:	8b 00                	mov    (%eax),%eax
  105458:	99                   	cltd   
  105459:	eb 10                	jmp    10546b <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  10545b:	8b 45 08             	mov    0x8(%ebp),%eax
  10545e:	8b 00                	mov    (%eax),%eax
  105460:	8d 48 04             	lea    0x4(%eax),%ecx
  105463:	8b 55 08             	mov    0x8(%ebp),%edx
  105466:	89 0a                	mov    %ecx,(%edx)
  105468:	8b 00                	mov    (%eax),%eax
  10546a:	99                   	cltd   
    }
}
  10546b:	5d                   	pop    %ebp
  10546c:	c3                   	ret    

0010546d <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10546d:	55                   	push   %ebp
  10546e:	89 e5                	mov    %esp,%ebp
  105470:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105473:	8d 45 14             	lea    0x14(%ebp),%eax
  105476:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10547c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105480:	8b 45 10             	mov    0x10(%ebp),%eax
  105483:	89 44 24 08          	mov    %eax,0x8(%esp)
  105487:	8b 45 0c             	mov    0xc(%ebp),%eax
  10548a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10548e:	8b 45 08             	mov    0x8(%ebp),%eax
  105491:	89 04 24             	mov    %eax,(%esp)
  105494:	e8 02 00 00 00       	call   10549b <vprintfmt>
    va_end(ap);
}
  105499:	c9                   	leave  
  10549a:	c3                   	ret    

0010549b <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10549b:	55                   	push   %ebp
  10549c:	89 e5                	mov    %esp,%ebp
  10549e:	56                   	push   %esi
  10549f:	53                   	push   %ebx
  1054a0:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1054a3:	eb 18                	jmp    1054bd <vprintfmt+0x22>
            if (ch == '\0') {
  1054a5:	85 db                	test   %ebx,%ebx
  1054a7:	75 05                	jne    1054ae <vprintfmt+0x13>
                return;
  1054a9:	e9 d1 03 00 00       	jmp    10587f <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  1054ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054b5:	89 1c 24             	mov    %ebx,(%esp)
  1054b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1054bb:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1054bd:	8b 45 10             	mov    0x10(%ebp),%eax
  1054c0:	8d 50 01             	lea    0x1(%eax),%edx
  1054c3:	89 55 10             	mov    %edx,0x10(%ebp)
  1054c6:	0f b6 00             	movzbl (%eax),%eax
  1054c9:	0f b6 d8             	movzbl %al,%ebx
  1054cc:	83 fb 25             	cmp    $0x25,%ebx
  1054cf:	75 d4                	jne    1054a5 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  1054d1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1054d5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1054dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1054df:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1054e2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1054e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1054ec:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1054ef:	8b 45 10             	mov    0x10(%ebp),%eax
  1054f2:	8d 50 01             	lea    0x1(%eax),%edx
  1054f5:	89 55 10             	mov    %edx,0x10(%ebp)
  1054f8:	0f b6 00             	movzbl (%eax),%eax
  1054fb:	0f b6 d8             	movzbl %al,%ebx
  1054fe:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105501:	83 f8 55             	cmp    $0x55,%eax
  105504:	0f 87 44 03 00 00    	ja     10584e <vprintfmt+0x3b3>
  10550a:	8b 04 85 c8 6f 10 00 	mov    0x106fc8(,%eax,4),%eax
  105511:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105513:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105517:	eb d6                	jmp    1054ef <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105519:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10551d:	eb d0                	jmp    1054ef <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10551f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105526:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105529:	89 d0                	mov    %edx,%eax
  10552b:	c1 e0 02             	shl    $0x2,%eax
  10552e:	01 d0                	add    %edx,%eax
  105530:	01 c0                	add    %eax,%eax
  105532:	01 d8                	add    %ebx,%eax
  105534:	83 e8 30             	sub    $0x30,%eax
  105537:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10553a:	8b 45 10             	mov    0x10(%ebp),%eax
  10553d:	0f b6 00             	movzbl (%eax),%eax
  105540:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105543:	83 fb 2f             	cmp    $0x2f,%ebx
  105546:	7e 0b                	jle    105553 <vprintfmt+0xb8>
  105548:	83 fb 39             	cmp    $0x39,%ebx
  10554b:	7f 06                	jg     105553 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10554d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  105551:	eb d3                	jmp    105526 <vprintfmt+0x8b>
            goto process_precision;
  105553:	eb 33                	jmp    105588 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  105555:	8b 45 14             	mov    0x14(%ebp),%eax
  105558:	8d 50 04             	lea    0x4(%eax),%edx
  10555b:	89 55 14             	mov    %edx,0x14(%ebp)
  10555e:	8b 00                	mov    (%eax),%eax
  105560:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105563:	eb 23                	jmp    105588 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  105565:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105569:	79 0c                	jns    105577 <vprintfmt+0xdc>
                width = 0;
  10556b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105572:	e9 78 ff ff ff       	jmp    1054ef <vprintfmt+0x54>
  105577:	e9 73 ff ff ff       	jmp    1054ef <vprintfmt+0x54>

        case '#':
            altflag = 1;
  10557c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105583:	e9 67 ff ff ff       	jmp    1054ef <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  105588:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10558c:	79 12                	jns    1055a0 <vprintfmt+0x105>
                width = precision, precision = -1;
  10558e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105591:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105594:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10559b:	e9 4f ff ff ff       	jmp    1054ef <vprintfmt+0x54>
  1055a0:	e9 4a ff ff ff       	jmp    1054ef <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1055a5:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1055a9:	e9 41 ff ff ff       	jmp    1054ef <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1055ae:	8b 45 14             	mov    0x14(%ebp),%eax
  1055b1:	8d 50 04             	lea    0x4(%eax),%edx
  1055b4:	89 55 14             	mov    %edx,0x14(%ebp)
  1055b7:	8b 00                	mov    (%eax),%eax
  1055b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1055bc:	89 54 24 04          	mov    %edx,0x4(%esp)
  1055c0:	89 04 24             	mov    %eax,(%esp)
  1055c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1055c6:	ff d0                	call   *%eax
            break;
  1055c8:	e9 ac 02 00 00       	jmp    105879 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1055cd:	8b 45 14             	mov    0x14(%ebp),%eax
  1055d0:	8d 50 04             	lea    0x4(%eax),%edx
  1055d3:	89 55 14             	mov    %edx,0x14(%ebp)
  1055d6:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1055d8:	85 db                	test   %ebx,%ebx
  1055da:	79 02                	jns    1055de <vprintfmt+0x143>
                err = -err;
  1055dc:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1055de:	83 fb 06             	cmp    $0x6,%ebx
  1055e1:	7f 0b                	jg     1055ee <vprintfmt+0x153>
  1055e3:	8b 34 9d 88 6f 10 00 	mov    0x106f88(,%ebx,4),%esi
  1055ea:	85 f6                	test   %esi,%esi
  1055ec:	75 23                	jne    105611 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  1055ee:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1055f2:	c7 44 24 08 b5 6f 10 	movl   $0x106fb5,0x8(%esp)
  1055f9:	00 
  1055fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  105601:	8b 45 08             	mov    0x8(%ebp),%eax
  105604:	89 04 24             	mov    %eax,(%esp)
  105607:	e8 61 fe ff ff       	call   10546d <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10560c:	e9 68 02 00 00       	jmp    105879 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105611:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105615:	c7 44 24 08 be 6f 10 	movl   $0x106fbe,0x8(%esp)
  10561c:	00 
  10561d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105620:	89 44 24 04          	mov    %eax,0x4(%esp)
  105624:	8b 45 08             	mov    0x8(%ebp),%eax
  105627:	89 04 24             	mov    %eax,(%esp)
  10562a:	e8 3e fe ff ff       	call   10546d <printfmt>
            }
            break;
  10562f:	e9 45 02 00 00       	jmp    105879 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105634:	8b 45 14             	mov    0x14(%ebp),%eax
  105637:	8d 50 04             	lea    0x4(%eax),%edx
  10563a:	89 55 14             	mov    %edx,0x14(%ebp)
  10563d:	8b 30                	mov    (%eax),%esi
  10563f:	85 f6                	test   %esi,%esi
  105641:	75 05                	jne    105648 <vprintfmt+0x1ad>
                p = "(null)";
  105643:	be c1 6f 10 00       	mov    $0x106fc1,%esi
            }
            if (width > 0 && padc != '-') {
  105648:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10564c:	7e 3e                	jle    10568c <vprintfmt+0x1f1>
  10564e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105652:	74 38                	je     10568c <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105654:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10565a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10565e:	89 34 24             	mov    %esi,(%esp)
  105661:	e8 15 03 00 00       	call   10597b <strnlen>
  105666:	29 c3                	sub    %eax,%ebx
  105668:	89 d8                	mov    %ebx,%eax
  10566a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10566d:	eb 17                	jmp    105686 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  10566f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105673:	8b 55 0c             	mov    0xc(%ebp),%edx
  105676:	89 54 24 04          	mov    %edx,0x4(%esp)
  10567a:	89 04 24             	mov    %eax,(%esp)
  10567d:	8b 45 08             	mov    0x8(%ebp),%eax
  105680:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  105682:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105686:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10568a:	7f e3                	jg     10566f <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10568c:	eb 38                	jmp    1056c6 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  10568e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105692:	74 1f                	je     1056b3 <vprintfmt+0x218>
  105694:	83 fb 1f             	cmp    $0x1f,%ebx
  105697:	7e 05                	jle    10569e <vprintfmt+0x203>
  105699:	83 fb 7e             	cmp    $0x7e,%ebx
  10569c:	7e 15                	jle    1056b3 <vprintfmt+0x218>
                    putch('?', putdat);
  10569e:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056a5:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1056ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1056af:	ff d0                	call   *%eax
  1056b1:	eb 0f                	jmp    1056c2 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  1056b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056ba:	89 1c 24             	mov    %ebx,(%esp)
  1056bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1056c0:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1056c2:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1056c6:	89 f0                	mov    %esi,%eax
  1056c8:	8d 70 01             	lea    0x1(%eax),%esi
  1056cb:	0f b6 00             	movzbl (%eax),%eax
  1056ce:	0f be d8             	movsbl %al,%ebx
  1056d1:	85 db                	test   %ebx,%ebx
  1056d3:	74 10                	je     1056e5 <vprintfmt+0x24a>
  1056d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1056d9:	78 b3                	js     10568e <vprintfmt+0x1f3>
  1056db:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  1056df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1056e3:	79 a9                	jns    10568e <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1056e5:	eb 17                	jmp    1056fe <vprintfmt+0x263>
                putch(' ', putdat);
  1056e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056ee:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1056f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1056f8:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1056fa:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1056fe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105702:	7f e3                	jg     1056e7 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  105704:	e9 70 01 00 00       	jmp    105879 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105709:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10570c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105710:	8d 45 14             	lea    0x14(%ebp),%eax
  105713:	89 04 24             	mov    %eax,(%esp)
  105716:	e8 0b fd ff ff       	call   105426 <getint>
  10571b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10571e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105724:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105727:	85 d2                	test   %edx,%edx
  105729:	79 26                	jns    105751 <vprintfmt+0x2b6>
                putch('-', putdat);
  10572b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10572e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105732:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105739:	8b 45 08             	mov    0x8(%ebp),%eax
  10573c:	ff d0                	call   *%eax
                num = -(long long)num;
  10573e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105741:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105744:	f7 d8                	neg    %eax
  105746:	83 d2 00             	adc    $0x0,%edx
  105749:	f7 da                	neg    %edx
  10574b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10574e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105751:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105758:	e9 a8 00 00 00       	jmp    105805 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  10575d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105760:	89 44 24 04          	mov    %eax,0x4(%esp)
  105764:	8d 45 14             	lea    0x14(%ebp),%eax
  105767:	89 04 24             	mov    %eax,(%esp)
  10576a:	e8 68 fc ff ff       	call   1053d7 <getuint>
  10576f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105772:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105775:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10577c:	e9 84 00 00 00       	jmp    105805 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105781:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105784:	89 44 24 04          	mov    %eax,0x4(%esp)
  105788:	8d 45 14             	lea    0x14(%ebp),%eax
  10578b:	89 04 24             	mov    %eax,(%esp)
  10578e:	e8 44 fc ff ff       	call   1053d7 <getuint>
  105793:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105796:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105799:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1057a0:	eb 63                	jmp    105805 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  1057a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057a9:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  1057b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1057b3:	ff d0                	call   *%eax
            putch('x', putdat);
  1057b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057bc:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  1057c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1057c6:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1057c8:	8b 45 14             	mov    0x14(%ebp),%eax
  1057cb:	8d 50 04             	lea    0x4(%eax),%edx
  1057ce:	89 55 14             	mov    %edx,0x14(%ebp)
  1057d1:	8b 00                	mov    (%eax),%eax
  1057d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1057d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1057dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1057e4:	eb 1f                	jmp    105805 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1057e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1057e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057ed:	8d 45 14             	lea    0x14(%ebp),%eax
  1057f0:	89 04 24             	mov    %eax,(%esp)
  1057f3:	e8 df fb ff ff       	call   1053d7 <getuint>
  1057f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1057fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1057fe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105805:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105809:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10580c:	89 54 24 18          	mov    %edx,0x18(%esp)
  105810:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105813:	89 54 24 14          	mov    %edx,0x14(%esp)
  105817:	89 44 24 10          	mov    %eax,0x10(%esp)
  10581b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10581e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105821:	89 44 24 08          	mov    %eax,0x8(%esp)
  105825:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105829:	8b 45 0c             	mov    0xc(%ebp),%eax
  10582c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105830:	8b 45 08             	mov    0x8(%ebp),%eax
  105833:	89 04 24             	mov    %eax,(%esp)
  105836:	e8 97 fa ff ff       	call   1052d2 <printnum>
            break;
  10583b:	eb 3c                	jmp    105879 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  10583d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105840:	89 44 24 04          	mov    %eax,0x4(%esp)
  105844:	89 1c 24             	mov    %ebx,(%esp)
  105847:	8b 45 08             	mov    0x8(%ebp),%eax
  10584a:	ff d0                	call   *%eax
            break;
  10584c:	eb 2b                	jmp    105879 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  10584e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105851:	89 44 24 04          	mov    %eax,0x4(%esp)
  105855:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10585c:	8b 45 08             	mov    0x8(%ebp),%eax
  10585f:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105861:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105865:	eb 04                	jmp    10586b <vprintfmt+0x3d0>
  105867:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10586b:	8b 45 10             	mov    0x10(%ebp),%eax
  10586e:	83 e8 01             	sub    $0x1,%eax
  105871:	0f b6 00             	movzbl (%eax),%eax
  105874:	3c 25                	cmp    $0x25,%al
  105876:	75 ef                	jne    105867 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  105878:	90                   	nop
        }
    }
  105879:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10587a:	e9 3e fc ff ff       	jmp    1054bd <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  10587f:	83 c4 40             	add    $0x40,%esp
  105882:	5b                   	pop    %ebx
  105883:	5e                   	pop    %esi
  105884:	5d                   	pop    %ebp
  105885:	c3                   	ret    

00105886 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105886:	55                   	push   %ebp
  105887:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105889:	8b 45 0c             	mov    0xc(%ebp),%eax
  10588c:	8b 40 08             	mov    0x8(%eax),%eax
  10588f:	8d 50 01             	lea    0x1(%eax),%edx
  105892:	8b 45 0c             	mov    0xc(%ebp),%eax
  105895:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105898:	8b 45 0c             	mov    0xc(%ebp),%eax
  10589b:	8b 10                	mov    (%eax),%edx
  10589d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058a0:	8b 40 04             	mov    0x4(%eax),%eax
  1058a3:	39 c2                	cmp    %eax,%edx
  1058a5:	73 12                	jae    1058b9 <sprintputch+0x33>
        *b->buf ++ = ch;
  1058a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058aa:	8b 00                	mov    (%eax),%eax
  1058ac:	8d 48 01             	lea    0x1(%eax),%ecx
  1058af:	8b 55 0c             	mov    0xc(%ebp),%edx
  1058b2:	89 0a                	mov    %ecx,(%edx)
  1058b4:	8b 55 08             	mov    0x8(%ebp),%edx
  1058b7:	88 10                	mov    %dl,(%eax)
    }
}
  1058b9:	5d                   	pop    %ebp
  1058ba:	c3                   	ret    

001058bb <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1058bb:	55                   	push   %ebp
  1058bc:	89 e5                	mov    %esp,%ebp
  1058be:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1058c1:	8d 45 14             	lea    0x14(%ebp),%eax
  1058c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1058c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1058ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1058d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1058d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1058df:	89 04 24             	mov    %eax,(%esp)
  1058e2:	e8 08 00 00 00       	call   1058ef <vsnprintf>
  1058e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1058ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1058ed:	c9                   	leave  
  1058ee:	c3                   	ret    

001058ef <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1058ef:	55                   	push   %ebp
  1058f0:	89 e5                	mov    %esp,%ebp
  1058f2:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1058f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1058f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1058fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058fe:	8d 50 ff             	lea    -0x1(%eax),%edx
  105901:	8b 45 08             	mov    0x8(%ebp),%eax
  105904:	01 d0                	add    %edx,%eax
  105906:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105909:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105910:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105914:	74 0a                	je     105920 <vsnprintf+0x31>
  105916:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10591c:	39 c2                	cmp    %eax,%edx
  10591e:	76 07                	jbe    105927 <vsnprintf+0x38>
        return -E_INVAL;
  105920:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105925:	eb 2a                	jmp    105951 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105927:	8b 45 14             	mov    0x14(%ebp),%eax
  10592a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10592e:	8b 45 10             	mov    0x10(%ebp),%eax
  105931:	89 44 24 08          	mov    %eax,0x8(%esp)
  105935:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105938:	89 44 24 04          	mov    %eax,0x4(%esp)
  10593c:	c7 04 24 86 58 10 00 	movl   $0x105886,(%esp)
  105943:	e8 53 fb ff ff       	call   10549b <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105948:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10594b:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10594e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105951:	c9                   	leave  
  105952:	c3                   	ret    

00105953 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105953:	55                   	push   %ebp
  105954:	89 e5                	mov    %esp,%ebp
  105956:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105959:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105960:	eb 04                	jmp    105966 <strlen+0x13>
        cnt ++;
  105962:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105966:	8b 45 08             	mov    0x8(%ebp),%eax
  105969:	8d 50 01             	lea    0x1(%eax),%edx
  10596c:	89 55 08             	mov    %edx,0x8(%ebp)
  10596f:	0f b6 00             	movzbl (%eax),%eax
  105972:	84 c0                	test   %al,%al
  105974:	75 ec                	jne    105962 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105976:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105979:	c9                   	leave  
  10597a:	c3                   	ret    

0010597b <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  10597b:	55                   	push   %ebp
  10597c:	89 e5                	mov    %esp,%ebp
  10597e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105981:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105988:	eb 04                	jmp    10598e <strnlen+0x13>
        cnt ++;
  10598a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  10598e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105991:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105994:	73 10                	jae    1059a6 <strnlen+0x2b>
  105996:	8b 45 08             	mov    0x8(%ebp),%eax
  105999:	8d 50 01             	lea    0x1(%eax),%edx
  10599c:	89 55 08             	mov    %edx,0x8(%ebp)
  10599f:	0f b6 00             	movzbl (%eax),%eax
  1059a2:	84 c0                	test   %al,%al
  1059a4:	75 e4                	jne    10598a <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  1059a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1059a9:	c9                   	leave  
  1059aa:	c3                   	ret    

001059ab <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1059ab:	55                   	push   %ebp
  1059ac:	89 e5                	mov    %esp,%ebp
  1059ae:	57                   	push   %edi
  1059af:	56                   	push   %esi
  1059b0:	83 ec 20             	sub    $0x20,%esp
  1059b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1059b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1059bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1059c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1059c5:	89 d1                	mov    %edx,%ecx
  1059c7:	89 c2                	mov    %eax,%edx
  1059c9:	89 ce                	mov    %ecx,%esi
  1059cb:	89 d7                	mov    %edx,%edi
  1059cd:	ac                   	lods   %ds:(%esi),%al
  1059ce:	aa                   	stos   %al,%es:(%edi)
  1059cf:	84 c0                	test   %al,%al
  1059d1:	75 fa                	jne    1059cd <strcpy+0x22>
  1059d3:	89 fa                	mov    %edi,%edx
  1059d5:	89 f1                	mov    %esi,%ecx
  1059d7:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1059da:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1059dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  1059e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1059e3:	83 c4 20             	add    $0x20,%esp
  1059e6:	5e                   	pop    %esi
  1059e7:	5f                   	pop    %edi
  1059e8:	5d                   	pop    %ebp
  1059e9:	c3                   	ret    

001059ea <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1059ea:	55                   	push   %ebp
  1059eb:	89 e5                	mov    %esp,%ebp
  1059ed:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1059f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1059f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1059f6:	eb 21                	jmp    105a19 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  1059f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059fb:	0f b6 10             	movzbl (%eax),%edx
  1059fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a01:	88 10                	mov    %dl,(%eax)
  105a03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a06:	0f b6 00             	movzbl (%eax),%eax
  105a09:	84 c0                	test   %al,%al
  105a0b:	74 04                	je     105a11 <strncpy+0x27>
            src ++;
  105a0d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105a11:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105a15:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105a19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a1d:	75 d9                	jne    1059f8 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105a1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105a22:	c9                   	leave  
  105a23:	c3                   	ret    

00105a24 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105a24:	55                   	push   %ebp
  105a25:	89 e5                	mov    %esp,%ebp
  105a27:	57                   	push   %edi
  105a28:	56                   	push   %esi
  105a29:	83 ec 20             	sub    $0x20,%esp
  105a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  105a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105a32:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a35:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105a38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a3e:	89 d1                	mov    %edx,%ecx
  105a40:	89 c2                	mov    %eax,%edx
  105a42:	89 ce                	mov    %ecx,%esi
  105a44:	89 d7                	mov    %edx,%edi
  105a46:	ac                   	lods   %ds:(%esi),%al
  105a47:	ae                   	scas   %es:(%edi),%al
  105a48:	75 08                	jne    105a52 <strcmp+0x2e>
  105a4a:	84 c0                	test   %al,%al
  105a4c:	75 f8                	jne    105a46 <strcmp+0x22>
  105a4e:	31 c0                	xor    %eax,%eax
  105a50:	eb 04                	jmp    105a56 <strcmp+0x32>
  105a52:	19 c0                	sbb    %eax,%eax
  105a54:	0c 01                	or     $0x1,%al
  105a56:	89 fa                	mov    %edi,%edx
  105a58:	89 f1                	mov    %esi,%ecx
  105a5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105a5d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105a60:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105a63:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105a66:	83 c4 20             	add    $0x20,%esp
  105a69:	5e                   	pop    %esi
  105a6a:	5f                   	pop    %edi
  105a6b:	5d                   	pop    %ebp
  105a6c:	c3                   	ret    

00105a6d <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105a6d:	55                   	push   %ebp
  105a6e:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105a70:	eb 0c                	jmp    105a7e <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105a72:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105a76:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105a7a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105a7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a82:	74 1a                	je     105a9e <strncmp+0x31>
  105a84:	8b 45 08             	mov    0x8(%ebp),%eax
  105a87:	0f b6 00             	movzbl (%eax),%eax
  105a8a:	84 c0                	test   %al,%al
  105a8c:	74 10                	je     105a9e <strncmp+0x31>
  105a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  105a91:	0f b6 10             	movzbl (%eax),%edx
  105a94:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a97:	0f b6 00             	movzbl (%eax),%eax
  105a9a:	38 c2                	cmp    %al,%dl
  105a9c:	74 d4                	je     105a72 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105a9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105aa2:	74 18                	je     105abc <strncmp+0x4f>
  105aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  105aa7:	0f b6 00             	movzbl (%eax),%eax
  105aaa:	0f b6 d0             	movzbl %al,%edx
  105aad:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ab0:	0f b6 00             	movzbl (%eax),%eax
  105ab3:	0f b6 c0             	movzbl %al,%eax
  105ab6:	29 c2                	sub    %eax,%edx
  105ab8:	89 d0                	mov    %edx,%eax
  105aba:	eb 05                	jmp    105ac1 <strncmp+0x54>
  105abc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105ac1:	5d                   	pop    %ebp
  105ac2:	c3                   	ret    

00105ac3 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105ac3:	55                   	push   %ebp
  105ac4:	89 e5                	mov    %esp,%ebp
  105ac6:	83 ec 04             	sub    $0x4,%esp
  105ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105acc:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105acf:	eb 14                	jmp    105ae5 <strchr+0x22>
        if (*s == c) {
  105ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  105ad4:	0f b6 00             	movzbl (%eax),%eax
  105ad7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105ada:	75 05                	jne    105ae1 <strchr+0x1e>
            return (char *)s;
  105adc:	8b 45 08             	mov    0x8(%ebp),%eax
  105adf:	eb 13                	jmp    105af4 <strchr+0x31>
        }
        s ++;
  105ae1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ae8:	0f b6 00             	movzbl (%eax),%eax
  105aeb:	84 c0                	test   %al,%al
  105aed:	75 e2                	jne    105ad1 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105aef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105af4:	c9                   	leave  
  105af5:	c3                   	ret    

00105af6 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105af6:	55                   	push   %ebp
  105af7:	89 e5                	mov    %esp,%ebp
  105af9:	83 ec 04             	sub    $0x4,%esp
  105afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aff:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105b02:	eb 11                	jmp    105b15 <strfind+0x1f>
        if (*s == c) {
  105b04:	8b 45 08             	mov    0x8(%ebp),%eax
  105b07:	0f b6 00             	movzbl (%eax),%eax
  105b0a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105b0d:	75 02                	jne    105b11 <strfind+0x1b>
            break;
  105b0f:	eb 0e                	jmp    105b1f <strfind+0x29>
        }
        s ++;
  105b11:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105b15:	8b 45 08             	mov    0x8(%ebp),%eax
  105b18:	0f b6 00             	movzbl (%eax),%eax
  105b1b:	84 c0                	test   %al,%al
  105b1d:	75 e5                	jne    105b04 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105b1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105b22:	c9                   	leave  
  105b23:	c3                   	ret    

00105b24 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105b24:	55                   	push   %ebp
  105b25:	89 e5                	mov    %esp,%ebp
  105b27:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105b2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105b31:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105b38:	eb 04                	jmp    105b3e <strtol+0x1a>
        s ++;
  105b3a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  105b41:	0f b6 00             	movzbl (%eax),%eax
  105b44:	3c 20                	cmp    $0x20,%al
  105b46:	74 f2                	je     105b3a <strtol+0x16>
  105b48:	8b 45 08             	mov    0x8(%ebp),%eax
  105b4b:	0f b6 00             	movzbl (%eax),%eax
  105b4e:	3c 09                	cmp    $0x9,%al
  105b50:	74 e8                	je     105b3a <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105b52:	8b 45 08             	mov    0x8(%ebp),%eax
  105b55:	0f b6 00             	movzbl (%eax),%eax
  105b58:	3c 2b                	cmp    $0x2b,%al
  105b5a:	75 06                	jne    105b62 <strtol+0x3e>
        s ++;
  105b5c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105b60:	eb 15                	jmp    105b77 <strtol+0x53>
    }
    else if (*s == '-') {
  105b62:	8b 45 08             	mov    0x8(%ebp),%eax
  105b65:	0f b6 00             	movzbl (%eax),%eax
  105b68:	3c 2d                	cmp    $0x2d,%al
  105b6a:	75 0b                	jne    105b77 <strtol+0x53>
        s ++, neg = 1;
  105b6c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105b70:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105b77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b7b:	74 06                	je     105b83 <strtol+0x5f>
  105b7d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105b81:	75 24                	jne    105ba7 <strtol+0x83>
  105b83:	8b 45 08             	mov    0x8(%ebp),%eax
  105b86:	0f b6 00             	movzbl (%eax),%eax
  105b89:	3c 30                	cmp    $0x30,%al
  105b8b:	75 1a                	jne    105ba7 <strtol+0x83>
  105b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  105b90:	83 c0 01             	add    $0x1,%eax
  105b93:	0f b6 00             	movzbl (%eax),%eax
  105b96:	3c 78                	cmp    $0x78,%al
  105b98:	75 0d                	jne    105ba7 <strtol+0x83>
        s += 2, base = 16;
  105b9a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105b9e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105ba5:	eb 2a                	jmp    105bd1 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105ba7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105bab:	75 17                	jne    105bc4 <strtol+0xa0>
  105bad:	8b 45 08             	mov    0x8(%ebp),%eax
  105bb0:	0f b6 00             	movzbl (%eax),%eax
  105bb3:	3c 30                	cmp    $0x30,%al
  105bb5:	75 0d                	jne    105bc4 <strtol+0xa0>
        s ++, base = 8;
  105bb7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105bbb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105bc2:	eb 0d                	jmp    105bd1 <strtol+0xad>
    }
    else if (base == 0) {
  105bc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105bc8:	75 07                	jne    105bd1 <strtol+0xad>
        base = 10;
  105bca:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  105bd4:	0f b6 00             	movzbl (%eax),%eax
  105bd7:	3c 2f                	cmp    $0x2f,%al
  105bd9:	7e 1b                	jle    105bf6 <strtol+0xd2>
  105bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  105bde:	0f b6 00             	movzbl (%eax),%eax
  105be1:	3c 39                	cmp    $0x39,%al
  105be3:	7f 11                	jg     105bf6 <strtol+0xd2>
            dig = *s - '0';
  105be5:	8b 45 08             	mov    0x8(%ebp),%eax
  105be8:	0f b6 00             	movzbl (%eax),%eax
  105beb:	0f be c0             	movsbl %al,%eax
  105bee:	83 e8 30             	sub    $0x30,%eax
  105bf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105bf4:	eb 48                	jmp    105c3e <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  105bf9:	0f b6 00             	movzbl (%eax),%eax
  105bfc:	3c 60                	cmp    $0x60,%al
  105bfe:	7e 1b                	jle    105c1b <strtol+0xf7>
  105c00:	8b 45 08             	mov    0x8(%ebp),%eax
  105c03:	0f b6 00             	movzbl (%eax),%eax
  105c06:	3c 7a                	cmp    $0x7a,%al
  105c08:	7f 11                	jg     105c1b <strtol+0xf7>
            dig = *s - 'a' + 10;
  105c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  105c0d:	0f b6 00             	movzbl (%eax),%eax
  105c10:	0f be c0             	movsbl %al,%eax
  105c13:	83 e8 57             	sub    $0x57,%eax
  105c16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105c19:	eb 23                	jmp    105c3e <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  105c1e:	0f b6 00             	movzbl (%eax),%eax
  105c21:	3c 40                	cmp    $0x40,%al
  105c23:	7e 3d                	jle    105c62 <strtol+0x13e>
  105c25:	8b 45 08             	mov    0x8(%ebp),%eax
  105c28:	0f b6 00             	movzbl (%eax),%eax
  105c2b:	3c 5a                	cmp    $0x5a,%al
  105c2d:	7f 33                	jg     105c62 <strtol+0x13e>
            dig = *s - 'A' + 10;
  105c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c32:	0f b6 00             	movzbl (%eax),%eax
  105c35:	0f be c0             	movsbl %al,%eax
  105c38:	83 e8 37             	sub    $0x37,%eax
  105c3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c41:	3b 45 10             	cmp    0x10(%ebp),%eax
  105c44:	7c 02                	jl     105c48 <strtol+0x124>
            break;
  105c46:	eb 1a                	jmp    105c62 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105c48:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105c4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105c4f:	0f af 45 10          	imul   0x10(%ebp),%eax
  105c53:	89 c2                	mov    %eax,%edx
  105c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c58:	01 d0                	add    %edx,%eax
  105c5a:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105c5d:	e9 6f ff ff ff       	jmp    105bd1 <strtol+0xad>

    if (endptr) {
  105c62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105c66:	74 08                	je     105c70 <strtol+0x14c>
        *endptr = (char *) s;
  105c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c6b:	8b 55 08             	mov    0x8(%ebp),%edx
  105c6e:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105c70:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105c74:	74 07                	je     105c7d <strtol+0x159>
  105c76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105c79:	f7 d8                	neg    %eax
  105c7b:	eb 03                	jmp    105c80 <strtol+0x15c>
  105c7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105c80:	c9                   	leave  
  105c81:	c3                   	ret    

00105c82 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105c82:	55                   	push   %ebp
  105c83:	89 e5                	mov    %esp,%ebp
  105c85:	57                   	push   %edi
  105c86:	83 ec 24             	sub    $0x24,%esp
  105c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c8c:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105c8f:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105c93:	8b 55 08             	mov    0x8(%ebp),%edx
  105c96:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105c99:	88 45 f7             	mov    %al,-0x9(%ebp)
  105c9c:	8b 45 10             	mov    0x10(%ebp),%eax
  105c9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105ca2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105ca5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105ca9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105cac:	89 d7                	mov    %edx,%edi
  105cae:	f3 aa                	rep stos %al,%es:(%edi)
  105cb0:	89 fa                	mov    %edi,%edx
  105cb2:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105cb5:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105cb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105cbb:	83 c4 24             	add    $0x24,%esp
  105cbe:	5f                   	pop    %edi
  105cbf:	5d                   	pop    %ebp
  105cc0:	c3                   	ret    

00105cc1 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105cc1:	55                   	push   %ebp
  105cc2:	89 e5                	mov    %esp,%ebp
  105cc4:	57                   	push   %edi
  105cc5:	56                   	push   %esi
  105cc6:	53                   	push   %ebx
  105cc7:	83 ec 30             	sub    $0x30,%esp
  105cca:	8b 45 08             	mov    0x8(%ebp),%eax
  105ccd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105cd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105cd6:	8b 45 10             	mov    0x10(%ebp),%eax
  105cd9:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105cdf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105ce2:	73 42                	jae    105d26 <memmove+0x65>
  105ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ce7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105cea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ced:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105cf0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105cf3:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105cf6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105cf9:	c1 e8 02             	shr    $0x2,%eax
  105cfc:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105cfe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105d01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105d04:	89 d7                	mov    %edx,%edi
  105d06:	89 c6                	mov    %eax,%esi
  105d08:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105d0a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105d0d:	83 e1 03             	and    $0x3,%ecx
  105d10:	74 02                	je     105d14 <memmove+0x53>
  105d12:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105d14:	89 f0                	mov    %esi,%eax
  105d16:	89 fa                	mov    %edi,%edx
  105d18:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105d1b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105d1e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105d21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105d24:	eb 36                	jmp    105d5c <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105d26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105d29:	8d 50 ff             	lea    -0x1(%eax),%edx
  105d2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d2f:	01 c2                	add    %eax,%edx
  105d31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105d34:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105d37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d3a:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105d3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105d40:	89 c1                	mov    %eax,%ecx
  105d42:	89 d8                	mov    %ebx,%eax
  105d44:	89 d6                	mov    %edx,%esi
  105d46:	89 c7                	mov    %eax,%edi
  105d48:	fd                   	std    
  105d49:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105d4b:	fc                   	cld    
  105d4c:	89 f8                	mov    %edi,%eax
  105d4e:	89 f2                	mov    %esi,%edx
  105d50:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105d53:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105d56:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105d5c:	83 c4 30             	add    $0x30,%esp
  105d5f:	5b                   	pop    %ebx
  105d60:	5e                   	pop    %esi
  105d61:	5f                   	pop    %edi
  105d62:	5d                   	pop    %ebp
  105d63:	c3                   	ret    

00105d64 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105d64:	55                   	push   %ebp
  105d65:	89 e5                	mov    %esp,%ebp
  105d67:	57                   	push   %edi
  105d68:	56                   	push   %esi
  105d69:	83 ec 20             	sub    $0x20,%esp
  105d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  105d6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d78:	8b 45 10             	mov    0x10(%ebp),%eax
  105d7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105d7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d81:	c1 e8 02             	shr    $0x2,%eax
  105d84:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105d86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105d89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d8c:	89 d7                	mov    %edx,%edi
  105d8e:	89 c6                	mov    %eax,%esi
  105d90:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105d92:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105d95:	83 e1 03             	and    $0x3,%ecx
  105d98:	74 02                	je     105d9c <memcpy+0x38>
  105d9a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105d9c:	89 f0                	mov    %esi,%eax
  105d9e:	89 fa                	mov    %edi,%edx
  105da0:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105da3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105da6:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105dac:	83 c4 20             	add    $0x20,%esp
  105daf:	5e                   	pop    %esi
  105db0:	5f                   	pop    %edi
  105db1:	5d                   	pop    %ebp
  105db2:	c3                   	ret    

00105db3 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105db3:	55                   	push   %ebp
  105db4:	89 e5                	mov    %esp,%ebp
  105db6:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105db9:	8b 45 08             	mov    0x8(%ebp),%eax
  105dbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dc2:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105dc5:	eb 30                	jmp    105df7 <memcmp+0x44>
        if (*s1 != *s2) {
  105dc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105dca:	0f b6 10             	movzbl (%eax),%edx
  105dcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105dd0:	0f b6 00             	movzbl (%eax),%eax
  105dd3:	38 c2                	cmp    %al,%dl
  105dd5:	74 18                	je     105def <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105dda:	0f b6 00             	movzbl (%eax),%eax
  105ddd:	0f b6 d0             	movzbl %al,%edx
  105de0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105de3:	0f b6 00             	movzbl (%eax),%eax
  105de6:	0f b6 c0             	movzbl %al,%eax
  105de9:	29 c2                	sub    %eax,%edx
  105deb:	89 d0                	mov    %edx,%eax
  105ded:	eb 1a                	jmp    105e09 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105def:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105df3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105df7:	8b 45 10             	mov    0x10(%ebp),%eax
  105dfa:	8d 50 ff             	lea    -0x1(%eax),%edx
  105dfd:	89 55 10             	mov    %edx,0x10(%ebp)
  105e00:	85 c0                	test   %eax,%eax
  105e02:	75 c3                	jne    105dc7 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105e04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105e09:	c9                   	leave  
  105e0a:	c3                   	ret    
