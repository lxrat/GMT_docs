绘制震源球
==========

:doc:`/module/psmeca` 模块可以用于绘制震源机制解。

绘制震源机制解就要向 GMT 提供震源的信息：震源机制解、震源位置、沙滩球位置和震级等等。
其中，震源机制解本身有多种描述方法，需要告诉 GMT 使用的是究竟哪种描述方式。
:doc:`/module/psmeca` 模块用 ``-S`` 选项决定震源球的描述方式，支持的描述方式有五种：

#. Aki-Richards 描述
#. Harvard CMT
#. GCMT 零迹矩张量
#. 两个断层平面的部分参数
#. T、N、P轴

具体请见模块手册。

在告知 gmt 震源机制解的描述方法后，就要根据相应的描述方法，向 gmt 输入相应的数据。
下面由简到繁讲解。

绘制单个震源球
--------------

.. gmt-plot::
   :language: bash
   :caption: 绘制单个震源球

   #!/bin/bash

   J=Q104/15c
   R=102.5/105.5/30.5/32.5
   PS=beachball_1.ps
   gmt psbasemap -J$J -R$R -BWSEN -Ba -P -K > $PS
   echo 104.33 31.9 39.8 32 64 85 7 0 0 A | gmt psmeca -J -R -CP5p -Sa1c -M -O>> $PS
   # 依次向 gmt 输入经度、纬度、深度(km)、strike、dip、rake、震级、newX、newY 和 ID

震源球大小随震级变化
--------------------

删除参数 -M，即可实现震源球大小随震级变化。
-Sa1c 的 1c 就是指明 5 级地震的大小为 1c。
其他地震的大小按照如下公式计算::

        size = M / 5 * <scale>

另外，现在需要画多个地震的震源机制，仍然用 echo 传给 gmt 的形式是不合理的。
可以用表数据的形式传入。

.. gmt-plot::
   :language: bash
   :caption: 震源球大小随震级变化

   #!/bin/bash

   J=Q104/15c
   R=102.5/105.5/30.5/32.5
   PS=beachball_2.ps

   gmt psbasemap -J$J -R$R -BWSEN -Ba -P -K > $PS
   # 依次向 gmt 输入经度、纬度、深度(km)、strike、dip、rake、震级、newX、newY 和 ID
   gmt psmeca -J -R -CP5p -Sa1c -O >> $PS << EOF
   104.33 31.91 39.8 32 64 85 7 0 0 A
   104.11 31.52 27.1 22 53 57 6 0 0 B
   EOF
   rm gmt.*

震源球大小随震级变化，颜色随深度变化
------------------------------------

现在用压缩区的颜色表示震源的深度。
先生成一个 cpt 文件，为每个深度段设置不同的颜色。
然后，使用 psmeca 模块的时候用 -Z 参数调用即可。

.. gmt-plot::
   :language: bash
   :caption: 震源球大小随震级变化，颜色随深度变化

   #!/bin/bash
   #   绘制震源机制分布图，震级控制震源球大小，深度控制震源球颜色

   J=Q104/15c
   R=102.5/105.5/30.5/32.5
   PS=beachball_3.ps
   CPT=meca.cpt

   # 生成CPT文件，为每个深度段设置不同的颜色
   cat << EOF > $CPT
    0   0-1-1   20   0-1-1
   20  60-1-1   40  60-1-1
   40 120-1-1   60 120-1-1
   60 240-1-1  100 240-1-1
   EOF

   gmt psbasemap -J$J -R$R -Ba -BWSEN -P -K > $PS
   gmt psmeca -J -R -CP5p -Sa1.3c -Z$CPT -K -O >> $PS << EOF
   # 经度 纬度 深度(km) strike dip rake 震级 newX newY ID
   104.33 31.91 39.8  32 64   85 7.0      0     0 A
   104.11 31.52 27.1  22 53   57 6.0      0     0 B
   103.67 31.13  6.4  86 32  -65 8.0      0     0 C
   103.90 31.34 43.6 194 84  179 4.9 104.18 30.84 D
   103.72 31.44 67.3  73 84 -162 4.9 103.12 31.64 E
   104.12 31.78 12.7 186 68  107 4.7 103.83 32.26 F
   104.23 31.61 62.0  86 63  -51 4.7 104.96 31.69 G
   EOF

   gmt psscale -J -R -C$CPT -DjBL+w5c/0.5c+ml+o0.8c/0.4c -Bx+lDepth -By+lkm -L -S -O >> $PS
   rm gmt.* $CPT
