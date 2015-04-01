
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 88 89 11 c0       	mov    $0xc0118988,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 2c 5c 00 00       	call   c0105c82 <memset>

    cons_init();                // init the console
c0100056:	e8 74 15 00 00       	call   c01015cf <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 20 5e 10 c0 	movl   $0xc0105e20,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 3c 5e 10 c0 	movl   $0xc0105e3c,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 a9 42 00 00       	call   c010432d <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 af 16 00 00       	call   c0101738 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 01 18 00 00       	call   c010188f <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 f2 0c 00 00       	call   c0100d85 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 0e 16 00 00       	call   c01016a6 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 fb 0b 00 00       	call   c0100cb7 <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 41 5e 10 c0 	movl   $0xc0105e41,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 4f 5e 10 c0 	movl   $0xc0105e4f,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 5d 5e 10 c0 	movl   $0xc0105e5d,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 6b 5e 10 c0 	movl   $0xc0105e6b,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 79 5e 10 c0 	movl   $0xc0105e79,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 88 5e 10 c0 	movl   $0xc0105e88,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 a8 5e 10 c0 	movl   $0xc0105ea8,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 c7 5e 10 c0 	movl   $0xc0105ec7,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 01 13 00 00       	call   c01015fb <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 64 51 00 00       	call   c010549b <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 88 12 00 00       	call   c01015fb <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 68 12 00 00       	call   c0101637 <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 cc 5e 10 c0    	movl   $0xc0105ecc,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 cc 5e 10 c0 	movl   $0xc0105ecc,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 20 71 10 c0 	movl   $0xc0107120,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 88 1a 11 c0 	movl   $0xc0111a88,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec 89 1a 11 c0 	movl   $0xc0111a89,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 b2 44 11 c0 	movl   $0xc01144b2,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 0a 54 00 00       	call   c0105af6 <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 d6 5e 10 c0 	movl   $0xc0105ed6,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 ef 5e 10 c0 	movl   $0xc0105eef,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 0b 5e 10 	movl   $0xc0105e0b,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 07 5f 10 c0 	movl   $0xc0105f07,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 1f 5f 10 c0 	movl   $0xc0105f1f,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 88 89 11 	movl   $0xc0118988,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 37 5f 10 c0 	movl   $0xc0105f37,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 88 89 11 c0       	mov    $0xc0118988,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 50 5f 10 c0 	movl   $0xc0105f50,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 7a 5f 10 c0 	movl   $0xc0105f7a,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 96 5f 10 c0 	movl   $0xc0105f96,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	53                   	push   %ebx
c01009be:	83 ec 44             	sub    $0x44,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009c1:	89 e8                	mov    %ebp,%eax
c01009c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c01009c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
      uint32_t ebp = read_ebp();
c01009c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      uint32_t eip = read_eip();
c01009cc:	e8 d8 ff ff ff       	call   c01009a9 <read_eip>
c01009d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
      int i;
      for (i = 0; i < STACKFRAME_DEPTH; i++)
c01009d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009db:	e9 8c 00 00 00       	jmp    c0100a6c <print_stackframe+0xb2>
      {
            if (ebp == 0) break;
c01009e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01009e4:	75 05                	jne    c01009eb <print_stackframe+0x31>
c01009e6:	e9 8b 00 00 00       	jmp    c0100a76 <print_stackframe+0xbc>
            cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
c01009eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009ee:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f9:	c7 04 24 a8 5f 10 c0 	movl   $0xc0105fa8,(%esp)
c0100a00:	e8 37 f9 ff ff       	call   c010033c <cprintf>
            uint32_t* args = ((uint32_t*)ebp) + 2;
c0100a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a08:	83 c0 08             	add    $0x8,%eax
c0100a0b:	89 45 e8             	mov    %eax,-0x18(%ebp)
            cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x\n", args[0], args[1], args[2], args[3]);
c0100a0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a11:	83 c0 0c             	add    $0xc,%eax
c0100a14:	8b 18                	mov    (%eax),%ebx
c0100a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a19:	83 c0 08             	add    $0x8,%eax
c0100a1c:	8b 08                	mov    (%eax),%ecx
c0100a1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a21:	83 c0 04             	add    $0x4,%eax
c0100a24:	8b 10                	mov    (%eax),%edx
c0100a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a29:	8b 00                	mov    (%eax),%eax
c0100a2b:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c0100a2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a33:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a3b:	c7 04 24 c0 5f 10 c0 	movl   $0xc0105fc0,(%esp)
c0100a42:	e8 f5 f8 ff ff       	call   c010033c <cprintf>
            print_debuginfo(eip-1);
c0100a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a4a:	83 e8 01             	sub    $0x1,%eax
c0100a4d:	89 04 24             	mov    %eax,(%esp)
c0100a50:	e8 b1 fe ff ff       	call   c0100906 <print_debuginfo>
            eip = *(uint32_t*)(ebp + 4);
c0100a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a58:	83 c0 04             	add    $0x4,%eax
c0100a5b:	8b 00                	mov    (%eax),%eax
c0100a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
            ebp = *(uint32_t*)ebp;
c0100a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a63:	8b 00                	mov    (%eax),%eax
c0100a65:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
      uint32_t ebp = read_ebp();
      uint32_t eip = read_eip();
      int i;
      for (i = 0; i < STACKFRAME_DEPTH; i++)
c0100a68:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a6c:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a70:	0f 8e 6a ff ff ff    	jle    c01009e0 <print_stackframe+0x26>
            cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x\n", args[0], args[1], args[2], args[3]);
            print_debuginfo(eip-1);
            eip = *(uint32_t*)(ebp + 4);
            ebp = *(uint32_t*)ebp;
      }
}
c0100a76:	83 c4 44             	add    $0x44,%esp
c0100a79:	5b                   	pop    %ebx
c0100a7a:	5d                   	pop    %ebp
c0100a7b:	c3                   	ret    

c0100a7c <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a7c:	55                   	push   %ebp
c0100a7d:	89 e5                	mov    %esp,%ebp
c0100a7f:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a89:	eb 0c                	jmp    c0100a97 <parse+0x1b>
            *buf ++ = '\0';
c0100a8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a8e:	8d 50 01             	lea    0x1(%eax),%edx
c0100a91:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a94:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a97:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a9a:	0f b6 00             	movzbl (%eax),%eax
c0100a9d:	84 c0                	test   %al,%al
c0100a9f:	74 1d                	je     c0100abe <parse+0x42>
c0100aa1:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa4:	0f b6 00             	movzbl (%eax),%eax
c0100aa7:	0f be c0             	movsbl %al,%eax
c0100aaa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aae:	c7 04 24 64 60 10 c0 	movl   $0xc0106064,(%esp)
c0100ab5:	e8 09 50 00 00       	call   c0105ac3 <strchr>
c0100aba:	85 c0                	test   %eax,%eax
c0100abc:	75 cd                	jne    c0100a8b <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100abe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac1:	0f b6 00             	movzbl (%eax),%eax
c0100ac4:	84 c0                	test   %al,%al
c0100ac6:	75 02                	jne    c0100aca <parse+0x4e>
            break;
c0100ac8:	eb 67                	jmp    c0100b31 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100aca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ace:	75 14                	jne    c0100ae4 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ad0:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ad7:	00 
c0100ad8:	c7 04 24 69 60 10 c0 	movl   $0xc0106069,(%esp)
c0100adf:	e8 58 f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae7:	8d 50 01             	lea    0x1(%eax),%edx
c0100aea:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100aed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100af4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100af7:	01 c2                	add    %eax,%edx
c0100af9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100afc:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100afe:	eb 04                	jmp    c0100b04 <parse+0x88>
            buf ++;
c0100b00:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b04:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b07:	0f b6 00             	movzbl (%eax),%eax
c0100b0a:	84 c0                	test   %al,%al
c0100b0c:	74 1d                	je     c0100b2b <parse+0xaf>
c0100b0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b11:	0f b6 00             	movzbl (%eax),%eax
c0100b14:	0f be c0             	movsbl %al,%eax
c0100b17:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b1b:	c7 04 24 64 60 10 c0 	movl   $0xc0106064,(%esp)
c0100b22:	e8 9c 4f 00 00       	call   c0105ac3 <strchr>
c0100b27:	85 c0                	test   %eax,%eax
c0100b29:	74 d5                	je     c0100b00 <parse+0x84>
            buf ++;
        }
    }
c0100b2b:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b2c:	e9 66 ff ff ff       	jmp    c0100a97 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b34:	c9                   	leave  
c0100b35:	c3                   	ret    

c0100b36 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b36:	55                   	push   %ebp
c0100b37:	89 e5                	mov    %esp,%ebp
c0100b39:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b3c:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b43:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b46:	89 04 24             	mov    %eax,(%esp)
c0100b49:	e8 2e ff ff ff       	call   c0100a7c <parse>
c0100b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b55:	75 0a                	jne    c0100b61 <runcmd+0x2b>
        return 0;
c0100b57:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b5c:	e9 85 00 00 00       	jmp    c0100be6 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b68:	eb 5c                	jmp    c0100bc6 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b6a:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b70:	89 d0                	mov    %edx,%eax
c0100b72:	01 c0                	add    %eax,%eax
c0100b74:	01 d0                	add    %edx,%eax
c0100b76:	c1 e0 02             	shl    $0x2,%eax
c0100b79:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b7e:	8b 00                	mov    (%eax),%eax
c0100b80:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b84:	89 04 24             	mov    %eax,(%esp)
c0100b87:	e8 98 4e 00 00       	call   c0105a24 <strcmp>
c0100b8c:	85 c0                	test   %eax,%eax
c0100b8e:	75 32                	jne    c0100bc2 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b90:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b93:	89 d0                	mov    %edx,%eax
c0100b95:	01 c0                	add    %eax,%eax
c0100b97:	01 d0                	add    %edx,%eax
c0100b99:	c1 e0 02             	shl    $0x2,%eax
c0100b9c:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100ba1:	8b 40 08             	mov    0x8(%eax),%eax
c0100ba4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100ba7:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100baa:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bad:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bb1:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bb4:	83 c2 04             	add    $0x4,%edx
c0100bb7:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bbb:	89 0c 24             	mov    %ecx,(%esp)
c0100bbe:	ff d0                	call   *%eax
c0100bc0:	eb 24                	jmp    c0100be6 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bc2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bc9:	83 f8 02             	cmp    $0x2,%eax
c0100bcc:	76 9c                	jbe    c0100b6a <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bce:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd5:	c7 04 24 87 60 10 c0 	movl   $0xc0106087,(%esp)
c0100bdc:	e8 5b f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100be1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100be6:	c9                   	leave  
c0100be7:	c3                   	ret    

c0100be8 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100be8:	55                   	push   %ebp
c0100be9:	89 e5                	mov    %esp,%ebp
c0100beb:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bee:	c7 04 24 a0 60 10 c0 	movl   $0xc01060a0,(%esp)
c0100bf5:	e8 42 f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bfa:	c7 04 24 c8 60 10 c0 	movl   $0xc01060c8,(%esp)
c0100c01:	e8 36 f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100c06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c0a:	74 0b                	je     c0100c17 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c0f:	89 04 24             	mov    %eax,(%esp)
c0100c12:	e8 2c 0e 00 00       	call   c0101a43 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c17:	c7 04 24 ed 60 10 c0 	movl   $0xc01060ed,(%esp)
c0100c1e:	e8 10 f6 ff ff       	call   c0100233 <readline>
c0100c23:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c2a:	74 18                	je     c0100c44 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c2f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c36:	89 04 24             	mov    %eax,(%esp)
c0100c39:	e8 f8 fe ff ff       	call   c0100b36 <runcmd>
c0100c3e:	85 c0                	test   %eax,%eax
c0100c40:	79 02                	jns    c0100c44 <kmonitor+0x5c>
                break;
c0100c42:	eb 02                	jmp    c0100c46 <kmonitor+0x5e>
            }
        }
    }
c0100c44:	eb d1                	jmp    c0100c17 <kmonitor+0x2f>
}
c0100c46:	c9                   	leave  
c0100c47:	c3                   	ret    

c0100c48 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c48:	55                   	push   %ebp
c0100c49:	89 e5                	mov    %esp,%ebp
c0100c4b:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c55:	eb 3f                	jmp    c0100c96 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c57:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c5a:	89 d0                	mov    %edx,%eax
c0100c5c:	01 c0                	add    %eax,%eax
c0100c5e:	01 d0                	add    %edx,%eax
c0100c60:	c1 e0 02             	shl    $0x2,%eax
c0100c63:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c68:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c6e:	89 d0                	mov    %edx,%eax
c0100c70:	01 c0                	add    %eax,%eax
c0100c72:	01 d0                	add    %edx,%eax
c0100c74:	c1 e0 02             	shl    $0x2,%eax
c0100c77:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c7c:	8b 00                	mov    (%eax),%eax
c0100c7e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c82:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c86:	c7 04 24 f1 60 10 c0 	movl   $0xc01060f1,(%esp)
c0100c8d:	e8 aa f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c92:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c99:	83 f8 02             	cmp    $0x2,%eax
c0100c9c:	76 b9                	jbe    c0100c57 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100c9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca3:	c9                   	leave  
c0100ca4:	c3                   	ret    

c0100ca5 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100ca5:	55                   	push   %ebp
c0100ca6:	89 e5                	mov    %esp,%ebp
c0100ca8:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cab:	e8 c0 fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100cb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb5:	c9                   	leave  
c0100cb6:	c3                   	ret    

c0100cb7 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cb7:	55                   	push   %ebp
c0100cb8:	89 e5                	mov    %esp,%ebp
c0100cba:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cbd:	e8 f8 fc ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100cc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc7:	c9                   	leave  
c0100cc8:	c3                   	ret    

c0100cc9 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cc9:	55                   	push   %ebp
c0100cca:	89 e5                	mov    %esp,%ebp
c0100ccc:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ccf:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100cd4:	85 c0                	test   %eax,%eax
c0100cd6:	74 02                	je     c0100cda <__panic+0x11>
        goto panic_dead;
c0100cd8:	eb 48                	jmp    c0100d22 <__panic+0x59>
    }
    is_panic = 1;
c0100cda:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100ce1:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100ce4:	8d 45 14             	lea    0x14(%ebp),%eax
c0100ce7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cea:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ced:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cf1:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cf4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cf8:	c7 04 24 fa 60 10 c0 	movl   $0xc01060fa,(%esp)
c0100cff:	e8 38 f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d0b:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d0e:	89 04 24             	mov    %eax,(%esp)
c0100d11:	e8 f3 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d16:	c7 04 24 16 61 10 c0 	movl   $0xc0106116,(%esp)
c0100d1d:	e8 1a f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d22:	e8 85 09 00 00       	call   c01016ac <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d27:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d2e:	e8 b5 fe ff ff       	call   c0100be8 <kmonitor>
    }
c0100d33:	eb f2                	jmp    c0100d27 <__panic+0x5e>

c0100d35 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d35:	55                   	push   %ebp
c0100d36:	89 e5                	mov    %esp,%ebp
c0100d38:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d3b:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d41:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d44:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d48:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d4f:	c7 04 24 18 61 10 c0 	movl   $0xc0106118,(%esp)
c0100d56:	e8 e1 f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d5e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d62:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d65:	89 04 24             	mov    %eax,(%esp)
c0100d68:	e8 9c f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d6d:	c7 04 24 16 61 10 c0 	movl   $0xc0106116,(%esp)
c0100d74:	e8 c3 f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d79:	c9                   	leave  
c0100d7a:	c3                   	ret    

c0100d7b <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d7b:	55                   	push   %ebp
c0100d7c:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d7e:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d83:	5d                   	pop    %ebp
c0100d84:	c3                   	ret    

c0100d85 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d85:	55                   	push   %ebp
c0100d86:	89 e5                	mov    %esp,%ebp
c0100d88:	83 ec 28             	sub    $0x28,%esp
c0100d8b:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d91:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d95:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d99:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d9d:	ee                   	out    %al,(%dx)
c0100d9e:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100da4:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100da8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dac:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100db0:	ee                   	out    %al,(%dx)
c0100db1:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100db7:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dbb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dbf:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dc3:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dc4:	c7 05 6c 89 11 c0 00 	movl   $0x0,0xc011896c
c0100dcb:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dce:	c7 04 24 36 61 10 c0 	movl   $0xc0106136,(%esp)
c0100dd5:	e8 62 f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100dda:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100de1:	e8 24 09 00 00       	call   c010170a <pic_enable>
}
c0100de6:	c9                   	leave  
c0100de7:	c3                   	ret    

c0100de8 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100de8:	55                   	push   %ebp
c0100de9:	89 e5                	mov    %esp,%ebp
c0100deb:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dee:	9c                   	pushf  
c0100def:	58                   	pop    %eax
c0100df0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100df6:	25 00 02 00 00       	and    $0x200,%eax
c0100dfb:	85 c0                	test   %eax,%eax
c0100dfd:	74 0c                	je     c0100e0b <__intr_save+0x23>
        intr_disable();
c0100dff:	e8 a8 08 00 00       	call   c01016ac <intr_disable>
        return 1;
c0100e04:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e09:	eb 05                	jmp    c0100e10 <__intr_save+0x28>
    }
    return 0;
c0100e0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e10:	c9                   	leave  
c0100e11:	c3                   	ret    

c0100e12 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e12:	55                   	push   %ebp
c0100e13:	89 e5                	mov    %esp,%ebp
c0100e15:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e1c:	74 05                	je     c0100e23 <__intr_restore+0x11>
        intr_enable();
c0100e1e:	e8 83 08 00 00       	call   c01016a6 <intr_enable>
    }
}
c0100e23:	c9                   	leave  
c0100e24:	c3                   	ret    

c0100e25 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e25:	55                   	push   %ebp
c0100e26:	89 e5                	mov    %esp,%ebp
c0100e28:	83 ec 10             	sub    $0x10,%esp
c0100e2b:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e31:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e35:	89 c2                	mov    %eax,%edx
c0100e37:	ec                   	in     (%dx),%al
c0100e38:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e3b:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e41:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e45:	89 c2                	mov    %eax,%edx
c0100e47:	ec                   	in     (%dx),%al
c0100e48:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e4b:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e51:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e55:	89 c2                	mov    %eax,%edx
c0100e57:	ec                   	in     (%dx),%al
c0100e58:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e5b:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e61:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e65:	89 c2                	mov    %eax,%edx
c0100e67:	ec                   	in     (%dx),%al
c0100e68:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e6b:	c9                   	leave  
c0100e6c:	c3                   	ret    

c0100e6d <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e6d:	55                   	push   %ebp
c0100e6e:	89 e5                	mov    %esp,%ebp
c0100e70:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e73:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e7d:	0f b7 00             	movzwl (%eax),%eax
c0100e80:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e87:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8f:	0f b7 00             	movzwl (%eax),%eax
c0100e92:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e96:	74 12                	je     c0100eaa <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e98:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e9f:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100ea6:	b4 03 
c0100ea8:	eb 13                	jmp    c0100ebd <cga_init+0x50>
    } else {
        *cp = was;
c0100eaa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ead:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eb1:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eb4:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100ebb:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ebd:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ec4:	0f b7 c0             	movzwl %ax,%eax
c0100ec7:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ecb:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ecf:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ed3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ed7:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ed8:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100edf:	83 c0 01             	add    $0x1,%eax
c0100ee2:	0f b7 c0             	movzwl %ax,%eax
c0100ee5:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ee9:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100eed:	89 c2                	mov    %eax,%edx
c0100eef:	ec                   	in     (%dx),%al
c0100ef0:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ef3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ef7:	0f b6 c0             	movzbl %al,%eax
c0100efa:	c1 e0 08             	shl    $0x8,%eax
c0100efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f00:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f07:	0f b7 c0             	movzwl %ax,%eax
c0100f0a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f0e:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f12:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f16:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f1a:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f1b:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f22:	83 c0 01             	add    $0x1,%eax
c0100f25:	0f b7 c0             	movzwl %ax,%eax
c0100f28:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f2c:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f30:	89 c2                	mov    %eax,%edx
c0100f32:	ec                   	in     (%dx),%al
c0100f33:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f36:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f3a:	0f b6 c0             	movzbl %al,%eax
c0100f3d:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f40:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f43:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f4b:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f51:	c9                   	leave  
c0100f52:	c3                   	ret    

c0100f53 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f53:	55                   	push   %ebp
c0100f54:	89 e5                	mov    %esp,%ebp
c0100f56:	83 ec 48             	sub    $0x48,%esp
c0100f59:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f5f:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f63:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f67:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f6b:	ee                   	out    %al,(%dx)
c0100f6c:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f72:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f76:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f7a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f7e:	ee                   	out    %al,(%dx)
c0100f7f:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f85:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f89:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f8d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f91:	ee                   	out    %al,(%dx)
c0100f92:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f98:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100f9c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fa0:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fa4:	ee                   	out    %al,(%dx)
c0100fa5:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fab:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100faf:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fb3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fb7:	ee                   	out    %al,(%dx)
c0100fb8:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fbe:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fc2:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fc6:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fca:	ee                   	out    %al,(%dx)
c0100fcb:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fd1:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fd5:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fd9:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fdd:	ee                   	out    %al,(%dx)
c0100fde:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fe4:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100fe8:	89 c2                	mov    %eax,%edx
c0100fea:	ec                   	in     (%dx),%al
c0100feb:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100fee:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100ff2:	3c ff                	cmp    $0xff,%al
c0100ff4:	0f 95 c0             	setne  %al
c0100ff7:	0f b6 c0             	movzbl %al,%eax
c0100ffa:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0100fff:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101005:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101009:	89 c2                	mov    %eax,%edx
c010100b:	ec                   	in     (%dx),%al
c010100c:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010100f:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101015:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101019:	89 c2                	mov    %eax,%edx
c010101b:	ec                   	in     (%dx),%al
c010101c:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010101f:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101024:	85 c0                	test   %eax,%eax
c0101026:	74 0c                	je     c0101034 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101028:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010102f:	e8 d6 06 00 00       	call   c010170a <pic_enable>
    }
}
c0101034:	c9                   	leave  
c0101035:	c3                   	ret    

c0101036 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101036:	55                   	push   %ebp
c0101037:	89 e5                	mov    %esp,%ebp
c0101039:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010103c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101043:	eb 09                	jmp    c010104e <lpt_putc_sub+0x18>
        delay();
c0101045:	e8 db fd ff ff       	call   c0100e25 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010104a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010104e:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101054:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101058:	89 c2                	mov    %eax,%edx
c010105a:	ec                   	in     (%dx),%al
c010105b:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010105e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101062:	84 c0                	test   %al,%al
c0101064:	78 09                	js     c010106f <lpt_putc_sub+0x39>
c0101066:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010106d:	7e d6                	jle    c0101045 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010106f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101072:	0f b6 c0             	movzbl %al,%eax
c0101075:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c010107b:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010107e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101082:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101086:	ee                   	out    %al,(%dx)
c0101087:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010108d:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101091:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101095:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101099:	ee                   	out    %al,(%dx)
c010109a:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010a0:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010a4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010a8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010ac:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010ad:	c9                   	leave  
c01010ae:	c3                   	ret    

c01010af <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010af:	55                   	push   %ebp
c01010b0:	89 e5                	mov    %esp,%ebp
c01010b2:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010b5:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010b9:	74 0d                	je     c01010c8 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01010be:	89 04 24             	mov    %eax,(%esp)
c01010c1:	e8 70 ff ff ff       	call   c0101036 <lpt_putc_sub>
c01010c6:	eb 24                	jmp    c01010ec <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010c8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010cf:	e8 62 ff ff ff       	call   c0101036 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010d4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010db:	e8 56 ff ff ff       	call   c0101036 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010e0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e7:	e8 4a ff ff ff       	call   c0101036 <lpt_putc_sub>
    }
}
c01010ec:	c9                   	leave  
c01010ed:	c3                   	ret    

c01010ee <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010ee:	55                   	push   %ebp
c01010ef:	89 e5                	mov    %esp,%ebp
c01010f1:	53                   	push   %ebx
c01010f2:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01010f8:	b0 00                	mov    $0x0,%al
c01010fa:	85 c0                	test   %eax,%eax
c01010fc:	75 07                	jne    c0101105 <cga_putc+0x17>
        c |= 0x0700;
c01010fe:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101105:	8b 45 08             	mov    0x8(%ebp),%eax
c0101108:	0f b6 c0             	movzbl %al,%eax
c010110b:	83 f8 0a             	cmp    $0xa,%eax
c010110e:	74 4c                	je     c010115c <cga_putc+0x6e>
c0101110:	83 f8 0d             	cmp    $0xd,%eax
c0101113:	74 57                	je     c010116c <cga_putc+0x7e>
c0101115:	83 f8 08             	cmp    $0x8,%eax
c0101118:	0f 85 88 00 00 00    	jne    c01011a6 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010111e:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101125:	66 85 c0             	test   %ax,%ax
c0101128:	74 30                	je     c010115a <cga_putc+0x6c>
            crt_pos --;
c010112a:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101131:	83 e8 01             	sub    $0x1,%eax
c0101134:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010113a:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010113f:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101146:	0f b7 d2             	movzwl %dx,%edx
c0101149:	01 d2                	add    %edx,%edx
c010114b:	01 c2                	add    %eax,%edx
c010114d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101150:	b0 00                	mov    $0x0,%al
c0101152:	83 c8 20             	or     $0x20,%eax
c0101155:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101158:	eb 72                	jmp    c01011cc <cga_putc+0xde>
c010115a:	eb 70                	jmp    c01011cc <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c010115c:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101163:	83 c0 50             	add    $0x50,%eax
c0101166:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010116c:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c0101173:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c010117a:	0f b7 c1             	movzwl %cx,%eax
c010117d:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101183:	c1 e8 10             	shr    $0x10,%eax
c0101186:	89 c2                	mov    %eax,%edx
c0101188:	66 c1 ea 06          	shr    $0x6,%dx
c010118c:	89 d0                	mov    %edx,%eax
c010118e:	c1 e0 02             	shl    $0x2,%eax
c0101191:	01 d0                	add    %edx,%eax
c0101193:	c1 e0 04             	shl    $0x4,%eax
c0101196:	29 c1                	sub    %eax,%ecx
c0101198:	89 ca                	mov    %ecx,%edx
c010119a:	89 d8                	mov    %ebx,%eax
c010119c:	29 d0                	sub    %edx,%eax
c010119e:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c01011a4:	eb 26                	jmp    c01011cc <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011a6:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01011ac:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011b3:	8d 50 01             	lea    0x1(%eax),%edx
c01011b6:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011bd:	0f b7 c0             	movzwl %ax,%eax
c01011c0:	01 c0                	add    %eax,%eax
c01011c2:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01011c8:	66 89 02             	mov    %ax,(%edx)
        break;
c01011cb:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011cc:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011d3:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011d7:	76 5b                	jbe    c0101234 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011d9:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011de:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011e4:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011e9:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011f0:	00 
c01011f1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011f5:	89 04 24             	mov    %eax,(%esp)
c01011f8:	e8 c4 4a 00 00       	call   c0105cc1 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011fd:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101204:	eb 15                	jmp    c010121b <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101206:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010120b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010120e:	01 d2                	add    %edx,%edx
c0101210:	01 d0                	add    %edx,%eax
c0101212:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101217:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010121b:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101222:	7e e2                	jle    c0101206 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101224:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010122b:	83 e8 50             	sub    $0x50,%eax
c010122e:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101234:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010123b:	0f b7 c0             	movzwl %ax,%eax
c010123e:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101242:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101246:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010124a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010124e:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010124f:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101256:	66 c1 e8 08          	shr    $0x8,%ax
c010125a:	0f b6 c0             	movzbl %al,%eax
c010125d:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101264:	83 c2 01             	add    $0x1,%edx
c0101267:	0f b7 d2             	movzwl %dx,%edx
c010126a:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010126e:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101271:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101275:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101279:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010127a:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101281:	0f b7 c0             	movzwl %ax,%eax
c0101284:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101288:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c010128c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101290:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101294:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101295:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010129c:	0f b6 c0             	movzbl %al,%eax
c010129f:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01012a6:	83 c2 01             	add    $0x1,%edx
c01012a9:	0f b7 d2             	movzwl %dx,%edx
c01012ac:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012b0:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012b3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012b7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012bb:	ee                   	out    %al,(%dx)
}
c01012bc:	83 c4 34             	add    $0x34,%esp
c01012bf:	5b                   	pop    %ebx
c01012c0:	5d                   	pop    %ebp
c01012c1:	c3                   	ret    

c01012c2 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012c2:	55                   	push   %ebp
c01012c3:	89 e5                	mov    %esp,%ebp
c01012c5:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012cf:	eb 09                	jmp    c01012da <serial_putc_sub+0x18>
        delay();
c01012d1:	e8 4f fb ff ff       	call   c0100e25 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012da:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012e0:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012e4:	89 c2                	mov    %eax,%edx
c01012e6:	ec                   	in     (%dx),%al
c01012e7:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012ea:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012ee:	0f b6 c0             	movzbl %al,%eax
c01012f1:	83 e0 20             	and    $0x20,%eax
c01012f4:	85 c0                	test   %eax,%eax
c01012f6:	75 09                	jne    c0101301 <serial_putc_sub+0x3f>
c01012f8:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012ff:	7e d0                	jle    c01012d1 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101301:	8b 45 08             	mov    0x8(%ebp),%eax
c0101304:	0f b6 c0             	movzbl %al,%eax
c0101307:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010130d:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101310:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101314:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101318:	ee                   	out    %al,(%dx)
}
c0101319:	c9                   	leave  
c010131a:	c3                   	ret    

c010131b <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010131b:	55                   	push   %ebp
c010131c:	89 e5                	mov    %esp,%ebp
c010131e:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101321:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101325:	74 0d                	je     c0101334 <serial_putc+0x19>
        serial_putc_sub(c);
c0101327:	8b 45 08             	mov    0x8(%ebp),%eax
c010132a:	89 04 24             	mov    %eax,(%esp)
c010132d:	e8 90 ff ff ff       	call   c01012c2 <serial_putc_sub>
c0101332:	eb 24                	jmp    c0101358 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101334:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010133b:	e8 82 ff ff ff       	call   c01012c2 <serial_putc_sub>
        serial_putc_sub(' ');
c0101340:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101347:	e8 76 ff ff ff       	call   c01012c2 <serial_putc_sub>
        serial_putc_sub('\b');
c010134c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101353:	e8 6a ff ff ff       	call   c01012c2 <serial_putc_sub>
    }
}
c0101358:	c9                   	leave  
c0101359:	c3                   	ret    

c010135a <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010135a:	55                   	push   %ebp
c010135b:	89 e5                	mov    %esp,%ebp
c010135d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101360:	eb 33                	jmp    c0101395 <cons_intr+0x3b>
        if (c != 0) {
c0101362:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101366:	74 2d                	je     c0101395 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101368:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010136d:	8d 50 01             	lea    0x1(%eax),%edx
c0101370:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c0101376:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101379:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010137f:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101384:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101389:	75 0a                	jne    c0101395 <cons_intr+0x3b>
                cons.wpos = 0;
c010138b:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c0101392:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101395:	8b 45 08             	mov    0x8(%ebp),%eax
c0101398:	ff d0                	call   *%eax
c010139a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010139d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013a1:	75 bf                	jne    c0101362 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013a3:	c9                   	leave  
c01013a4:	c3                   	ret    

c01013a5 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013a5:	55                   	push   %ebp
c01013a6:	89 e5                	mov    %esp,%ebp
c01013a8:	83 ec 10             	sub    $0x10,%esp
c01013ab:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013b1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013b5:	89 c2                	mov    %eax,%edx
c01013b7:	ec                   	in     (%dx),%al
c01013b8:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013bb:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013bf:	0f b6 c0             	movzbl %al,%eax
c01013c2:	83 e0 01             	and    $0x1,%eax
c01013c5:	85 c0                	test   %eax,%eax
c01013c7:	75 07                	jne    c01013d0 <serial_proc_data+0x2b>
        return -1;
c01013c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013ce:	eb 2a                	jmp    c01013fa <serial_proc_data+0x55>
c01013d0:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013d6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013da:	89 c2                	mov    %eax,%edx
c01013dc:	ec                   	in     (%dx),%al
c01013dd:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013e0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013e4:	0f b6 c0             	movzbl %al,%eax
c01013e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013ea:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013ee:	75 07                	jne    c01013f7 <serial_proc_data+0x52>
        c = '\b';
c01013f0:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013fa:	c9                   	leave  
c01013fb:	c3                   	ret    

c01013fc <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013fc:	55                   	push   %ebp
c01013fd:	89 e5                	mov    %esp,%ebp
c01013ff:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101402:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101407:	85 c0                	test   %eax,%eax
c0101409:	74 0c                	je     c0101417 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010140b:	c7 04 24 a5 13 10 c0 	movl   $0xc01013a5,(%esp)
c0101412:	e8 43 ff ff ff       	call   c010135a <cons_intr>
    }
}
c0101417:	c9                   	leave  
c0101418:	c3                   	ret    

c0101419 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101419:	55                   	push   %ebp
c010141a:	89 e5                	mov    %esp,%ebp
c010141c:	83 ec 38             	sub    $0x38,%esp
c010141f:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101425:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101429:	89 c2                	mov    %eax,%edx
c010142b:	ec                   	in     (%dx),%al
c010142c:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010142f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101433:	0f b6 c0             	movzbl %al,%eax
c0101436:	83 e0 01             	and    $0x1,%eax
c0101439:	85 c0                	test   %eax,%eax
c010143b:	75 0a                	jne    c0101447 <kbd_proc_data+0x2e>
        return -1;
c010143d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101442:	e9 59 01 00 00       	jmp    c01015a0 <kbd_proc_data+0x187>
c0101447:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010144d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101451:	89 c2                	mov    %eax,%edx
c0101453:	ec                   	in     (%dx),%al
c0101454:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101457:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010145b:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010145e:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101462:	75 17                	jne    c010147b <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101464:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101469:	83 c8 40             	or     $0x40,%eax
c010146c:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101471:	b8 00 00 00 00       	mov    $0x0,%eax
c0101476:	e9 25 01 00 00       	jmp    c01015a0 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010147b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010147f:	84 c0                	test   %al,%al
c0101481:	79 47                	jns    c01014ca <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101483:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101488:	83 e0 40             	and    $0x40,%eax
c010148b:	85 c0                	test   %eax,%eax
c010148d:	75 09                	jne    c0101498 <kbd_proc_data+0x7f>
c010148f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101493:	83 e0 7f             	and    $0x7f,%eax
c0101496:	eb 04                	jmp    c010149c <kbd_proc_data+0x83>
c0101498:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010149c:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c010149f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a3:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014aa:	83 c8 40             	or     $0x40,%eax
c01014ad:	0f b6 c0             	movzbl %al,%eax
c01014b0:	f7 d0                	not    %eax
c01014b2:	89 c2                	mov    %eax,%edx
c01014b4:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014b9:	21 d0                	and    %edx,%eax
c01014bb:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014c0:	b8 00 00 00 00       	mov    $0x0,%eax
c01014c5:	e9 d6 00 00 00       	jmp    c01015a0 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014ca:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014cf:	83 e0 40             	and    $0x40,%eax
c01014d2:	85 c0                	test   %eax,%eax
c01014d4:	74 11                	je     c01014e7 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014d6:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014da:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014df:	83 e0 bf             	and    $0xffffffbf,%eax
c01014e2:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014e7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014eb:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014f2:	0f b6 d0             	movzbl %al,%edx
c01014f5:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014fa:	09 d0                	or     %edx,%eax
c01014fc:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c0101501:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101505:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c010150c:	0f b6 d0             	movzbl %al,%edx
c010150f:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101514:	31 d0                	xor    %edx,%eax
c0101516:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c010151b:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101520:	83 e0 03             	and    $0x3,%eax
c0101523:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c010152a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010152e:	01 d0                	add    %edx,%eax
c0101530:	0f b6 00             	movzbl (%eax),%eax
c0101533:	0f b6 c0             	movzbl %al,%eax
c0101536:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101539:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010153e:	83 e0 08             	and    $0x8,%eax
c0101541:	85 c0                	test   %eax,%eax
c0101543:	74 22                	je     c0101567 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101545:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101549:	7e 0c                	jle    c0101557 <kbd_proc_data+0x13e>
c010154b:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010154f:	7f 06                	jg     c0101557 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101551:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101555:	eb 10                	jmp    c0101567 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101557:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010155b:	7e 0a                	jle    c0101567 <kbd_proc_data+0x14e>
c010155d:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101561:	7f 04                	jg     c0101567 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101563:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101567:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010156c:	f7 d0                	not    %eax
c010156e:	83 e0 06             	and    $0x6,%eax
c0101571:	85 c0                	test   %eax,%eax
c0101573:	75 28                	jne    c010159d <kbd_proc_data+0x184>
c0101575:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010157c:	75 1f                	jne    c010159d <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010157e:	c7 04 24 51 61 10 c0 	movl   $0xc0106151,(%esp)
c0101585:	e8 b2 ed ff ff       	call   c010033c <cprintf>
c010158a:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101590:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101594:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101598:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c010159c:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010159d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015a0:	c9                   	leave  
c01015a1:	c3                   	ret    

