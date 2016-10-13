#!/bin/sh
# total=0
# rootdir=""
function scandir() {
    local cur_dir parent_dir workdir 
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
            	if test $mached -eq 1
            		then
                    oecount=$(($oecount+1))
            		name=$(ls -l ${cur_dir}| egrep ".*.png" | awk -F ' ' '{print $NF}')
            		regx=$(echo $name | grep ".*@3x.png")
            		if test $regx
            			then
            			ancount=$(($ancount+1))
                	echo  "warning 3x only imgae --- $regx"
            		fi
                elif test $mached -eq 2; then
                    twcount=$(($twcount+1))
                elif test $mached -eq 3; then
                    tecount=$(($tecount+1))
            	fi
                break
            fi
        fi
 
		# if test $cur_dir = $rootdir
		# 	then
		# 	total=$(($total-1))
		# 	if test $total -eq 0
		# 		then
		# 		echo 'total ancount' $ancount
		# 	fi
		# fi

    done
}
#三种规格
tecount=0 
#两种规格
twcount=0
#一种规格
oecount=0
#只有一个3x图片
ancount=0
# total=0
if test -d $1
then
    scandir $1
    echo 'one asset image count' $oecount
    echo 'two asset image count' $twcount
    echo 'three asset image count' $tecount
    echo '3x only imgae image count' $ancount
elif test -f $1
then
    echo "you input a file but not a directory,pls reinput and try again"
    exit 1
else
    echo "the Directory isn't exist which you input,pls input a new one!!"
    exit 1
fi