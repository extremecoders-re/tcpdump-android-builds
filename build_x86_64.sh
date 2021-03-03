#!/bin/bash

tcpdump_ver=4.9.2
libpcap_ver=1.9.0
android_api_def=23
toolchain_arch=x86_64
toolchain_dir=toolchain_x86_64

#-------------------------------------------------------#

tcpdump_dir=tcpdump-${tcpdump_ver}
libpcap_dir=libpcap-${libpcap_ver}


exit_error()
{
    echo " _______"
    echo "|       |"
    echo "| ERROR |"
    echo "|_______|"
    exit 1
}

if [ ${NDK} ]
then
    ndk_dir=${NDK}
else
    echo Please specify NDK path
    exit_error
fi

ndk_dir=`readlink -f ${ndk_dir}`

if [ ${ANDROID_API} ]
then
    android_api=${ANDROID_API}
else
    android_api=${android_api_def}
fi

echo "_______________________"
echo ""
echo "NDK - ${ndk_dir}"
echo "Android API: ${android_api}"
echo "_______________________"

{
    if [ $# -ne 0 ]
    then
        if [ -d $1 ]
        then
            cd $1
        else
            echo directory $1 not found
            exit_error
        fi
    else
        mkdir tcpdumpbuild-${toolchain_arch}
        cd tcpdumpbuild-${toolchain_arch}
    fi
}



{
    echo " ____________________"
    echo "|                    |"
    echo "| TOOLCHAIN          |"
    echo "|____________________|"

    toolchain_dir=$ndk_dir/toolchains/llvm/prebuilt/linux-x86_64
    export sysroot=$toolchain_dir/sysroot
    export PATH=$toolchain_dir/bin:$PATH
        
    target_host=x86_64-linux-android
    target_host_with_api=$target_host$android_api
    export AR=llvm-ar
    export AS=$target_host_with_api-clang
    export CC=$target_host_with_api-clang
    export CXX=$target_host_with_api-clang++
    export LD=$target_host-ld
    export STRIP=$target_host-strip
    export RANLIB=$target_host-ranlib
    export STRIP=$target_host-strip
    export CFLAGS="-static -O2 -fPIE -fPIC --sysroot=$sysroot"
    export LDFLAGS="-pie --sysroot=$sysroot"
}

# download & untar libpcap + tcpdump
{
    echo " _______________________________"
    echo "|                               |"
    echo "| DOWNLOADING LIBPCAP & TCPDUMP |"
    echo "|_______________________________|"
    
    tcpdump_file=${tcpdump_dir}.tar.gz
    libpcap_file=${libpcap_dir}.tar.gz
    tcpdump_link=http://www.tcpdump.org/release/${tcpdump_file}
    libpcap_link=http://www.tcpdump.org/release/${libpcap_file}
    
    if [ -f ${tcpdump_file} ]
    then
        echo ${tcpdump_file} already downloaded! Nothing to do.
    else
        echo Download ${tcpdump_file}...
        wget ${tcpdump_link}
        if [ ! -f ${tcpdump_file} ]
        then
            exit_error
        fi
    fi

    if [ -f ${libpcap_file} ]
    then
        echo ${libpcap_file} already downloaded! Nothing to do.
    else
        echo Download ${libpcap_file}...
        wget ${libpcap_link}
        if [ ! -f ${libpcap_file} ]
        then
            exit_error
        fi
    fi

    if [ -d ${tcpdump_dir} ]
    then
        echo ${tcpdump_dir} directory already exist! Nothing to do.
    else
        echo untar ${tcpdump_file}
        tar -zxf ${tcpdump_file}
    fi
    
    if [ -d ${libpcap_dir} ]
    then
        echo ${libpcap_dir} directory already exist! Nothing to do.
    else
        echo untar ${libpcap_file}
        tar -zxf ${libpcap_file}
    fi
}

# build libpcap
{
    cd ${libpcap_dir}

    echo " _____________________"
    echo "|                     |"
    echo "| CONFIGURING LIBPCAP |"
    echo "|_____________________|"
    
    chmod +x configure
    ./configure --host=x86_64-linux-android --with-pcap=linux

    if [ $? -ne 0 ]
    then
        exit_error
    fi	

    echo " __________________"
    echo "|                  |"
    echo "| BUILDING LIBPCAP |"
    echo "|__________________|"

    chmod +x runlex.sh
    make

    if [ $? -ne 0 ]
    then
        exit_error
    fi

    cd ..
}

# build tcpdump
{
    cd ${tcpdump_dir}
    
    echo " _____________________"
    echo "|                     |"
    echo "| CONFIGURING TCPDUMP |"
    echo "|_____________________|"
        
    chmod +x configure
    ./configure --host=x86_64-linux-android --with-pcap=linux

    if [ $? -ne 0 ]
    then
        exit_error
    fi	

    echo " __________________"
    echo "|                  |"
    echo "| BUILDING TCPDUMP |"
    echo "|__________________|"
    
    sed -i".bak" "s/setprotoent/\/\/setprotoent/g" print-isakmp.c
    sed -i".bak" "s/endprotoent/\/\/endprotoent/g" print-isakmp.c

    make
    
    if [ $? -ne 0 ]
    then
        exit_error
    fi
    
    cd ..
}

mv ${tcpdump_dir}/tcpdump tcpdump-${toolchain_arch}
chmod +x tcpdump-${toolchain_arch}

echo " __________________"
echo "|                  |"
echo "| TCPDUMP IS READY |"
echo "|__________________|"
echo `pwd`/tcpdump-${toolchain_arch}