c01015a2 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015a2:	55                   	push   %ebp
c01015a3:	89 e5                	mov    %esp,%ebp
c01015a5:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015a8:	c7 04 24 19 14 10 c0 	movl   $0xc0101419,(%esp)
c01015af:	e8 a6 fd ff ff       	call   c010135a <cons_intr>
}
c01015b4:	c9                   	leave  
c01015b5:	c3                   	ret    

c01015b6 <kbd_init>:

static void
kbd_init(void) {
c01015b6:	55                   	push   %ebp
c01015b7:	89 e5                	mov    %esp,%ebp
c01015b9:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015bc:	e8 e1 ff ff ff       	call   c01015a2 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015c8:	e8 3d 01 00 00       	call   c010170a <pic_enable>
}
c01015cd:	c9                   	leave  
c01015ce:	c3                   	ret    

c01015cf <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015cf:	55                   	push   %ebp
c01015d0:	89 e5                	mov    %esp,%ebp
c01015d2:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015d5:	e8 93 f8 ff ff       	call   c0100e6d <cga_init>
    serial_init();
c01015da:	e8 74 f9 ff ff       	call   c0100f53 <serial_init>
    kbd_init();
c01015df:	e8 d2 ff ff ff       	call   c01015b6 <kbd_init>
    if (!serial_exists) {
c01015e4:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015e9:	85 c0                	test   %eax,%eax
c01015eb:	75 0c                	jne    c01015f9 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015ed:	c7 04 24 5d 61 10 c0 	movl   $0xc010615d,(%esp)
c01015f4:	e8 43 ed ff ff       	call   c010033c <cprintf>
    }
}
c01015f9:	c9                   	leave  
c01015fa:	c3                   	ret    

c01015fb <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015fb:	55                   	push   %ebp
c01015fc:	89 e5                	mov    %esp,%ebp
c01015fe:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101601:	e8 e2 f7 ff ff       	call   c0100de8 <__intr_save>
c0101606:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101609:	8b 45 08             	mov    0x8(%ebp),%eax
c010160c:	89 04 24             	mov    %eax,(%esp)
c010160f:	e8 9b fa ff ff       	call   c01010af <lpt_putc>
        cga_putc(c);
c0101614:	8b 45 08             	mov    0x8(%ebp),%eax
c0101617:	89 04 24             	mov    %eax,(%esp)
c010161a:	e8 cf fa ff ff       	call   c01010ee <cga_putc>
        serial_putc(c);
c010161f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101622:	89 04 24             	mov    %eax,(%esp)
c0101625:	e8 f1 fc ff ff       	call   c010131b <serial_putc>
    }
    local_intr_restore(intr_flag);
c010162a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010162d:	89 04 24             	mov    %eax,(%esp)
c0101630:	e8 dd f7 ff ff       	call   c0100e12 <__intr_restore>
}
c0101635:	c9                   	leave  
c0101636:	c3                   	ret    

c0101637 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101637:	55                   	push   %ebp
c0101638:	89 e5                	mov    %esp,%ebp
c010163a:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010163d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101644:	e8 9f f7 ff ff       	call   c0100de8 <__intr_save>
c0101649:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010164c:	e8 ab fd ff ff       	call   c01013fc <serial_intr>
        kbd_intr();
c0101651:	e8 4c ff ff ff       	call   c01015a2 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101656:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c010165c:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101661:	39 c2                	cmp    %eax,%edx
c0101663:	74 31                	je     c0101696 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101665:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c010166a:	8d 50 01             	lea    0x1(%eax),%edx
c010166d:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c0101673:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c010167a:	0f b6 c0             	movzbl %al,%eax
c010167d:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101680:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101685:	3d 00 02 00 00       	cmp    $0x200,%eax
c010168a:	75 0a                	jne    c0101696 <cons_getc+0x5f>
                cons.rpos = 0;
c010168c:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c0101693:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101696:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101699:	89 04 24             	mov    %eax,(%esp)
c010169c:	e8 71 f7 ff ff       	call   c0100e12 <__intr_restore>
    return c;
c01016a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016a4:	c9                   	leave  
c01016a5:	c3                   	ret    

c01016a6 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016a6:	55                   	push   %ebp
c01016a7:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016a9:	fb                   	sti    
    sti();
}
c01016aa:	5d                   	pop    %ebp
c01016ab:	c3                   	ret    

c01016ac <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016ac:	55                   	push   %ebp
c01016ad:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016af:	fa                   	cli    
    cli();
}
c01016b0:	5d                   	pop    %ebp
c01016b1:	c3                   	ret    

c01016b2 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016b2:	55                   	push   %ebp
c01016b3:	89 e5                	mov    %esp,%ebp
c01016b5:	83 ec 14             	sub    $0x14,%esp
c01016b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01016bb:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016bf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c3:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016c9:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016ce:	85 c0                	test   %eax,%eax
c01016d0:	74 36                	je     c0101708 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016d2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d6:	0f b6 c0             	movzbl %al,%eax
c01016d9:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016df:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016e2:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016e6:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016ea:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016eb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016ef:	66 c1 e8 08          	shr    $0x8,%ax
c01016f3:	0f b6 c0             	movzbl %al,%eax
c01016f6:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01016fc:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016ff:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101703:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101707:	ee                   	out    %al,(%dx)
    }
}
c0101708:	c9                   	leave  
c0101709:	c3                   	ret    

c010170a <pic_enable>:

void
pic_enable(unsigned int irq) {
c010170a:	55                   	push   %ebp
c010170b:	89 e5                	mov    %esp,%ebp
c010170d:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101710:	8b 45 08             	mov    0x8(%ebp),%eax
c0101713:	ba 01 00 00 00       	mov    $0x1,%edx
c0101718:	89 c1                	mov    %eax,%ecx
c010171a:	d3 e2                	shl    %cl,%edx
c010171c:	89 d0                	mov    %edx,%eax
c010171e:	f7 d0                	not    %eax
c0101720:	89 c2                	mov    %eax,%edx
c0101722:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101729:	21 d0                	and    %edx,%eax
c010172b:	0f b7 c0             	movzwl %ax,%eax
c010172e:	89 04 24             	mov    %eax,(%esp)
c0101731:	e8 7c ff ff ff       	call   c01016b2 <pic_setmask>
}
c0101736:	c9                   	leave  
c0101737:	c3                   	ret    

c0101738 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101738:	55                   	push   %ebp
c0101739:	89 e5                	mov    %esp,%ebp
c010173b:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c010173e:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101745:	00 00 00 
c0101748:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c010174e:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101752:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101756:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010175a:	ee                   	out    %al,(%dx)
c010175b:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101761:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101765:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101769:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010176d:	ee                   	out    %al,(%dx)
c010176e:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101774:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101778:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010177c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101780:	ee                   	out    %al,(%dx)
c0101781:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0101787:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010178b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010178f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101793:	ee                   	out    %al,(%dx)
c0101794:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010179a:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c010179e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017a2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017a6:	ee                   	out    %al,(%dx)
c01017a7:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017ad:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017b1:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017b5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017b9:	ee                   	out    %al,(%dx)
c01017ba:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017c0:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017c4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017c8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017cc:	ee                   	out    %al,(%dx)
c01017cd:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017d3:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017d7:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017db:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017df:	ee                   	out    %al,(%dx)
c01017e0:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017e6:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017ea:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017ee:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017f2:	ee                   	out    %al,(%dx)
c01017f3:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017f9:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c01017fd:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101801:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101805:	ee                   	out    %al,(%dx)
c0101806:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010180c:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101810:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101814:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101818:	ee                   	out    %al,(%dx)
c0101819:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010181f:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101823:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101827:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010182b:	ee                   	out    %al,(%dx)
c010182c:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0101832:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101836:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010183a:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010183e:	ee                   	out    %al,(%dx)
c010183f:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101845:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101849:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010184d:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101851:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101852:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101859:	66 83 f8 ff          	cmp    $0xffff,%ax
c010185d:	74 12                	je     c0101871 <pic_init+0x139>
        pic_setmask(irq_mask);
c010185f:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101866:	0f b7 c0             	movzwl %ax,%eax
c0101869:	89 04 24             	mov    %eax,(%esp)
c010186c:	e8 41 fe ff ff       	call   c01016b2 <pic_setmask>
    }
}
c0101871:	c9                   	leave  
c0101872:	c3                   	ret    

c0101873 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101873:	55                   	push   %ebp
c0101874:	89 e5                	mov    %esp,%ebp
c0101876:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101879:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101880:	00 
c0101881:	c7 04 24 80 61 10 c0 	movl   $0xc0106180,(%esp)
c0101888:	e8 af ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c010188d:	c9                   	leave  
c010188e:	c3                   	ret    

c010188f <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010188f:	55                   	push   %ebp
c0101890:	89 e5                	mov    %esp,%ebp
c0101892:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 256; i++)
c0101895:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010189c:	e9 c3 00 00 00       	jmp    c0101964 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018a4:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018ab:	89 c2                	mov    %eax,%edx
c01018ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018b0:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018b7:	c0 
c01018b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018bb:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018c2:	c0 08 00 
c01018c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018c8:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018cf:	c0 
c01018d0:	83 e2 e0             	and    $0xffffffe0,%edx
c01018d3:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018da:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018dd:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018e4:	c0 
c01018e5:	83 e2 1f             	and    $0x1f,%edx
c01018e8:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f2:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c01018f9:	c0 
c01018fa:	83 e2 f0             	and    $0xfffffff0,%edx
c01018fd:	83 ca 0e             	or     $0xe,%edx
c0101900:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101907:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010190a:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101911:	c0 
c0101912:	83 e2 ef             	and    $0xffffffef,%edx
c0101915:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010191c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010191f:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101926:	c0 
c0101927:	83 e2 9f             	and    $0xffffff9f,%edx
c010192a:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101931:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101934:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010193b:	c0 
c010193c:	83 ca 80             	or     $0xffffff80,%edx
c010193f:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101946:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101949:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101950:	c1 e8 10             	shr    $0x10,%eax
c0101953:	89 c2                	mov    %eax,%edx
c0101955:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101958:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c010195f:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 256; i++)
c0101960:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101964:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c010196b:	0f 8e 30 ff ff ff    	jle    c01018a1 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    SETGATE(idt[T_SYSCALL], 1, GD_KTEXT, __vectors[T_SYSCALL], DPL_USER);
c0101971:	a1 00 78 11 c0       	mov    0xc0117800,%eax
c0101976:	66 a3 c0 84 11 c0    	mov    %ax,0xc01184c0
c010197c:	66 c7 05 c2 84 11 c0 	movw   $0x8,0xc01184c2
c0101983:	08 00 
c0101985:	0f b6 05 c4 84 11 c0 	movzbl 0xc01184c4,%eax
c010198c:	83 e0 e0             	and    $0xffffffe0,%eax
c010198f:	a2 c4 84 11 c0       	mov    %al,0xc01184c4
c0101994:	0f b6 05 c4 84 11 c0 	movzbl 0xc01184c4,%eax
c010199b:	83 e0 1f             	and    $0x1f,%eax
c010199e:	a2 c4 84 11 c0       	mov    %al,0xc01184c4
c01019a3:	0f b6 05 c5 84 11 c0 	movzbl 0xc01184c5,%eax
c01019aa:	83 c8 0f             	or     $0xf,%eax
c01019ad:	a2 c5 84 11 c0       	mov    %al,0xc01184c5
c01019b2:	0f b6 05 c5 84 11 c0 	movzbl 0xc01184c5,%eax
c01019b9:	83 e0 ef             	and    $0xffffffef,%eax
c01019bc:	a2 c5 84 11 c0       	mov    %al,0xc01184c5
c01019c1:	0f b6 05 c5 84 11 c0 	movzbl 0xc01184c5,%eax
c01019c8:	83 c8 60             	or     $0x60,%eax
c01019cb:	a2 c5 84 11 c0       	mov    %al,0xc01184c5
c01019d0:	0f b6 05 c5 84 11 c0 	movzbl 0xc01184c5,%eax
c01019d7:	83 c8 80             	or     $0xffffff80,%eax
c01019da:	a2 c5 84 11 c0       	mov    %al,0xc01184c5
c01019df:	a1 00 78 11 c0       	mov    0xc0117800,%eax
c01019e4:	c1 e8 10             	shr    $0x10,%eax
c01019e7:	66 a3 c6 84 11 c0    	mov    %ax,0xc01184c6
c01019ed:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01019f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019f7:	0f 01 18             	lidtl  (%eax)
    lidt(&idt_pd);
}
c01019fa:	c9                   	leave  
c01019fb:	c3                   	ret    

c01019fc <trapname>:

static const char *
trapname(int trapno) {
c01019fc:	55                   	push   %ebp
c01019fd:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01019ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a02:	83 f8 13             	cmp    $0x13,%eax
c0101a05:	77 0c                	ja     c0101a13 <trapname+0x17>
        return excnames[trapno];
c0101a07:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a0a:	8b 04 85 e0 64 10 c0 	mov    -0x3fef9b20(,%eax,4),%eax
c0101a11:	eb 18                	jmp    c0101a2b <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a13:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a17:	7e 0d                	jle    c0101a26 <trapname+0x2a>
c0101a19:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a1d:	7f 07                	jg     c0101a26 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a1f:	b8 8a 61 10 c0       	mov    $0xc010618a,%eax
c0101a24:	eb 05                	jmp    c0101a2b <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a26:	b8 9d 61 10 c0       	mov    $0xc010619d,%eax
}
c0101a2b:	5d                   	pop    %ebp
c0101a2c:	c3                   	ret    

c0101a2d <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a2d:	55                   	push   %ebp
c0101a2e:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a30:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a33:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a37:	66 83 f8 08          	cmp    $0x8,%ax
c0101a3b:	0f 94 c0             	sete   %al
c0101a3e:	0f b6 c0             	movzbl %al,%eax
}
c0101a41:	5d                   	pop    %ebp
c0101a42:	c3                   	ret    

c0101a43 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a43:	55                   	push   %ebp
c0101a44:	89 e5                	mov    %esp,%ebp
c0101a46:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a49:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a50:	c7 04 24 de 61 10 c0 	movl   $0xc01061de,(%esp)
c0101a57:	e8 e0 e8 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c0101a5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a5f:	89 04 24             	mov    %eax,(%esp)
c0101a62:	e8 a1 01 00 00       	call   c0101c08 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a67:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a6a:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a6e:	0f b7 c0             	movzwl %ax,%eax
c0101a71:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a75:	c7 04 24 ef 61 10 c0 	movl   $0xc01061ef,(%esp)
c0101a7c:	e8 bb e8 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a81:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a84:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a88:	0f b7 c0             	movzwl %ax,%eax
c0101a8b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a8f:	c7 04 24 02 62 10 c0 	movl   $0xc0106202,(%esp)
c0101a96:	e8 a1 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a9e:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101aa2:	0f b7 c0             	movzwl %ax,%eax
c0101aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aa9:	c7 04 24 15 62 10 c0 	movl   $0xc0106215,(%esp)
c0101ab0:	e8 87 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab8:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101abc:	0f b7 c0             	movzwl %ax,%eax
c0101abf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac3:	c7 04 24 28 62 10 c0 	movl   $0xc0106228,(%esp)
c0101aca:	e8 6d e8 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101acf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad2:	8b 40 30             	mov    0x30(%eax),%eax
c0101ad5:	89 04 24             	mov    %eax,(%esp)
c0101ad8:	e8 1f ff ff ff       	call   c01019fc <trapname>
c0101add:	8b 55 08             	mov    0x8(%ebp),%edx
c0101ae0:	8b 52 30             	mov    0x30(%edx),%edx
c0101ae3:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101ae7:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101aeb:	c7 04 24 3b 62 10 c0 	movl   $0xc010623b,(%esp)
c0101af2:	e8 45 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101af7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101afa:	8b 40 34             	mov    0x34(%eax),%eax
c0101afd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b01:	c7 04 24 4d 62 10 c0 	movl   $0xc010624d,(%esp)
c0101b08:	e8 2f e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b10:	8b 40 38             	mov    0x38(%eax),%eax
c0101b13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b17:	c7 04 24 5c 62 10 c0 	movl   $0xc010625c,(%esp)
c0101b1e:	e8 19 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b23:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b26:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b2a:	0f b7 c0             	movzwl %ax,%eax
c0101b2d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b31:	c7 04 24 6b 62 10 c0 	movl   $0xc010626b,(%esp)
c0101b38:	e8 ff e7 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b40:	8b 40 40             	mov    0x40(%eax),%eax
c0101b43:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b47:	c7 04 24 7e 62 10 c0 	movl   $0xc010627e,(%esp)
c0101b4e:	e8 e9 e7 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b5a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b61:	eb 3e                	jmp    c0101ba1 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b63:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b66:	8b 50 40             	mov    0x40(%eax),%edx
c0101b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b6c:	21 d0                	and    %edx,%eax
c0101b6e:	85 c0                	test   %eax,%eax
c0101b70:	74 28                	je     c0101b9a <print_trapframe+0x157>
c0101b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b75:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b7c:	85 c0                	test   %eax,%eax
c0101b7e:	74 1a                	je     c0101b9a <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b83:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b8a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b8e:	c7 04 24 8d 62 10 c0 	movl   $0xc010628d,(%esp)
c0101b95:	e8 a2 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b9a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101b9e:	d1 65 f0             	shll   -0x10(%ebp)
c0101ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ba4:	83 f8 17             	cmp    $0x17,%eax
c0101ba7:	76 ba                	jbe    c0101b63 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101ba9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bac:	8b 40 40             	mov    0x40(%eax),%eax
c0101baf:	25 00 30 00 00       	and    $0x3000,%eax
c0101bb4:	c1 e8 0c             	shr    $0xc,%eax
c0101bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bbb:	c7 04 24 91 62 10 c0 	movl   $0xc0106291,(%esp)
c0101bc2:	e8 75 e7 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101bc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bca:	89 04 24             	mov    %eax,(%esp)
c0101bcd:	e8 5b fe ff ff       	call   c0101a2d <trap_in_kernel>
c0101bd2:	85 c0                	test   %eax,%eax
c0101bd4:	75 30                	jne    c0101c06 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101bd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd9:	8b 40 44             	mov    0x44(%eax),%eax
c0101bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101be0:	c7 04 24 9a 62 10 c0 	movl   $0xc010629a,(%esp)
c0101be7:	e8 50 e7 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101bec:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bef:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101bf3:	0f b7 c0             	movzwl %ax,%eax
c0101bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bfa:	c7 04 24 a9 62 10 c0 	movl   $0xc01062a9,(%esp)
c0101c01:	e8 36 e7 ff ff       	call   c010033c <cprintf>
    }
}
c0101c06:	c9                   	leave  
c0101c07:	c3                   	ret    

c0101c08 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c08:	55                   	push   %ebp
c0101c09:	89 e5                	mov    %esp,%ebp
c0101c0b:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c11:	8b 00                	mov    (%eax),%eax
c0101c13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c17:	c7 04 24 bc 62 10 c0 	movl   $0xc01062bc,(%esp)
c0101c1e:	e8 19 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c23:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c26:	8b 40 04             	mov    0x4(%eax),%eax
c0101c29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c2d:	c7 04 24 cb 62 10 c0 	movl   $0xc01062cb,(%esp)
c0101c34:	e8 03 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c39:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c3c:	8b 40 08             	mov    0x8(%eax),%eax
c0101c3f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c43:	c7 04 24 da 62 10 c0 	movl   $0xc01062da,(%esp)
c0101c4a:	e8 ed e6 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c52:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c59:	c7 04 24 e9 62 10 c0 	movl   $0xc01062e9,(%esp)
c0101c60:	e8 d7 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c65:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c68:	8b 40 10             	mov    0x10(%eax),%eax
c0101c6b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c6f:	c7 04 24 f8 62 10 c0 	movl   $0xc01062f8,(%esp)
c0101c76:	e8 c1 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7e:	8b 40 14             	mov    0x14(%eax),%eax
c0101c81:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c85:	c7 04 24 07 63 10 c0 	movl   $0xc0106307,(%esp)
c0101c8c:	e8 ab e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c91:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c94:	8b 40 18             	mov    0x18(%eax),%eax
c0101c97:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c9b:	c7 04 24 16 63 10 c0 	movl   $0xc0106316,(%esp)
c0101ca2:	e8 95 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101ca7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101caa:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cad:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cb1:	c7 04 24 25 63 10 c0 	movl   $0xc0106325,(%esp)
c0101cb8:	e8 7f e6 ff ff       	call   c010033c <cprintf>
}
c0101cbd:	c9                   	leave  
c0101cbe:	c3                   	ret    

c0101cbf <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101cbf:	55                   	push   %ebp
c0101cc0:	89 e5                	mov    %esp,%ebp
c0101cc2:	83 ec 28             	sub    $0x28,%esp
    char c;
    static int ticks_time;
    switch (tf->tf_trapno) {
c0101cc5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc8:	8b 40 30             	mov    0x30(%eax),%eax
c0101ccb:	83 f8 2f             	cmp    $0x2f,%eax
c0101cce:	77 21                	ja     c0101cf1 <trap_dispatch+0x32>
c0101cd0:	83 f8 2e             	cmp    $0x2e,%eax
c0101cd3:	0f 83 0b 01 00 00    	jae    c0101de4 <trap_dispatch+0x125>
c0101cd9:	83 f8 21             	cmp    $0x21,%eax
c0101cdc:	0f 84 88 00 00 00    	je     c0101d6a <trap_dispatch+0xab>
c0101ce2:	83 f8 24             	cmp    $0x24,%eax
c0101ce5:	74 5d                	je     c0101d44 <trap_dispatch+0x85>
c0101ce7:	83 f8 20             	cmp    $0x20,%eax
c0101cea:	74 16                	je     c0101d02 <trap_dispatch+0x43>
c0101cec:	e9 bb 00 00 00       	jmp    c0101dac <trap_dispatch+0xed>
c0101cf1:	83 e8 78             	sub    $0x78,%eax
c0101cf4:	83 f8 01             	cmp    $0x1,%eax
c0101cf7:	0f 87 af 00 00 00    	ja     c0101dac <trap_dispatch+0xed>
c0101cfd:	e9 8e 00 00 00       	jmp    c0101d90 <trap_dispatch+0xd1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks_time++;
c0101d02:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0101d07:	83 c0 01             	add    $0x1,%eax
c0101d0a:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
	    if (ticks_time % TICK_NUM == 0)
c0101d0f:	8b 0d c0 88 11 c0    	mov    0xc01188c0,%ecx
c0101d15:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d1a:	89 c8                	mov    %ecx,%eax
c0101d1c:	f7 ea                	imul   %edx
c0101d1e:	c1 fa 05             	sar    $0x5,%edx
c0101d21:	89 c8                	mov    %ecx,%eax
c0101d23:	c1 f8 1f             	sar    $0x1f,%eax
c0101d26:	29 c2                	sub    %eax,%edx
c0101d28:	89 d0                	mov    %edx,%eax
c0101d2a:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d2d:	29 c1                	sub    %eax,%ecx
c0101d2f:	89 c8                	mov    %ecx,%eax
c0101d31:	85 c0                	test   %eax,%eax
c0101d33:	75 0a                	jne    c0101d3f <trap_dispatch+0x80>
	        print_ticks();
c0101d35:	e8 39 fb ff ff       	call   c0101873 <print_ticks>
        break;
c0101d3a:	e9 a6 00 00 00       	jmp    c0101de5 <trap_dispatch+0x126>
c0101d3f:	e9 a1 00 00 00       	jmp    c0101de5 <trap_dispatch+0x126>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d44:	e8 ee f8 ff ff       	call   c0101637 <cons_getc>
c0101d49:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d4c:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d50:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d54:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d58:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d5c:	c7 04 24 34 63 10 c0 	movl   $0xc0106334,(%esp)
c0101d63:	e8 d4 e5 ff ff       	call   c010033c <cprintf>
        break;
c0101d68:	eb 7b                	jmp    c0101de5 <trap_dispatch+0x126>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d6a:	e8 c8 f8 ff ff       	call   c0101637 <cons_getc>
c0101d6f:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d72:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d76:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d7a:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d82:	c7 04 24 46 63 10 c0 	movl   $0xc0106346,(%esp)
c0101d89:	e8 ae e5 ff ff       	call   c010033c <cprintf>
        break;
c0101d8e:	eb 55                	jmp    c0101de5 <trap_dispatch+0x126>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101d90:	c7 44 24 08 55 63 10 	movl   $0xc0106355,0x8(%esp)
c0101d97:	c0 
c0101d98:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
c0101d9f:	00 
c0101da0:	c7 04 24 65 63 10 c0 	movl   $0xc0106365,(%esp)
c0101da7:	e8 1d ef ff ff       	call   c0100cc9 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101dac:	8b 45 08             	mov    0x8(%ebp),%eax
c0101daf:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101db3:	0f b7 c0             	movzwl %ax,%eax
c0101db6:	83 e0 03             	and    $0x3,%eax
c0101db9:	85 c0                	test   %eax,%eax
c0101dbb:	75 28                	jne    c0101de5 <trap_dispatch+0x126>
            print_trapframe(tf);
c0101dbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dc0:	89 04 24             	mov    %eax,(%esp)
c0101dc3:	e8 7b fc ff ff       	call   c0101a43 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101dc8:	c7 44 24 08 76 63 10 	movl   $0xc0106376,0x8(%esp)
c0101dcf:	c0 
c0101dd0:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0101dd7:	00 
c0101dd8:	c7 04 24 65 63 10 c0 	movl   $0xc0106365,(%esp)
c0101ddf:	e8 e5 ee ff ff       	call   c0100cc9 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101de4:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101de5:	c9                   	leave  
c0101de6:	c3                   	ret    

c0101de7 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101de7:	55                   	push   %ebp
c0101de8:	89 e5                	mov    %esp,%ebp
c0101dea:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101ded:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df0:	89 04 24             	mov    %eax,(%esp)
c0101df3:	e8 c7 fe ff ff       	call   c0101cbf <trap_dispatch>
}
c0101df8:	c9                   	leave  
c0101df9:	c3                   	ret    

c0101dfa <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101dfa:	1e                   	push   %ds
    pushl %es
c0101dfb:	06                   	push   %es
    pushl %fs
c0101dfc:	0f a0                	push   %fs
    pushl %gs
c0101dfe:	0f a8                	push   %gs
    pushal
c0101e00:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101e01:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101e06:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101e08:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101e0a:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101e0b:	e8 d7 ff ff ff       	call   c0101de7 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101e10:	5c                   	pop    %esp

c0101e11 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101e11:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101e12:	0f a9                	pop    %gs
    popl %fs
c0101e14:	0f a1                	pop    %fs
    popl %es
c0101e16:	07                   	pop    %es
    popl %ds
c0101e17:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101e18:	83 c4 08             	add    $0x8,%esp
    iret
c0101e1b:	cf                   	iret   

c0101e1c <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e1c:	6a 00                	push   $0x0
  pushl $0
c0101e1e:	6a 00                	push   $0x0
  jmp __alltraps
c0101e20:	e9 d5 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e25 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e25:	6a 00                	push   $0x0
  pushl $1
c0101e27:	6a 01                	push   $0x1
  jmp __alltraps
c0101e29:	e9 cc ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e2e <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e2e:	6a 00                	push   $0x0
  pushl $2
c0101e30:	6a 02                	push   $0x2
  jmp __alltraps
c0101e32:	e9 c3 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e37 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e37:	6a 00                	push   $0x0
  pushl $3
c0101e39:	6a 03                	push   $0x3
  jmp __alltraps
c0101e3b:	e9 ba ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e40 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e40:	6a 00                	push   $0x0
  pushl $4
c0101e42:	6a 04                	push   $0x4
  jmp __alltraps
c0101e44:	e9 b1 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e49 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e49:	6a 00                	push   $0x0
  pushl $5
c0101e4b:	6a 05                	push   $0x5
  jmp __alltraps
c0101e4d:	e9 a8 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e52 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e52:	6a 00                	push   $0x0
  pushl $6
c0101e54:	6a 06                	push   $0x6
  jmp __alltraps
c0101e56:	e9 9f ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e5b <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e5b:	6a 00                	push   $0x0
  pushl $7
c0101e5d:	6a 07                	push   $0x7
  jmp __alltraps
c0101e5f:	e9 96 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e64 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e64:	6a 08                	push   $0x8
  jmp __alltraps
c0101e66:	e9 8f ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e6b <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e6b:	6a 09                	push   $0x9
  jmp __alltraps
c0101e6d:	e9 88 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e72 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e72:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e74:	e9 81 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e79 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e79:	6a 0b                	push   $0xb
  jmp __alltraps
c0101e7b:	e9 7a ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e80 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e80:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e82:	e9 73 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e87 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e87:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e89:	e9 6c ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e8e <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e8e:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e90:	e9 65 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e95 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e95:	6a 00                	push   $0x0
  pushl $15
c0101e97:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e99:	e9 5c ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e9e <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e9e:	6a 00                	push   $0x0
  pushl $16
c0101ea0:	6a 10                	push   $0x10
  jmp __alltraps
c0101ea2:	e9 53 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101ea7 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101ea7:	6a 11                	push   $0x11
  jmp __alltraps
c0101ea9:	e9 4c ff ff ff       	jmp    c0101dfa <__alltraps>

c0101eae <vector18>:
.globl vector18
vector18:
  pushl $0
c0101eae:	6a 00                	push   $0x0
  pushl $18
c0101eb0:	6a 12                	push   $0x12
  jmp __alltraps
c0101eb2:	e9 43 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101eb7 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101eb7:	6a 00                	push   $0x0
  pushl $19
c0101eb9:	6a 13                	push   $0x13
  jmp __alltraps
c0101ebb:	e9 3a ff ff ff       	jmp    c0101dfa <__alltraps>

c0101ec0 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101ec0:	6a 00                	push   $0x0
  pushl $20
c0101ec2:	6a 14                	push   $0x14
  jmp __alltraps
c0101ec4:	e9 31 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101ec9 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101ec9:	6a 00                	push   $0x0
  pushl $21
c0101ecb:	6a 15                	push   $0x15
  jmp __alltraps
c0101ecd:	e9 28 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101ed2 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101ed2:	6a 00                	push   $0x0
  pushl $22
c0101ed4:	6a 16                	push   $0x16
  jmp __alltraps
c0101ed6:	e9 1f ff ff ff       	jmp    c0101dfa <__alltraps>

c0101edb <vector23>:
.globl vector23
vector23:
  pushl $0
c0101edb:	6a 00                	push   $0x0
  pushl $23
c0101edd:	6a 17                	push   $0x17
  jmp __alltraps
c0101edf:	e9 16 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101ee4 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101ee4:	6a 00                	push   $0x0
  pushl $24
c0101ee6:	6a 18                	push   $0x18
  jmp __alltraps
c0101ee8:	e9 0d ff ff ff       	jmp    c0101dfa <__alltraps>

c0101eed <vector25>:
.globl vector25
vector25:
  pushl $0
c0101eed:	6a 00                	push   $0x0
  pushl $25
c0101eef:	6a 19                	push   $0x19
  jmp __alltraps
c0101ef1:	e9 04 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101ef6 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101ef6:	6a 00                	push   $0x0
  pushl $26
c0101ef8:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101efa:	e9 fb fe ff ff       	jmp    c0101dfa <__alltraps>

c0101eff <vector27>:
.globl vector27
vector27:
  pushl $0
c0101eff:	6a 00                	push   $0x0
  pushl $27
c0101f01:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101f03:	e9 f2 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f08 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101f08:	6a 00                	push   $0x0
  pushl $28
c0101f0a:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101f0c:	e9 e9 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f11 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f11:	6a 00                	push   $0x0
  pushl $29
c0101f13:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f15:	e9 e0 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f1a <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f1a:	6a 00                	push   $0x0
  pushl $30
c0101f1c:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f1e:	e9 d7 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f23 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f23:	6a 00                	push   $0x0
  pushl $31
c0101f25:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f27:	e9 ce fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f2c <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f2c:	6a 00                	push   $0x0
  pushl $32
c0101f2e:	6a 20                	push   $0x20
  jmp __alltraps
c0101f30:	e9 c5 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f35 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f35:	6a 00                	push   $0x0
  pushl $33
c0101f37:	6a 21                	push   $0x21
  jmp __alltraps
c0101f39:	e9 bc fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f3e <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f3e:	6a 00                	push   $0x0
  pushl $34
c0101f40:	6a 22                	push   $0x22
  jmp __alltraps
c0101f42:	e9 b3 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f47 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f47:	6a 00                	push   $0x0
  pushl $35
c0101f49:	6a 23                	push   $0x23
  jmp __alltraps
c0101f4b:	e9 aa fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f50 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f50:	6a 00                	push   $0x0
  pushl $36
c0101f52:	6a 24                	push   $0x24
  jmp __alltraps
c0101f54:	e9 a1 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f59 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101f59:	6a 00                	push   $0x0
  pushl $37
c0101f5b:	6a 25                	push   $0x25
  jmp __alltraps
c0101f5d:	e9 98 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f62 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f62:	6a 00                	push   $0x0
  pushl $38
c0101f64:	6a 26                	push   $0x26
  jmp __alltraps
c0101f66:	e9 8f fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f6b <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f6b:	6a 00                	push   $0x0
  pushl $39
c0101f6d:	6a 27                	push   $0x27
  jmp __alltraps
c0101f6f:	e9 86 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f74 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f74:	6a 00                	push   $0x0
  pushl $40
c0101f76:	6a 28                	push   $0x28
  jmp __alltraps
c0101f78:	e9 7d fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f7d <vector41>:
.globl vector41
vector41:
  pushl $0
c0101f7d:	6a 00                	push   $0x0
  pushl $41
c0101f7f:	6a 29                	push   $0x29
  jmp __alltraps
c0101f81:	e9 74 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f86 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f86:	6a 00                	push   $0x0
  pushl $42
c0101f88:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f8a:	e9 6b fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f8f <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f8f:	6a 00                	push   $0x0
  pushl $43
c0101f91:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f93:	e9 62 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f98 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f98:	6a 00                	push   $0x0
  pushl $44
c0101f9a:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f9c:	e9 59 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101fa1 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101fa1:	6a 00                	push   $0x0
  pushl $45
c0101fa3:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101fa5:	e9 50 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101faa <vector46>:
.globl vector46
vector46:
  pushl $0
c0101faa:	6a 00                	push   $0x0
  pushl $46
c0101fac:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101fae:	e9 47 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101fb3 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101fb3:	6a 00                	push   $0x0
  pushl $47
c0101fb5:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101fb7:	e9 3e fe ff ff       	jmp    c0101dfa <__alltraps>

c0101fbc <vector48>:
.globl vector48
vector48:
  pushl $0
c0101fbc:	6a 00                	push   $0x0
  pushl $48
c0101fbe:	6a 30                	push   $0x30
  jmp __alltraps
c0101fc0:	e9 35 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101fc5 <vector49>:
.globl vector49
vector49:
  pushl $0
c0101fc5:	6a 00                	push   $0x0
  pushl $49
c0101fc7:	6a 31                	push   $0x31
  jmp __alltraps
c0101fc9:	e9 2c fe ff ff       	jmp    c0101dfa <__alltraps>

