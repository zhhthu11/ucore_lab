# Rerport: LAB2

计13，张宏辉，2011011237


##练习1：实现 first-fit 连续物理内存分配算法（需要编程）

1. 设计实现过程

主要在源程序基础上实现default_pmm.c中的如下函数：

- default_init：无需修改。将nr_free置零即可
- default_init_memmap：已完成修改。需要对p进行SetPageProperty，并将list_add修改为list_add_before以保证访问列表时物理地址由小到大
- default_alloc_pages：已完成修改。线性扫描找到一个大小大于等于n的页之后，先利用原来的大block将空闲的插入正确的位置，再将大block删除，并且在分配页之后设置相应的reserved位。而大block如果有超过n的剩余部分，则剩余部分也作为一个block使用并标记。
- default_free_pages：已完成修改。线性扫描找到第一个基址比当前要释放的页的基址大的页，在插入的过程中对所插入页的flags进行修改，同时设置第一个插入页的property表示该block页数。关于相邻block的合并，如果后续页面的基址与当前插入的页面相邻，那么将这两个block合并。接着重新线性扫描，如果遇到一个页，以其开始的block正好与插入的block相邻则将两个block合并。

2. 算法改进空间

利用高级数据结构能节约时间开销

##练习2：实现寻找虚拟地址对应的页表项（需要编程）

