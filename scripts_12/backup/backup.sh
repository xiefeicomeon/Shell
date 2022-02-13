#!/bin/bash
#本shell脚本用来打包文件，并将其发送到对应的机器，输入参数为backup.txt
#删除文件中的空行
sed -i '/^\s*$/d' $1
#读取文件内容并存入数组，一行代表数组的一个值
temp=$(cat $1 | tr -d '\r')
content=$(echo "$temp" | tr -d '\n')
# echo " print contents"
# echo "$content"
IFS=" ;"
#paths数组存储每一行
paths=($content)

#  echo " print every line"
#  echo ${paths[@]}
paths_num=${#paths[@]}
unset IFS
#创建备份文件夹，用来存储待备份的文件
#基路径
backup_basePath="/home/smart"
#备份文件夹
dir_Backup="Backup"
mkdir "$backup_basePath/$dir_Backup"
#对每一行内容进行解析
#第一个参数是打包路径，后面是需打包的文件名或者文件夹名


  for((i =0;i<$paths_num;i++ ));
     do
     value=${paths[i]}
     if [[ "$value" != "" ]];then
   #   echo " print value"
   #   echo $value
       #生成参数数组 
        IFS=','
       para_Araay=($value)
      # echo " print each file"
      # echo ${para_Araay[@]}
      # echo ${#para_Araay[@]}
       #获取备份路径
       path_file=${para_Araay[0]}
       #判断目录是否存在
     #if [[ -d $path_file ]];then
        #获取需备份的文件数目+1
        para_nums=${#para_Araay[@]}
        #创建备份存放目录并记录原始备份路径到path.txt文件
        backup_Path="$backup_basePath/$dir_Backup/$i"
        mkdir $backup_Path
        cd $backup_Path
        touch path.txt
        echo $path_file > path.txt

        #进入原始备份目录
        cd $path_file
        for (( n=1; n<$para_nums;n++ ));do
            name=${para_Araay[n]}
         if [[ -d $name ]];then
          cp -R $name $backup_Path
         elif [[ -f $name ]];then
          cp  $name $backup_Path
         else
            echo "the child directory or file is not exist"
         fi
        done
     else
      echo "the directory is not exist"
      fi
    
   # # fi
 unset IFS
  done
 
#打包压缩文件
cd "$backup_basePath"
tar_Path="$backup_basePath/$dir_Backup.tar.gz"
tar -czvf $tar_Path "$dir_Backup"
cd ../
rm -rf "$backup_basePath/$dir_Backup"

