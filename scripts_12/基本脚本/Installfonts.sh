#!/bin/bash
path0=/usr/share/fonts/zh_CN

mkdir $path0
path1="$(pwd)/$1"

cp $path1 $path0
cd $path0
chmod 766 $1
cd ~
mkfontscale
mkfontdir
fc-cache -fv