c0101fce <vector50>:
.globl vector50
vector50:
  pushl $0
c0101fce:	6a 00                	push   $0x0
  pushl $50
c0101fd0:	6a 32                	push   $0x32
  jmp __alltraps
c0101fd2:	e9 23 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101fd7 <vector51>:
.globl vector51
vector51:
  pushl $0
c0101fd7:	6a 00                	push   $0x0
  pushl $51
c0101fd9:	6a 33                	push   $0x33
  jmp __alltraps
c0101fdb:	e9 1a fe ff ff       	jmp    c0101dfa <__alltraps>

c0101fe0 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101fe0:	6a 00                	push   $0x0
  pushl $52
c0101fe2:	6a 34                	push   $0x34
  jmp __alltraps
c0101fe4:	e9 11 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101fe9 <vector53>:
.globl vector53
vector53:
  pushl $0
c0101fe9:	6a 00                	push   $0x0
  pushl $53
c0101feb:	6a 35                	push   $0x35
  jmp __alltraps
c0101fed:	e9 08 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101ff2 <vector54>:
.globl vector54
vector54:
  pushl $0
c0101ff2:	6a 00                	push   $0x0
  pushl $54
c0101ff4:	6a 36                	push   $0x36
  jmp __alltraps
c0101ff6:	e9 ff fd ff ff       	jmp    c0101dfa <__alltraps>

c0101ffb <vector55>:
.globl vector55
vector55:
  pushl $0
c0101ffb:	6a 00                	push   $0x0
  pushl $55
c0101ffd:	6a 37                	push   $0x37
  jmp __alltraps
c0101fff:	e9 f6 fd ff ff       	jmp    c0101dfa <__alltraps>

c0102004 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102004:	6a 00                	push   $0x0
  pushl $56
c0102006:	6a 38                	push   $0x38
  jmp __alltraps
c0102008:	e9 ed fd ff ff       	jmp    c0101dfa <__alltraps>

c010200d <vector57>:
.globl vector57
vector57:
  pushl $0
c010200d:	6a 00                	push   $0x0
  pushl $57
c010200f:	6a 39                	push   $0x39
  jmp __alltraps
c0102011:	e9 e4 fd ff ff       	jmp    c0101dfa <__alltraps>

c0102016 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102016:	6a 00                	push   $0x0
  pushl $58
c0102018:	6a 3a                	push   $0x3a
  jmp __alltraps
c010201a:	e9 db fd ff ff       	jmp    c0101dfa <__alltraps>

c010201f <vector59>:
.globl vector59
vector59:
  pushl $0
c010201f:	6a 00                	push   $0x0
  pushl $59
c0102021:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102023:	e9 d2 fd ff ff       	jmp    c0101dfa <__alltraps>

c0102028 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102028:	6a 00                	push   $0x0
  pushl $60
c010202a:	6a 3c                	push   $0x3c
  jmp __alltraps
c010202c:	e9 c9 fd ff ff       	jmp    c0101dfa <__alltraps>

c0102031 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102031:	6a 00                	push   $0x0
  pushl $61
c0102033:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102035:	e9 c0 fd ff ff       	jmp    c0101dfa <__alltraps>

c010203a <vector62>:
.globl vector62
vector62:
  pushl $0
c010203a:	6a 00                	push   $0x0
  pushl $62
c010203c:	6a 3e                	push   $0x3e
  jmp __alltraps
c010203e:	e9 b7 fd ff ff       	jmp    c0101dfa <__alltraps>

c0102043 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102043:	6a 00                	push   $0x0
  pushl $63
c0102045:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102047:	e9 ae fd ff ff       	jmp    c0101dfa <__alltraps>

c010204c <vector64>:
.globl vector64
vector64:
  pushl $0
c010204c:	6a 00                	push   $0x0
  pushl $64
c010204e:	6a 40                	push   $0x40
  jmp __alltraps
c0102050:	e9 a5 fd ff ff       	jmp    c0101dfa <__alltraps>

c0102055 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102055:	6a 00                	push   $0x0
  pushl $65
c0102057:	6a 41                	push   $0x41
  jmp __alltraps
c0102059:	e9 9c fd ff ff       	jmp    c0101dfa <__alltraps>

c010205e <vector66>:
.globl vector66
vector66:
  pushl $0
c010205e:	6a 00                	push   $0x0
  pushl $66
c0102060:	6a 42                	push   $0x42
  jmp __alltraps
c0102062:	e9 93 fd ff ff       	jmp    c0101dfa <__alltraps>

c0102067 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102067:	6a 00                	push   $0x0
  pushl $67
c0102069:	6a 43                	push   $0x43
  jmp __alltraps
c010206b:	e9 8a fd ff ff       	jmp    c0101dfa <__alltraps>

c0102070 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102070:	6a 00                	push   $0x0
  pushl $68
c0102072:	6a 44                	push   $0x44
  jmp __alltraps
c0102074:	e9 81 fd ff ff       	jmp    c0101dfa <__alltraps>

c0102079 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102079:	6a 00                	push   $0x0
  pushl $69
c010207b:	6a 45                	push   $0x45
  jmp __alltraps
c010207d:	e9 78 fd ff ff       	jmp    c0101dfa <__alltraps>

c0102082 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102082:	6a 00                	push   $0x0
  pushl $70
c0102084:	6a 46                	push   $0x46
  jmp __alltraps
c0102086:	e9 6f fd ff ff       	jmp    c0101dfa <__alltraps>

c010208b <vector71>:
.globl vector71
vector71:
  pushl $0
c010208b:	6a 00                	push   $0x0
  pushl $71
c010208d:	6a 47                	push   $0x47
  jmp __alltraps
c010208f:	e9 66 fd ff ff       	jmp    c0101dfa <__alltraps>

c0102094 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102094:	6a 00                	push   $0x0
  pushl $72
c0102096:	6a 48                	push   $0x48
  jmp __alltraps
c0102098:	e9 5d fd ff ff       	jmp    c0101dfa <__alltraps>

c010209d <vector73>:
.globl vector73
vector73:
  pushl $0
c010209d:	6a 00                	push   $0x0
  pushl $73
c010209f:	6a 49                	push   $0x49
  jmp __alltraps
c01020a1:	e9 54 fd ff ff       	jmp    c0101dfa <__alltraps>

c01020a6 <vector74>:
.globl vector74
vector74:
  pushl $0
c01020a6:	6a 00                	push   $0x0
  pushl $74
c01020a8:	6a 4a                	push   $0x4a
  jmp __alltraps
c01020aa:	e9 4b fd ff ff       	jmp    c0101dfa <__alltraps>

c01020af <vector75>:
.globl vector75
vector75:
  pushl $0
c01020af:	6a 00                	push   $0x0
  pushl $75
c01020b1:	6a 4b                	push   $0x4b
  jmp __alltraps
c01020b3:	e9 42 fd ff ff       	jmp    c0101dfa <__alltraps>

c01020b8 <vector76>:
.globl vector76
vector76:
  pushl $0
c01020b8:	6a 00                	push   $0x0
  pushl $76
c01020ba:	6a 4c                	push   $0x4c
  jmp __alltraps
c01020bc:	e9 39 fd ff ff       	jmp    c0101dfa <__alltraps>

c01020c1 <vector77>:
.globl vector77
vector77:
  pushl $0
c01020c1:	6a 00                	push   $0x0
  pushl $77
c01020c3:	6a 4d                	push   $0x4d
  jmp __alltraps
c01020c5:	e9 30 fd ff ff       	jmp    c0101dfa <__alltraps>

c01020ca <vector78>:
.globl vector78
vector78:
  pushl $0
c01020ca:	6a 00                	push   $0x0
  pushl $78
c01020cc:	6a 4e                	push   $0x4e
  jmp __alltraps
c01020ce:	e9 27 fd ff ff       	jmp    c0101dfa <__alltraps>

c01020d3 <vector79>:
.globl vector79
vector79:
  pushl $0
c01020d3:	6a 00                	push   $0x0
  pushl $79
c01020d5:	6a 4f                	push   $0x4f
  jmp __alltraps
c01020d7:	e9 1e fd ff ff       	jmp    c0101dfa <__alltraps>

c01020dc <vector80>:
.globl vector80
vector80:
  pushl $0
c01020dc:	6a 00                	push   $0x0
  pushl $80
c01020de:	6a 50                	push   $0x50
  jmp __alltraps
c01020e0:	e9 15 fd ff ff       	jmp    c0101dfa <__alltraps>

c01020e5 <vector81>:
.globl vector81
vector81:
  pushl $0
c01020e5:	6a 00                	push   $0x0
  pushl $81
c01020e7:	6a 51                	push   $0x51
  jmp __alltraps
c01020e9:	e9 0c fd ff ff       	jmp    c0101dfa <__alltraps>

c01020ee <vector82>:
.globl vector82
vector82:
  pushl $0
c01020ee:	6a 00                	push   $0x0
  pushl $82
c01020f0:	6a 52                	push   $0x52
  jmp __alltraps
c01020f2:	e9 03 fd ff ff       	jmp    c0101dfa <__alltraps>

c01020f7 <vector83>:
.globl vector83
vector83:
  pushl $0
c01020f7:	6a 00                	push   $0x0
  pushl $83
c01020f9:	6a 53                	push   $0x53
  jmp __alltraps
c01020fb:	e9 fa fc ff ff       	jmp    c0101dfa <__alltraps>

c0102100 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102100:	6a 00                	push   $0x0
  pushl $84
c0102102:	6a 54                	push   $0x54
  jmp __alltraps
c0102104:	e9 f1 fc ff ff       	jmp    c0101dfa <__alltraps>

c0102109 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102109:	6a 00                	push   $0x0
  pushl $85
c010210b:	6a 55                	push   $0x55
  jmp __alltraps
c010210d:	e9 e8 fc ff ff       	jmp    c0101dfa <__alltraps>

c0102112 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102112:	6a 00                	push   $0x0
  pushl $86
c0102114:	6a 56                	push   $0x56
  jmp __alltraps
c0102116:	e9 df fc ff ff       	jmp    c0101dfa <__alltraps>

c010211b <vector87>:
.globl vector87
vector87:
  pushl $0
c010211b:	6a 00                	push   $0x0
  pushl $87
c010211d:	6a 57                	push   $0x57
  jmp __alltraps
c010211f:	e9 d6 fc ff ff       	jmp    c0101dfa <__alltraps>

c0102124 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102124:	6a 00                	push   $0x0
  pushl $88
c0102126:	6a 58                	push   $0x58
  jmp __alltraps
c0102128:	e9 cd fc ff ff       	jmp    c0101dfa <__alltraps>

c010212d <vector89>:
.globl vector89
vector89:
  pushl $0
c010212d:	6a 00                	push   $0x0
  pushl $89
c010212f:	6a 59                	push   $0x59
  jmp __alltraps
c0102131:	e9 c4 fc ff ff       	jmp    c0101dfa <__alltraps>

c0102136 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102136:	6a 00                	push   $0x0
  pushl $90
c0102138:	6a 5a                	push   $0x5a
  jmp __alltraps
c010213a:	e9 bb fc ff ff       	jmp    c0101dfa <__alltraps>

c010213f <vector91>:
.globl vector91
vector91:
  pushl $0
c010213f:	6a 00                	push   $0x0
  pushl $91
c0102141:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102143:	e9 b2 fc ff ff       	jmp    c0101dfa <__alltraps>

c0102148 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102148:	6a 00                	push   $0x0
  pushl $92
c010214a:	6a 5c                	push   $0x5c
  jmp __alltraps
c010214c:	e9 a9 fc ff ff       	jmp    c0101dfa <__alltraps>

c0102151 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102151:	6a 00                	push   $0x0
  pushl $93
c0102153:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102155:	e9 a0 fc ff ff       	jmp    c0101dfa <__alltraps>

c010215a <vector94>:
.globl vector94
vector94:
  pushl $0
c010215a:	6a 00                	push   $0x0
  pushl $94
c010215c:	6a 5e                	push   $0x5e
  jmp __alltraps
c010215e:	e9 97 fc ff ff       	jmp    c0101dfa <__alltraps>

c0102163 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102163:	6a 00                	push   $0x0
  pushl $95
c0102165:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102167:	e9 8e fc ff ff       	jmp    c0101dfa <__alltraps>

c010216c <vector96>:
.globl vector96
vector96:
  pushl $0
c010216c:	6a 00                	push   $0x0
  pushl $96
c010216e:	6a 60                	push   $0x60
  jmp __alltraps
c0102170:	e9 85 fc ff ff       	jmp    c0101dfa <__alltraps>

c0102175 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102175:	6a 00                	push   $0x0
  pushl $97
c0102177:	6a 61                	push   $0x61
  jmp __alltraps
c0102179:	e9 7c fc ff ff       	jmp    c0101dfa <__alltraps>

c010217e <vector98>:
.globl vector98
vector98:
  pushl $0
c010217e:	6a 00                	push   $0x0
  pushl $98
c0102180:	6a 62                	push   $0x62
  jmp __alltraps
c0102182:	e9 73 fc ff ff       	jmp    c0101dfa <__alltraps>

c0102187 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102187:	6a 00                	push   $0x0
  pushl $99
c0102189:	6a 63                	push   $0x63
  jmp __alltraps
c010218b:	e9 6a fc ff ff       	jmp    c0101dfa <__alltraps>

c0102190 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102190:	6a 00                	push   $0x0
  pushl $100
c0102192:	6a 64                	push   $0x64
  jmp __alltraps
c0102194:	e9 61 fc ff ff       	jmp    c0101dfa <__alltraps>

c0102199 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102199:	6a 00                	push   $0x0
  pushl $101
c010219b:	6a 65                	push   $0x65
  jmp __alltraps
c010219d:	e9 58 fc ff ff       	jmp    c0101dfa <__alltraps>

c01021a2 <vector102>:
.globl vector102
vector102:
  pushl $0
c01021a2:	6a 00                	push   $0x0
  pushl $102
c01021a4:	6a 66                	push   $0x66
  jmp __alltraps
c01021a6:	e9 4f fc ff ff       	jmp    c0101dfa <__alltraps>

c01021ab <vector103>:
.globl vector103
vector103:
  pushl $0
c01021ab:	6a 00                	push   $0x0
  pushl $103
c01021ad:	6a 67                	push   $0x67
  jmp __alltraps
c01021af:	e9 46 fc ff ff       	jmp    c0101dfa <__alltraps>

c01021b4 <vector104>:
.globl vector104
vector104:
  pushl $0
c01021b4:	6a 00                	push   $0x0
  pushl $104
c01021b6:	6a 68                	push   $0x68
  jmp __alltraps
c01021b8:	e9 3d fc ff ff       	jmp    c0101dfa <__alltraps>

c01021bd <vector105>:
.globl vector105
vector105:
  pushl $0
c01021bd:	6a 00                	push   $0x0
  pushl $105
c01021bf:	6a 69                	push   $0x69
  jmp __alltraps
c01021c1:	e9 34 fc ff ff       	jmp    c0101dfa <__alltraps>

c01021c6 <vector106>:
.globl vector106
vector106:
  pushl $0
c01021c6:	6a 00                	push   $0x0
  pushl $106
c01021c8:	6a 6a                	push   $0x6a
  jmp __alltraps
c01021ca:	e9 2b fc ff ff       	jmp    c0101dfa <__alltraps>

c01021cf <vector107>:
.globl vector107
vector107:
  pushl $0
c01021cf:	6a 00                	push   $0x0
  pushl $107
c01021d1:	6a 6b                	push   $0x6b
  jmp __alltraps
c01021d3:	e9 22 fc ff ff       	jmp    c0101dfa <__alltraps>

c01021d8 <vector108>:
.globl vector108
vector108:
  pushl $0
c01021d8:	6a 00                	push   $0x0
  pushl $108
c01021da:	6a 6c                	push   $0x6c
  jmp __alltraps
c01021dc:	e9 19 fc ff ff       	jmp    c0101dfa <__alltraps>

c01021e1 <vector109>:
.globl vector109
vector109:
  pushl $0
c01021e1:	6a 00                	push   $0x0
  pushl $109
c01021e3:	6a 6d                	push   $0x6d
  jmp __alltraps
c01021e5:	e9 10 fc ff ff       	jmp    c0101dfa <__alltraps>

c01021ea <vector110>:
.globl vector110
vector110:
  pushl $0
c01021ea:	6a 00                	push   $0x0
  pushl $110
c01021ec:	6a 6e                	push   $0x6e
  jmp __alltraps
c01021ee:	e9 07 fc ff ff       	jmp    c0101dfa <__alltraps>

c01021f3 <vector111>:
.globl vector111
vector111:
  pushl $0
c01021f3:	6a 00                	push   $0x0
  pushl $111
c01021f5:	6a 6f                	push   $0x6f
  jmp __alltraps
c01021f7:	e9 fe fb ff ff       	jmp    c0101dfa <__alltraps>

c01021fc <vector112>:
.globl vector112
vector112:
  pushl $0
c01021fc:	6a 00                	push   $0x0
  pushl $112
c01021fe:	6a 70                	push   $0x70
  jmp __alltraps
c0102200:	e9 f5 fb ff ff       	jmp    c0101dfa <__alltraps>

c0102205 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102205:	6a 00                	push   $0x0
  pushl $113
c0102207:	6a 71                	push   $0x71
  jmp __alltraps
c0102209:	e9 ec fb ff ff       	jmp    c0101dfa <__alltraps>

c010220e <vector114>:
.globl vector114
vector114:
  pushl $0
c010220e:	6a 00                	push   $0x0
  pushl $114
c0102210:	6a 72                	push   $0x72
  jmp __alltraps
c0102212:	e9 e3 fb ff ff       	jmp    c0101dfa <__alltraps>

c0102217 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102217:	6a 00                	push   $0x0
  pushl $115
c0102219:	6a 73                	push   $0x73
  jmp __alltraps
c010221b:	e9 da fb ff ff       	jmp    c0101dfa <__alltraps>

c0102220 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102220:	6a 00                	push   $0x0
  pushl $116
c0102222:	6a 74                	push   $0x74
  jmp __alltraps
c0102224:	e9 d1 fb ff ff       	jmp    c0101dfa <__alltraps>

c0102229 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102229:	6a 00                	push   $0x0
  pushl $117
c010222b:	6a 75                	push   $0x75
  jmp __alltraps
c010222d:	e9 c8 fb ff ff       	jmp    c0101dfa <__alltraps>

c0102232 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102232:	6a 00                	push   $0x0
  pushl $118
c0102234:	6a 76                	push   $0x76
  jmp __alltraps
c0102236:	e9 bf fb ff ff       	jmp    c0101dfa <__alltraps>

c010223b <vector119>:
.globl vector119
vector119:
  pushl $0
c010223b:	6a 00                	push   $0x0
  pushl $119
c010223d:	6a 77                	push   $0x77
  jmp __alltraps
c010223f:	e9 b6 fb ff ff       	jmp    c0101dfa <__alltraps>

c0102244 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102244:	6a 00                	push   $0x0
  pushl $120
c0102246:	6a 78                	push   $0x78
  jmp __alltraps
c0102248:	e9 ad fb ff ff       	jmp    c0101dfa <__alltraps>

c010224d <vector121>:
.globl vector121
vector121:
  pushl $0
c010224d:	6a 00                	push   $0x0
  pushl $121
c010224f:	6a 79                	push   $0x79
  jmp __alltraps
c0102251:	e9 a4 fb ff ff       	jmp    c0101dfa <__alltraps>

c0102256 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102256:	6a 00                	push   $0x0
  pushl $122
c0102258:	6a 7a                	push   $0x7a
  jmp __alltraps
c010225a:	e9 9b fb ff ff       	jmp    c0101dfa <__alltraps>

c010225f <vector123>:
.globl vector123
vector123:
  pushl $0
c010225f:	6a 00                	push   $0x0
  pushl $123
c0102261:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102263:	e9 92 fb ff ff       	jmp    c0101dfa <__alltraps>

c0102268 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102268:	6a 00                	push   $0x0
  pushl $124
c010226a:	6a 7c                	push   $0x7c
  jmp __alltraps
c010226c:	e9 89 fb ff ff       	jmp    c0101dfa <__alltraps>

c0102271 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102271:	6a 00                	push   $0x0
  pushl $125
c0102273:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102275:	e9 80 fb ff ff       	jmp    c0101dfa <__alltraps>

c010227a <vector126>:
.globl vector126
vector126:
  pushl $0
c010227a:	6a 00                	push   $0x0
  pushl $126
c010227c:	6a 7e                	push   $0x7e
  jmp __alltraps
c010227e:	e9 77 fb ff ff       	jmp    c0101dfa <__alltraps>

c0102283 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102283:	6a 00                	push   $0x0
  pushl $127
c0102285:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102287:	e9 6e fb ff ff       	jmp    c0101dfa <__alltraps>

c010228c <vector128>:
.globl vector128
vector128:
  pushl $0
c010228c:	6a 00                	push   $0x0
  pushl $128
c010228e:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102293:	e9 62 fb ff ff       	jmp    c0101dfa <__alltraps>

c0102298 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102298:	6a 00                	push   $0x0
  pushl $129
c010229a:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c010229f:	e9 56 fb ff ff       	jmp    c0101dfa <__alltraps>

c01022a4 <vector130>:
.globl vector130
vector130:
  pushl $0
c01022a4:	6a 00                	push   $0x0
  pushl $130
c01022a6:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01022ab:	e9 4a fb ff ff       	jmp    c0101dfa <__alltraps>

c01022b0 <vector131>:
.globl vector131
vector131:
  pushl $0
c01022b0:	6a 00                	push   $0x0
  pushl $131
c01022b2:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01022b7:	e9 3e fb ff ff       	jmp    c0101dfa <__alltraps>

c01022bc <vector132>:
.globl vector132
vector132:
  pushl $0
c01022bc:	6a 00                	push   $0x0
  pushl $132
c01022be:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01022c3:	e9 32 fb ff ff       	jmp    c0101dfa <__alltraps>

c01022c8 <vector133>:
.globl vector133
vector133:
  pushl $0
c01022c8:	6a 00                	push   $0x0
  pushl $133
c01022ca:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01022cf:	e9 26 fb ff ff       	jmp    c0101dfa <__alltraps>

c01022d4 <vector134>:
.globl vector134
vector134:
  pushl $0
c01022d4:	6a 00                	push   $0x0
  pushl $134
c01022d6:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01022db:	e9 1a fb ff ff       	jmp    c0101dfa <__alltraps>

c01022e0 <vector135>:
.globl vector135
vector135:
  pushl $0
c01022e0:	6a 00                	push   $0x0
  pushl $135
c01022e2:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01022e7:	e9 0e fb ff ff       	jmp    c0101dfa <__alltraps>

c01022ec <vector136>:
.globl vector136
vector136:
  pushl $0
c01022ec:	6a 00                	push   $0x0
  pushl $136
c01022ee:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01022f3:	e9 02 fb ff ff       	jmp    c0101dfa <__alltraps>

c01022f8 <vector137>:
.globl vector137
vector137:
  pushl $0
c01022f8:	6a 00                	push   $0x0
  pushl $137
c01022fa:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01022ff:	e9 f6 fa ff ff       	jmp    c0101dfa <__alltraps>

c0102304 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102304:	6a 00                	push   $0x0
  pushl $138
c0102306:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010230b:	e9 ea fa ff ff       	jmp    c0101dfa <__alltraps>

c0102310 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102310:	6a 00                	push   $0x0
  pushl $139
c0102312:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102317:	e9 de fa ff ff       	jmp    c0101dfa <__alltraps>

c010231c <vector140>:
.globl vector140
vector140:
  pushl $0
c010231c:	6a 00                	push   $0x0
  pushl $140
c010231e:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102323:	e9 d2 fa ff ff       	jmp    c0101dfa <__alltraps>

c0102328 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102328:	6a 00                	push   $0x0
  pushl $141
c010232a:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010232f:	e9 c6 fa ff ff       	jmp    c0101dfa <__alltraps>

c0102334 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102334:	6a 00                	push   $0x0
  pushl $142
c0102336:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c010233b:	e9 ba fa ff ff       	jmp    c0101dfa <__alltraps>

c0102340 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102340:	6a 00                	push   $0x0
  pushl $143
c0102342:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102347:	e9 ae fa ff ff       	jmp    c0101dfa <__alltraps>

c010234c <vector144>:
.globl vector144
vector144:
  pushl $0
c010234c:	6a 00                	push   $0x0
  pushl $144
c010234e:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102353:	e9 a2 fa ff ff       	jmp    c0101dfa <__alltraps>

c0102358 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102358:	6a 00                	push   $0x0
  pushl $145
c010235a:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c010235f:	e9 96 fa ff ff       	jmp    c0101dfa <__alltraps>

c0102364 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102364:	6a 00                	push   $0x0
  pushl $146
c0102366:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c010236b:	e9 8a fa ff ff       	jmp    c0101dfa <__alltraps>

c0102370 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102370:	6a 00                	push   $0x0
  pushl $147
c0102372:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102377:	e9 7e fa ff ff       	jmp    c0101dfa <__alltraps>

c010237c <vector148>:
.globl vector148
vector148:
  pushl $0
c010237c:	6a 00                	push   $0x0
  pushl $148
c010237e:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102383:	e9 72 fa ff ff       	jmp    c0101dfa <__alltraps>

c0102388 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102388:	6a 00                	push   $0x0
  pushl $149
c010238a:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c010238f:	e9 66 fa ff ff       	jmp    c0101dfa <__alltraps>

c0102394 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102394:	6a 00                	push   $0x0
  pushl $150
c0102396:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c010239b:	e9 5a fa ff ff       	jmp    c0101dfa <__alltraps>

c01023a0 <vector151>:
.globl vector151
vector151:
  pushl $0
c01023a0:	6a 00                	push   $0x0
  pushl $151
c01023a2:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01023a7:	e9 4e fa ff ff       	jmp    c0101dfa <__alltraps>

c01023ac <vector152>:
.globl vector152
vector152:
  pushl $0
c01023ac:	6a 00                	push   $0x0
  pushl $152
c01023ae:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01023b3:	e9 42 fa ff ff       	jmp    c0101dfa <__alltraps>

c01023b8 <vector153>:
.globl vector153
vector153:
  pushl $0
c01023b8:	6a 00                	push   $0x0
  pushl $153
c01023ba:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01023bf:	e9 36 fa ff ff       	jmp    c0101dfa <__alltraps>

c01023c4 <vector154>:
.globl vector154
vector154:
  pushl $0
c01023c4:	6a 00                	push   $0x0
  pushl $154
c01023c6:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01023cb:	e9 2a fa ff ff       	jmp    c0101dfa <__alltraps>

c01023d0 <vector155>:
.globl vector155
vector155:
  pushl $0
c01023d0:	6a 00                	push   $0x0
  pushl $155
c01023d2:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01023d7:	e9 1e fa ff ff       	jmp    c0101dfa <__alltraps>

c01023dc <vector156>:
.globl vector156
vector156:
  pushl $0
c01023dc:	6a 00                	push   $0x0
  pushl $156
c01023de:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01023e3:	e9 12 fa ff ff       	jmp    c0101dfa <__alltraps>

c01023e8 <vector157>:
.globl vector157
vector157:
  pushl $0
c01023e8:	6a 00                	push   $0x0
  pushl $157
c01023ea:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01023ef:	e9 06 fa ff ff       	jmp    c0101dfa <__alltraps>

c01023f4 <vector158>:
.globl vector158
vector158:
  pushl $0
c01023f4:	6a 00                	push   $0x0
  pushl $158
c01023f6:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01023fb:	e9 fa f9 ff ff       	jmp    c0101dfa <__alltraps>

c0102400 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102400:	6a 00                	push   $0x0
  pushl $159
c0102402:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102407:	e9 ee f9 ff ff       	jmp    c0101dfa <__alltraps>

c010240c <vector160>:
.globl vector160
vector160:
  pushl $0
c010240c:	6a 00                	push   $0x0
  pushl $160
c010240e:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102413:	e9 e2 f9 ff ff       	jmp    c0101dfa <__alltraps>

c0102418 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102418:	6a 00                	push   $0x0
  pushl $161
c010241a:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010241f:	e9 d6 f9 ff ff       	jmp    c0101dfa <__alltraps>

c0102424 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102424:	6a 00                	push   $0x0
  pushl $162
c0102426:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010242b:	e9 ca f9 ff ff       	jmp    c0101dfa <__alltraps>

c0102430 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102430:	6a 00                	push   $0x0
  pushl $163
c0102432:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102437:	e9 be f9 ff ff       	jmp    c0101dfa <__alltraps>

c010243c <vector164>:
.globl vector164
vector164:
  pushl $0
c010243c:	6a 00                	push   $0x0
  pushl $164
c010243e:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102443:	e9 b2 f9 ff ff       	jmp    c0101dfa <__alltraps>

c0102448 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102448:	6a 00                	push   $0x0
  pushl $165
c010244a:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010244f:	e9 a6 f9 ff ff       	jmp    c0101dfa <__alltraps>

c0102454 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102454:	6a 00                	push   $0x0
  pushl $166
c0102456:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c010245b:	e9 9a f9 ff ff       	jmp    c0101dfa <__alltraps>

c0102460 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102460:	6a 00                	push   $0x0
  pushl $167
c0102462:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102467:	e9 8e f9 ff ff       	jmp    c0101dfa <__alltraps>

c010246c <vector168>:
.globl vector168
vector168:
  pushl $0
c010246c:	6a 00                	push   $0x0
  pushl $168
c010246e:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102473:	e9 82 f9 ff ff       	jmp    c0101dfa <__alltraps>

c0102478 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102478:	6a 00                	push   $0x0
  pushl $169
c010247a:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c010247f:	e9 76 f9 ff ff       	jmp    c0101dfa <__alltraps>

c0102484 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102484:	6a 00                	push   $0x0
  pushl $170
c0102486:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010248b:	e9 6a f9 ff ff       	jmp    c0101dfa <__alltraps>

c0102490 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102490:	6a 00                	push   $0x0
  pushl $171
c0102492:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102497:	e9 5e f9 ff ff       	jmp    c0101dfa <__alltraps>

c010249c <vector172>:
.globl vector172
vector172:
  pushl $0
c010249c:	6a 00                	push   $0x0
  pushl $172
c010249e:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01024a3:	e9 52 f9 ff ff       	jmp    c0101dfa <__alltraps>

c01024a8 <vector173>:
.globl vector173
vector173:
  pushl $0
c01024a8:	6a 00                	push   $0x0
  pushl $173
c01024aa:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01024af:	e9 46 f9 ff ff       	jmp    c0101dfa <__alltraps>

c01024b4 <vector174>:
.globl vector174
vector174:
  pushl $0
c01024b4:	6a 00                	push   $0x0
  pushl $174
c01024b6:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01024bb:	e9 3a f9 ff ff       	jmp    c0101dfa <__alltraps>

c01024c0 <vector175>:
.globl vector175
vector175:
  pushl $0
c01024c0:	6a 00                	push   $0x0
  pushl $175
c01024c2:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01024c7:	e9 2e f9 ff ff       	jmp    c0101dfa <__alltraps>

c01024cc <vector176>:
.globl vector176
vector176:
  pushl $0
c01024cc:	6a 00                	push   $0x0
  pushl $176
c01024ce:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01024d3:	e9 22 f9 ff ff       	jmp    c0101dfa <__alltraps>

c01024d8 <vector177>:
.globl vector177
vector177:
  pushl $0
c01024d8:	6a 00                	push   $0x0
  pushl $177
c01024da:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01024df:	e9 16 f9 ff ff       	jmp    c0101dfa <__alltraps>

c01024e4 <vector178>:
.globl vector178
vector178:
  pushl $0
c01024e4:	6a 00                	push   $0x0
  pushl $178
c01024e6:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01024eb:	e9 0a f9 ff ff       	jmp    c0101dfa <__alltraps>

c01024f0 <vector179>:
.globl vector179
vector179:
  pushl $0
c01024f0:	6a 00                	push   $0x0
  pushl $179
c01024f2:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01024f7:	e9 fe f8 ff ff       	jmp    c0101dfa <__alltraps>

c01024fc <vector180>:
.globl vector180
vector180:
  pushl $0
c01024fc:	6a 00                	push   $0x0
  pushl $180
c01024fe:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102503:	e9 f2 f8 ff ff       	jmp    c0101dfa <__alltraps>

c0102508 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102508:	6a 00                	push   $0x0
  pushl $181
c010250a:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010250f:	e9 e6 f8 ff ff       	jmp    c0101dfa <__alltraps>

c0102514 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102514:	6a 00                	push   $0x0
  pushl $182
c0102516:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010251b:	e9 da f8 ff ff       	jmp    c0101dfa <__alltraps>

c0102520 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102520:	6a 00                	push   $0x0
  pushl $183
c0102522:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102527:	e9 ce f8 ff ff       	jmp    c0101dfa <__alltraps>

c010252c <vector184>:
.globl vector184
vector184:
  pushl $0
c010252c:	6a 00                	push   $0x0
  pushl $184
c010252e:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102533:	e9 c2 f8 ff ff       	jmp    c0101dfa <__alltraps>

c0102538 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102538:	6a 00                	push   $0x0
  pushl $185
c010253a:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c010253f:	e9 b6 f8 ff ff       	jmp    c0101dfa <__alltraps>

c0102544 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102544:	6a 00                	push   $0x0
  pushl $186
c0102546:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010254b:	e9 aa f8 ff ff       	jmp    c0101dfa <__alltraps>

c0102550 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102550:	6a 00                	push   $0x0
  pushl $187
c0102552:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102557:	e9 9e f8 ff ff       	jmp    c0101dfa <__alltraps>

c010255c <vector188>:
.globl vector188
vector188:
  pushl $0
c010255c:	6a 00                	push   $0x0
  pushl $188
c010255e:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102563:	e9 92 f8 ff ff       	jmp    c0101dfa <__alltraps>

c0102568 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102568:	6a 00                	push   $0x0
  pushl $189
c010256a:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c010256f:	e9 86 f8 ff ff       	jmp    c0101dfa <__alltraps>

c0102574 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102574:	6a 00                	push   $0x0
  pushl $190
c0102576:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c010257b:	e9 7a f8 ff ff       	jmp    c0101dfa <__alltraps>

c0102580 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102580:	6a 00                	push   $0x0
  pushl $191
c0102582:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102587:	e9 6e f8 ff ff       	jmp    c0101dfa <__alltraps>

c010258c <vector192>:
.globl vector192
vector192:
  pushl $0
c010258c:	6a 00                	push   $0x0
  pushl $192
c010258e:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102593:	e9 62 f8 ff ff       	jmp    c0101dfa <__alltraps>

c0102598 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102598:	6a 00                	push   $0x0
  pushl $193
c010259a:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c010259f:	e9 56 f8 ff ff       	jmp    c0101dfa <__alltraps>

c01025a4 <vector194>:
.globl vector194
vector194:
  pushl $0
c01025a4:	6a 00                	push   $0x0
  pushl $194
c01025a6:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01025ab:	e9 4a f8 ff ff       	jmp    c0101dfa <__alltraps>

c01025b0 <vector195>:
.globl vector195
vector195:
  pushl $0
c01025b0:	6a 00                	push   $0x0
  pushl $195
c01025b2:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01025b7:	e9 3e f8 ff ff       	jmp    c0101dfa <__alltraps>

c01025bc <vector196>:
.globl vector196
vector196:
  pushl $0
c01025bc:	6a 00                	push   $0x0
  pushl $196
c01025be:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01025c3:	e9 32 f8 ff ff       	jmp    c0101dfa <__alltraps>

c01025c8 <vector197>:
.globl vector197
vector197:
  pushl $0
c01025c8:	6a 00                	push   $0x0
  pushl $197
c01025ca:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01025cf:	e9 26 f8 ff ff       	jmp    c0101dfa <__alltraps>

c01025d4 <vector198>:
.globl vector198
vector198:
  pushl $0
c01025d4:	6a 00                	push   $0x0
  pushl $198
c01025d6:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01025db:	e9 1a f8 ff ff       	jmp    c0101dfa <__alltraps>

c01025e0 <vector199>:
.globl vector199
vector199:
  pushl $0
c01025e0:	6a 00                	push   $0x0
  pushl $199
