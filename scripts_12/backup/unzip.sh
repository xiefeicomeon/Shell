#!/bin/bash
 #echo "hello world"
backup_basePath="/home/smart/Backup"
file_numbers=100
#解压缩打包文件
tar_Path="/home/smart/Backup.tar.gz"
tar -xzvf $tar_Path -C /home/smart
cd $backup_basePath
for (( i=0;i<$file_numbers;i++ ));do
   dir_name=$i
  if [[ -d $dir_name ]];then
    cd $dir_name
    #获取解压的原始路径
     origin_Path=$(cat path.txt) 
     #echo $origin_Path
     rm path.txt
    #对每个文件或者文件夹进行移动
        for file in ./* ;do
        #如果是目录，提取目录名，判断A5000里面对应路径有没有该目录
        #如果有则重命名A5000里面的对应目录然后移动目录，
        #如果没有则进入该目录并移动其子文件
        if [[ -d $file ]];then
        dir_name=${file##*/}
        find_name=$( ls "$origin_Path"| grep "^$dir_name$")
        #echo $dir_name
        if [[ $find_name == '' ]];then
          cd $file
          for childfile in ./* ;do
          child_dir_name=${childfile##*/}
          child_find_name=$( ls "$origin_Path"| grep "^$child_dir_name$")
          #判断原始路径是否包含子目录或者文件，如果包含，删除并移动子目录或者文件，不包含则移动子目录或者文件
          if [[ $child_find_name != '' ]];then
          #重命名原来文件或者子目录
           mv "$origin_Path/$child_dir_name"  "$origin_Path/$child_dir_name.bak"
          fi
          #移动文件
           mv  $childfile $origin_Path

           done
           
        else
         #重命名原来文件夹 
         mv "$origin_Path/$dir_name" "$origin_Path/$dir_name.bak"
         #移动文件
         mv $file $origin_Path
        fi  
        
        else 
         mv  $file $origin_Path
        #echo $file
        
        fi
        done
  else
        break
  fi
  cd $backup_basePath
done

echo " mv success"
cd /home/smart
rm -rf $backup_basePath
 rm  -rf $tar_Path
rm -rf unzip.sh




