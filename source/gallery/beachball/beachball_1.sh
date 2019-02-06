#!/bin/bash

J=Q104/15c
R=102.5/105.5/30.5/32.5
PS=beachball_1.ps

gmt psbasemap -J$J -R$R -BWSEN -Ba -P -K > $PS
echo 104.33 31.9 39.8 32 64 85 7 0 0 A | gmt psmeca -J -R -CP5p -Sa1c -M -O>> $PS
# 依次向 gmt 输入经度、纬度、深度(km)、strike、dip、rake、震级、newX、newY 和 ID