c01025e2:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01025e7:	e9 0e f8 ff ff       	jmp    c0101dfa <__alltraps>

c01025ec <vector200>:
.globl vector200
vector200:
  pushl $0
c01025ec:	6a 00                	push   $0x0
  pushl $200
c01025ee:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01025f3:	e9 02 f8 ff ff       	jmp    c0101dfa <__alltraps>

c01025f8 <vector201>:
.globl vector201
vector201:
  pushl $0
c01025f8:	6a 00                	push   $0x0
  pushl $201
c01025fa:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01025ff:	e9 f6 f7 ff ff       	jmp    c0101dfa <__alltraps>

c0102604 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102604:	6a 00                	push   $0x0
  pushl $202
c0102606:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010260b:	e9 ea f7 ff ff       	jmp    c0101dfa <__alltraps>

c0102610 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102610:	6a 00                	push   $0x0
  pushl $203
c0102612:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102617:	e9 de f7 ff ff       	jmp    c0101dfa <__alltraps>

c010261c <vector204>:
.globl vector204
vector204:
  pushl $0
c010261c:	6a 00                	push   $0x0
  pushl $204
c010261e:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102623:	e9 d2 f7 ff ff       	jmp    c0101dfa <__alltraps>

c0102628 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102628:	6a 00                	push   $0x0
  pushl $205
c010262a:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010262f:	e9 c6 f7 ff ff       	jmp    c0101dfa <__alltraps>

c0102634 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102634:	6a 00                	push   $0x0
  pushl $206
c0102636:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010263b:	e9 ba f7 ff ff       	jmp    c0101dfa <__alltraps>

c0102640 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102640:	6a 00                	push   $0x0
  pushl $207
c0102642:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102647:	e9 ae f7 ff ff       	jmp    c0101dfa <__alltraps>

c010264c <vector208>:
.globl vector208
vector208:
  pushl $0
c010264c:	6a 00                	push   $0x0
  pushl $208
c010264e:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102653:	e9 a2 f7 ff ff       	jmp    c0101dfa <__alltraps>

c0102658 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102658:	6a 00                	push   $0x0
  pushl $209
c010265a:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c010265f:	e9 96 f7 ff ff       	jmp    c0101dfa <__alltraps>

c0102664 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102664:	6a 00                	push   $0x0
  pushl $210
c0102666:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010266b:	e9 8a f7 ff ff       	jmp    c0101dfa <__alltraps>

c0102670 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102670:	6a 00                	push   $0x0
  pushl $211
c0102672:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102677:	e9 7e f7 ff ff       	jmp    c0101dfa <__alltraps>

c010267c <vector212>:
.globl vector212
vector212:
  pushl $0
c010267c:	6a 00                	push   $0x0
  pushl $212
c010267e:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102683:	e9 72 f7 ff ff       	jmp    c0101dfa <__alltraps>

c0102688 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102688:	6a 00                	push   $0x0
  pushl $213
c010268a:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c010268f:	e9 66 f7 ff ff       	jmp    c0101dfa <__alltraps>

c0102694 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102694:	6a 00                	push   $0x0
  pushl $214
c0102696:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010269b:	e9 5a f7 ff ff       	jmp    c0101dfa <__alltraps>

c01026a0 <vector215>:
.globl vector215
vector215:
  pushl $0
c01026a0:	6a 00                	push   $0x0
  pushl $215
c01026a2:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01026a7:	e9 4e f7 ff ff       	jmp    c0101dfa <__alltraps>

c01026ac <vector216>:
.globl vector216
vector216:
  pushl $0
c01026ac:	6a 00                	push   $0x0
  pushl $216
c01026ae:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01026b3:	e9 42 f7 ff ff       	jmp    c0101dfa <__alltraps>

c01026b8 <vector217>:
.globl vector217
vector217:
  pushl $0
c01026b8:	6a 00                	push   $0x0
  pushl $217
c01026ba:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01026bf:	e9 36 f7 ff ff       	jmp    c0101dfa <__alltraps>

c01026c4 <vector218>:
.globl vector218
vector218:
  pushl $0
c01026c4:	6a 00                	push   $0x0
  pushl $218
c01026c6:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01026cb:	e9 2a f7 ff ff       	jmp    c0101dfa <__alltraps>

c01026d0 <vector219>:
.globl vector219
vector219:
  pushl $0
c01026d0:	6a 00                	push   $0x0
  pushl $219
c01026d2:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01026d7:	e9 1e f7 ff ff       	jmp    c0101dfa <__alltraps>

c01026dc <vector220>:
.globl vector220
vector220:
  pushl $0
c01026dc:	6a 00                	push   $0x0
  pushl $220
c01026de:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01026e3:	e9 12 f7 ff ff       	jmp    c0101dfa <__alltraps>

c01026e8 <vector221>:
.globl vector221
vector221:
  pushl $0
c01026e8:	6a 00                	push   $0x0
  pushl $221
c01026ea:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01026ef:	e9 06 f7 ff ff       	jmp    c0101dfa <__alltraps>

c01026f4 <vector222>:
.globl vector222
vector222:
  pushl $0
c01026f4:	6a 00                	push   $0x0
  pushl $222
c01026f6:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01026fb:	e9 fa f6 ff ff       	jmp    c0101dfa <__alltraps>

c0102700 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102700:	6a 00                	push   $0x0
  pushl $223
c0102702:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102707:	e9 ee f6 ff ff       	jmp    c0101dfa <__alltraps>

c010270c <vector224>:
.globl vector224
vector224:
  pushl $0
c010270c:	6a 00                	push   $0x0
  pushl $224
c010270e:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102713:	e9 e2 f6 ff ff       	jmp    c0101dfa <__alltraps>

c0102718 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102718:	6a 00                	push   $0x0
  pushl $225
c010271a:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010271f:	e9 d6 f6 ff ff       	jmp    c0101dfa <__alltraps>

c0102724 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102724:	6a 00                	push   $0x0
  pushl $226
c0102726:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010272b:	e9 ca f6 ff ff       	jmp    c0101dfa <__alltraps>

c0102730 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102730:	6a 00                	push   $0x0
  pushl $227
c0102732:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102737:	e9 be f6 ff ff       	jmp    c0101dfa <__alltraps>

c010273c <vector228>:
.globl vector228
vector228:
  pushl $0
c010273c:	6a 00                	push   $0x0
  pushl $228
c010273e:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102743:	e9 b2 f6 ff ff       	jmp    c0101dfa <__alltraps>

c0102748 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102748:	6a 00                	push   $0x0
  pushl $229
c010274a:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010274f:	e9 a6 f6 ff ff       	jmp    c0101dfa <__alltraps>

c0102754 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102754:	6a 00                	push   $0x0
  pushl $230
c0102756:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010275b:	e9 9a f6 ff ff       	jmp    c0101dfa <__alltraps>

c0102760 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102760:	6a 00                	push   $0x0
  pushl $231
c0102762:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102767:	e9 8e f6 ff ff       	jmp    c0101dfa <__alltraps>

c010276c <vector232>:
.globl vector232
vector232:
  pushl $0
c010276c:	6a 00                	push   $0x0
  pushl $232
c010276e:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102773:	e9 82 f6 ff ff       	jmp    c0101dfa <__alltraps>

c0102778 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102778:	6a 00                	push   $0x0
  pushl $233
c010277a:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c010277f:	e9 76 f6 ff ff       	jmp    c0101dfa <__alltraps>

c0102784 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102784:	6a 00                	push   $0x0
  pushl $234
c0102786:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010278b:	e9 6a f6 ff ff       	jmp    c0101dfa <__alltraps>

c0102790 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102790:	6a 00                	push   $0x0
  pushl $235
c0102792:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102797:	e9 5e f6 ff ff       	jmp    c0101dfa <__alltraps>

c010279c <vector236>:
.globl vector236
vector236:
  pushl $0
c010279c:	6a 00                	push   $0x0
  pushl $236
c010279e:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01027a3:	e9 52 f6 ff ff       	jmp    c0101dfa <__alltraps>

c01027a8 <vector237>:
.globl vector237
vector237:
  pushl $0
c01027a8:	6a 00                	push   $0x0
  pushl $237
c01027aa:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01027af:	e9 46 f6 ff ff       	jmp    c0101dfa <__alltraps>

c01027b4 <vector238>:
.globl vector238
vector238:
  pushl $0
c01027b4:	6a 00                	push   $0x0
  pushl $238
c01027b6:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01027bb:	e9 3a f6 ff ff       	jmp    c0101dfa <__alltraps>

c01027c0 <vector239>:
.globl vector239
vector239:
  pushl $0
c01027c0:	6a 00                	push   $0x0
  pushl $239
c01027c2:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01027c7:	e9 2e f6 ff ff       	jmp    c0101dfa <__alltraps>

c01027cc <vector240>:
.globl vector240
vector240:
  pushl $0
c01027cc:	6a 00                	push   $0x0
  pushl $240
c01027ce:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01027d3:	e9 22 f6 ff ff       	jmp    c0101dfa <__alltraps>

c01027d8 <vector241>:
.globl vector241
vector241:
  pushl $0
c01027d8:	6a 00                	push   $0x0
  pushl $241
c01027da:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01027df:	e9 16 f6 ff ff       	jmp    c0101dfa <__alltraps>

c01027e4 <vector242>:
.globl vector242
vector242:
  pushl $0
c01027e4:	6a 00                	push   $0x0
  pushl $242
c01027e6:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01027eb:	e9 0a f6 ff ff       	jmp    c0101dfa <__alltraps>

c01027f0 <vector243>:
.globl vector243
vector243:
  pushl $0
c01027f0:	6a 00                	push   $0x0
  pushl $243
c01027f2:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01027f7:	e9 fe f5 ff ff       	jmp    c0101dfa <__alltraps>

c01027fc <vector244>:
.globl vector244
vector244:
  pushl $0
c01027fc:	6a 00                	push   $0x0
  pushl $244
c01027fe:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102803:	e9 f2 f5 ff ff       	jmp    c0101dfa <__alltraps>

c0102808 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102808:	6a 00                	push   $0x0
  pushl $245
c010280a:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010280f:	e9 e6 f5 ff ff       	jmp    c0101dfa <__alltraps>

c0102814 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102814:	6a 00                	push   $0x0
  pushl $246
c0102816:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010281b:	e9 da f5 ff ff       	jmp    c0101dfa <__alltraps>

c0102820 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102820:	6a 00                	push   $0x0
  pushl $247
c0102822:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102827:	e9 ce f5 ff ff       	jmp    c0101dfa <__alltraps>

c010282c <vector248>:
.globl vector248
vector248:
  pushl $0
c010282c:	6a 00                	push   $0x0
  pushl $248
c010282e:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102833:	e9 c2 f5 ff ff       	jmp    c0101dfa <__alltraps>

c0102838 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102838:	6a 00                	push   $0x0
  pushl $249
c010283a:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010283f:	e9 b6 f5 ff ff       	jmp    c0101dfa <__alltraps>

c0102844 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102844:	6a 00                	push   $0x0
  pushl $250
c0102846:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010284b:	e9 aa f5 ff ff       	jmp    c0101dfa <__alltraps>

c0102850 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102850:	6a 00                	push   $0x0
  pushl $251
c0102852:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102857:	e9 9e f5 ff ff       	jmp    c0101dfa <__alltraps>

c010285c <vector252>:
.globl vector252
vector252:
  pushl $0
c010285c:	6a 00                	push   $0x0
  pushl $252
c010285e:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102863:	e9 92 f5 ff ff       	jmp    c0101dfa <__alltraps>

c0102868 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102868:	6a 00                	push   $0x0
  pushl $253
c010286a:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c010286f:	e9 86 f5 ff ff       	jmp    c0101dfa <__alltraps>

c0102874 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102874:	6a 00                	push   $0x0
  pushl $254
c0102876:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010287b:	e9 7a f5 ff ff       	jmp    c0101dfa <__alltraps>

c0102880 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102880:	6a 00                	push   $0x0
  pushl $255
c0102882:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102887:	e9 6e f5 ff ff       	jmp    c0101dfa <__alltraps>

c010288c <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010288c:	55                   	push   %ebp
c010288d:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010288f:	8b 55 08             	mov    0x8(%ebp),%edx
c0102892:	a1 84 89 11 c0       	mov    0xc0118984,%eax
c0102897:	29 c2                	sub    %eax,%edx
c0102899:	89 d0                	mov    %edx,%eax
c010289b:	c1 f8 02             	sar    $0x2,%eax
c010289e:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01028a4:	5d                   	pop    %ebp
c01028a5:	c3                   	ret    

c01028a6 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01028a6:	55                   	push   %ebp
c01028a7:	89 e5                	mov    %esp,%ebp
c01028a9:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01028ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01028af:	89 04 24             	mov    %eax,(%esp)
c01028b2:	e8 d5 ff ff ff       	call   c010288c <page2ppn>
c01028b7:	c1 e0 0c             	shl    $0xc,%eax
}
c01028ba:	c9                   	leave  
c01028bb:	c3                   	ret    

c01028bc <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01028bc:	55                   	push   %ebp
c01028bd:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01028bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01028c2:	8b 00                	mov    (%eax),%eax
}
c01028c4:	5d                   	pop    %ebp
c01028c5:	c3                   	ret    

c01028c6 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01028c6:	55                   	push   %ebp
c01028c7:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01028c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01028cc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01028cf:	89 10                	mov    %edx,(%eax)
}
c01028d1:	5d                   	pop    %ebp
c01028d2:	c3                   	ret    

c01028d3 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01028d3:	55                   	push   %ebp
c01028d4:	89 e5                	mov    %esp,%ebp
c01028d6:	83 ec 10             	sub    $0x10,%esp
c01028d9:	c7 45 fc 70 89 11 c0 	movl   $0xc0118970,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01028e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01028e6:	89 50 04             	mov    %edx,0x4(%eax)
c01028e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028ec:	8b 50 04             	mov    0x4(%eax),%edx
c01028ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028f2:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01028f4:	c7 05 78 89 11 c0 00 	movl   $0x0,0xc0118978
c01028fb:	00 00 00 
}
c01028fe:	c9                   	leave  
c01028ff:	c3                   	ret    

c0102900 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0102900:	55                   	push   %ebp
c0102901:	89 e5                	mov    %esp,%ebp
c0102903:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0102906:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010290a:	75 24                	jne    c0102930 <default_init_memmap+0x30>
c010290c:	c7 44 24 0c 30 65 10 	movl   $0xc0106530,0xc(%esp)
c0102913:	c0 
c0102914:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c010291b:	c0 
c010291c:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0102923:	00 
c0102924:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c010292b:	e8 99 e3 ff ff       	call   c0100cc9 <__panic>
    struct Page *p = base;
c0102930:	8b 45 08             	mov    0x8(%ebp),%eax
c0102933:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102936:	eb 7d                	jmp    c01029b5 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0102938:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010293b:	83 c0 04             	add    $0x4,%eax
c010293e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102945:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102948:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010294b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010294e:	0f a3 10             	bt     %edx,(%eax)
c0102951:	19 c0                	sbb    %eax,%eax
c0102953:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102956:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010295a:	0f 95 c0             	setne  %al
c010295d:	0f b6 c0             	movzbl %al,%eax
c0102960:	85 c0                	test   %eax,%eax
c0102962:	75 24                	jne    c0102988 <default_init_memmap+0x88>
c0102964:	c7 44 24 0c 61 65 10 	movl   $0xc0106561,0xc(%esp)
c010296b:	c0 
c010296c:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0102973:	c0 
c0102974:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c010297b:	00 
c010297c:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0102983:	e8 41 e3 ff ff       	call   c0100cc9 <__panic>
        p->flags = p->property = 0;
c0102988:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010298b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0102992:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102995:	8b 50 08             	mov    0x8(%eax),%edx
c0102998:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010299b:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c010299e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01029a5:	00 
c01029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029a9:	89 04 24             	mov    %eax,(%esp)
c01029ac:	e8 15 ff ff ff       	call   c01028c6 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01029b1:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01029b5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029b8:	89 d0                	mov    %edx,%eax
c01029ba:	c1 e0 02             	shl    $0x2,%eax
c01029bd:	01 d0                	add    %edx,%eax
c01029bf:	c1 e0 02             	shl    $0x2,%eax
c01029c2:	89 c2                	mov    %eax,%edx
c01029c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01029c7:	01 d0                	add    %edx,%eax
c01029c9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01029cc:	0f 85 66 ff ff ff    	jne    c0102938 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c01029d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01029d5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029d8:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01029db:	8b 45 08             	mov    0x8(%ebp),%eax
c01029de:	83 c0 04             	add    $0x4,%eax
c01029e1:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01029e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01029eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01029ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01029f1:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c01029f4:	8b 15 78 89 11 c0    	mov    0xc0118978,%edx
c01029fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01029fd:	01 d0                	add    %edx,%eax
c01029ff:	a3 78 89 11 c0       	mov    %eax,0xc0118978
    list_add(&free_list, &(base->page_link));
c0102a04:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a07:	83 c0 0c             	add    $0xc,%eax
c0102a0a:	c7 45 dc 70 89 11 c0 	movl   $0xc0118970,-0x24(%ebp)
c0102a11:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102a14:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a17:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0102a1a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102a1d:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102a20:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a23:	8b 40 04             	mov    0x4(%eax),%eax
c0102a26:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102a29:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102a2c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a2f:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0102a32:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102a35:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102a38:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102a3b:	89 10                	mov    %edx,(%eax)
c0102a3d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102a40:	8b 10                	mov    (%eax),%edx
c0102a42:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102a45:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102a48:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a4b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102a4e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102a51:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a54:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102a57:	89 10                	mov    %edx,(%eax)
}
c0102a59:	c9                   	leave  
c0102a5a:	c3                   	ret    

c0102a5b <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102a5b:	55                   	push   %ebp
c0102a5c:	89 e5                	mov    %esp,%ebp
c0102a5e:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102a61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102a65:	75 24                	jne    c0102a8b <default_alloc_pages+0x30>
c0102a67:	c7 44 24 0c 30 65 10 	movl   $0xc0106530,0xc(%esp)
c0102a6e:	c0 
c0102a6f:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0102a76:	c0 
c0102a77:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c0102a7e:	00 
c0102a7f:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0102a86:	e8 3e e2 ff ff       	call   c0100cc9 <__panic>
    if (n > nr_free) {
c0102a8b:	a1 78 89 11 c0       	mov    0xc0118978,%eax
c0102a90:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a93:	73 0a                	jae    c0102a9f <default_alloc_pages+0x44>
        return NULL;
c0102a95:	b8 00 00 00 00       	mov    $0x0,%eax
c0102a9a:	e9 2a 01 00 00       	jmp    c0102bc9 <default_alloc_pages+0x16e>
    }
    struct Page *page = NULL;
c0102a9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102aa6:	c7 45 f0 70 89 11 c0 	movl   $0xc0118970,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102aad:	eb 1c                	jmp    c0102acb <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ab2:	83 e8 0c             	sub    $0xc,%eax
c0102ab5:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0102ab8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102abb:	8b 40 08             	mov    0x8(%eax),%eax
c0102abe:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102ac1:	72 08                	jb     c0102acb <default_alloc_pages+0x70>
            page = p;
c0102ac3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ac6:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102ac9:	eb 18                	jmp    c0102ae3 <default_alloc_pages+0x88>
c0102acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ace:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102ad1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102ad4:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0102ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102ada:	81 7d f0 70 89 11 c0 	cmpl   $0xc0118970,-0x10(%ebp)
c0102ae1:	75 cc                	jne    c0102aaf <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0102ae3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102ae7:	0f 84 d9 00 00 00    	je     c0102bc6 <default_alloc_pages+0x16b>
        list_del(&(page->page_link));
c0102aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102af0:	83 c0 0c             	add    $0xc,%eax
c0102af3:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102af6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102af9:	8b 40 04             	mov    0x4(%eax),%eax
c0102afc:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102aff:	8b 12                	mov    (%edx),%edx
c0102b01:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0102b04:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b07:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102b0a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102b0d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b10:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b13:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102b16:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c0102b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b1b:	8b 40 08             	mov    0x8(%eax),%eax
c0102b1e:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b21:	76 7d                	jbe    c0102ba0 <default_alloc_pages+0x145>
            struct Page *p = page + n;
c0102b23:	8b 55 08             	mov    0x8(%ebp),%edx
c0102b26:	89 d0                	mov    %edx,%eax
c0102b28:	c1 e0 02             	shl    $0x2,%eax
c0102b2b:	01 d0                	add    %edx,%eax
c0102b2d:	c1 e0 02             	shl    $0x2,%eax
c0102b30:	89 c2                	mov    %eax,%edx
c0102b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b35:	01 d0                	add    %edx,%eax
c0102b37:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0102b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b3d:	8b 40 08             	mov    0x8(%eax),%eax
c0102b40:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b43:	89 c2                	mov    %eax,%edx
c0102b45:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b48:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
c0102b4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b4e:	83 c0 0c             	add    $0xc,%eax
c0102b51:	c7 45 d4 70 89 11 c0 	movl   $0xc0118970,-0x2c(%ebp)
c0102b58:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102b5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102b5e:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0102b61:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b64:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102b67:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b6a:	8b 40 04             	mov    0x4(%eax),%eax
c0102b6d:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102b70:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102b73:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102b76:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102b79:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102b7c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102b7f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b82:	89 10                	mov    %edx,(%eax)
c0102b84:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102b87:	8b 10                	mov    (%eax),%edx
c0102b89:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102b8c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102b8f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102b92:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102b95:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102b98:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102b9b:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102b9e:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
c0102ba0:	a1 78 89 11 c0       	mov    0xc0118978,%eax
c0102ba5:	2b 45 08             	sub    0x8(%ebp),%eax
c0102ba8:	a3 78 89 11 c0       	mov    %eax,0xc0118978
        ClearPageProperty(page);
c0102bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bb0:	83 c0 04             	add    $0x4,%eax
c0102bb3:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102bba:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102bbd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102bc0:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102bc3:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0102bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102bc9:	c9                   	leave  
c0102bca:	c3                   	ret    

c0102bcb <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102bcb:	55                   	push   %ebp
c0102bcc:	89 e5                	mov    %esp,%ebp
c0102bce:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0102bd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102bd8:	75 24                	jne    c0102bfe <default_free_pages+0x33>
c0102bda:	c7 44 24 0c 30 65 10 	movl   $0xc0106530,0xc(%esp)
c0102be1:	c0 
c0102be2:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0102be9:	c0 
c0102bea:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0102bf1:	00 
c0102bf2:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0102bf9:	e8 cb e0 ff ff       	call   c0100cc9 <__panic>
    struct Page *p = base;
c0102bfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c01:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102c04:	e9 9d 00 00 00       	jmp    c0102ca6 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0102c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c0c:	83 c0 04             	add    $0x4,%eax
c0102c0f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102c16:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c19:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102c1f:	0f a3 10             	bt     %edx,(%eax)
c0102c22:	19 c0                	sbb    %eax,%eax
c0102c24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102c27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102c2b:	0f 95 c0             	setne  %al
c0102c2e:	0f b6 c0             	movzbl %al,%eax
c0102c31:	85 c0                	test   %eax,%eax
c0102c33:	75 2c                	jne    c0102c61 <default_free_pages+0x96>
c0102c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c38:	83 c0 04             	add    $0x4,%eax
c0102c3b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102c42:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c45:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c48:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102c4b:	0f a3 10             	bt     %edx,(%eax)
c0102c4e:	19 c0                	sbb    %eax,%eax
c0102c50:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102c53:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102c57:	0f 95 c0             	setne  %al
c0102c5a:	0f b6 c0             	movzbl %al,%eax
c0102c5d:	85 c0                	test   %eax,%eax
c0102c5f:	74 24                	je     c0102c85 <default_free_pages+0xba>
c0102c61:	c7 44 24 0c 74 65 10 	movl   $0xc0106574,0xc(%esp)
c0102c68:	c0 
c0102c69:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0102c70:	c0 
c0102c71:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c0102c78:	00 
c0102c79:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0102c80:	e8 44 e0 ff ff       	call   c0100cc9 <__panic>
        p->flags = 0;
c0102c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102c8f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102c96:	00 
c0102c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c9a:	89 04 24             	mov    %eax,(%esp)
c0102c9d:	e8 24 fc ff ff       	call   c01028c6 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102ca2:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102ca9:	89 d0                	mov    %edx,%eax
c0102cab:	c1 e0 02             	shl    $0x2,%eax
c0102cae:	01 d0                	add    %edx,%eax
c0102cb0:	c1 e0 02             	shl    $0x2,%eax
c0102cb3:	89 c2                	mov    %eax,%edx
c0102cb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cb8:	01 d0                	add    %edx,%eax
c0102cba:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102cbd:	0f 85 46 ff ff ff    	jne    c0102c09 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102cc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cc6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cc9:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102ccc:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ccf:	83 c0 04             	add    $0x4,%eax
c0102cd2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102cd9:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102cdc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102cdf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102ce2:	0f ab 10             	bts    %edx,(%eax)
c0102ce5:	c7 45 cc 70 89 11 c0 	movl   $0xc0118970,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102cec:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102cef:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102cf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102cf5:	e9 08 01 00 00       	jmp    c0102e02 <default_free_pages+0x237>
        p = le2page(le, page_link);
c0102cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cfd:	83 e8 0c             	sub    $0xc,%eax
c0102d00:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d06:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102d09:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102d0c:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102d0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0102d12:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d15:	8b 50 08             	mov    0x8(%eax),%edx
c0102d18:	89 d0                	mov    %edx,%eax
c0102d1a:	c1 e0 02             	shl    $0x2,%eax
c0102d1d:	01 d0                	add    %edx,%eax
c0102d1f:	c1 e0 02             	shl    $0x2,%eax
c0102d22:	89 c2                	mov    %eax,%edx
c0102d24:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d27:	01 d0                	add    %edx,%eax
c0102d29:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102d2c:	75 5a                	jne    c0102d88 <default_free_pages+0x1bd>
            base->property += p->property;
c0102d2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d31:	8b 50 08             	mov    0x8(%eax),%edx
c0102d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d37:	8b 40 08             	mov    0x8(%eax),%eax
c0102d3a:	01 c2                	add    %eax,%edx
c0102d3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d3f:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d45:	83 c0 04             	add    $0x4,%eax
c0102d48:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0102d4f:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d52:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102d55:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102d58:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0102d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d5e:	83 c0 0c             	add    $0xc,%eax
c0102d61:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102d64:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d67:	8b 40 04             	mov    0x4(%eax),%eax
c0102d6a:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102d6d:	8b 12                	mov    (%edx),%edx
c0102d6f:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102d72:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102d75:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102d78:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102d7b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102d7e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102d81:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102d84:	89 10                	mov    %edx,(%eax)
c0102d86:	eb 7a                	jmp    c0102e02 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
c0102d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d8b:	8b 50 08             	mov    0x8(%eax),%edx
c0102d8e:	89 d0                	mov    %edx,%eax
c0102d90:	c1 e0 02             	shl    $0x2,%eax
c0102d93:	01 d0                	add    %edx,%eax
c0102d95:	c1 e0 02             	shl    $0x2,%eax
c0102d98:	89 c2                	mov    %eax,%edx
c0102d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d9d:	01 d0                	add    %edx,%eax
c0102d9f:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102da2:	75 5e                	jne    c0102e02 <default_free_pages+0x237>
            p->property += base->property;
c0102da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102da7:	8b 50 08             	mov    0x8(%eax),%edx
c0102daa:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dad:	8b 40 08             	mov    0x8(%eax),%eax
c0102db0:	01 c2                	add    %eax,%edx
c0102db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102db5:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102db8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dbb:	83 c0 04             	add    $0x4,%eax
c0102dbe:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0102dc5:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0102dc8:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102dcb:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102dce:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0102dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dd4:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dda:	83 c0 0c             	add    $0xc,%eax
c0102ddd:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102de0:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102de3:	8b 40 04             	mov    0x4(%eax),%eax
c0102de6:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102de9:	8b 12                	mov    (%edx),%edx
c0102deb:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102dee:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102df1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102df4:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0102df7:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102dfa:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102dfd:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102e00:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c0102e02:	81 7d f0 70 89 11 c0 	cmpl   $0xc0118970,-0x10(%ebp)
c0102e09:	0f 85 eb fe ff ff    	jne    c0102cfa <default_free_pages+0x12f>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
c0102e0f:	8b 15 78 89 11 c0    	mov    0xc0118978,%edx
c0102e15:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102e18:	01 d0                	add    %edx,%eax
c0102e1a:	a3 78 89 11 c0       	mov    %eax,0xc0118978
    list_add(&free_list, &(base->page_link));
c0102e1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e22:	83 c0 0c             	add    $0xc,%eax
c0102e25:	c7 45 9c 70 89 11 c0 	movl   $0xc0118970,-0x64(%ebp)
c0102e2c:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102e2f:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102e32:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102e35:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102e38:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102e3b:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102e3e:	8b 40 04             	mov    0x4(%eax),%eax
c0102e41:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102e44:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0102e47:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102e4a:	89 55 88             	mov    %edx,-0x78(%ebp)
c0102e4d:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102e50:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102e53:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102e56:	89 10                	mov    %edx,(%eax)
c0102e58:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102e5b:	8b 10                	mov    (%eax),%edx
c0102e5d:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102e60:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102e63:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102e66:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102e69:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102e6c:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102e6f:	8b 55 88             	mov    -0x78(%ebp),%edx
c0102e72:	89 10                	mov    %edx,(%eax)
}
c0102e74:	c9                   	leave  
c0102e75:	c3                   	ret    

c0102e76 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102e76:	55                   	push   %ebp
c0102e77:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102e79:	a1 78 89 11 c0       	mov    0xc0118978,%eax
}
c0102e7e:	5d                   	pop    %ebp
c0102e7f:	c3                   	ret    

c0102e80 <basic_check>:

