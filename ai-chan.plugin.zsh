
#!/bin/zsh
ai_detect_bicode() {
    detect_bicode_f() {
        # set -x
        
        # 原理：
        # 1、通常情况下，bitcode 会存在以下两个位置
        # 2、如果是 bitcode marker，size == 0x0000000000000001
        
        # sectname __bitcode
        # segname __LLVM
        #     addr 0x0000000000000100
        #     size 0x0000000000002290
        
        # sectname __bundle
        # segname __LLVM
        #     addr 0x0000000000720000
        #     size 0x0000000000000001
        local sizeInfo=$(otool -l $1 | egrep "(sectname __bundle)|(sectname __bitcode)" -A 3 | grep "segname __LLVM" -A 2)
        if [[ $(echo $sizeInfo | grep "size" -c) -gt 0 ]];then
            if [[ $(echo $sizeInfo | grep "size 0x0000000000000001" -c) -gt 0 ]];then
                echo " ⚠️  检测到 bitcode marker"
            else
                echo " ✅ 检测到 bitcode "
            fi
        else
            echo " ❌ 未检测到 bitcode"
        fi
    }
    
    if [[ "$#" == "0" ]];
    then
        local workdir=$(pwd)
    else
        if test -d $1;then
            local  workdir=$1
            echo "开始搜索" ${workdir}
            detect_f() {
                if [[ $(file $1 | grep -c "Mach-O") -gt 0 ]];then
                    echo "检测到 Mach-O 文件 \n $(pwd)/$1";
                    detect_bicode_f $1
                fi
            }
            trav_folder() {
                if [[ "${1}" == '.git' ]];
                then
                    return 0
                fi
                cd $1
                flist=`ls .`
                for f in `ls .`; do
                    if test -d $f;then
                        trav_folder $f
                        cd ..
                    else
                        detect_f $f
                    fi
                done
            }
            trav_folder $workdir
        else
            echo "开始检测${1}"
            detect_bicode_f $1
        fi
    fi
}
