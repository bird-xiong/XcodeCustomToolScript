#!/bin/sh
count=0
# total=0
# rootdir=""
function scandir() {
    local cur_dir parent_dir workdir 
    # count=0
    workdir=$1
    cd ${workdir}
    if [ ${workdir} = "/" ]
    then
        cur_dir=""
    else
        cur_dir=$(pwd)
    fi

    # if test -z $rootdir
    # 	then
    # 	rootdir=$cur_dir
    # fi

    # if test $total -eq 0
    #     then
    #     total=$(ls -l ${cur_dir}| egrep "^-|^d"|wc -l)  
    # fi
    
    for dirlist in $(ls ${cur_dir})
    do
        if test -d ${dirlist};then
            cd ${dirlist}
            scandir ${cur_dir}/${dirlist}
            cd ..
        else
            isimagedir=$(echo `basename $cur_dir` | grep '.*.imageset')
            if test $isimagedir
            then 
            	mached=$(ls -l ${cur_dir}| egrep ".*.png"|wc -l)
            	if test $mached -lt 2
            		then
            		name=$(ls -l ${cur_dir}| egrep ".*.png" | awk -F ' ' '{print $NF}')
            		regx=$(echo $name | grep ".*@3x.png")
            		if test $regx
            			then
            			count=$(($count+1))
                	echo  "$cur_dir/$regx"
            		fi
            	fi
                break
            fi
        fi
 
		# if test $cur_dir = $rootdir
		# 	then
		# 	total=$(($total-1))
		# 	if test $total -eq 0
		# 		then
		# 		echo 'total count' $count
		# 	fi
		# fi

    done
}
if test -d $1
then
    scandir $1
    echo 'total count' $count
elif test -f $1
then
    echo "you input a file but not a directory,pls reinput and try again"
    exit 1
else
    echo "the Directory isn't exist which you input,pls input a new one!!"
    exit 1
fi