static void
basic_check(void) {
c0102e80:	55                   	push   %ebp
c0102e81:	89 e5                	mov    %esp,%ebp
c0102e83:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102e86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e90:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e96:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102e99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102ea0:	e8 78 0e 00 00       	call   c0103d1d <alloc_pages>
c0102ea5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102ea8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102eac:	75 24                	jne    c0102ed2 <basic_check+0x52>
c0102eae:	c7 44 24 0c 99 65 10 	movl   $0xc0106599,0xc(%esp)
c0102eb5:	c0 
c0102eb6:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0102ebd:	c0 
c0102ebe:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
c0102ec5:	00 
c0102ec6:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0102ecd:	e8 f7 dd ff ff       	call   c0100cc9 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102ed2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102ed9:	e8 3f 0e 00 00       	call   c0103d1d <alloc_pages>
c0102ede:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102ee1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102ee5:	75 24                	jne    c0102f0b <basic_check+0x8b>
c0102ee7:	c7 44 24 0c b5 65 10 	movl   $0xc01065b5,0xc(%esp)
c0102eee:	c0 
c0102eef:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0102ef6:	c0 
c0102ef7:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0102efe:	00 
c0102eff:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0102f06:	e8 be dd ff ff       	call   c0100cc9 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102f0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f12:	e8 06 0e 00 00       	call   c0103d1d <alloc_pages>
c0102f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102f1e:	75 24                	jne    c0102f44 <basic_check+0xc4>
c0102f20:	c7 44 24 0c d1 65 10 	movl   $0xc01065d1,0xc(%esp)
c0102f27:	c0 
c0102f28:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0102f2f:	c0 
c0102f30:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
c0102f37:	00 
c0102f38:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0102f3f:	e8 85 dd ff ff       	call   c0100cc9 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102f44:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f47:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102f4a:	74 10                	je     c0102f5c <basic_check+0xdc>
c0102f4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f4f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f52:	74 08                	je     c0102f5c <basic_check+0xdc>
c0102f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f57:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f5a:	75 24                	jne    c0102f80 <basic_check+0x100>
c0102f5c:	c7 44 24 0c f0 65 10 	movl   $0xc01065f0,0xc(%esp)
c0102f63:	c0 
c0102f64:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0102f6b:	c0 
c0102f6c:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
c0102f73:	00 
c0102f74:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0102f7b:	e8 49 dd ff ff       	call   c0100cc9 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102f80:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f83:	89 04 24             	mov    %eax,(%esp)
c0102f86:	e8 31 f9 ff ff       	call   c01028bc <page_ref>
c0102f8b:	85 c0                	test   %eax,%eax
c0102f8d:	75 1e                	jne    c0102fad <basic_check+0x12d>
c0102f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f92:	89 04 24             	mov    %eax,(%esp)
c0102f95:	e8 22 f9 ff ff       	call   c01028bc <page_ref>
c0102f9a:	85 c0                	test   %eax,%eax
c0102f9c:	75 0f                	jne    c0102fad <basic_check+0x12d>
c0102f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fa1:	89 04 24             	mov    %eax,(%esp)
c0102fa4:	e8 13 f9 ff ff       	call   c01028bc <page_ref>
c0102fa9:	85 c0                	test   %eax,%eax
c0102fab:	74 24                	je     c0102fd1 <basic_check+0x151>
c0102fad:	c7 44 24 0c 14 66 10 	movl   $0xc0106614,0xc(%esp)
c0102fb4:	c0 
c0102fb5:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0102fbc:	c0 
c0102fbd:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0102fc4:	00 
c0102fc5:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0102fcc:	e8 f8 dc ff ff       	call   c0100cc9 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102fd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fd4:	89 04 24             	mov    %eax,(%esp)
c0102fd7:	e8 ca f8 ff ff       	call   c01028a6 <page2pa>
c0102fdc:	8b 15 e0 88 11 c0    	mov    0xc01188e0,%edx
c0102fe2:	c1 e2 0c             	shl    $0xc,%edx
c0102fe5:	39 d0                	cmp    %edx,%eax
c0102fe7:	72 24                	jb     c010300d <basic_check+0x18d>
c0102fe9:	c7 44 24 0c 50 66 10 	movl   $0xc0106650,0xc(%esp)
c0102ff0:	c0 
c0102ff1:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0102ff8:	c0 
c0102ff9:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0103000:	00 
c0103001:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0103008:	e8 bc dc ff ff       	call   c0100cc9 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c010300d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103010:	89 04 24             	mov    %eax,(%esp)
c0103013:	e8 8e f8 ff ff       	call   c01028a6 <page2pa>
c0103018:	8b 15 e0 88 11 c0    	mov    0xc01188e0,%edx
c010301e:	c1 e2 0c             	shl    $0xc,%edx
c0103021:	39 d0                	cmp    %edx,%eax
c0103023:	72 24                	jb     c0103049 <basic_check+0x1c9>
c0103025:	c7 44 24 0c 6d 66 10 	movl   $0xc010666d,0xc(%esp)
c010302c:	c0 
c010302d:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0103034:	c0 
c0103035:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c010303c:	00 
c010303d:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0103044:	e8 80 dc ff ff       	call   c0100cc9 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103049:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010304c:	89 04 24             	mov    %eax,(%esp)
c010304f:	e8 52 f8 ff ff       	call   c01028a6 <page2pa>
c0103054:	8b 15 e0 88 11 c0    	mov    0xc01188e0,%edx
c010305a:	c1 e2 0c             	shl    $0xc,%edx
c010305d:	39 d0                	cmp    %edx,%eax
c010305f:	72 24                	jb     c0103085 <basic_check+0x205>
c0103061:	c7 44 24 0c 8a 66 10 	movl   $0xc010668a,0xc(%esp)
c0103068:	c0 
c0103069:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0103070:	c0 
c0103071:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0103078:	00 
c0103079:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0103080:	e8 44 dc ff ff       	call   c0100cc9 <__panic>

    list_entry_t free_list_store = free_list;
c0103085:	a1 70 89 11 c0       	mov    0xc0118970,%eax
c010308a:	8b 15 74 89 11 c0    	mov    0xc0118974,%edx
c0103090:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103093:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103096:	c7 45 e0 70 89 11 c0 	movl   $0xc0118970,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010309d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01030a3:	89 50 04             	mov    %edx,0x4(%eax)
c01030a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030a9:	8b 50 04             	mov    0x4(%eax),%edx
c01030ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030af:	89 10                	mov    %edx,(%eax)
c01030b1:	c7 45 dc 70 89 11 c0 	movl   $0xc0118970,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01030b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01030bb:	8b 40 04             	mov    0x4(%eax),%eax
c01030be:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01030c1:	0f 94 c0             	sete   %al
c01030c4:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01030c7:	85 c0                	test   %eax,%eax
c01030c9:	75 24                	jne    c01030ef <basic_check+0x26f>
c01030cb:	c7 44 24 0c a7 66 10 	movl   $0xc01066a7,0xc(%esp)
c01030d2:	c0 
c01030d3:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c01030da:	c0 
c01030db:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c01030e2:	00 
c01030e3:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c01030ea:	e8 da db ff ff       	call   c0100cc9 <__panic>

    unsigned int nr_free_store = nr_free;
c01030ef:	a1 78 89 11 c0       	mov    0xc0118978,%eax
c01030f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01030f7:	c7 05 78 89 11 c0 00 	movl   $0x0,0xc0118978
c01030fe:	00 00 00 

    assert(alloc_page() == NULL);
c0103101:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103108:	e8 10 0c 00 00       	call   c0103d1d <alloc_pages>
c010310d:	85 c0                	test   %eax,%eax
c010310f:	74 24                	je     c0103135 <basic_check+0x2b5>
c0103111:	c7 44 24 0c be 66 10 	movl   $0xc01066be,0xc(%esp)
c0103118:	c0 
c0103119:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0103120:	c0 
c0103121:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c0103128:	00 
c0103129:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0103130:	e8 94 db ff ff       	call   c0100cc9 <__panic>

    free_page(p0);
c0103135:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010313c:	00 
c010313d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103140:	89 04 24             	mov    %eax,(%esp)
c0103143:	e8 0d 0c 00 00       	call   c0103d55 <free_pages>
    free_page(p1);
c0103148:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010314f:	00 
c0103150:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103153:	89 04 24             	mov    %eax,(%esp)
c0103156:	e8 fa 0b 00 00       	call   c0103d55 <free_pages>
    free_page(p2);
c010315b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103162:	00 
c0103163:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103166:	89 04 24             	mov    %eax,(%esp)
c0103169:	e8 e7 0b 00 00       	call   c0103d55 <free_pages>
    assert(nr_free == 3);
c010316e:	a1 78 89 11 c0       	mov    0xc0118978,%eax
c0103173:	83 f8 03             	cmp    $0x3,%eax
c0103176:	74 24                	je     c010319c <basic_check+0x31c>
c0103178:	c7 44 24 0c d3 66 10 	movl   $0xc01066d3,0xc(%esp)
c010317f:	c0 
c0103180:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0103187:	c0 
c0103188:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c010318f:	00 
c0103190:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0103197:	e8 2d db ff ff       	call   c0100cc9 <__panic>

    assert((p0 = alloc_page()) != NULL);
c010319c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031a3:	e8 75 0b 00 00       	call   c0103d1d <alloc_pages>
c01031a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01031ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01031af:	75 24                	jne    c01031d5 <basic_check+0x355>
c01031b1:	c7 44 24 0c 99 65 10 	movl   $0xc0106599,0xc(%esp)
c01031b8:	c0 
c01031b9:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c01031c0:	c0 
c01031c1:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c01031c8:	00 
c01031c9:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c01031d0:	e8 f4 da ff ff       	call   c0100cc9 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01031d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031dc:	e8 3c 0b 00 00       	call   c0103d1d <alloc_pages>
c01031e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01031e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01031e8:	75 24                	jne    c010320e <basic_check+0x38e>
c01031ea:	c7 44 24 0c b5 65 10 	movl   $0xc01065b5,0xc(%esp)
c01031f1:	c0 
c01031f2:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c01031f9:	c0 
c01031fa:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0103201:	00 
c0103202:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0103209:	e8 bb da ff ff       	call   c0100cc9 <__panic>
    assert((p2 = alloc_page()) != NULL);
c010320e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103215:	e8 03 0b 00 00       	call   c0103d1d <alloc_pages>
c010321a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010321d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103221:	75 24                	jne    c0103247 <basic_check+0x3c7>
c0103223:	c7 44 24 0c d1 65 10 	movl   $0xc01065d1,0xc(%esp)
c010322a:	c0 
c010322b:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0103232:	c0 
c0103233:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c010323a:	00 
c010323b:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0103242:	e8 82 da ff ff       	call   c0100cc9 <__panic>

    assert(alloc_page() == NULL);
c0103247:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010324e:	e8 ca 0a 00 00       	call   c0103d1d <alloc_pages>
c0103253:	85 c0                	test   %eax,%eax
c0103255:	74 24                	je     c010327b <basic_check+0x3fb>
c0103257:	c7 44 24 0c be 66 10 	movl   $0xc01066be,0xc(%esp)
c010325e:	c0 
c010325f:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0103266:	c0 
c0103267:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c010326e:	00 
c010326f:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0103276:	e8 4e da ff ff       	call   c0100cc9 <__panic>

    free_page(p0);
c010327b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103282:	00 
c0103283:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103286:	89 04 24             	mov    %eax,(%esp)
c0103289:	e8 c7 0a 00 00       	call   c0103d55 <free_pages>
c010328e:	c7 45 d8 70 89 11 c0 	movl   $0xc0118970,-0x28(%ebp)
c0103295:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103298:	8b 40 04             	mov    0x4(%eax),%eax
c010329b:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010329e:	0f 94 c0             	sete   %al
c01032a1:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01032a4:	85 c0                	test   %eax,%eax
c01032a6:	74 24                	je     c01032cc <basic_check+0x44c>
c01032a8:	c7 44 24 0c e0 66 10 	movl   $0xc01066e0,0xc(%esp)
c01032af:	c0 
c01032b0:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c01032b7:	c0 
c01032b8:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c01032bf:	00 
c01032c0:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c01032c7:	e8 fd d9 ff ff       	call   c0100cc9 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01032cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032d3:	e8 45 0a 00 00       	call   c0103d1d <alloc_pages>
c01032d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01032db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032de:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01032e1:	74 24                	je     c0103307 <basic_check+0x487>
c01032e3:	c7 44 24 0c f8 66 10 	movl   $0xc01066f8,0xc(%esp)
c01032ea:	c0 
c01032eb:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c01032f2:	c0 
c01032f3:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c01032fa:	00 
c01032fb:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0103302:	e8 c2 d9 ff ff       	call   c0100cc9 <__panic>
    assert(alloc_page() == NULL);
c0103307:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010330e:	e8 0a 0a 00 00       	call   c0103d1d <alloc_pages>
c0103313:	85 c0                	test   %eax,%eax
c0103315:	74 24                	je     c010333b <basic_check+0x4bb>
c0103317:	c7 44 24 0c be 66 10 	movl   $0xc01066be,0xc(%esp)
c010331e:	c0 
c010331f:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0103326:	c0 
c0103327:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c010332e:	00 
c010332f:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0103336:	e8 8e d9 ff ff       	call   c0100cc9 <__panic>

    assert(nr_free == 0);
c010333b:	a1 78 89 11 c0       	mov    0xc0118978,%eax
c0103340:	85 c0                	test   %eax,%eax
c0103342:	74 24                	je     c0103368 <basic_check+0x4e8>
c0103344:	c7 44 24 0c 11 67 10 	movl   $0xc0106711,0xc(%esp)
c010334b:	c0 
c010334c:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0103353:	c0 
c0103354:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c010335b:	00 
c010335c:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0103363:	e8 61 d9 ff ff       	call   c0100cc9 <__panic>
    free_list = free_list_store;
c0103368:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010336b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010336e:	a3 70 89 11 c0       	mov    %eax,0xc0118970
c0103373:	89 15 74 89 11 c0    	mov    %edx,0xc0118974
    nr_free = nr_free_store;
c0103379:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010337c:	a3 78 89 11 c0       	mov    %eax,0xc0118978

    free_page(p);
c0103381:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103388:	00 
c0103389:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010338c:	89 04 24             	mov    %eax,(%esp)
c010338f:	e8 c1 09 00 00       	call   c0103d55 <free_pages>
    free_page(p1);
c0103394:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010339b:	00 
c010339c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010339f:	89 04 24             	mov    %eax,(%esp)
c01033a2:	e8 ae 09 00 00       	call   c0103d55 <free_pages>
    free_page(p2);
c01033a7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033ae:	00 
c01033af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033b2:	89 04 24             	mov    %eax,(%esp)
c01033b5:	e8 9b 09 00 00       	call   c0103d55 <free_pages>
}
c01033ba:	c9                   	leave  
c01033bb:	c3                   	ret    

c01033bc <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01033bc:	55                   	push   %ebp
c01033bd:	89 e5                	mov    %esp,%ebp
c01033bf:	53                   	push   %ebx
c01033c0:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c01033c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01033cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01033d4:	c7 45 ec 70 89 11 c0 	movl   $0xc0118970,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01033db:	eb 6b                	jmp    c0103448 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01033dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033e0:	83 e8 0c             	sub    $0xc,%eax
c01033e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c01033e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033e9:	83 c0 04             	add    $0x4,%eax
c01033ec:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01033f3:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01033f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01033f9:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01033fc:	0f a3 10             	bt     %edx,(%eax)
c01033ff:	19 c0                	sbb    %eax,%eax
c0103401:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103404:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103408:	0f 95 c0             	setne  %al
c010340b:	0f b6 c0             	movzbl %al,%eax
c010340e:	85 c0                	test   %eax,%eax
c0103410:	75 24                	jne    c0103436 <default_check+0x7a>
c0103412:	c7 44 24 0c 1e 67 10 	movl   $0xc010671e,0xc(%esp)
c0103419:	c0 
c010341a:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0103421:	c0 
c0103422:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0103429:	00 
c010342a:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0103431:	e8 93 d8 ff ff       	call   c0100cc9 <__panic>
        count ++, total += p->property;
c0103436:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010343a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010343d:	8b 50 08             	mov    0x8(%eax),%edx
c0103440:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103443:	01 d0                	add    %edx,%eax
c0103445:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103448:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010344b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010344e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103451:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103454:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103457:	81 7d ec 70 89 11 c0 	cmpl   $0xc0118970,-0x14(%ebp)
c010345e:	0f 85 79 ff ff ff    	jne    c01033dd <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103464:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103467:	e8 1b 09 00 00       	call   c0103d87 <nr_free_pages>
c010346c:	39 c3                	cmp    %eax,%ebx
c010346e:	74 24                	je     c0103494 <default_check+0xd8>
c0103470:	c7 44 24 0c 2e 67 10 	movl   $0xc010672e,0xc(%esp)
c0103477:	c0 
c0103478:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c010347f:	c0 
c0103480:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103487:	00 
c0103488:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c010348f:	e8 35 d8 ff ff       	call   c0100cc9 <__panic>

    basic_check();
c0103494:	e8 e7 f9 ff ff       	call   c0102e80 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103499:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01034a0:	e8 78 08 00 00       	call   c0103d1d <alloc_pages>
c01034a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01034a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01034ac:	75 24                	jne    c01034d2 <default_check+0x116>
c01034ae:	c7 44 24 0c 47 67 10 	movl   $0xc0106747,0xc(%esp)
c01034b5:	c0 
c01034b6:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c01034bd:	c0 
c01034be:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c01034c5:	00 
c01034c6:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c01034cd:	e8 f7 d7 ff ff       	call   c0100cc9 <__panic>
    assert(!PageProperty(p0));
c01034d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034d5:	83 c0 04             	add    $0x4,%eax
c01034d8:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01034df:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01034e2:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01034e5:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01034e8:	0f a3 10             	bt     %edx,(%eax)
c01034eb:	19 c0                	sbb    %eax,%eax
c01034ed:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01034f0:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01034f4:	0f 95 c0             	setne  %al
c01034f7:	0f b6 c0             	movzbl %al,%eax
c01034fa:	85 c0                	test   %eax,%eax
c01034fc:	74 24                	je     c0103522 <default_check+0x166>
c01034fe:	c7 44 24 0c 52 67 10 	movl   $0xc0106752,0xc(%esp)
c0103505:	c0 
c0103506:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c010350d:	c0 
c010350e:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103515:	00 
c0103516:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c010351d:	e8 a7 d7 ff ff       	call   c0100cc9 <__panic>

    list_entry_t free_list_store = free_list;
c0103522:	a1 70 89 11 c0       	mov    0xc0118970,%eax
c0103527:	8b 15 74 89 11 c0    	mov    0xc0118974,%edx
c010352d:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103530:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103533:	c7 45 b4 70 89 11 c0 	movl   $0xc0118970,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010353a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010353d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103540:	89 50 04             	mov    %edx,0x4(%eax)
c0103543:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103546:	8b 50 04             	mov    0x4(%eax),%edx
c0103549:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010354c:	89 10                	mov    %edx,(%eax)
c010354e:	c7 45 b0 70 89 11 c0 	movl   $0xc0118970,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103555:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103558:	8b 40 04             	mov    0x4(%eax),%eax
c010355b:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c010355e:	0f 94 c0             	sete   %al
c0103561:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103564:	85 c0                	test   %eax,%eax
c0103566:	75 24                	jne    c010358c <default_check+0x1d0>
c0103568:	c7 44 24 0c a7 66 10 	movl   $0xc01066a7,0xc(%esp)
c010356f:	c0 
c0103570:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0103577:	c0 
c0103578:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c010357f:	00 
c0103580:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0103587:	e8 3d d7 ff ff       	call   c0100cc9 <__panic>
    assert(alloc_page() == NULL);
c010358c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103593:	e8 85 07 00 00       	call   c0103d1d <alloc_pages>
c0103598:	85 c0                	test   %eax,%eax
c010359a:	74 24                	je     c01035c0 <default_check+0x204>
c010359c:	c7 44 24 0c be 66 10 	movl   $0xc01066be,0xc(%esp)
c01035a3:	c0 
c01035a4:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c01035ab:	c0 
c01035ac:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c01035b3:	00 
c01035b4:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c01035bb:	e8 09 d7 ff ff       	call   c0100cc9 <__panic>

    unsigned int nr_free_store = nr_free;
c01035c0:	a1 78 89 11 c0       	mov    0xc0118978,%eax
c01035c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01035c8:	c7 05 78 89 11 c0 00 	movl   $0x0,0xc0118978
c01035cf:	00 00 00 

    free_pages(p0 + 2, 3);
c01035d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035d5:	83 c0 28             	add    $0x28,%eax
c01035d8:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01035df:	00 
c01035e0:	89 04 24             	mov    %eax,(%esp)
c01035e3:	e8 6d 07 00 00       	call   c0103d55 <free_pages>
    assert(alloc_pages(4) == NULL);
c01035e8:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01035ef:	e8 29 07 00 00       	call   c0103d1d <alloc_pages>
c01035f4:	85 c0                	test   %eax,%eax
c01035f6:	74 24                	je     c010361c <default_check+0x260>
c01035f8:	c7 44 24 0c 64 67 10 	movl   $0xc0106764,0xc(%esp)
c01035ff:	c0 
c0103600:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0103607:	c0 
c0103608:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c010360f:	00 
c0103610:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0103617:	e8 ad d6 ff ff       	call   c0100cc9 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010361c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010361f:	83 c0 28             	add    $0x28,%eax
c0103622:	83 c0 04             	add    $0x4,%eax
c0103625:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c010362c:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010362f:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103632:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103635:	0f a3 10             	bt     %edx,(%eax)
c0103638:	19 c0                	sbb    %eax,%eax
c010363a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c010363d:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103641:	0f 95 c0             	setne  %al
c0103644:	0f b6 c0             	movzbl %al,%eax
c0103647:	85 c0                	test   %eax,%eax
c0103649:	74 0e                	je     c0103659 <default_check+0x29d>
c010364b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010364e:	83 c0 28             	add    $0x28,%eax
c0103651:	8b 40 08             	mov    0x8(%eax),%eax
c0103654:	83 f8 03             	cmp    $0x3,%eax
c0103657:	74 24                	je     c010367d <default_check+0x2c1>
c0103659:	c7 44 24 0c 7c 67 10 	movl   $0xc010677c,0xc(%esp)
c0103660:	c0 
c0103661:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0103668:	c0 
c0103669:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0103670:	00 
c0103671:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0103678:	e8 4c d6 ff ff       	call   c0100cc9 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010367d:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103684:	e8 94 06 00 00       	call   c0103d1d <alloc_pages>
c0103689:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010368c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103690:	75 24                	jne    c01036b6 <default_check+0x2fa>
c0103692:	c7 44 24 0c a8 67 10 	movl   $0xc01067a8,0xc(%esp)
c0103699:	c0 
c010369a:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c01036a1:	c0 
c01036a2:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c01036a9:	00 
c01036aa:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c01036b1:	e8 13 d6 ff ff       	call   c0100cc9 <__panic>
    assert(alloc_page() == NULL);
c01036b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01036bd:	e8 5b 06 00 00       	call   c0103d1d <alloc_pages>
c01036c2:	85 c0                	test   %eax,%eax
c01036c4:	74 24                	je     c01036ea <default_check+0x32e>
c01036c6:	c7 44 24 0c be 66 10 	movl   $0xc01066be,0xc(%esp)
c01036cd:	c0 
c01036ce:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c01036d5:	c0 
c01036d6:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c01036dd:	00 
c01036de:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c01036e5:	e8 df d5 ff ff       	call   c0100cc9 <__panic>
    assert(p0 + 2 == p1);
c01036ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036ed:	83 c0 28             	add    $0x28,%eax
c01036f0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01036f3:	74 24                	je     c0103719 <default_check+0x35d>
c01036f5:	c7 44 24 0c c6 67 10 	movl   $0xc01067c6,0xc(%esp)
c01036fc:	c0 
c01036fd:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0103704:	c0 
c0103705:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c010370c:	00 
c010370d:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0103714:	e8 b0 d5 ff ff       	call   c0100cc9 <__panic>

    p2 = p0 + 1;
c0103719:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010371c:	83 c0 14             	add    $0x14,%eax
c010371f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103722:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103729:	00 
c010372a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010372d:	89 04 24             	mov    %eax,(%esp)
c0103730:	e8 20 06 00 00       	call   c0103d55 <free_pages>
    free_pages(p1, 3);
c0103735:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010373c:	00 
c010373d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103740:	89 04 24             	mov    %eax,(%esp)
c0103743:	e8 0d 06 00 00       	call   c0103d55 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0103748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010374b:	83 c0 04             	add    $0x4,%eax
c010374e:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103755:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103758:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010375b:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010375e:	0f a3 10             	bt     %edx,(%eax)
c0103761:	19 c0                	sbb    %eax,%eax
c0103763:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103766:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010376a:	0f 95 c0             	setne  %al
c010376d:	0f b6 c0             	movzbl %al,%eax
c0103770:	85 c0                	test   %eax,%eax
c0103772:	74 0b                	je     c010377f <default_check+0x3c3>
c0103774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103777:	8b 40 08             	mov    0x8(%eax),%eax
c010377a:	83 f8 01             	cmp    $0x1,%eax
c010377d:	74 24                	je     c01037a3 <default_check+0x3e7>
c010377f:	c7 44 24 0c d4 67 10 	movl   $0xc01067d4,0xc(%esp)
c0103786:	c0 
c0103787:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c010378e:	c0 
c010378f:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0103796:	00 
c0103797:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c010379e:	e8 26 d5 ff ff       	call   c0100cc9 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01037a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037a6:	83 c0 04             	add    $0x4,%eax
c01037a9:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01037b0:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01037b3:	8b 45 90             	mov    -0x70(%ebp),%eax
c01037b6:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01037b9:	0f a3 10             	bt     %edx,(%eax)
c01037bc:	19 c0                	sbb    %eax,%eax
c01037be:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01037c1:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01037c5:	0f 95 c0             	setne  %al
c01037c8:	0f b6 c0             	movzbl %al,%eax
c01037cb:	85 c0                	test   %eax,%eax
c01037cd:	74 0b                	je     c01037da <default_check+0x41e>
c01037cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037d2:	8b 40 08             	mov    0x8(%eax),%eax
c01037d5:	83 f8 03             	cmp    $0x3,%eax
c01037d8:	74 24                	je     c01037fe <default_check+0x442>
c01037da:	c7 44 24 0c fc 67 10 	movl   $0xc01067fc,0xc(%esp)
c01037e1:	c0 
c01037e2:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c01037e9:	c0 
c01037ea:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c01037f1:	00 
c01037f2:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c01037f9:	e8 cb d4 ff ff       	call   c0100cc9 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01037fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103805:	e8 13 05 00 00       	call   c0103d1d <alloc_pages>
c010380a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010380d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103810:	83 e8 14             	sub    $0x14,%eax
c0103813:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103816:	74 24                	je     c010383c <default_check+0x480>
c0103818:	c7 44 24 0c 22 68 10 	movl   $0xc0106822,0xc(%esp)
c010381f:	c0 
c0103820:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0103827:	c0 
c0103828:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c010382f:	00 
c0103830:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0103837:	e8 8d d4 ff ff       	call   c0100cc9 <__panic>
    free_page(p0);
c010383c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103843:	00 
c0103844:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103847:	89 04 24             	mov    %eax,(%esp)
c010384a:	e8 06 05 00 00       	call   c0103d55 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010384f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103856:	e8 c2 04 00 00       	call   c0103d1d <alloc_pages>
c010385b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010385e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103861:	83 c0 14             	add    $0x14,%eax
c0103864:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103867:	74 24                	je     c010388d <default_check+0x4d1>
c0103869:	c7 44 24 0c 40 68 10 	movl   $0xc0106840,0xc(%esp)
c0103870:	c0 
c0103871:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0103878:	c0 
c0103879:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0103880:	00 
c0103881:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0103888:	e8 3c d4 ff ff       	call   c0100cc9 <__panic>

    free_pages(p0, 2);
c010388d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103894:	00 
c0103895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103898:	89 04 24             	mov    %eax,(%esp)
c010389b:	e8 b5 04 00 00       	call   c0103d55 <free_pages>
    free_page(p2);
c01038a0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01038a7:	00 
c01038a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01038ab:	89 04 24             	mov    %eax,(%esp)
c01038ae:	e8 a2 04 00 00       	call   c0103d55 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01038b3:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01038ba:	e8 5e 04 00 00       	call   c0103d1d <alloc_pages>
c01038bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01038c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01038c6:	75 24                	jne    c01038ec <default_check+0x530>
c01038c8:	c7 44 24 0c 60 68 10 	movl   $0xc0106860,0xc(%esp)
c01038cf:	c0 
c01038d0:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c01038d7:	c0 
c01038d8:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c01038df:	00 
c01038e0:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c01038e7:	e8 dd d3 ff ff       	call   c0100cc9 <__panic>
    assert(alloc_page() == NULL);
c01038ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038f3:	e8 25 04 00 00       	call   c0103d1d <alloc_pages>
c01038f8:	85 c0                	test   %eax,%eax
c01038fa:	74 24                	je     c0103920 <default_check+0x564>
c01038fc:	c7 44 24 0c be 66 10 	movl   $0xc01066be,0xc(%esp)
c0103903:	c0 
c0103904:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c010390b:	c0 
c010390c:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c0103913:	00 
c0103914:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c010391b:	e8 a9 d3 ff ff       	call   c0100cc9 <__panic>

    assert(nr_free == 0);
c0103920:	a1 78 89 11 c0       	mov    0xc0118978,%eax
c0103925:	85 c0                	test   %eax,%eax
c0103927:	74 24                	je     c010394d <default_check+0x591>
c0103929:	c7 44 24 0c 11 67 10 	movl   $0xc0106711,0xc(%esp)
c0103930:	c0 
c0103931:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c0103938:	c0 
c0103939:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0103940:	00 
c0103941:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0103948:	e8 7c d3 ff ff       	call   c0100cc9 <__panic>
    nr_free = nr_free_store;
c010394d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103950:	a3 78 89 11 c0       	mov    %eax,0xc0118978

    free_list = free_list_store;
c0103955:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103958:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010395b:	a3 70 89 11 c0       	mov    %eax,0xc0118970
c0103960:	89 15 74 89 11 c0    	mov    %edx,0xc0118974
    free_pages(p0, 5);
c0103966:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c010396d:	00 
c010396e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103971:	89 04 24             	mov    %eax,(%esp)
c0103974:	e8 dc 03 00 00       	call   c0103d55 <free_pages>

    le = &free_list;
c0103979:	c7 45 ec 70 89 11 c0 	movl   $0xc0118970,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103980:	eb 1d                	jmp    c010399f <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0103982:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103985:	83 e8 0c             	sub    $0xc,%eax
c0103988:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c010398b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010398f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103992:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103995:	8b 40 08             	mov    0x8(%eax),%eax
c0103998:	29 c2                	sub    %eax,%edx
c010399a:	89 d0                	mov    %edx,%eax
c010399c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010399f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039a2:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01039a5:	8b 45 88             	mov    -0x78(%ebp),%eax
c01039a8:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01039ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01039ae:	81 7d ec 70 89 11 c0 	cmpl   $0xc0118970,-0x14(%ebp)
c01039b5:	75 cb                	jne    c0103982 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01039b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01039bb:	74 24                	je     c01039e1 <default_check+0x625>
c01039bd:	c7 44 24 0c 7e 68 10 	movl   $0xc010687e,0xc(%esp)
c01039c4:	c0 
c01039c5:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c01039cc:	c0 
c01039cd:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c01039d4:	00 
c01039d5:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c01039dc:	e8 e8 d2 ff ff       	call   c0100cc9 <__panic>
    assert(total == 0);
c01039e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01039e5:	74 24                	je     c0103a0b <default_check+0x64f>
c01039e7:	c7 44 24 0c 89 68 10 	movl   $0xc0106889,0xc(%esp)
c01039ee:	c0 
c01039ef:	c7 44 24 08 36 65 10 	movl   $0xc0106536,0x8(%esp)
c01039f6:	c0 
c01039f7:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01039fe:	00 
c01039ff:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0103a06:	e8 be d2 ff ff       	call   c0100cc9 <__panic>
}
c0103a0b:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103a11:	5b                   	pop    %ebx
c0103a12:	5d                   	pop    %ebp
c0103a13:	c3                   	ret    

c0103a14 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103a14:	55                   	push   %ebp
c0103a15:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103a17:	8b 55 08             	mov    0x8(%ebp),%edx
c0103a1a:	a1 84 89 11 c0       	mov    0xc0118984,%eax
c0103a1f:	29 c2                	sub    %eax,%edx
c0103a21:	89 d0                	mov    %edx,%eax
c0103a23:	c1 f8 02             	sar    $0x2,%eax
c0103a26:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103a2c:	5d                   	pop    %ebp
c0103a2d:	c3                   	ret    

c0103a2e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103a2e:	55                   	push   %ebp
c0103a2f:	89 e5                	mov    %esp,%ebp
c0103a31:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103a34:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a37:	89 04 24             	mov    %eax,(%esp)
c0103a3a:	e8 d5 ff ff ff       	call   c0103a14 <page2ppn>
c0103a3f:	c1 e0 0c             	shl    $0xc,%eax
}
c0103a42:	c9                   	leave  
c0103a43:	c3                   	ret    

c0103a44 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103a44:	55                   	push   %ebp
c0103a45:	89 e5                	mov    %esp,%ebp
c0103a47:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103a4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a4d:	c1 e8 0c             	shr    $0xc,%eax
c0103a50:	89 c2                	mov    %eax,%edx
c0103a52:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0103a57:	39 c2                	cmp    %eax,%edx
c0103a59:	72 1c                	jb     c0103a77 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103a5b:	c7 44 24 08 c4 68 10 	movl   $0xc01068c4,0x8(%esp)
c0103a62:	c0 
c0103a63:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103a6a:	00 
c0103a6b:	c7 04 24 e3 68 10 c0 	movl   $0xc01068e3,(%esp)
c0103a72:	e8 52 d2 ff ff       	call   c0100cc9 <__panic>
    }
    return &pages[PPN(pa)];
c0103a77:	8b 0d 84 89 11 c0    	mov    0xc0118984,%ecx
c0103a7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a80:	c1 e8 0c             	shr    $0xc,%eax
c0103a83:	89 c2                	mov    %eax,%edx
c0103a85:	89 d0                	mov    %edx,%eax
c0103a87:	c1 e0 02             	shl    $0x2,%eax
c0103a8a:	01 d0                	add    %edx,%eax
c0103a8c:	c1 e0 02             	shl    $0x2,%eax
c0103a8f:	01 c8                	add    %ecx,%eax
}
c0103a91:	c9                   	leave  
c0103a92:	c3                   	ret    

c0103a93 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103a93:	55                   	push   %ebp
c0103a94:	89 e5                	mov    %esp,%ebp
c0103a96:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103a99:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a9c:	89 04 24             	mov    %eax,(%esp)
c0103a9f:	e8 8a ff ff ff       	call   c0103a2e <page2pa>
c0103aa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aaa:	c1 e8 0c             	shr    $0xc,%eax
c0103aad:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103ab0:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0103ab5:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103ab8:	72 23                	jb     c0103add <page2kva+0x4a>
c0103aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103abd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103ac1:	c7 44 24 08 f4 68 10 	movl   $0xc01068f4,0x8(%esp)
c0103ac8:	c0 
c0103ac9:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103ad0:	00 
c0103ad1:	c7 04 24 e3 68 10 c0 	movl   $0xc01068e3,(%esp)
c0103ad8:	e8 ec d1 ff ff       	call   c0100cc9 <__panic>
c0103add:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ae0:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103ae5:	c9                   	leave  
c0103ae6:	c3                   	ret    

c0103ae7 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103ae7:	55                   	push   %ebp
c0103ae8:	89 e5                	mov    %esp,%ebp
c0103aea:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103aed:	8b 45 08             	mov    0x8(%ebp),%eax
c0103af0:	83 e0 01             	and    $0x1,%eax
c0103af3:	85 c0                	test   %eax,%eax
c0103af5:	75 1c                	jne    c0103b13 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103af7:	c7 44 24 08 18 69 10 	movl   $0xc0106918,0x8(%esp)
c0103afe:	c0 
c0103aff:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103b06:	00 
c0103b07:	c7 04 24 e3 68 10 c0 	movl   $0xc01068e3,(%esp)
c0103b0e:	e8 b6 d1 ff ff       	call   c0100cc9 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103b13:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b1b:	89 04 24             	mov    %eax,(%esp)
c0103b1e:	e8 21 ff ff ff       	call   c0103a44 <pa2page>
}
c0103b23:	c9                   	leave  
c0103b24:	c3                   	ret    

c0103b25 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103b25:	55                   	push   %ebp
c0103b26:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103b28:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b2b:	8b 00                	mov    (%eax),%eax
}
c0103b2d:	5d                   	pop    %ebp
c0103b2e:	c3                   	ret    

c0103b2f <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c0103b2f:	55                   	push   %ebp
c0103b30:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103b32:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b35:	8b 00                	mov    (%eax),%eax
c0103b37:	8d 50 01             	lea    0x1(%eax),%edx
c0103b3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b3d:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103b3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b42:	8b 00                	mov    (%eax),%eax
}
c0103b44:	5d                   	pop    %ebp
c0103b45:	c3                   	ret    

c0103b46 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103b46:	55                   	push   %ebp
c0103b47:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103b49:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b4c:	8b 00                	mov    (%eax),%eax
c0103b4e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103b51:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b54:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b59:	8b 00                	mov    (%eax),%eax
}
c0103b5b:	5d                   	pop    %ebp
c0103b5c:	c3                   	ret    

c0103b5d <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103b5d:	55                   	push   %ebp
c0103b5e:	89 e5                	mov    %esp,%ebp
c0103b60:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103b63:	9c                   	pushf  
c0103b64:	58                   	pop    %eax
c0103b65:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103b6b:	25 00 02 00 00       	and    $0x200,%eax
c0103b70:	85 c0                	test   %eax,%eax
c0103b72:	74 0c                	je     c0103b80 <__intr_save+0x23>
        intr_disable();
c0103b74:	e8 33 db ff ff       	call   c01016ac <intr_disable>
        return 1;
c0103b79:	b8 01 00 00 00       	mov    $0x1,%eax
c0103b7e:	eb 05                	jmp    c0103b85 <__intr_save+0x28>
    }
    return 0;
c0103b80:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103b85:	c9                   	leave  
c0103b86:	c3                   	ret    

c0103b87 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103b87:	55                   	push   %ebp
c0103b88:	89 e5                	mov    %esp,%ebp
c0103b8a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103b8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103b91:	74 05                	je     c0103b98 <__intr_restore+0x11>
        intr_enable();
c0103b93:	e8 0e db ff ff       	call   c01016a6 <intr_enable>
    }
}
c0103b98:	c9                   	leave  
c0103b99:	c3                   	ret    

c0103b9a <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103b9a:	55                   	push   %ebp
c0103b9b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103b9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ba0:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103ba3:	b8 23 00 00 00       	mov    $0x23,%eax
c0103ba8:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103baa:	b8 23 00 00 00       	mov    $0x23,%eax
c0103baf:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103bb1:	b8 10 00 00 00       	mov    $0x10,%eax
c0103bb6:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103bb8:	b8 10 00 00 00       	mov    $0x10,%eax
c0103bbd:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103bbf:	b8 10 00 00 00       	mov    $0x10,%eax
c0103bc4:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103bc6:	ea cd 3b 10 c0 08 00 	ljmp   $0x8,$0xc0103bcd
}
c0103bcd:	5d                   	pop    %ebp
c0103bce:	c3                   	ret    

c0103bcf <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103bcf:	55                   	push   %ebp
c0103bd0:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103bd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bd5:	a3 04 89 11 c0       	mov    %eax,0xc0118904
}
c0103bda:	5d                   	pop    %ebp
c0103bdb:	c3                   	ret    

c0103bdc <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103bdc:	55                   	push   %ebp
c0103bdd:	89 e5                	mov    %esp,%ebp
c0103bdf:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103be2:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103be7:	89 04 24             	mov    %eax,(%esp)
c0103bea:	e8 e0 ff ff ff       	call   c0103bcf <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103bef:	66 c7 05 08 89 11 c0 	movw   $0x10,0xc0118908
c0103bf6:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103bf8:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103bff:	68 00 
c0103c01:	b8 00 89 11 c0       	mov    $0xc0118900,%eax
c0103c06:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103c0c:	b8 00 89 11 c0       	mov    $0xc0118900,%eax
c0103c11:	c1 e8 10             	shr    $0x10,%eax
c0103c14:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103c19:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c20:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c23:	83 c8 09             	or     $0x9,%eax
c0103c26:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c2b:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c32:	83 e0 ef             	and    $0xffffffef,%eax
c0103c35:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c3a:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c41:	83 e0 9f             	and    $0xffffff9f,%eax
c0103c44:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c49:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c50:	83 c8 80             	or     $0xffffff80,%eax
c0103c53:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c58:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c5f:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c62:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c67:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c6e:	83 e0 ef             	and    $0xffffffef,%eax
c0103c71:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c76:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c7d:	83 e0 df             	and    $0xffffffdf,%eax
c0103c80:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c85:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c8c:	83 c8 40             	or     $0x40,%eax
c0103c8f:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c94:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c9b:	83 e0 7f             	and    $0x7f,%eax
c0103c9e:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103ca3:	b8 00 89 11 c0       	mov    $0xc0118900,%eax
c0103ca8:	c1 e8 18             	shr    $0x18,%eax
c0103cab:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103cb0:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103cb7:	e8 de fe ff ff       	call   c0103b9a <lgdt>
c0103cbc:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103cc2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103cc6:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103cc9:	c9                   	leave  
c0103cca:	c3                   	ret    

c0103ccb <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103ccb:	55                   	push   %ebp
c0103ccc:	89 e5                	mov    %esp,%ebp
c0103cce:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103cd1:	c7 05 7c 89 11 c0 a8 	movl   $0xc01068a8,0xc011897c
c0103cd8:	68 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103cdb:	a1 7c 89 11 c0       	mov    0xc011897c,%eax
c0103ce0:	8b 00                	mov    (%eax),%eax
c0103ce2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103ce6:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0103ced:	e8 4a c6 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103cf2:	a1 7c 89 11 c0       	mov    0xc011897c,%eax
c0103cf7:	8b 40 04             	mov    0x4(%eax),%eax
c0103cfa:	ff d0                	call   *%eax
}
c0103cfc:	c9                   	leave  
c0103cfd:	c3                   	ret    

c0103cfe <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103cfe:	55                   	push   %ebp
c0103cff:	89 e5                	mov    %esp,%ebp
c0103d01:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103d04:	a1 7c 89 11 c0       	mov    0xc011897c,%eax
c0103d09:	8b 40 08             	mov    0x8(%eax),%eax
c0103d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d0f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d13:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d16:	89 14 24             	mov    %edx,(%esp)
c0103d19:	ff d0                	call   *%eax
}
c0103d1b:	c9                   	leave  
c0103d1c:	c3                   	ret    

c0103d1d <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103d1d:	55                   	push   %ebp
c0103d1e:	89 e5                	mov    %esp,%ebp
c0103d20:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103d23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d2a:	e8 2e fe ff ff       	call   c0103b5d <__intr_save>
c0103d2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103d32:	a1 7c 89 11 c0       	mov    0xc011897c,%eax
c0103d37:	8b 40 0c             	mov    0xc(%eax),%eax
c0103d3a:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d3d:	89 14 24             	mov    %edx,(%esp)
c0103d40:	ff d0                	call   *%eax
c0103d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d48:	89 04 24             	mov    %eax,(%esp)
c0103d4b:	e8 37 fe ff ff       	call   c0103b87 <__intr_restore>
    return page;
c0103d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103d53:	c9                   	leave  
c0103d54:	c3                   	ret    

c0103d55 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103d55:	55                   	push   %ebp
c0103d56:	89 e5                	mov    %esp,%ebp
c0103d58:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d5b:	e8 fd fd ff ff       	call   c0103b5d <__intr_save>
c0103d60:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103d63:	a1 7c 89 11 c0       	mov    0xc011897c,%eax
c0103d68:	8b 40 10             	mov    0x10(%eax),%eax
c0103d6b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d6e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d72:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d75:	89 14 24             	mov    %edx,(%esp)
c0103d78:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d7d:	89 04 24             	mov    %eax,(%esp)
c0103d80:	e8 02 fe ff ff       	call   c0103b87 <__intr_restore>
}
c0103d85:	c9                   	leave  
c0103d86:	c3                   	ret    

c0103d87 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103d87:	55                   	push   %ebp
c0103d88:	89 e5                	mov    %esp,%ebp
c0103d8a:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d8d:	e8 cb fd ff ff       	call   c0103b5d <__intr_save>
c0103d92:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103d95:	a1 7c 89 11 c0       	mov    0xc011897c,%eax
c0103d9a:	8b 40 14             	mov    0x14(%eax),%eax
c0103d9d:	ff d0                	call   *%eax
c0103d9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103da5:	89 04 24             	mov    %eax,(%esp)
c0103da8:	e8 da fd ff ff       	call   c0103b87 <__intr_restore>
    return ret;
c0103dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103db0:	c9                   	leave  
c0103db1:	c3                   	ret    

c0103db2 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103db2:	55                   	push   %ebp
c0103db3:	89 e5                	mov    %esp,%ebp
c0103db5:	57                   	push   %edi
c0103db6:	56                   	push   %esi
c0103db7:	53                   	push   %ebx
c0103db8:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103dbe:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103dc5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103dcc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103dd3:	c7 04 24 5b 69 10 c0 	movl   $0xc010695b,(%esp)
c0103dda:	e8 5d c5 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103ddf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103de6:	e9 15 01 00 00       	jmp    c0103f00 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103deb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103dee:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103df1:	89 d0                	mov    %edx,%eax
c0103df3:	c1 e0 02             	shl    $0x2,%eax
c0103df6:	01 d0                	add    %edx,%eax
c0103df8:	c1 e0 02             	shl    $0x2,%eax
c0103dfb:	01 c8                	add    %ecx,%eax
c0103dfd:	8b 50 08             	mov    0x8(%eax),%edx
c0103e00:	8b 40 04             	mov    0x4(%eax),%eax
c0103e03:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103e06:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103e09:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e0f:	89 d0                	mov    %edx,%eax
c0103e11:	c1 e0 02             	shl    $0x2,%eax
c0103e14:	01 d0                	add    %edx,%eax
c0103e16:	c1 e0 02             	shl    $0x2,%eax
c0103e19:	01 c8                	add    %ecx,%eax
c0103e1b:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e1e:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e21:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e24:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e27:	01 c8                	add    %ecx,%eax
c0103e29:	11 da                	adc    %ebx,%edx
c0103e2b:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103e2e:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103e31:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e34:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e37:	89 d0                	mov    %edx,%eax
c0103e39:	c1 e0 02             	shl    $0x2,%eax
c0103e3c:	01 d0                	add    %edx,%eax
c0103e3e:	c1 e0 02             	shl    $0x2,%eax
c0103e41:	01 c8                	add    %ecx,%eax
c0103e43:	83 c0 14             	add    $0x14,%eax
c0103e46:	8b 00                	mov    (%eax),%eax
c0103e48:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103e4e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e51:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e54:	83 c0 ff             	add    $0xffffffff,%eax
c0103e57:	83 d2 ff             	adc    $0xffffffff,%edx
c0103e5a:	89 c6                	mov    %eax,%esi
c0103e5c:	89 d7                	mov    %edx,%edi
c0103e5e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e61:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e64:	89 d0                	mov    %edx,%eax
c0103e66:	c1 e0 02             	shl    $0x2,%eax
c0103e69:	01 d0                	add    %edx,%eax
c0103e6b:	c1 e0 02             	shl    $0x2,%eax
c0103e6e:	01 c8                	add    %ecx,%eax
c0103e70:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e73:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e76:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103e7c:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103e80:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103e84:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103e88:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e8b:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e8e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103e92:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103e96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103e9a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103e9e:	c7 04 24 68 69 10 c0 	movl   $0xc0106968,(%esp)
c0103ea5:	e8 92 c4 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103eaa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103ead:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103eb0:	89 d0                	mov    %edx,%eax
c0103eb2:	c1 e0 02             	shl    $0x2,%eax
c0103eb5:	01 d0                	add    %edx,%eax
c0103eb7:	c1 e0 02             	shl    $0x2,%eax
c0103eba:	01 c8                	add    %ecx,%eax
c0103ebc:	83 c0 14             	add    $0x14,%eax
c0103ebf:	8b 00                	mov    (%eax),%eax
c0103ec1:	83 f8 01             	cmp    $0x1,%eax
c0103ec4:	75 36                	jne    c0103efc <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103ec6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ec9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103ecc:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103ecf:	77 2b                	ja     c0103efc <page_init+0x14a>
c0103ed1:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103ed4:	72 05                	jb     c0103edb <page_init+0x129>
c0103ed6:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103ed9:	73 21                	jae    c0103efc <page_init+0x14a>
c0103edb:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103edf:	77 1b                	ja     c0103efc <page_init+0x14a>
c0103ee1:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103ee5:	72 09                	jb     c0103ef0 <page_init+0x13e>
c0103ee7:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103eee:	77 0c                	ja     c0103efc <page_init+0x14a>
                maxpa = end;
c0103ef0:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103ef3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103ef6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103ef9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103efc:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103f00:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103f03:	8b 00                	mov    (%eax),%eax
c0103f05:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103f08:	0f 8f dd fe ff ff    	jg     c0103deb <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103f0e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f12:	72 1d                	jb     c0103f31 <page_init+0x17f>
c0103f14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f18:	77 09                	ja     c0103f23 <page_init+0x171>
c0103f1a:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103f21:	76 0e                	jbe    c0103f31 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103f23:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103f2a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103f31:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103f37:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103f3b:	c1 ea 0c             	shr    $0xc,%edx
c0103f3e:	a3 e0 88 11 c0       	mov    %eax,0xc01188e0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103f43:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103f4a:	b8 88 89 11 c0       	mov    $0xc0118988,%eax
c0103f4f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103f52:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103f55:	01 d0                	add    %edx,%eax
c0103f57:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103f5a:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103f5d:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f62:	f7 75 ac             	divl   -0x54(%ebp)
c0103f65:	89 d0                	mov    %edx,%eax
c0103f67:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103f6a:	29 c2                	sub    %eax,%edx
c0103f6c:	89 d0                	mov    %edx,%eax
c0103f6e:	a3 84 89 11 c0       	mov    %eax,0xc0118984

    for (i = 0; i < npage; i ++) {
c0103f73:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103f7a:	eb 2f                	jmp    c0103fab <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103f7c:	8b 0d 84 89 11 c0    	mov    0xc0118984,%ecx
c0103f82:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f85:	89 d0                	mov    %edx,%eax
c0103f87:	c1 e0 02             	shl    $0x2,%eax
c0103f8a:	01 d0                	add    %edx,%eax
c0103f8c:	c1 e0 02             	shl    $0x2,%eax
c0103f8f:	01 c8                	add    %ecx,%eax
c0103f91:	83 c0 04             	add    $0x4,%eax
c0103f94:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103f9b:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103f9e:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103fa1:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103fa4:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0103fa7:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103fab:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fae:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0103fb3:	39 c2                	cmp    %eax,%edx
c0103fb5:	72 c5                	jb     c0103f7c <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103fb7:	8b 15 e0 88 11 c0    	mov    0xc01188e0,%edx
c0103fbd:	89 d0                	mov    %edx,%eax
c0103fbf:	c1 e0 02             	shl    $0x2,%eax
c0103fc2:	01 d0                	add    %edx,%eax
c0103fc4:	c1 e0 02             	shl    $0x2,%eax
c0103fc7:	89 c2                	mov    %eax,%edx
c0103fc9:	a1 84 89 11 c0       	mov    0xc0118984,%eax
c0103fce:	01 d0                	add    %edx,%eax
c0103fd0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103fd3:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103fda:	77 23                	ja     c0103fff <page_init+0x24d>
c0103fdc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103fdf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103fe3:	c7 44 24 08 98 69 10 	movl   $0xc0106998,0x8(%esp)
c0103fea:	c0 
c0103feb:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103ff2:	00 
c0103ff3:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0103ffa:	e8 ca cc ff ff       	call   c0100cc9 <__panic>
c0103fff:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104002:	05 00 00 00 40       	add    $0x40000000,%eax
c0104007:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c010400a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104011:	e9 74 01 00 00       	jmp    c010418a <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104016:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104019:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010401c:	89 d0                	mov    %edx,%eax
c010401e:	c1 e0 02             	shl    $0x2,%eax
c0104021:	01 d0                	add    %edx,%eax
c0104023:	c1 e0 02             	shl    $0x2,%eax
c0104026:	01 c8                	add    %ecx,%eax
c0104028:	8b 50 08             	mov    0x8(%eax),%edx
c010402b:	8b 40 04             	mov    0x4(%eax),%eax
c010402e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104031:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104034:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104037:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010403a:	89 d0                	mov    %edx,%eax
c010403c:	c1 e0 02             	shl    $0x2,%eax
c010403f:	01 d0                	add    %edx,%eax
c0104041:	c1 e0 02             	shl    $0x2,%eax
c0104044:	01 c8                	add    %ecx,%eax
c0104046:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104049:	8b 58 10             	mov    0x10(%eax),%ebx
c010404c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010404f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104052:	01 c8                	add    %ecx,%eax
c0104054:	11 da                	adc    %ebx,%edx
c0104056:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104059:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010405c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010405f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104062:	89 d0                	mov    %edx,%eax
c0104064:	c1 e0 02             	shl    $0x2,%eax
c0104067:	01 d0                	add    %edx,%eax
c0104069:	c1 e0 02             	shl    $0x2,%eax
c010406c:	01 c8                	add    %ecx,%eax
c010406e:	83 c0 14             	add    $0x14,%eax
c0104071:	8b 00                	mov    (%eax),%eax
c0104073:	83 f8 01             	cmp    $0x1,%eax
c0104076:	0f 85 0a 01 00 00    	jne    c0104186 <page_init+0x3d4>
            if (begin < freemem) {
c010407c:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010407f:	ba 00 00 00 00       	mov    $0x0,%edx
c0104084:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104087:	72 17                	jb     c01040a0 <page_init+0x2ee>
c0104089:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010408c:	77 05                	ja     c0104093 <page_init+0x2e1>
c010408e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104091:	76 0d                	jbe    c01040a0 <page_init+0x2ee>
                begin = freemem;
c0104093:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104096:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104099:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01040a0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01040a4:	72 1d                	jb     c01040c3 <page_init+0x311>
c01040a6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01040aa:	77 09                	ja     c01040b5 <page_init+0x303>
c01040ac:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01040b3:	76 0e                	jbe    c01040c3 <page_init+0x311>
                end = KMEMSIZE;
c01040b5:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01040bc:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01040c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040c9:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040cc:	0f 87 b4 00 00 00    	ja     c0104186 <page_init+0x3d4>
c01040d2:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040d5:	72 09                	jb     c01040e0 <page_init+0x32e>
c01040d7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01040da:	0f 83 a6 00 00 00    	jae    c0104186 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c01040e0:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01040e7:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01040ea:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01040ed:	01 d0                	add    %edx,%eax
c01040ef:	83 e8 01             	sub    $0x1,%eax
c01040f2:	89 45 98             	mov    %eax,-0x68(%ebp)
c01040f5:	8b 45 98             	mov    -0x68(%ebp),%eax
c01040f8:	ba 00 00 00 00       	mov    $0x0,%edx
c01040fd:	f7 75 9c             	divl   -0x64(%ebp)
c0104100:	89 d0                	mov    %edx,%eax
c0104102:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104105:	29 c2                	sub    %eax,%edx
c0104107:	89 d0                	mov    %edx,%eax
c0104109:	ba 00 00 00 00       	mov    $0x0,%edx
c010410e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104111:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104114:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104117:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010411a:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010411d:	ba 00 00 00 00       	mov    $0x0,%edx
c0104122:	89 c7                	mov    %eax,%edi
c0104124:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010412a:	89 7d 80             	mov    %edi,-0x80(%ebp)
c010412d:	89 d0                	mov    %edx,%eax
c010412f:	83 e0 00             	and    $0x0,%eax
c0104132:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104135:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104138:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010413b:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010413e:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104141:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104144:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104147:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010414a:	77 3a                	ja     c0104186 <page_init+0x3d4>
c010414c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010414f:	72 05                	jb     c0104156 <page_init+0x3a4>
c0104151:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104154:	73 30                	jae    c0104186 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104156:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104159:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c010415c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010415f:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104162:	29 c8                	sub    %ecx,%eax
c0104164:	19 da                	sbb    %ebx,%edx
c0104166:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010416a:	c1 ea 0c             	shr    $0xc,%edx
c010416d:	89 c3                	mov    %eax,%ebx
c010416f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104172:	89 04 24             	mov    %eax,(%esp)
c0104175:	e8 ca f8 ff ff       	call   c0103a44 <pa2page>
c010417a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010417e:	89 04 24             	mov    %eax,(%esp)
c0104181:	e8 78 fb ff ff       	call   c0103cfe <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104186:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010418a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010418d:	8b 00                	mov    (%eax),%eax
c010418f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104192:	0f 8f 7e fe ff ff    	jg     c0104016 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104198:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c010419e:	5b                   	pop    %ebx
c010419f:	5e                   	pop    %esi
c01041a0:	5f                   	pop    %edi
c01041a1:	5d                   	pop    %ebp
c01041a2:	c3                   	ret    

c01041a3 <enable_paging>:

static void
enable_paging(void) {
c01041a3:	55                   	push   %ebp
c01041a4:	89 e5                	mov    %esp,%ebp
c01041a6:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01041a9:	a1 80 89 11 c0       	mov    0xc0118980,%eax
c01041ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01041b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01041b4:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c01041b7:	0f 20 c0             	mov    %cr0,%eax
c01041ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01041bd:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c01041c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c01041c3:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c01041ca:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c01041ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01041d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c01041d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041d7:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c01041da:	c9                   	leave  
c01041db:	c3                   	ret    

c01041dc <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01041dc:	55                   	push   %ebp
c01041dd:	89 e5                	mov    %esp,%ebp
c01041df:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01041e2:	8b 45 14             	mov    0x14(%ebp),%eax
c01041e5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01041e8:	31 d0                	xor    %edx,%eax
c01041ea:	25 ff 0f 00 00       	and    $0xfff,%eax
c01041ef:	85 c0                	test   %eax,%eax
c01041f1:	74 24                	je     c0104217 <boot_map_segment+0x3b>
c01041f3:	c7 44 24 0c ca 69 10 	movl   $0xc01069ca,0xc(%esp)
c01041fa:	c0 
c01041fb:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104202:	c0 
c0104203:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c010420a:	00 
c010420b:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104212:	e8 b2 ca ff ff       	call   c0100cc9 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104217:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010421e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104221:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104226:	89 c2                	mov    %eax,%edx
c0104228:	8b 45 10             	mov    0x10(%ebp),%eax
c010422b:	01 c2                	add    %eax,%edx
c010422d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104230:	01 d0                	add    %edx,%eax
c0104232:	83 e8 01             	sub    $0x1,%eax
c0104235:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104238:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010423b:	ba 00 00 00 00       	mov    $0x0,%edx
c0104240:	f7 75 f0             	divl   -0x10(%ebp)
c0104243:	89 d0                	mov    %edx,%eax
c0104245:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104248:	29 c2                	sub    %eax,%edx
c010424a:	89 d0                	mov    %edx,%eax
c010424c:	c1 e8 0c             	shr    $0xc,%eax
c010424f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104252:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104255:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104258:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010425b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104260:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104263:	8b 45 14             	mov    0x14(%ebp),%eax
c0104266:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104269:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010426c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104271:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104274:	eb 6b                	jmp    c01042e1 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104276:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010427d:	00 
c010427e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104281:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104285:	8b 45 08             	mov    0x8(%ebp),%eax
c0104288:	89 04 24             	mov    %eax,(%esp)
c010428b:	e8 cc 01 00 00       	call   c010445c <get_pte>
c0104290:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104293:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104297:	75 24                	jne    c01042bd <boot_map_segment+0xe1>
c0104299:	c7 44 24 0c f6 69 10 	movl   $0xc01069f6,0xc(%esp)
c01042a0:	c0 
c01042a1:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c01042a8:	c0 
c01042a9:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c01042b0:	00 
c01042b1:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c01042b8:	e8 0c ca ff ff       	call   c0100cc9 <__panic>
        *ptep = pa | PTE_P | perm;
c01042bd:	8b 45 18             	mov    0x18(%ebp),%eax
c01042c0:	8b 55 14             	mov    0x14(%ebp),%edx
c01042c3:	09 d0                	or     %edx,%eax
c01042c5:	83 c8 01             	or     $0x1,%eax
c01042c8:	89 c2                	mov    %eax,%edx
c01042ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042cd:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01042cf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01042d3:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01042da:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01042e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042e5:	75 8f                	jne    c0104276 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01042e7:	c9                   	leave  
c01042e8:	c3                   	ret    

c01042e9 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01042e9:	55                   	push   %ebp
c01042ea:	89 e5                	mov    %esp,%ebp
c01042ec:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01042ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01042f6:	e8 22 fa ff ff       	call   c0103d1d <alloc_pages>
c01042fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01042fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104302:	75 1c                	jne    c0104320 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104304:	c7 44 24 08 03 6a 10 	movl   $0xc0106a03,0x8(%esp)
c010430b:	c0 
c010430c:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0104313:	00 
c0104314:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c010431b:	e8 a9 c9 ff ff       	call   c0100cc9 <__panic>
    }
    return page2kva(p);
c0104320:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104323:	89 04 24             	mov    %eax,(%esp)
c0104326:	e8 68 f7 ff ff       	call   c0103a93 <page2kva>
}
c010432b:	c9                   	leave  
c010432c:	c3                   	ret    

c010432d <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010432d:	55                   	push   %ebp
c010432e:	89 e5                	mov    %esp,%ebp
c0104330:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104333:	e8 93 f9 ff ff       	call   c0103ccb <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104338:	e8 75 fa ff ff       	call   c0103db2 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010433d:	e8 d7 02 00 00       	call   c0104619 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104342:	e8 a2 ff ff ff       	call   c01042e9 <boot_alloc_page>
c0104347:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
    memset(boot_pgdir, 0, PGSIZE);
c010434c:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104351:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104358:	00 
c0104359:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104360:	00 
c0104361:	89 04 24             	mov    %eax,(%esp)
c0104364:	e8 19 19 00 00       	call   c0105c82 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0104369:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c010436e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104371:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104378:	77 23                	ja     c010439d <pmm_init+0x70>
c010437a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010437d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104381:	c7 44 24 08 98 69 10 	movl   $0xc0106998,0x8(%esp)
c0104388:	c0 
c0104389:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0104390:	00 
c0104391:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104398:	e8 2c c9 ff ff       	call   c0100cc9 <__panic>
c010439d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043a0:	05 00 00 00 40       	add    $0x40000000,%eax
c01043a5:	a3 80 89 11 c0       	mov    %eax,0xc0118980

    check_pgdir();
c01043aa:	e8 88 02 00 00       	call   c0104637 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01043af:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01043b4:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01043ba:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01043bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01043c2:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01043c9:	77 23                	ja     c01043ee <pmm_init+0xc1>
c01043cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043ce:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043d2:	c7 44 24 08 98 69 10 	movl   $0xc0106998,0x8(%esp)
c01043d9:	c0 
c01043da:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c01043e1:	00 
c01043e2:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c01043e9:	e8 db c8 ff ff       	call   c0100cc9 <__panic>
c01043ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043f1:	05 00 00 00 40       	add    $0x40000000,%eax
c01043f6:	83 c8 03             	or     $0x3,%eax
c01043f9:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01043fb:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104400:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104407:	00 
c0104408:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010440f:	00 
c0104410:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104417:	38 
c0104418:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c010441f:	c0 
c0104420:	89 04 24             	mov    %eax,(%esp)
c0104423:	e8 b4 fd ff ff       	call   c01041dc <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0104428:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c010442d:	8b 15 e4 88 11 c0    	mov    0xc01188e4,%edx
c0104433:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0104439:	89 10                	mov    %edx,(%eax)

    enable_paging();
c010443b:	e8 63 fd ff ff       	call   c01041a3 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104440:	e8 97 f7 ff ff       	call   c0103bdc <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104445:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c010444a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104450:	e8 7d 08 00 00       	call   c0104cd2 <check_boot_pgdir>

    print_pgdir();
c0104455:	e8 0a 0d 00 00       	call   c0105164 <print_pgdir>

}
c010445a:	c9                   	leave  
c010445b:	c3                   	ret    

c010445c <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010445c:	55                   	push   %ebp
c010445d:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c010445f:	5d                   	pop    %ebp
c0104460:	c3                   	ret    

c0104461 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104461:	55                   	push   %ebp
c0104462:	89 e5                	mov    %esp,%ebp
c0104464:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104467:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010446e:	00 
c010446f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104472:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104476:	8b 45 08             	mov    0x8(%ebp),%eax
c0104479:	89 04 24             	mov    %eax,(%esp)
c010447c:	e8 db ff ff ff       	call   c010445c <get_pte>
c0104481:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104484:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104488:	74 08                	je     c0104492 <get_page+0x31>
        *ptep_store = ptep;
c010448a:	8b 45 10             	mov    0x10(%ebp),%eax
c010448d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104490:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104492:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104496:	74 1b                	je     c01044b3 <get_page+0x52>
c0104498:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010449b:	8b 00                	mov    (%eax),%eax
c010449d:	83 e0 01             	and    $0x1,%eax
c01044a0:	85 c0                	test   %eax,%eax
c01044a2:	74 0f                	je     c01044b3 <get_page+0x52>
        return pa2page(*ptep);
c01044a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044a7:	8b 00                	mov    (%eax),%eax
c01044a9:	89 04 24             	mov    %eax,(%esp)
c01044ac:	e8 93 f5 ff ff       	call   c0103a44 <pa2page>
c01044b1:	eb 05                	jmp    c01044b8 <get_page+0x57>
    }
    return NULL;
c01044b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01044b8:	c9                   	leave  
c01044b9:	c3                   	ret    

c01044ba <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01044ba:	55                   	push   %ebp
c01044bb:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c01044bd:	5d                   	pop    %ebp
c01044be:	c3                   	ret    

c01044bf <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01044bf:	55                   	push   %ebp
c01044c0:	89 e5                	mov    %esp,%ebp
c01044c2:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01044c5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01044cc:	00 
c01044cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01044d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01044d7:	89 04 24             	mov    %eax,(%esp)
c01044da:	e8 7d ff ff ff       	call   c010445c <get_pte>
c01044df:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c01044e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01044e6:	74 19                	je     c0104501 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01044e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01044eb:	89 44 24 08          	mov    %eax,0x8(%esp)
c01044ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01044f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01044f9:	89 04 24             	mov    %eax,(%esp)
c01044fc:	e8 b9 ff ff ff       	call   c01044ba <page_remove_pte>
    }
}
c0104501:	c9                   	leave  
c0104502:	c3                   	ret    

c0104503 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104503:	55                   	push   %ebp
c0104504:	89 e5                	mov    %esp,%ebp
c0104506:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104509:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104510:	00 
c0104511:	8b 45 10             	mov    0x10(%ebp),%eax
c0104514:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104518:	8b 45 08             	mov    0x8(%ebp),%eax
c010451b:	89 04 24             	mov    %eax,(%esp)
c010451e:	e8 39 ff ff ff       	call   c010445c <get_pte>
c0104523:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104526:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010452a:	75 0a                	jne    c0104536 <page_insert+0x33>
        return -E_NO_MEM;
c010452c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104531:	e9 84 00 00 00       	jmp    c01045ba <page_insert+0xb7>
    }
    page_ref_inc(page);
c0104536:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104539:	89 04 24             	mov    %eax,(%esp)
c010453c:	e8 ee f5 ff ff       	call   c0103b2f <page_ref_inc>
    if (*ptep & PTE_P) {
c0104541:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104544:	8b 00                	mov    (%eax),%eax
c0104546:	83 e0 01             	and    $0x1,%eax
c0104549:	85 c0                	test   %eax,%eax
c010454b:	74 3e                	je     c010458b <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010454d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104550:	8b 00                	mov    (%eax),%eax
c0104552:	89 04 24             	mov    %eax,(%esp)
c0104555:	e8 8d f5 ff ff       	call   c0103ae7 <pte2page>
c010455a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010455d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104560:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104563:	75 0d                	jne    c0104572 <page_insert+0x6f>
            page_ref_dec(page);
c0104565:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104568:	89 04 24             	mov    %eax,(%esp)
c010456b:	e8 d6 f5 ff ff       	call   c0103b46 <page_ref_dec>
c0104570:	eb 19                	jmp    c010458b <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104572:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104575:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104579:	8b 45 10             	mov    0x10(%ebp),%eax
c010457c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104580:	8b 45 08             	mov    0x8(%ebp),%eax
c0104583:	89 04 24             	mov    %eax,(%esp)
c0104586:	e8 2f ff ff ff       	call   c01044ba <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010458b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010458e:	89 04 24             	mov    %eax,(%esp)
c0104591:	e8 98 f4 ff ff       	call   c0103a2e <page2pa>
c0104596:	0b 45 14             	or     0x14(%ebp),%eax
c0104599:	83 c8 01             	or     $0x1,%eax
c010459c:	89 c2                	mov    %eax,%edx
c010459e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045a1:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01045a3:	8b 45 10             	mov    0x10(%ebp),%eax
c01045a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01045ad:	89 04 24             	mov    %eax,(%esp)
c01045b0:	e8 07 00 00 00       	call   c01045bc <tlb_invalidate>
    return 0;
c01045b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01045ba:	c9                   	leave  
c01045bb:	c3                   	ret    

c01045bc <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01045bc:	55                   	push   %ebp
c01045bd:	89 e5                	mov    %esp,%ebp
c01045bf:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01045c2:	0f 20 d8             	mov    %cr3,%eax
c01045c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01045c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01045cb:	89 c2                	mov    %eax,%edx
c01045cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01045d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01045d3:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01045da:	77 23                	ja     c01045ff <tlb_invalidate+0x43>
c01045dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045df:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01045e3:	c7 44 24 08 98 69 10 	movl   $0xc0106998,0x8(%esp)
c01045ea:	c0 
c01045eb:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
c01045f2:	00 
c01045f3:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c01045fa:	e8 ca c6 ff ff       	call   c0100cc9 <__panic>
c01045ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104602:	05 00 00 00 40       	add    $0x40000000,%eax
c0104607:	39 c2                	cmp    %eax,%edx
c0104609:	75 0c                	jne    c0104617 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c010460b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010460e:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104611:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104614:	0f 01 38             	invlpg (%eax)
    }
}
c0104617:	c9                   	leave  
c0104618:	c3                   	ret    

c0104619 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104619:	55                   	push   %ebp
c010461a:	89 e5                	mov    %esp,%ebp
c010461c:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c010461f:	a1 7c 89 11 c0       	mov    0xc011897c,%eax
c0104624:	8b 40 18             	mov    0x18(%eax),%eax
c0104627:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104629:	c7 04 24 1c 6a 10 c0 	movl   $0xc0106a1c,(%esp)
c0104630:	e8 07 bd ff ff       	call   c010033c <cprintf>
}
c0104635:	c9                   	leave  
c0104636:	c3                   	ret    

c0104637 <check_pgdir>:

static void
check_pgdir(void) {
c0104637:	55                   	push   %ebp
c0104638:	89 e5                	mov    %esp,%ebp
c010463a:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010463d:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0104642:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104647:	76 24                	jbe    c010466d <check_pgdir+0x36>
c0104649:	c7 44 24 0c 3b 6a 10 	movl   $0xc0106a3b,0xc(%esp)
c0104650:	c0 
c0104651:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104658:	c0 
c0104659:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c0104660:	00 
c0104661:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104668:	e8 5c c6 ff ff       	call   c0100cc9 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010466d:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104672:	85 c0                	test   %eax,%eax
c0104674:	74 0e                	je     c0104684 <check_pgdir+0x4d>
c0104676:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c010467b:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104680:	85 c0                	test   %eax,%eax
c0104682:	74 24                	je     c01046a8 <check_pgdir+0x71>
c0104684:	c7 44 24 0c 58 6a 10 	movl   $0xc0106a58,0xc(%esp)
c010468b:	c0 
c010468c:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104693:	c0 
c0104694:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c010469b:	00 
c010469c:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c01046a3:	e8 21 c6 ff ff       	call   c0100cc9 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01046a8:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01046ad:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01046b4:	00 
c01046b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01046bc:	00 
c01046bd:	89 04 24             	mov    %eax,(%esp)
c01046c0:	e8 9c fd ff ff       	call   c0104461 <get_page>
c01046c5:	85 c0                	test   %eax,%eax
c01046c7:	74 24                	je     c01046ed <check_pgdir+0xb6>
c01046c9:	c7 44 24 0c 90 6a 10 	movl   $0xc0106a90,0xc(%esp)
c01046d0:	c0 
c01046d1:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c01046d8:	c0 
c01046d9:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
c01046e0:	00 
c01046e1:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c01046e8:	e8 dc c5 ff ff       	call   c0100cc9 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01046ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01046f4:	e8 24 f6 ff ff       	call   c0103d1d <alloc_pages>
c01046f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01046fc:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104701:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104708:	00 
c0104709:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104710:	00 
c0104711:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104714:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104718:	89 04 24             	mov    %eax,(%esp)
c010471b:	e8 e3 fd ff ff       	call   c0104503 <page_insert>
c0104720:	85 c0                	test   %eax,%eax
c0104722:	74 24                	je     c0104748 <check_pgdir+0x111>
c0104724:	c7 44 24 0c b8 6a 10 	movl   $0xc0106ab8,0xc(%esp)
c010472b:	c0 
c010472c:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104733:	c0 
c0104734:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c010473b:	00 
c010473c:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104743:	e8 81 c5 ff ff       	call   c0100cc9 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104748:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c010474d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104754:	00 
c0104755:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010475c:	00 
c010475d:	89 04 24             	mov    %eax,(%esp)
c0104760:	e8 f7 fc ff ff       	call   c010445c <get_pte>
c0104765:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104768:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010476c:	75 24                	jne    c0104792 <check_pgdir+0x15b>
c010476e:	c7 44 24 0c e4 6a 10 	movl   $0xc0106ae4,0xc(%esp)
c0104775:	c0 
c0104776:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c010477d:	c0 
c010477e:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c0104785:	00 
c0104786:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c010478d:	e8 37 c5 ff ff       	call   c0100cc9 <__panic>
    assert(pa2page(*ptep) == p1);
c0104792:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104795:	8b 00                	mov    (%eax),%eax
c0104797:	89 04 24             	mov    %eax,(%esp)
c010479a:	e8 a5 f2 ff ff       	call   c0103a44 <pa2page>
c010479f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01047a2:	74 24                	je     c01047c8 <check_pgdir+0x191>
c01047a4:	c7 44 24 0c 11 6b 10 	movl   $0xc0106b11,0xc(%esp)
c01047ab:	c0 
c01047ac:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c01047b3:	c0 
c01047b4:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c01047bb:	00 
c01047bc:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c01047c3:	e8 01 c5 ff ff       	call   c0100cc9 <__panic>
    assert(page_ref(p1) == 1);
c01047c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047cb:	89 04 24             	mov    %eax,(%esp)
c01047ce:	e8 52 f3 ff ff       	call   c0103b25 <page_ref>
c01047d3:	83 f8 01             	cmp    $0x1,%eax
c01047d6:	74 24                	je     c01047fc <check_pgdir+0x1c5>
c01047d8:	c7 44 24 0c 26 6b 10 	movl   $0xc0106b26,0xc(%esp)
c01047df:	c0 
c01047e0:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c01047e7:	c0 
c01047e8:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c01047ef:	00 
c01047f0:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c01047f7:	e8 cd c4 ff ff       	call   c0100cc9 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01047fc:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104801:	8b 00                	mov    (%eax),%eax
c0104803:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104808:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010480b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010480e:	c1 e8 0c             	shr    $0xc,%eax
c0104811:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104814:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0104819:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010481c:	72 23                	jb     c0104841 <check_pgdir+0x20a>
c010481e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104821:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104825:	c7 44 24 08 f4 68 10 	movl   $0xc01068f4,0x8(%esp)
c010482c:	c0 
c010482d:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c0104834:	00 
c0104835:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c010483c:	e8 88 c4 ff ff       	call   c0100cc9 <__panic>
c0104841:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104844:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104849:	83 c0 04             	add    $0x4,%eax
c010484c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c010484f:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104854:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010485b:	00 
c010485c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104863:	00 
c0104864:	89 04 24             	mov    %eax,(%esp)
c0104867:	e8 f0 fb ff ff       	call   c010445c <get_pte>
c010486c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010486f:	74 24                	je     c0104895 <check_pgdir+0x25e>
c0104871:	c7 44 24 0c 38 6b 10 	movl   $0xc0106b38,0xc(%esp)
c0104878:	c0 
c0104879:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104880:	c0 
c0104881:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c0104888:	00 
c0104889:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104890:	e8 34 c4 ff ff       	call   c0100cc9 <__panic>

    p2 = alloc_page();
c0104895:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010489c:	e8 7c f4 ff ff       	call   c0103d1d <alloc_pages>
c01048a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01048a4:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01048a9:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c01048b0:	00 
c01048b1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01048b8:	00 
c01048b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01048bc:	89 54 24 04          	mov    %edx,0x4(%esp)
c01048c0:	89 04 24             	mov    %eax,(%esp)
c01048c3:	e8 3b fc ff ff       	call   c0104503 <page_insert>
c01048c8:	85 c0                	test   %eax,%eax
c01048ca:	74 24                	je     c01048f0 <check_pgdir+0x2b9>
c01048cc:	c7 44 24 0c 60 6b 10 	movl   $0xc0106b60,0xc(%esp)
c01048d3:	c0 
c01048d4:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c01048db:	c0 
c01048dc:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c01048e3:	00 
c01048e4:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c01048eb:	e8 d9 c3 ff ff       	call   c0100cc9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01048f0:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01048f5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048fc:	00 
c01048fd:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104904:	00 
c0104905:	89 04 24             	mov    %eax,(%esp)
c0104908:	e8 4f fb ff ff       	call   c010445c <get_pte>
c010490d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104910:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104914:	75 24                	jne    c010493a <check_pgdir+0x303>
c0104916:	c7 44 24 0c 98 6b 10 	movl   $0xc0106b98,0xc(%esp)
c010491d:	c0 
c010491e:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104925:	c0 
c0104926:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c010492d:	00 
c010492e:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104935:	e8 8f c3 ff ff       	call   c0100cc9 <__panic>
    assert(*ptep & PTE_U);
c010493a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010493d:	8b 00                	mov    (%eax),%eax
c010493f:	83 e0 04             	and    $0x4,%eax
c0104942:	85 c0                	test   %eax,%eax
c0104944:	75 24                	jne    c010496a <check_pgdir+0x333>
c0104946:	c7 44 24 0c c8 6b 10 	movl   $0xc0106bc8,0xc(%esp)
c010494d:	c0 
c010494e:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104955:	c0 
c0104956:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c010495d:	00 
c010495e:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104965:	e8 5f c3 ff ff       	call   c0100cc9 <__panic>
    assert(*ptep & PTE_W);
c010496a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010496d:	8b 00                	mov    (%eax),%eax
c010496f:	83 e0 02             	and    $0x2,%eax
c0104972:	85 c0                	test   %eax,%eax
c0104974:	75 24                	jne    c010499a <check_pgdir+0x363>
c0104976:	c7 44 24 0c d6 6b 10 	movl   $0xc0106bd6,0xc(%esp)
c010497d:	c0 
c010497e:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104985:	c0 
c0104986:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c010498d:	00 
c010498e:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104995:	e8 2f c3 ff ff       	call   c0100cc9 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c010499a:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c010499f:	8b 00                	mov    (%eax),%eax
c01049a1:	83 e0 04             	and    $0x4,%eax
c01049a4:	85 c0                	test   %eax,%eax
c01049a6:	75 24                	jne    c01049cc <check_pgdir+0x395>
c01049a8:	c7 44 24 0c e4 6b 10 	movl   $0xc0106be4,0xc(%esp)
c01049af:	c0 
c01049b0:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c01049b7:	c0 
c01049b8:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c01049bf:	00 
c01049c0:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c01049c7:	e8 fd c2 ff ff       	call   c0100cc9 <__panic>
    assert(page_ref(p2) == 1);
c01049cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01049cf:	89 04 24             	mov    %eax,(%esp)
c01049d2:	e8 4e f1 ff ff       	call   c0103b25 <page_ref>
c01049d7:	83 f8 01             	cmp    $0x1,%eax
c01049da:	74 24                	je     c0104a00 <check_pgdir+0x3c9>
c01049dc:	c7 44 24 0c fa 6b 10 	movl   $0xc0106bfa,0xc(%esp)
c01049e3:	c0 
c01049e4:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c01049eb:	c0 
c01049ec:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c01049f3:	00 
c01049f4:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c01049fb:	e8 c9 c2 ff ff       	call   c0100cc9 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104a00:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104a05:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104a0c:	00 
c0104a0d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104a14:	00 
c0104a15:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104a18:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a1c:	89 04 24             	mov    %eax,(%esp)
c0104a1f:	e8 df fa ff ff       	call   c0104503 <page_insert>
c0104a24:	85 c0                	test   %eax,%eax
c0104a26:	74 24                	je     c0104a4c <check_pgdir+0x415>
c0104a28:	c7 44 24 0c 0c 6c 10 	movl   $0xc0106c0c,0xc(%esp)
c0104a2f:	c0 
c0104a30:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104a37:	c0 
c0104a38:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0104a3f:	00 
c0104a40:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104a47:	e8 7d c2 ff ff       	call   c0100cc9 <__panic>
    assert(page_ref(p1) == 2);
c0104a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a4f:	89 04 24             	mov    %eax,(%esp)
c0104a52:	e8 ce f0 ff ff       	call   c0103b25 <page_ref>
c0104a57:	83 f8 02             	cmp    $0x2,%eax
c0104a5a:	74 24                	je     c0104a80 <check_pgdir+0x449>
c0104a5c:	c7 44 24 0c 38 6c 10 	movl   $0xc0106c38,0xc(%esp)
c0104a63:	c0 
c0104a64:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104a6b:	c0 
c0104a6c:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0104a73:	00 
c0104a74:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104a7b:	e8 49 c2 ff ff       	call   c0100cc9 <__panic>
    assert(page_ref(p2) == 0);
c0104a80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a83:	89 04 24             	mov    %eax,(%esp)
c0104a86:	e8 9a f0 ff ff       	call   c0103b25 <page_ref>
c0104a8b:	85 c0                	test   %eax,%eax
c0104a8d:	74 24                	je     c0104ab3 <check_pgdir+0x47c>
c0104a8f:	c7 44 24 0c 4a 6c 10 	movl   $0xc0106c4a,0xc(%esp)
c0104a96:	c0 
c0104a97:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104a9e:	c0 
c0104a9f:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0104aa6:	00 
c0104aa7:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104aae:	e8 16 c2 ff ff       	call   c0100cc9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104ab3:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104ab8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104abf:	00 
c0104ac0:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104ac7:	00 
c0104ac8:	89 04 24             	mov    %eax,(%esp)
c0104acb:	e8 8c f9 ff ff       	call   c010445c <get_pte>
c0104ad0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ad3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104ad7:	75 24                	jne    c0104afd <check_pgdir+0x4c6>
c0104ad9:	c7 44 24 0c 98 6b 10 	movl   $0xc0106b98,0xc(%esp)
c0104ae0:	c0 
c0104ae1:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104ae8:	c0 
c0104ae9:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0104af0:	00 
c0104af1:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104af8:	e8 cc c1 ff ff       	call   c0100cc9 <__panic>
    assert(pa2page(*ptep) == p1);
c0104afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b00:	8b 00                	mov    (%eax),%eax
c0104b02:	89 04 24             	mov    %eax,(%esp)
c0104b05:	e8 3a ef ff ff       	call   c0103a44 <pa2page>
c0104b0a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104b0d:	74 24                	je     c0104b33 <check_pgdir+0x4fc>
c0104b0f:	c7 44 24 0c 11 6b 10 	movl   $0xc0106b11,0xc(%esp)
c0104b16:	c0 
c0104b17:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104b1e:	c0 
c0104b1f:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0104b26:	00 
c0104b27:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104b2e:	e8 96 c1 ff ff       	call   c0100cc9 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b36:	8b 00                	mov    (%eax),%eax
c0104b38:	83 e0 04             	and    $0x4,%eax
c0104b3b:	85 c0                	test   %eax,%eax
c0104b3d:	74 24                	je     c0104b63 <check_pgdir+0x52c>
c0104b3f:	c7 44 24 0c 5c 6c 10 	movl   $0xc0106c5c,0xc(%esp)
c0104b46:	c0 
c0104b47:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104b4e:	c0 
c0104b4f:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0104b56:	00 
c0104b57:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104b5e:	e8 66 c1 ff ff       	call   c0100cc9 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104b63:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104b68:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104b6f:	00 
c0104b70:	89 04 24             	mov    %eax,(%esp)
c0104b73:	e8 47 f9 ff ff       	call   c01044bf <page_remove>
    assert(page_ref(p1) == 1);
c0104b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b7b:	89 04 24             	mov    %eax,(%esp)
c0104b7e:	e8 a2 ef ff ff       	call   c0103b25 <page_ref>
c0104b83:	83 f8 01             	cmp    $0x1,%eax
c0104b86:	74 24                	je     c0104bac <check_pgdir+0x575>
c0104b88:	c7 44 24 0c 26 6b 10 	movl   $0xc0106b26,0xc(%esp)
c0104b8f:	c0 
c0104b90:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104b97:	c0 
c0104b98:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0104b9f:	00 
c0104ba0:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104ba7:	e8 1d c1 ff ff       	call   c0100cc9 <__panic>
    assert(page_ref(p2) == 0);
c0104bac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104baf:	89 04 24             	mov    %eax,(%esp)
c0104bb2:	e8 6e ef ff ff       	call   c0103b25 <page_ref>
c0104bb7:	85 c0                	test   %eax,%eax
c0104bb9:	74 24                	je     c0104bdf <check_pgdir+0x5a8>
c0104bbb:	c7 44 24 0c 4a 6c 10 	movl   $0xc0106c4a,0xc(%esp)
c0104bc2:	c0 
c0104bc3:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104bca:	c0 
c0104bcb:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0104bd2:	00 
c0104bd3:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104bda:	e8 ea c0 ff ff       	call   c0100cc9 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104bdf:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104be4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104beb:	00 
c0104bec:	89 04 24             	mov    %eax,(%esp)
c0104bef:	e8 cb f8 ff ff       	call   c01044bf <page_remove>
    assert(page_ref(p1) == 0);
c0104bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bf7:	89 04 24             	mov    %eax,(%esp)
c0104bfa:	e8 26 ef ff ff       	call   c0103b25 <page_ref>
c0104bff:	85 c0                	test   %eax,%eax
c0104c01:	74 24                	je     c0104c27 <check_pgdir+0x5f0>
c0104c03:	c7 44 24 0c 71 6c 10 	movl   $0xc0106c71,0xc(%esp)
c0104c0a:	c0 
c0104c0b:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104c12:	c0 
c0104c13:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104c1a:	00 
c0104c1b:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104c22:	e8 a2 c0 ff ff       	call   c0100cc9 <__panic>
    assert(page_ref(p2) == 0);
c0104c27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c2a:	89 04 24             	mov    %eax,(%esp)
c0104c2d:	e8 f3 ee ff ff       	call   c0103b25 <page_ref>
c0104c32:	85 c0                	test   %eax,%eax
c0104c34:	74 24                	je     c0104c5a <check_pgdir+0x623>
c0104c36:	c7 44 24 0c 4a 6c 10 	movl   $0xc0106c4a,0xc(%esp)
c0104c3d:	c0 
c0104c3e:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104c45:	c0 
c0104c46:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104c4d:	00 
c0104c4e:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104c55:	e8 6f c0 ff ff       	call   c0100cc9 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0104c5a:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104c5f:	8b 00                	mov    (%eax),%eax
c0104c61:	89 04 24             	mov    %eax,(%esp)
c0104c64:	e8 db ed ff ff       	call   c0103a44 <pa2page>
c0104c69:	89 04 24             	mov    %eax,(%esp)
c0104c6c:	e8 b4 ee ff ff       	call   c0103b25 <page_ref>
c0104c71:	83 f8 01             	cmp    $0x1,%eax
c0104c74:	74 24                	je     c0104c9a <check_pgdir+0x663>
c0104c76:	c7 44 24 0c 84 6c 10 	movl   $0xc0106c84,0xc(%esp)
c0104c7d:	c0 
c0104c7e:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104c85:	c0 
c0104c86:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0104c8d:	00 
c0104c8e:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104c95:	e8 2f c0 ff ff       	call   c0100cc9 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0104c9a:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104c9f:	8b 00                	mov    (%eax),%eax
c0104ca1:	89 04 24             	mov    %eax,(%esp)
c0104ca4:	e8 9b ed ff ff       	call   c0103a44 <pa2page>
c0104ca9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104cb0:	00 
c0104cb1:	89 04 24             	mov    %eax,(%esp)
c0104cb4:	e8 9c f0 ff ff       	call   c0103d55 <free_pages>
    boot_pgdir[0] = 0;
c0104cb9:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104cbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104cc4:	c7 04 24 aa 6c 10 c0 	movl   $0xc0106caa,(%esp)
c0104ccb:	e8 6c b6 ff ff       	call   c010033c <cprintf>
}
c0104cd0:	c9                   	leave  
c0104cd1:	c3                   	ret    

c0104cd2 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104cd2:	55                   	push   %ebp
c0104cd3:	89 e5                	mov    %esp,%ebp
c0104cd5:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104cd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104cdf:	e9 ca 00 00 00       	jmp    c0104dae <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ce7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ced:	c1 e8 0c             	shr    $0xc,%eax
c0104cf0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104cf3:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0104cf8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104cfb:	72 23                	jb     c0104d20 <check_boot_pgdir+0x4e>
c0104cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d00:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d04:	c7 44 24 08 f4 68 10 	movl   $0xc01068f4,0x8(%esp)
c0104d0b:	c0 
c0104d0c:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104d13:	00 
c0104d14:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104d1b:	e8 a9 bf ff ff       	call   c0100cc9 <__panic>
c0104d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d23:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104d28:	89 c2                	mov    %eax,%edx
c0104d2a:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104d2f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104d36:	00 
c0104d37:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104d3b:	89 04 24             	mov    %eax,(%esp)
c0104d3e:	e8 19 f7 ff ff       	call   c010445c <get_pte>
c0104d43:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104d46:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104d4a:	75 24                	jne    c0104d70 <check_boot_pgdir+0x9e>
c0104d4c:	c7 44 24 0c c4 6c 10 	movl   $0xc0106cc4,0xc(%esp)
c0104d53:	c0 
c0104d54:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104d5b:	c0 
c0104d5c:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104d63:	00 
c0104d64:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104d6b:	e8 59 bf ff ff       	call   c0100cc9 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104d70:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d73:	8b 00                	mov    (%eax),%eax
c0104d75:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104d7a:	89 c2                	mov    %eax,%edx
c0104d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d7f:	39 c2                	cmp    %eax,%edx
c0104d81:	74 24                	je     c0104da7 <check_boot_pgdir+0xd5>
c0104d83:	c7 44 24 0c 01 6d 10 	movl   $0xc0106d01,0xc(%esp)
c0104d8a:	c0 
c0104d8b:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104d92:	c0 
c0104d93:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104d9a:	00 
c0104d9b:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104da2:	e8 22 bf ff ff       	call   c0100cc9 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104da7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104dae:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104db1:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0104db6:	39 c2                	cmp    %eax,%edx
c0104db8:	0f 82 26 ff ff ff    	jb     c0104ce4 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104dbe:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104dc3:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104dc8:	8b 00                	mov    (%eax),%eax
c0104dca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104dcf:	89 c2                	mov    %eax,%edx
c0104dd1:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104dd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104dd9:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104de0:	77 23                	ja     c0104e05 <check_boot_pgdir+0x133>
c0104de2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104de5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104de9:	c7 44 24 08 98 69 10 	movl   $0xc0106998,0x8(%esp)
c0104df0:	c0 
c0104df1:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104df8:	00 
c0104df9:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104e00:	e8 c4 be ff ff       	call   c0100cc9 <__panic>
c0104e05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e08:	05 00 00 00 40       	add    $0x40000000,%eax
c0104e0d:	39 c2                	cmp    %eax,%edx
c0104e0f:	74 24                	je     c0104e35 <check_boot_pgdir+0x163>
c0104e11:	c7 44 24 0c 18 6d 10 	movl   $0xc0106d18,0xc(%esp)
c0104e18:	c0 
c0104e19:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104e20:	c0 
c0104e21:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104e28:	00 
c0104e29:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104e30:	e8 94 be ff ff       	call   c0100cc9 <__panic>

    assert(boot_pgdir[0] == 0);
c0104e35:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104e3a:	8b 00                	mov    (%eax),%eax
c0104e3c:	85 c0                	test   %eax,%eax
c0104e3e:	74 24                	je     c0104e64 <check_boot_pgdir+0x192>
c0104e40:	c7 44 24 0c 4c 6d 10 	movl   $0xc0106d4c,0xc(%esp)
c0104e47:	c0 
c0104e48:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104e4f:	c0 
c0104e50:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104e57:	00 
c0104e58:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104e5f:	e8 65 be ff ff       	call   c0100cc9 <__panic>

    struct Page *p;
    p = alloc_page();
c0104e64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e6b:	e8 ad ee ff ff       	call   c0103d1d <alloc_pages>
c0104e70:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104e73:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104e78:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104e7f:	00 
c0104e80:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104e87:	00 
c0104e88:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104e8b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e8f:	89 04 24             	mov    %eax,(%esp)
c0104e92:	e8 6c f6 ff ff       	call   c0104503 <page_insert>
c0104e97:	85 c0                	test   %eax,%eax
c0104e99:	74 24                	je     c0104ebf <check_boot_pgdir+0x1ed>
c0104e9b:	c7 44 24 0c 60 6d 10 	movl   $0xc0106d60,0xc(%esp)
c0104ea2:	c0 
c0104ea3:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104eaa:	c0 
c0104eab:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0104eb2:	00 
c0104eb3:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104eba:	e8 0a be ff ff       	call   c0100cc9 <__panic>
    assert(page_ref(p) == 1);
c0104ebf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ec2:	89 04 24             	mov    %eax,(%esp)
c0104ec5:	e8 5b ec ff ff       	call   c0103b25 <page_ref>
c0104eca:	83 f8 01             	cmp    $0x1,%eax
c0104ecd:	74 24                	je     c0104ef3 <check_boot_pgdir+0x221>
c0104ecf:	c7 44 24 0c 8e 6d 10 	movl   $0xc0106d8e,0xc(%esp)
c0104ed6:	c0 
c0104ed7:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104ede:	c0 
c0104edf:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0104ee6:	00 
c0104ee7:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104eee:	e8 d6 bd ff ff       	call   c0100cc9 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104ef3:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104ef8:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104eff:	00 
c0104f00:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104f07:	00 
c0104f08:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104f0b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f0f:	89 04 24             	mov    %eax,(%esp)
c0104f12:	e8 ec f5 ff ff       	call   c0104503 <page_insert>
c0104f17:	85 c0                	test   %eax,%eax
c0104f19:	74 24                	je     c0104f3f <check_boot_pgdir+0x26d>
c0104f1b:	c7 44 24 0c a0 6d 10 	movl   $0xc0106da0,0xc(%esp)
c0104f22:	c0 
c0104f23:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104f2a:	c0 
c0104f2b:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0104f32:	00 
c0104f33:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104f3a:	e8 8a bd ff ff       	call   c0100cc9 <__panic>
    assert(page_ref(p) == 2);
c0104f3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f42:	89 04 24             	mov    %eax,(%esp)
c0104f45:	e8 db eb ff ff       	call   c0103b25 <page_ref>
c0104f4a:	83 f8 02             	cmp    $0x2,%eax
c0104f4d:	74 24                	je     c0104f73 <check_boot_pgdir+0x2a1>
c0104f4f:	c7 44 24 0c d7 6d 10 	movl   $0xc0106dd7,0xc(%esp)
c0104f56:	c0 
c0104f57:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104f5e:	c0 
c0104f5f:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0104f66:	00 
c0104f67:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104f6e:	e8 56 bd ff ff       	call   c0100cc9 <__panic>

    const char *str = "ucore: Hello world!!";
c0104f73:	c7 45 dc e8 6d 10 c0 	movl   $0xc0106de8,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0104f7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f7d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f81:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104f88:	e8 1e 0a 00 00       	call   c01059ab <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104f8d:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0104f94:	00 
c0104f95:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104f9c:	e8 83 0a 00 00       	call   c0105a24 <strcmp>
c0104fa1:	85 c0                	test   %eax,%eax
c0104fa3:	74 24                	je     c0104fc9 <check_boot_pgdir+0x2f7>
c0104fa5:	c7 44 24 0c 00 6e 10 	movl   $0xc0106e00,0xc(%esp)
c0104fac:	c0 
c0104fad:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104fb4:	c0 
c0104fb5:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0104fbc:	00 
c0104fbd:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c0104fc4:	e8 00 bd ff ff       	call   c0100cc9 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104fc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104fcc:	89 04 24             	mov    %eax,(%esp)
c0104fcf:	e8 bf ea ff ff       	call   c0103a93 <page2kva>
c0104fd4:	05 00 01 00 00       	add    $0x100,%eax
c0104fd9:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104fdc:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104fe3:	e8 6b 09 00 00       	call   c0105953 <strlen>
c0104fe8:	85 c0                	test   %eax,%eax
c0104fea:	74 24                	je     c0105010 <check_boot_pgdir+0x33e>
c0104fec:	c7 44 24 0c 38 6e 10 	movl   $0xc0106e38,0xc(%esp)
c0104ff3:	c0 
c0104ff4:	c7 44 24 08 e1 69 10 	movl   $0xc01069e1,0x8(%esp)
c0104ffb:	c0 
c0104ffc:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0105003:	00 
c0105004:	c7 04 24 bc 69 10 c0 	movl   $0xc01069bc,(%esp)
c010500b:	e8 b9 bc ff ff       	call   c0100cc9 <__panic>

    free_page(p);
c0105010:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105017:	00 
c0105018:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010501b:	89 04 24             	mov    %eax,(%esp)
c010501e:	e8 32 ed ff ff       	call   c0103d55 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0105023:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0105028:	8b 00                	mov    (%eax),%eax
c010502a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010502f:	89 04 24             	mov    %eax,(%esp)
c0105032:	e8 0d ea ff ff       	call   c0103a44 <pa2page>
c0105037:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010503e:	00 
c010503f:	89 04 24             	mov    %eax,(%esp)
c0105042:	e8 0e ed ff ff       	call   c0103d55 <free_pages>
    boot_pgdir[0] = 0;
c0105047:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c010504c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105052:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0105059:	e8 de b2 ff ff       	call   c010033c <cprintf>
}
c010505e:	c9                   	leave  
c010505f:	c3                   	ret    

c0105060 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105060:	55                   	push   %ebp
c0105061:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105063:	8b 45 08             	mov    0x8(%ebp),%eax
c0105066:	83 e0 04             	and    $0x4,%eax
c0105069:	85 c0                	test   %eax,%eax
c010506b:	74 07                	je     c0105074 <perm2str+0x14>
c010506d:	b8 75 00 00 00       	mov    $0x75,%eax
c0105072:	eb 05                	jmp    c0105079 <perm2str+0x19>
c0105074:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105079:	a2 68 89 11 c0       	mov    %al,0xc0118968
    str[1] = 'r';
c010507e:	c6 05 69 89 11 c0 72 	movb   $0x72,0xc0118969
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105085:	8b 45 08             	mov    0x8(%ebp),%eax
c0105088:	83 e0 02             	and    $0x2,%eax
c010508b:	85 c0                	test   %eax,%eax
c010508d:	74 07                	je     c0105096 <perm2str+0x36>
c010508f:	b8 77 00 00 00       	mov    $0x77,%eax
c0105094:	eb 05                	jmp    c010509b <perm2str+0x3b>
c0105096:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010509b:	a2 6a 89 11 c0       	mov    %al,0xc011896a
    str[3] = '\0';
c01050a0:	c6 05 6b 89 11 c0 00 	movb   $0x0,0xc011896b
    return str;
c01050a7:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
}
c01050ac:	5d                   	pop    %ebp
c01050ad:	c3                   	ret    

c01050ae <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01050ae:	55                   	push   %ebp
c01050af:	89 e5                	mov    %esp,%ebp
c01050b1:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01050b4:	8b 45 10             	mov    0x10(%ebp),%eax
c01050b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01050ba:	72 0a                	jb     c01050c6 <get_pgtable_items+0x18>
        return 0;
c01050bc:	b8 00 00 00 00       	mov    $0x0,%eax
c01050c1:	e9 9c 00 00 00       	jmp    c0105162 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c01050c6:	eb 04                	jmp    c01050cc <get_pgtable_items+0x1e>
        start ++;
c01050c8:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c01050cc:	8b 45 10             	mov    0x10(%ebp),%eax
c01050cf:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01050d2:	73 18                	jae    c01050ec <get_pgtable_items+0x3e>
c01050d4:	8b 45 10             	mov    0x10(%ebp),%eax
c01050d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01050de:	8b 45 14             	mov    0x14(%ebp),%eax
c01050e1:	01 d0                	add    %edx,%eax
c01050e3:	8b 00                	mov    (%eax),%eax
c01050e5:	83 e0 01             	and    $0x1,%eax
c01050e8:	85 c0                	test   %eax,%eax
c01050ea:	74 dc                	je     c01050c8 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c01050ec:	8b 45 10             	mov    0x10(%ebp),%eax
c01050ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01050f2:	73 69                	jae    c010515d <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c01050f4:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01050f8:	74 08                	je     c0105102 <get_pgtable_items+0x54>
            *left_store = start;
c01050fa:	8b 45 18             	mov    0x18(%ebp),%eax
c01050fd:	8b 55 10             	mov    0x10(%ebp),%edx
c0105100:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105102:	8b 45 10             	mov    0x10(%ebp),%eax
c0105105:	8d 50 01             	lea    0x1(%eax),%edx
c0105108:	89 55 10             	mov    %edx,0x10(%ebp)
c010510b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105112:	8b 45 14             	mov    0x14(%ebp),%eax
c0105115:	01 d0                	add    %edx,%eax
c0105117:	8b 00                	mov    (%eax),%eax
c0105119:	83 e0 07             	and    $0x7,%eax
c010511c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010511f:	eb 04                	jmp    c0105125 <get_pgtable_items+0x77>
            start ++;
c0105121:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105125:	8b 45 10             	mov    0x10(%ebp),%eax
c0105128:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010512b:	73 1d                	jae    c010514a <get_pgtable_items+0x9c>
c010512d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105130:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105137:	8b 45 14             	mov    0x14(%ebp),%eax
c010513a:	01 d0                	add    %edx,%eax
c010513c:	8b 00                	mov    (%eax),%eax
c010513e:	83 e0 07             	and    $0x7,%eax
c0105141:	89 c2                	mov    %eax,%edx
c0105143:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105146:	39 c2                	cmp    %eax,%edx
c0105148:	74 d7                	je     c0105121 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c010514a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010514e:	74 08                	je     c0105158 <get_pgtable_items+0xaa>
            *right_store = start;
c0105150:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105153:	8b 55 10             	mov    0x10(%ebp),%edx
c0105156:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105158:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010515b:	eb 05                	jmp    c0105162 <get_pgtable_items+0xb4>
    }
    return 0;
c010515d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105162:	c9                   	leave  
c0105163:	c3                   	ret    

c0105164 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105164:	55                   	push   %ebp
c0105165:	89 e5                	mov    %esp,%ebp
c0105167:	57                   	push   %edi
c0105168:	56                   	push   %esi
c0105169:	53                   	push   %ebx
c010516a:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010516d:	c7 04 24 7c 6e 10 c0 	movl   $0xc0106e7c,(%esp)
c0105174:	e8 c3 b1 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c0105179:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105180:	e9 fa 00 00 00       	jmp    c010527f <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105185:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105188:	89 04 24             	mov    %eax,(%esp)
c010518b:	e8 d0 fe ff ff       	call   c0105060 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105190:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105193:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105196:	29 d1                	sub    %edx,%ecx
c0105198:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010519a:	89 d6                	mov    %edx,%esi
c010519c:	c1 e6 16             	shl    $0x16,%esi
c010519f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01051a2:	89 d3                	mov    %edx,%ebx
c01051a4:	c1 e3 16             	shl    $0x16,%ebx
c01051a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01051aa:	89 d1                	mov    %edx,%ecx
c01051ac:	c1 e1 16             	shl    $0x16,%ecx
c01051af:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01051b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01051b5:	29 d7                	sub    %edx,%edi
c01051b7:	89 fa                	mov    %edi,%edx
c01051b9:	89 44 24 14          	mov    %eax,0x14(%esp)
c01051bd:	89 74 24 10          	mov    %esi,0x10(%esp)
c01051c1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01051c5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01051c9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01051cd:	c7 04 24 ad 6e 10 c0 	movl   $0xc0106ead,(%esp)
c01051d4:	e8 63 b1 ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c01051d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01051dc:	c1 e0 0a             	shl    $0xa,%eax
c01051df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01051e2:	eb 54                	jmp    c0105238 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01051e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01051e7:	89 04 24             	mov    %eax,(%esp)
c01051ea:	e8 71 fe ff ff       	call   c0105060 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01051ef:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01051f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01051f5:	29 d1                	sub    %edx,%ecx
c01051f7:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01051f9:	89 d6                	mov    %edx,%esi
c01051fb:	c1 e6 0c             	shl    $0xc,%esi
c01051fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105201:	89 d3                	mov    %edx,%ebx
c0105203:	c1 e3 0c             	shl    $0xc,%ebx
c0105206:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105209:	c1 e2 0c             	shl    $0xc,%edx
c010520c:	89 d1                	mov    %edx,%ecx
c010520e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105211:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105214:	29 d7                	sub    %edx,%edi
c0105216:	89 fa                	mov    %edi,%edx
c0105218:	89 44 24 14          	mov    %eax,0x14(%esp)
c010521c:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105220:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105224:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105228:	89 54 24 04          	mov    %edx,0x4(%esp)
c010522c:	c7 04 24 cc 6e 10 c0 	movl   $0xc0106ecc,(%esp)
c0105233:	e8 04 b1 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105238:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c010523d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105240:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105243:	89 ce                	mov    %ecx,%esi
c0105245:	c1 e6 0a             	shl    $0xa,%esi
c0105248:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c010524b:	89 cb                	mov    %ecx,%ebx
c010524d:	c1 e3 0a             	shl    $0xa,%ebx
c0105250:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105253:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105257:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c010525a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010525e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105262:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105266:	89 74 24 04          	mov    %esi,0x4(%esp)
c010526a:	89 1c 24             	mov    %ebx,(%esp)
c010526d:	e8 3c fe ff ff       	call   c01050ae <get_pgtable_items>
c0105272:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105275:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105279:	0f 85 65 ff ff ff    	jne    c01051e4 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010527f:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105284:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105287:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c010528a:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010528e:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105291:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105295:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105299:	89 44 24 08          	mov    %eax,0x8(%esp)
c010529d:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01052a4:	00 
c01052a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01052ac:	e8 fd fd ff ff       	call   c01050ae <get_pgtable_items>
c01052b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01052b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01052b8:	0f 85 c7 fe ff ff    	jne    c0105185 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01052be:	c7 04 24 f0 6e 10 c0 	movl   $0xc0106ef0,(%esp)
c01052c5:	e8 72 b0 ff ff       	call   c010033c <cprintf>
}
c01052ca:	83 c4 4c             	add    $0x4c,%esp
c01052cd:	5b                   	pop    %ebx
c01052ce:	5e                   	pop    %esi
c01052cf:	5f                   	pop    %edi
c01052d0:	5d                   	pop    %ebp
c01052d1:	c3                   	ret    

c01052d2 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01052d2:	55                   	push   %ebp
c01052d3:	89 e5                	mov    %esp,%ebp
c01052d5:	83 ec 58             	sub    $0x58,%esp
c01052d8:	8b 45 10             	mov    0x10(%ebp),%eax
c01052db:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01052de:	8b 45 14             	mov    0x14(%ebp),%eax
c01052e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01052e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01052e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01052ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01052ed:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01052f0:	8b 45 18             	mov    0x18(%ebp),%eax
c01052f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01052f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01052fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01052ff:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105302:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105305:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105308:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010530c:	74 1c                	je     c010532a <printnum+0x58>
c010530e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105311:	ba 00 00 00 00       	mov    $0x0,%edx
c0105316:	f7 75 e4             	divl   -0x1c(%ebp)
c0105319:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010531c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010531f:	ba 00 00 00 00       	mov    $0x0,%edx
c0105324:	f7 75 e4             	divl   -0x1c(%ebp)
c0105327:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010532a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010532d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105330:	f7 75 e4             	divl   -0x1c(%ebp)
c0105333:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105336:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105339:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010533c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010533f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105342:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105345:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105348:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010534b:	8b 45 18             	mov    0x18(%ebp),%eax
c010534e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105353:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105356:	77 56                	ja     c01053ae <printnum+0xdc>
c0105358:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010535b:	72 05                	jb     c0105362 <printnum+0x90>
c010535d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105360:	77 4c                	ja     c01053ae <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105362:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105365:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105368:	8b 45 20             	mov    0x20(%ebp),%eax
c010536b:	89 44 24 18          	mov    %eax,0x18(%esp)
c010536f:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105373:	8b 45 18             	mov    0x18(%ebp),%eax
c0105376:	89 44 24 10          	mov    %eax,0x10(%esp)
c010537a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010537d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105380:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105384:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105388:	8b 45 0c             	mov    0xc(%ebp),%eax
c010538b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010538f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105392:	89 04 24             	mov    %eax,(%esp)
c0105395:	e8 38 ff ff ff       	call   c01052d2 <printnum>
c010539a:	eb 1c                	jmp    c01053b8 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010539c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010539f:	89 44 24 04          	mov    %eax,0x4(%esp)
c01053a3:	8b 45 20             	mov    0x20(%ebp),%eax
c01053a6:	89 04 24             	mov    %eax,(%esp)
c01053a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01053ac:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01053ae:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01053b2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01053b6:	7f e4                	jg     c010539c <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01053b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01053bb:	05 a4 6f 10 c0       	add    $0xc0106fa4,%eax
c01053c0:	0f b6 00             	movzbl (%eax),%eax
c01053c3:	0f be c0             	movsbl %al,%eax
c01053c6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01053c9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053cd:	89 04 24             	mov    %eax,(%esp)
c01053d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01053d3:	ff d0                	call   *%eax
}
c01053d5:	c9                   	leave  
c01053d6:	c3                   	ret    

c01053d7 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01053d7:	55                   	push   %ebp
c01053d8:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01053da:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01053de:	7e 14                	jle    c01053f4 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01053e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01053e3:	8b 00                	mov    (%eax),%eax
c01053e5:	8d 48 08             	lea    0x8(%eax),%ecx
c01053e8:	8b 55 08             	mov    0x8(%ebp),%edx
c01053eb:	89 0a                	mov    %ecx,(%edx)
c01053ed:	8b 50 04             	mov    0x4(%eax),%edx
c01053f0:	8b 00                	mov    (%eax),%eax
c01053f2:	eb 30                	jmp    c0105424 <getuint+0x4d>
    }
    else if (lflag) {
c01053f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01053f8:	74 16                	je     c0105410 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01053fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01053fd:	8b 00                	mov    (%eax),%eax
c01053ff:	8d 48 04             	lea    0x4(%eax),%ecx
c0105402:	8b 55 08             	mov    0x8(%ebp),%edx
c0105405:	89 0a                	mov    %ecx,(%edx)
c0105407:	8b 00                	mov    (%eax),%eax
c0105409:	ba 00 00 00 00       	mov    $0x0,%edx
c010540e:	eb 14                	jmp    c0105424 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105410:	8b 45 08             	mov    0x8(%ebp),%eax
c0105413:	8b 00                	mov    (%eax),%eax
c0105415:	8d 48 04             	lea    0x4(%eax),%ecx
c0105418:	8b 55 08             	mov    0x8(%ebp),%edx
c010541b:	89 0a                	mov    %ecx,(%edx)
c010541d:	8b 00                	mov    (%eax),%eax
c010541f:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105424:	5d                   	pop    %ebp
c0105425:	c3                   	ret    

c0105426 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105426:	55                   	push   %ebp
c0105427:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105429:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010542d:	7e 14                	jle    c0105443 <getint+0x1d>
        return va_arg(*ap, long long);
c010542f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105432:	8b 00                	mov    (%eax),%eax
c0105434:	8d 48 08             	lea    0x8(%eax),%ecx
c0105437:	8b 55 08             	mov    0x8(%ebp),%edx
c010543a:	89 0a                	mov    %ecx,(%edx)
c010543c:	8b 50 04             	mov    0x4(%eax),%edx
c010543f:	8b 00                	mov    (%eax),%eax
c0105441:	eb 28                	jmp    c010546b <getint+0x45>
    }
    else if (lflag) {
c0105443:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105447:	74 12                	je     c010545b <getint+0x35>
        return va_arg(*ap, long);
c0105449:	8b 45 08             	mov    0x8(%ebp),%eax
c010544c:	8b 00                	mov    (%eax),%eax
c010544e:	8d 48 04             	lea    0x4(%eax),%ecx
c0105451:	8b 55 08             	mov    0x8(%ebp),%edx
c0105454:	89 0a                	mov    %ecx,(%edx)
c0105456:	8b 00                	mov    (%eax),%eax
c0105458:	99                   	cltd   
c0105459:	eb 10                	jmp    c010546b <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c010545b:	8b 45 08             	mov    0x8(%ebp),%eax
c010545e:	8b 00                	mov    (%eax),%eax
c0105460:	8d 48 04             	lea    0x4(%eax),%ecx
c0105463:	8b 55 08             	mov    0x8(%ebp),%edx
c0105466:	89 0a                	mov    %ecx,(%edx)
c0105468:	8b 00                	mov    (%eax),%eax
c010546a:	99                   	cltd   
    }
}
c010546b:	5d                   	pop    %ebp
c010546c:	c3                   	ret    

c010546d <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010546d:	55                   	push   %ebp
c010546e:	89 e5                	mov    %esp,%ebp
c0105470:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105473:	8d 45 14             	lea    0x14(%ebp),%eax
c0105476:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105479:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010547c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105480:	8b 45 10             	mov    0x10(%ebp),%eax
c0105483:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105487:	8b 45 0c             	mov    0xc(%ebp),%eax
c010548a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010548e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105491:	89 04 24             	mov    %eax,(%esp)
c0105494:	e8 02 00 00 00       	call   c010549b <vprintfmt>
    va_end(ap);
}
c0105499:	c9                   	leave  
c010549a:	c3                   	ret    

c010549b <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010549b:	55                   	push   %ebp
c010549c:	89 e5                	mov    %esp,%ebp
c010549e:	56                   	push   %esi
c010549f:	53                   	push   %ebx
c01054a0:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01054a3:	eb 18                	jmp    c01054bd <vprintfmt+0x22>
            if (ch == '\0') {
c01054a5:	85 db                	test   %ebx,%ebx
c01054a7:	75 05                	jne    c01054ae <vprintfmt+0x13>
                return;
c01054a9:	e9 d1 03 00 00       	jmp    c010587f <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c01054ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054b5:	89 1c 24             	mov    %ebx,(%esp)
c01054b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01054bb:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01054bd:	8b 45 10             	mov    0x10(%ebp),%eax
c01054c0:	8d 50 01             	lea    0x1(%eax),%edx
c01054c3:	89 55 10             	mov    %edx,0x10(%ebp)
c01054c6:	0f b6 00             	movzbl (%eax),%eax
c01054c9:	0f b6 d8             	movzbl %al,%ebx
c01054cc:	83 fb 25             	cmp    $0x25,%ebx
c01054cf:	75 d4                	jne    c01054a5 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01054d1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01054d5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01054dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054df:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01054e2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01054e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01054ec:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01054ef:	8b 45 10             	mov    0x10(%ebp),%eax
c01054f2:	8d 50 01             	lea    0x1(%eax),%edx
c01054f5:	89 55 10             	mov    %edx,0x10(%ebp)
c01054f8:	0f b6 00             	movzbl (%eax),%eax
c01054fb:	0f b6 d8             	movzbl %al,%ebx
c01054fe:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105501:	83 f8 55             	cmp    $0x55,%eax
c0105504:	0f 87 44 03 00 00    	ja     c010584e <vprintfmt+0x3b3>
c010550a:	8b 04 85 c8 6f 10 c0 	mov    -0x3fef9038(,%eax,4),%eax
c0105511:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105513:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105517:	eb d6                	jmp    c01054ef <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105519:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010551d:	eb d0                	jmp    c01054ef <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010551f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105526:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105529:	89 d0                	mov    %edx,%eax
c010552b:	c1 e0 02             	shl    $0x2,%eax
c010552e:	01 d0                	add    %edx,%eax
c0105530:	01 c0                	add    %eax,%eax
c0105532:	01 d8                	add    %ebx,%eax
c0105534:	83 e8 30             	sub    $0x30,%eax
c0105537:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010553a:	8b 45 10             	mov    0x10(%ebp),%eax
c010553d:	0f b6 00             	movzbl (%eax),%eax
c0105540:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105543:	83 fb 2f             	cmp    $0x2f,%ebx
c0105546:	7e 0b                	jle    c0105553 <vprintfmt+0xb8>
c0105548:	83 fb 39             	cmp    $0x39,%ebx
c010554b:	7f 06                	jg     c0105553 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010554d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0105551:	eb d3                	jmp    c0105526 <vprintfmt+0x8b>
            goto process_precision;
c0105553:	eb 33                	jmp    c0105588 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0105555:	8b 45 14             	mov    0x14(%ebp),%eax
c0105558:	8d 50 04             	lea    0x4(%eax),%edx
c010555b:	89 55 14             	mov    %edx,0x14(%ebp)
c010555e:	8b 00                	mov    (%eax),%eax
c0105560:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105563:	eb 23                	jmp    c0105588 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0105565:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105569:	79 0c                	jns    c0105577 <vprintfmt+0xdc>
                width = 0;
c010556b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105572:	e9 78 ff ff ff       	jmp    c01054ef <vprintfmt+0x54>
c0105577:	e9 73 ff ff ff       	jmp    c01054ef <vprintfmt+0x54>

        case '#':
            altflag = 1;
c010557c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105583:	e9 67 ff ff ff       	jmp    c01054ef <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0105588:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010558c:	79 12                	jns    c01055a0 <vprintfmt+0x105>
                width = precision, precision = -1;
c010558e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105591:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105594:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010559b:	e9 4f ff ff ff       	jmp    c01054ef <vprintfmt+0x54>
c01055a0:	e9 4a ff ff ff       	jmp    c01054ef <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01055a5:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01055a9:	e9 41 ff ff ff       	jmp    c01054ef <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01055ae:	8b 45 14             	mov    0x14(%ebp),%eax
c01055b1:	8d 50 04             	lea    0x4(%eax),%edx
c01055b4:	89 55 14             	mov    %edx,0x14(%ebp)
c01055b7:	8b 00                	mov    (%eax),%eax
c01055b9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01055bc:	89 54 24 04          	mov    %edx,0x4(%esp)
c01055c0:	89 04 24             	mov    %eax,(%esp)
c01055c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01055c6:	ff d0                	call   *%eax
            break;
c01055c8:	e9 ac 02 00 00       	jmp    c0105879 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01055cd:	8b 45 14             	mov    0x14(%ebp),%eax
c01055d0:	8d 50 04             	lea    0x4(%eax),%edx
c01055d3:	89 55 14             	mov    %edx,0x14(%ebp)
c01055d6:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01055d8:	85 db                	test   %ebx,%ebx
c01055da:	79 02                	jns    c01055de <vprintfmt+0x143>
                err = -err;
c01055dc:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01055de:	83 fb 06             	cmp    $0x6,%ebx
c01055e1:	7f 0b                	jg     c01055ee <vprintfmt+0x153>
c01055e3:	8b 34 9d 88 6f 10 c0 	mov    -0x3fef9078(,%ebx,4),%esi
c01055ea:	85 f6                	test   %esi,%esi
c01055ec:	75 23                	jne    c0105611 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c01055ee:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01055f2:	c7 44 24 08 b5 6f 10 	movl   $0xc0106fb5,0x8(%esp)
c01055f9:	c0 
c01055fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105601:	8b 45 08             	mov    0x8(%ebp),%eax
c0105604:	89 04 24             	mov    %eax,(%esp)
c0105607:	e8 61 fe ff ff       	call   c010546d <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010560c:	e9 68 02 00 00       	jmp    c0105879 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105611:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105615:	c7 44 24 08 be 6f 10 	movl   $0xc0106fbe,0x8(%esp)
c010561c:	c0 
c010561d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105620:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105624:	8b 45 08             	mov    0x8(%ebp),%eax
c0105627:	89 04 24             	mov    %eax,(%esp)
c010562a:	e8 3e fe ff ff       	call   c010546d <printfmt>
            }
            break;
c010562f:	e9 45 02 00 00       	jmp    c0105879 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105634:	8b 45 14             	mov    0x14(%ebp),%eax
c0105637:	8d 50 04             	lea    0x4(%eax),%edx
c010563a:	89 55 14             	mov    %edx,0x14(%ebp)
c010563d:	8b 30                	mov    (%eax),%esi
c010563f:	85 f6                	test   %esi,%esi
c0105641:	75 05                	jne    c0105648 <vprintfmt+0x1ad>
                p = "(null)";
c0105643:	be c1 6f 10 c0       	mov    $0xc0106fc1,%esi
            }
            if (width > 0 && padc != '-') {
c0105648:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010564c:	7e 3e                	jle    c010568c <vprintfmt+0x1f1>
c010564e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105652:	74 38                	je     c010568c <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105654:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0105657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010565a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010565e:	89 34 24             	mov    %esi,(%esp)
c0105661:	e8 15 03 00 00       	call   c010597b <strnlen>
c0105666:	29 c3                	sub    %eax,%ebx
c0105668:	89 d8                	mov    %ebx,%eax
c010566a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010566d:	eb 17                	jmp    c0105686 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c010566f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105673:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105676:	89 54 24 04          	mov    %edx,0x4(%esp)
c010567a:	89 04 24             	mov    %eax,(%esp)
c010567d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105680:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105682:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105686:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010568a:	7f e3                	jg     c010566f <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010568c:	eb 38                	jmp    c01056c6 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c010568e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105692:	74 1f                	je     c01056b3 <vprintfmt+0x218>
c0105694:	83 fb 1f             	cmp    $0x1f,%ebx
c0105697:	7e 05                	jle    c010569e <vprintfmt+0x203>
c0105699:	83 fb 7e             	cmp    $0x7e,%ebx
c010569c:	7e 15                	jle    c01056b3 <vprintfmt+0x218>
                    putch('?', putdat);
c010569e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056a5:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01056ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01056af:	ff d0                	call   *%eax
c01056b1:	eb 0f                	jmp    c01056c2 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c01056b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056b6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056ba:	89 1c 24             	mov    %ebx,(%esp)
c01056bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01056c0:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01056c2:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01056c6:	89 f0                	mov    %esi,%eax
c01056c8:	8d 70 01             	lea    0x1(%eax),%esi
c01056cb:	0f b6 00             	movzbl (%eax),%eax
c01056ce:	0f be d8             	movsbl %al,%ebx
c01056d1:	85 db                	test   %ebx,%ebx
c01056d3:	74 10                	je     c01056e5 <vprintfmt+0x24a>
c01056d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01056d9:	78 b3                	js     c010568e <vprintfmt+0x1f3>
c01056db:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01056df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01056e3:	79 a9                	jns    c010568e <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01056e5:	eb 17                	jmp    c01056fe <vprintfmt+0x263>
                putch(' ', putdat);
c01056e7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056ea:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056ee:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01056f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01056f8:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01056fa:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01056fe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105702:	7f e3                	jg     c01056e7 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0105704:	e9 70 01 00 00       	jmp    c0105879 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105709:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010570c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105710:	8d 45 14             	lea    0x14(%ebp),%eax
c0105713:	89 04 24             	mov    %eax,(%esp)
c0105716:	e8 0b fd ff ff       	call   c0105426 <getint>
c010571b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010571e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105721:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105724:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105727:	85 d2                	test   %edx,%edx
c0105729:	79 26                	jns    c0105751 <vprintfmt+0x2b6>
                putch('-', putdat);
c010572b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010572e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105732:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105739:	8b 45 08             	mov    0x8(%ebp),%eax
c010573c:	ff d0                	call   *%eax
                num = -(long long)num;
c010573e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105741:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105744:	f7 d8                	neg    %eax
c0105746:	83 d2 00             	adc    $0x0,%edx
c0105749:	f7 da                	neg    %edx
c010574b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010574e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105751:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105758:	e9 a8 00 00 00       	jmp    c0105805 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010575d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105760:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105764:	8d 45 14             	lea    0x14(%ebp),%eax
c0105767:	89 04 24             	mov    %eax,(%esp)
c010576a:	e8 68 fc ff ff       	call   c01053d7 <getuint>
c010576f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105772:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105775:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010577c:	e9 84 00 00 00       	jmp    c0105805 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105781:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105784:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105788:	8d 45 14             	lea    0x14(%ebp),%eax
c010578b:	89 04 24             	mov    %eax,(%esp)
c010578e:	e8 44 fc ff ff       	call   c01053d7 <getuint>
c0105793:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105796:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105799:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01057a0:	eb 63                	jmp    c0105805 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c01057a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057a9:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c01057b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01057b3:	ff d0                	call   *%eax
            putch('x', putdat);
c01057b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057b8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057bc:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01057c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01057c6:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01057c8:	8b 45 14             	mov    0x14(%ebp),%eax
c01057cb:	8d 50 04             	lea    0x4(%eax),%edx
c01057ce:	89 55 14             	mov    %edx,0x14(%ebp)
c01057d1:	8b 00                	mov    (%eax),%eax
c01057d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01057dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01057e4:	eb 1f                	jmp    c0105805 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01057e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057ed:	8d 45 14             	lea    0x14(%ebp),%eax
c01057f0:	89 04 24             	mov    %eax,(%esp)
c01057f3:	e8 df fb ff ff       	call   c01053d7 <getuint>
c01057f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01057fe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105805:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105809:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010580c:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105810:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105813:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105817:	89 44 24 10          	mov    %eax,0x10(%esp)
c010581b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010581e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105821:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105825:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105829:	8b 45 0c             	mov    0xc(%ebp),%eax
c010582c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105830:	8b 45 08             	mov    0x8(%ebp),%eax
c0105833:	89 04 24             	mov    %eax,(%esp)
c0105836:	e8 97 fa ff ff       	call   c01052d2 <printnum>
            break;
c010583b:	eb 3c                	jmp    c0105879 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010583d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105840:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105844:	89 1c 24             	mov    %ebx,(%esp)
c0105847:	8b 45 08             	mov    0x8(%ebp),%eax
c010584a:	ff d0                	call   *%eax
            break;
c010584c:	eb 2b                	jmp    c0105879 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010584e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105851:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105855:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010585c:	8b 45 08             	mov    0x8(%ebp),%eax
c010585f:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105861:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105865:	eb 04                	jmp    c010586b <vprintfmt+0x3d0>
c0105867:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010586b:	8b 45 10             	mov    0x10(%ebp),%eax
c010586e:	83 e8 01             	sub    $0x1,%eax
c0105871:	0f b6 00             	movzbl (%eax),%eax
c0105874:	3c 25                	cmp    $0x25,%al
c0105876:	75 ef                	jne    c0105867 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0105878:	90                   	nop
        }
    }
c0105879:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010587a:	e9 3e fc ff ff       	jmp    c01054bd <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c010587f:	83 c4 40             	add    $0x40,%esp
c0105882:	5b                   	pop    %ebx
c0105883:	5e                   	pop    %esi
c0105884:	5d                   	pop    %ebp
c0105885:	c3                   	ret    

c0105886 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105886:	55                   	push   %ebp
c0105887:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105889:	8b 45 0c             	mov    0xc(%ebp),%eax
c010588c:	8b 40 08             	mov    0x8(%eax),%eax
c010588f:	8d 50 01             	lea    0x1(%eax),%edx
c0105892:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105895:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105898:	8b 45 0c             	mov    0xc(%ebp),%eax
c010589b:	8b 10                	mov    (%eax),%edx
c010589d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058a0:	8b 40 04             	mov    0x4(%eax),%eax
c01058a3:	39 c2                	cmp    %eax,%edx
c01058a5:	73 12                	jae    c01058b9 <sprintputch+0x33>
        *b->buf ++ = ch;
c01058a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058aa:	8b 00                	mov    (%eax),%eax
c01058ac:	8d 48 01             	lea    0x1(%eax),%ecx
c01058af:	8b 55 0c             	mov    0xc(%ebp),%edx
c01058b2:	89 0a                	mov    %ecx,(%edx)
c01058b4:	8b 55 08             	mov    0x8(%ebp),%edx
c01058b7:	88 10                	mov    %dl,(%eax)
    }
}
c01058b9:	5d                   	pop    %ebp
c01058ba:	c3                   	ret    

c01058bb <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01058bb:	55                   	push   %ebp
c01058bc:	89 e5                	mov    %esp,%ebp
c01058be:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01058c1:	8d 45 14             	lea    0x14(%ebp),%eax
c01058c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01058c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01058ce:	8b 45 10             	mov    0x10(%ebp),%eax
c01058d1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01058d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058d8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01058df:	89 04 24             	mov    %eax,(%esp)
c01058e2:	e8 08 00 00 00       	call   c01058ef <vsnprintf>
c01058e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01058ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01058ed:	c9                   	leave  
c01058ee:	c3                   	ret    

c01058ef <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01058ef:	55                   	push   %ebp
c01058f0:	89 e5                	mov    %esp,%ebp
c01058f2:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01058f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01058f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01058fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058fe:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105901:	8b 45 08             	mov    0x8(%ebp),%eax
c0105904:	01 d0                	add    %edx,%eax
c0105906:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105909:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105910:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105914:	74 0a                	je     c0105920 <vsnprintf+0x31>
c0105916:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105919:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010591c:	39 c2                	cmp    %eax,%edx
c010591e:	76 07                	jbe    c0105927 <vsnprintf+0x38>
        return -E_INVAL;
c0105920:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105925:	eb 2a                	jmp    c0105951 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105927:	8b 45 14             	mov    0x14(%ebp),%eax
c010592a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010592e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105931:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105935:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105938:	89 44 24 04          	mov    %eax,0x4(%esp)
c010593c:	c7 04 24 86 58 10 c0 	movl   $0xc0105886,(%esp)
c0105943:	e8 53 fb ff ff       	call   c010549b <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105948:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010594b:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c010594e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105951:	c9                   	leave  
c0105952:	c3                   	ret    

c0105953 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105953:	55                   	push   %ebp
c0105954:	89 e5                	mov    %esp,%ebp
c0105956:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105959:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105960:	eb 04                	jmp    c0105966 <strlen+0x13>
        cnt ++;
c0105962:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105966:	8b 45 08             	mov    0x8(%ebp),%eax
c0105969:	8d 50 01             	lea    0x1(%eax),%edx
c010596c:	89 55 08             	mov    %edx,0x8(%ebp)
c010596f:	0f b6 00             	movzbl (%eax),%eax
c0105972:	84 c0                	test   %al,%al
c0105974:	75 ec                	jne    c0105962 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105976:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105979:	c9                   	leave  
c010597a:	c3                   	ret    

c010597b <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010597b:	55                   	push   %ebp
c010597c:	89 e5                	mov    %esp,%ebp
c010597e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105981:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105988:	eb 04                	jmp    c010598e <strnlen+0x13>
        cnt ++;
c010598a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c010598e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105991:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105994:	73 10                	jae    c01059a6 <strnlen+0x2b>
c0105996:	8b 45 08             	mov    0x8(%ebp),%eax
c0105999:	8d 50 01             	lea    0x1(%eax),%edx
c010599c:	89 55 08             	mov    %edx,0x8(%ebp)
c010599f:	0f b6 00             	movzbl (%eax),%eax
c01059a2:	84 c0                	test   %al,%al
c01059a4:	75 e4                	jne    c010598a <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c01059a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01059a9:	c9                   	leave  
c01059aa:	c3                   	ret    

c01059ab <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01059ab:	55                   	push   %ebp
c01059ac:	89 e5                	mov    %esp,%ebp
c01059ae:	57                   	push   %edi
c01059af:	56                   	push   %esi
c01059b0:	83 ec 20             	sub    $0x20,%esp
c01059b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01059b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01059bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01059c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059c5:	89 d1                	mov    %edx,%ecx
c01059c7:	89 c2                	mov    %eax,%edx
c01059c9:	89 ce                	mov    %ecx,%esi
c01059cb:	89 d7                	mov    %edx,%edi
c01059cd:	ac                   	lods   %ds:(%esi),%al
c01059ce:	aa                   	stos   %al,%es:(%edi)
c01059cf:	84 c0                	test   %al,%al
c01059d1:	75 fa                	jne    c01059cd <strcpy+0x22>
c01059d3:	89 fa                	mov    %edi,%edx
c01059d5:	89 f1                	mov    %esi,%ecx
c01059d7:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01059da:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01059dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01059e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01059e3:	83 c4 20             	add    $0x20,%esp
c01059e6:	5e                   	pop    %esi
c01059e7:	5f                   	pop    %edi
c01059e8:	5d                   	pop    %ebp
c01059e9:	c3                   	ret    

c01059ea <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01059ea:	55                   	push   %ebp
c01059eb:	89 e5                	mov    %esp,%ebp
c01059ed:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01059f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01059f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01059f6:	eb 21                	jmp    c0105a19 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c01059f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059fb:	0f b6 10             	movzbl (%eax),%edx
c01059fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a01:	88 10                	mov    %dl,(%eax)
c0105a03:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a06:	0f b6 00             	movzbl (%eax),%eax
c0105a09:	84 c0                	test   %al,%al
c0105a0b:	74 04                	je     c0105a11 <strncpy+0x27>
            src ++;
c0105a0d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105a11:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105a15:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105a19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a1d:	75 d9                	jne    c01059f8 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105a1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105a22:	c9                   	leave  
c0105a23:	c3                   	ret    

c0105a24 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105a24:	55                   	push   %ebp
c0105a25:	89 e5                	mov    %esp,%ebp
c0105a27:	57                   	push   %edi
c0105a28:	56                   	push   %esi
c0105a29:	83 ec 20             	sub    $0x20,%esp
c0105a2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a32:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a35:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105a38:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a3e:	89 d1                	mov    %edx,%ecx
c0105a40:	89 c2                	mov    %eax,%edx
c0105a42:	89 ce                	mov    %ecx,%esi
c0105a44:	89 d7                	mov    %edx,%edi
c0105a46:	ac                   	lods   %ds:(%esi),%al
c0105a47:	ae                   	scas   %es:(%edi),%al
c0105a48:	75 08                	jne    c0105a52 <strcmp+0x2e>
c0105a4a:	84 c0                	test   %al,%al
c0105a4c:	75 f8                	jne    c0105a46 <strcmp+0x22>
c0105a4e:	31 c0                	xor    %eax,%eax
c0105a50:	eb 04                	jmp    c0105a56 <strcmp+0x32>
c0105a52:	19 c0                	sbb    %eax,%eax
c0105a54:	0c 01                	or     $0x1,%al
c0105a56:	89 fa                	mov    %edi,%edx
c0105a58:	89 f1                	mov    %esi,%ecx
c0105a5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a5d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105a60:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105a63:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105a66:	83 c4 20             	add    $0x20,%esp
c0105a69:	5e                   	pop    %esi
c0105a6a:	5f                   	pop    %edi
c0105a6b:	5d                   	pop    %ebp
c0105a6c:	c3                   	ret    

c0105a6d <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105a6d:	55                   	push   %ebp
c0105a6e:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105a70:	eb 0c                	jmp    c0105a7e <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105a72:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105a76:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105a7a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105a7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a82:	74 1a                	je     c0105a9e <strncmp+0x31>
c0105a84:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a87:	0f b6 00             	movzbl (%eax),%eax
c0105a8a:	84 c0                	test   %al,%al
c0105a8c:	74 10                	je     c0105a9e <strncmp+0x31>
c0105a8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a91:	0f b6 10             	movzbl (%eax),%edx
c0105a94:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a97:	0f b6 00             	movzbl (%eax),%eax
c0105a9a:	38 c2                	cmp    %al,%dl
c0105a9c:	74 d4                	je     c0105a72 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105a9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105aa2:	74 18                	je     c0105abc <strncmp+0x4f>
c0105aa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa7:	0f b6 00             	movzbl (%eax),%eax
c0105aaa:	0f b6 d0             	movzbl %al,%edx
c0105aad:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ab0:	0f b6 00             	movzbl (%eax),%eax
c0105ab3:	0f b6 c0             	movzbl %al,%eax
c0105ab6:	29 c2                	sub    %eax,%edx
c0105ab8:	89 d0                	mov    %edx,%eax
c0105aba:	eb 05                	jmp    c0105ac1 <strncmp+0x54>
c0105abc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105ac1:	5d                   	pop    %ebp
c0105ac2:	c3                   	ret    

c0105ac3 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105ac3:	55                   	push   %ebp
c0105ac4:	89 e5                	mov    %esp,%ebp
c0105ac6:	83 ec 04             	sub    $0x4,%esp
c0105ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105acc:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105acf:	eb 14                	jmp    c0105ae5 <strchr+0x22>
        if (*s == c) {
c0105ad1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ad4:	0f b6 00             	movzbl (%eax),%eax
c0105ad7:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105ada:	75 05                	jne    c0105ae1 <strchr+0x1e>
            return (char *)s;
c0105adc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105adf:	eb 13                	jmp    c0105af4 <strchr+0x31>
        }
        s ++;
c0105ae1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105ae5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ae8:	0f b6 00             	movzbl (%eax),%eax
c0105aeb:	84 c0                	test   %al,%al
c0105aed:	75 e2                	jne    c0105ad1 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105aef:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105af4:	c9                   	leave  
c0105af5:	c3                   	ret    

c0105af6 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105af6:	55                   	push   %ebp
c0105af7:	89 e5                	mov    %esp,%ebp
c0105af9:	83 ec 04             	sub    $0x4,%esp
c0105afc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aff:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105b02:	eb 11                	jmp    c0105b15 <strfind+0x1f>
        if (*s == c) {
c0105b04:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b07:	0f b6 00             	movzbl (%eax),%eax
c0105b0a:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105b0d:	75 02                	jne    c0105b11 <strfind+0x1b>
            break;
c0105b0f:	eb 0e                	jmp    c0105b1f <strfind+0x29>
        }
        s ++;
c0105b11:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105b15:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b18:	0f b6 00             	movzbl (%eax),%eax
c0105b1b:	84 c0                	test   %al,%al
c0105b1d:	75 e5                	jne    c0105b04 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105b1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105b22:	c9                   	leave  
c0105b23:	c3                   	ret    

c0105b24 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105b24:	55                   	push   %ebp
c0105b25:	89 e5                	mov    %esp,%ebp
c0105b27:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105b2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105b31:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105b38:	eb 04                	jmp    c0105b3e <strtol+0x1a>
        s ++;
c0105b3a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105b3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b41:	0f b6 00             	movzbl (%eax),%eax
c0105b44:	3c 20                	cmp    $0x20,%al
c0105b46:	74 f2                	je     c0105b3a <strtol+0x16>
c0105b48:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b4b:	0f b6 00             	movzbl (%eax),%eax
c0105b4e:	3c 09                	cmp    $0x9,%al
c0105b50:	74 e8                	je     c0105b3a <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105b52:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b55:	0f b6 00             	movzbl (%eax),%eax
c0105b58:	3c 2b                	cmp    $0x2b,%al
c0105b5a:	75 06                	jne    c0105b62 <strtol+0x3e>
        s ++;
c0105b5c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105b60:	eb 15                	jmp    c0105b77 <strtol+0x53>
    }
    else if (*s == '-') {
c0105b62:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b65:	0f b6 00             	movzbl (%eax),%eax
c0105b68:	3c 2d                	cmp    $0x2d,%al
c0105b6a:	75 0b                	jne    c0105b77 <strtol+0x53>
        s ++, neg = 1;
c0105b6c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105b70:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105b77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b7b:	74 06                	je     c0105b83 <strtol+0x5f>
c0105b7d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105b81:	75 24                	jne    c0105ba7 <strtol+0x83>
c0105b83:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b86:	0f b6 00             	movzbl (%eax),%eax
c0105b89:	3c 30                	cmp    $0x30,%al
c0105b8b:	75 1a                	jne    c0105ba7 <strtol+0x83>
c0105b8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b90:	83 c0 01             	add    $0x1,%eax
c0105b93:	0f b6 00             	movzbl (%eax),%eax
c0105b96:	3c 78                	cmp    $0x78,%al
c0105b98:	75 0d                	jne    c0105ba7 <strtol+0x83>
        s += 2, base = 16;
c0105b9a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105b9e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105ba5:	eb 2a                	jmp    c0105bd1 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105ba7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bab:	75 17                	jne    c0105bc4 <strtol+0xa0>
c0105bad:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bb0:	0f b6 00             	movzbl (%eax),%eax
c0105bb3:	3c 30                	cmp    $0x30,%al
c0105bb5:	75 0d                	jne    c0105bc4 <strtol+0xa0>
        s ++, base = 8;
c0105bb7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105bbb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105bc2:	eb 0d                	jmp    c0105bd1 <strtol+0xad>
    }
    else if (base == 0) {
c0105bc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bc8:	75 07                	jne    c0105bd1 <strtol+0xad>
        base = 10;
c0105bca:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105bd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd4:	0f b6 00             	movzbl (%eax),%eax
c0105bd7:	3c 2f                	cmp    $0x2f,%al
c0105bd9:	7e 1b                	jle    c0105bf6 <strtol+0xd2>
c0105bdb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bde:	0f b6 00             	movzbl (%eax),%eax
c0105be1:	3c 39                	cmp    $0x39,%al
c0105be3:	7f 11                	jg     c0105bf6 <strtol+0xd2>
            dig = *s - '0';
c0105be5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105be8:	0f b6 00             	movzbl (%eax),%eax
c0105beb:	0f be c0             	movsbl %al,%eax
c0105bee:	83 e8 30             	sub    $0x30,%eax
c0105bf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105bf4:	eb 48                	jmp    c0105c3e <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105bf6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf9:	0f b6 00             	movzbl (%eax),%eax
c0105bfc:	3c 60                	cmp    $0x60,%al
c0105bfe:	7e 1b                	jle    c0105c1b <strtol+0xf7>
c0105c00:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c03:	0f b6 00             	movzbl (%eax),%eax
c0105c06:	3c 7a                	cmp    $0x7a,%al
c0105c08:	7f 11                	jg     c0105c1b <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105c0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c0d:	0f b6 00             	movzbl (%eax),%eax
c0105c10:	0f be c0             	movsbl %al,%eax
c0105c13:	83 e8 57             	sub    $0x57,%eax
c0105c16:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105c19:	eb 23                	jmp    c0105c3e <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105c1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c1e:	0f b6 00             	movzbl (%eax),%eax
c0105c21:	3c 40                	cmp    $0x40,%al
c0105c23:	7e 3d                	jle    c0105c62 <strtol+0x13e>
c0105c25:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c28:	0f b6 00             	movzbl (%eax),%eax
c0105c2b:	3c 5a                	cmp    $0x5a,%al
c0105c2d:	7f 33                	jg     c0105c62 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105c2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c32:	0f b6 00             	movzbl (%eax),%eax
c0105c35:	0f be c0             	movsbl %al,%eax
c0105c38:	83 e8 37             	sub    $0x37,%eax
c0105c3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c41:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105c44:	7c 02                	jl     c0105c48 <strtol+0x124>
            break;
c0105c46:	eb 1a                	jmp    c0105c62 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105c48:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105c4f:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105c53:	89 c2                	mov    %eax,%edx
c0105c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c58:	01 d0                	add    %edx,%eax
c0105c5a:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105c5d:	e9 6f ff ff ff       	jmp    c0105bd1 <strtol+0xad>

    if (endptr) {
c0105c62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105c66:	74 08                	je     c0105c70 <strtol+0x14c>
        *endptr = (char *) s;
c0105c68:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c6b:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c6e:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105c70:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105c74:	74 07                	je     c0105c7d <strtol+0x159>
c0105c76:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105c79:	f7 d8                	neg    %eax
c0105c7b:	eb 03                	jmp    c0105c80 <strtol+0x15c>
c0105c7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105c80:	c9                   	leave  
c0105c81:	c3                   	ret    

c0105c82 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105c82:	55                   	push   %ebp
c0105c83:	89 e5                	mov    %esp,%ebp
c0105c85:	57                   	push   %edi
c0105c86:	83 ec 24             	sub    $0x24,%esp
c0105c89:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c8c:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105c8f:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105c93:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c96:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105c99:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105c9c:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105ca2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105ca5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105ca9:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105cac:	89 d7                	mov    %edx,%edi
c0105cae:	f3 aa                	rep stos %al,%es:(%edi)
c0105cb0:	89 fa                	mov    %edi,%edx
c0105cb2:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105cb5:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105cb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105cbb:	83 c4 24             	add    $0x24,%esp
c0105cbe:	5f                   	pop    %edi
c0105cbf:	5d                   	pop    %ebp
c0105cc0:	c3                   	ret    

c0105cc1 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105cc1:	55                   	push   %ebp
c0105cc2:	89 e5                	mov    %esp,%ebp
c0105cc4:	57                   	push   %edi
c0105cc5:	56                   	push   %esi
c0105cc6:	53                   	push   %ebx
c0105cc7:	83 ec 30             	sub    $0x30,%esp
c0105cca:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ccd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105cd0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105cd6:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cd9:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105cdf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105ce2:	73 42                	jae    c0105d26 <memmove+0x65>
c0105ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ce7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105cea:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ced:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105cf0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105cf3:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105cf6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105cf9:	c1 e8 02             	shr    $0x2,%eax
c0105cfc:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105cfe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105d01:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d04:	89 d7                	mov    %edx,%edi
c0105d06:	89 c6                	mov    %eax,%esi
c0105d08:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105d0a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105d0d:	83 e1 03             	and    $0x3,%ecx
c0105d10:	74 02                	je     c0105d14 <memmove+0x53>
c0105d12:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105d14:	89 f0                	mov    %esi,%eax
c0105d16:	89 fa                	mov    %edi,%edx
c0105d18:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105d1b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105d1e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105d21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d24:	eb 36                	jmp    c0105d5c <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105d26:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d29:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105d2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d2f:	01 c2                	add    %eax,%edx
c0105d31:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d34:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105d37:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d3a:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105d3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d40:	89 c1                	mov    %eax,%ecx
c0105d42:	89 d8                	mov    %ebx,%eax
c0105d44:	89 d6                	mov    %edx,%esi
c0105d46:	89 c7                	mov    %eax,%edi
c0105d48:	fd                   	std    
c0105d49:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105d4b:	fc                   	cld    
c0105d4c:	89 f8                	mov    %edi,%eax
c0105d4e:	89 f2                	mov    %esi,%edx
c0105d50:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105d53:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105d56:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105d5c:	83 c4 30             	add    $0x30,%esp
c0105d5f:	5b                   	pop    %ebx
c0105d60:	5e                   	pop    %esi
c0105d61:	5f                   	pop    %edi
c0105d62:	5d                   	pop    %ebp
c0105d63:	c3                   	ret    

c0105d64 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105d64:	55                   	push   %ebp
c0105d65:	89 e5                	mov    %esp,%ebp
c0105d67:	57                   	push   %edi
c0105d68:	56                   	push   %esi
c0105d69:	83 ec 20             	sub    $0x20,%esp
c0105d6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d72:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d75:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d78:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105d7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d81:	c1 e8 02             	shr    $0x2,%eax
c0105d84:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105d86:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d89:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d8c:	89 d7                	mov    %edx,%edi
c0105d8e:	89 c6                	mov    %eax,%esi
c0105d90:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105d92:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105d95:	83 e1 03             	and    $0x3,%ecx
c0105d98:	74 02                	je     c0105d9c <memcpy+0x38>
c0105d9a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105d9c:	89 f0                	mov    %esi,%eax
c0105d9e:	89 fa                	mov    %edi,%edx
c0105da0:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105da3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105da6:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105dac:	83 c4 20             	add    $0x20,%esp
c0105daf:	5e                   	pop    %esi
c0105db0:	5f                   	pop    %edi
c0105db1:	5d                   	pop    %ebp
c0105db2:	c3                   	ret    

c0105db3 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105db3:	55                   	push   %ebp
c0105db4:	89 e5                	mov    %esp,%ebp
c0105db6:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105db9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dc2:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105dc5:	eb 30                	jmp    c0105df7 <memcmp+0x44>
        if (*s1 != *s2) {
c0105dc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105dca:	0f b6 10             	movzbl (%eax),%edx
c0105dcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105dd0:	0f b6 00             	movzbl (%eax),%eax
c0105dd3:	38 c2                	cmp    %al,%dl
c0105dd5:	74 18                	je     c0105def <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105dda:	0f b6 00             	movzbl (%eax),%eax
c0105ddd:	0f b6 d0             	movzbl %al,%edx
c0105de0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105de3:	0f b6 00             	movzbl (%eax),%eax
c0105de6:	0f b6 c0             	movzbl %al,%eax
c0105de9:	29 c2                	sub    %eax,%edx
c0105deb:	89 d0                	mov    %edx,%eax
c0105ded:	eb 1a                	jmp    c0105e09 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105def:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105df3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105df7:	8b 45 10             	mov    0x10(%ebp),%eax
c0105dfa:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105dfd:	89 55 10             	mov    %edx,0x10(%ebp)
c0105e00:	85 c0                	test   %eax,%eax
c0105e02:	75 c3                	jne    c0105dc7 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105e04:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105e09:	c9                   	leave  
c0105e0a:	c3                   	ret    
