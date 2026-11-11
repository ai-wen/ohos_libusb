setarm32ENV() {
    export AS=${OHOS_SDK}/native/llvm/bin/llvm-as
    export CC=${OHOS_SDK}/native/llvm/bin/arm-linux-ohos-clang
    export CXX=${OHOS_SDK}/native/llvm/bin/arm-linux-ohos-clang++
    export LD=${OHOS_SDK}/native/llvm/bin/ld.lld
    export STRIP=${OHOS_SDK}/native/llvm/bin/llvm-strip
    export RANLIB=${OHOS_SDK}/native/llvm/bin/llvm-ranlib
    export OBJDUMP=${OHOS_SDK}/native/llvm/bin/llvm-objdump
    export OBJCOPY=${OHOS_SDK}/native/llvm/bin/llvm-objcopy
    export NM=${OHOS_SDK}/native/llvm/bin/llvm-nm
    export AR=${OHOS_SDK}/native/llvm/bin/llvm-ar
    export CFLAGS="-DOHOS_NDK -fPIC -march=armv7a -D__MUSL__=1 -O3 -D_FORTIFY_SOURCE=2 -fstack-protector-strong"
    export CXXFLAGS="-DOHOS_NDK -fPIC -march=armv7a -D__MUSL__=1 -O3 -D_FORTIFY_SOURCE=2 -fstack-protector-strong"
    export LDFLAGS=""
}

unsetarm32ENV() {
  unset AS CC CXX LD STRIP RANLIB OBJDUMP OBJCOPY NM AR CFLAGS CXXFLAGS LDFLAGS
}

setarm64ENV() {
  export AS=${OHOS_SDK}/native/llvm/bin/llvm-as
  export CC=${OHOS_SDK}/native/llvm/bin/aarch64-linux-ohos-clang
  export CXX=${OHOS_SDK}/native/llvm/bin/aarch64-linux-ohos-clang++
  export LD=${OHOS_SDK}/native/llvm/bin/ld.lld
  export STRIP=${OHOS_SDK}/native/llvm/bin/llvm-strip
  export RANLIB=${OHOS_SDK}/native/llvm/bin/llvm-ranlib
  export OBJDUMP=${OHOS_SDK}/native/llvm/bin/llvm-objdump
  export OBJCOPY=${OHOS_SDK}/native/llvm/bin/llvm-objcopy
  export NM=${OHOS_SDK}/native/llvm/bin/llvm-nm
  export AR=${OHOS_SDK}/native/llvm/bin/llvm-ar
  export CFLAGS="-DOHOS_NDK -fPIC -D__MUSL__=1 -O3 -D_FORTIFY_SOURCE=2 -fstack-protector-strong"
  export CXXFLAGS="-DOHOS_NDK -fPIC -D__MUSL__=1 -O3 -D_FORTIFY_SOURCE=2 -fstack-protector-strong"
  export LDFLAGS=""
}

unsetarm64ENV() {
    unset AS CC CXX LD STRIP RANLIB OBJDUMP OBJCOPY NM AR CFLAGS CXXFLAGS LDFLAGS
}

setx86_64ENV() {
  export AS=${OHOS_SDK}/native/llvm/bin/llvm-as
  export CC=${OHOS_SDK}/native/llvm/bin/x86_64-linux-ohos-clang
  export CXX=${OHOS_SDK}/native/llvm/bin/x86_64-linux-ohos-clang++
  export LD=${OHOS_SDK}/native/llvm/bin/ld.lld
  export STRIP=${OHOS_SDK}/native/llvm/bin/llvm-strip
  export RANLIB=${OHOS_SDK}/native/llvm/bin/llvm-ranlib
  export OBJDUMP=${OHOS_SDK}/native/llvm/bin/llvm-objdump
  export OBJCOPY=${OHOS_SDK}/native/llvm/bin/llvm-objcopy
  export NM=${OHOS_SDK}/native/llvm/bin/llvm-nm
  export AR=${OHOS_SDK}/native/llvm/bin/llvm-ar
  export CFLAGS="-DOHOS_NDK -fPIC -D__MUSL__=1 -O3 -D_FORTIFY_SOURCE=2 -fstack-protector-strong"
  export CXXFLAGS="-DOHOS_NDK -fPIC -D__MUSL__=1 -O3 -D_FORTIFY_SOURCE=2 -fstack-protector-strong"
  export LDFLAGS=""
}
unsetx86_64ENV() {
    unset AS CC CXX LD STRIP RANLIB OBJDUMP OBJCOPY NM AR CFLAGS CXXFLAGS LDFLAGS
}

archs=("armeabi-v7a" "arm64-v8a" "x86_64")
hosts=("arm-linux" "aarch64-linux" "x86_64-linux")

#source="https://gitee.com/mirrors/libusb/repository/archive/v1.0.26.zip"
#https://repo.huaweicloud.com/openharmony/os/7.0-Release/ohos-sdk-windows_linux-public_20260829.tar.gz

#unzip native-linux-x64-26.0.0.38-Release.zip
unzip libusb-v1.0.26.zip
cd libusb-v1.0.26
patch -p1 < ../libusb_ohos.patch

OHOS_SDK=$(pwd)

for i in "${!archs[@]}"; do
    arch="${archs[$i]}"
    if [ $arch == "armeabi-v7a" ]
    then
        unsetarm32ENV
        setarm32ENV
        host="${hosts[$i]}"
    fi
    if [ $arch == "arm64-v8a" ]
    then
        unsetarm64ENV
        setarm64ENV
        host="${hosts[$i]}"
    fi
    if [ $arch == "x86_64" ]
    then
        unsetx86_64ENV
        setx86_64ENV
        host="${hosts[$i]}"
    fi

    echo "arch=$arch host=$host"
    echo "$CC"
    export CFLAGS="$CFLAGS -g -O0"
    export CXXFLAGS="$CXXFLAGS -g -O0"
    autoreconf -ifv
    ./configure --host=$host --disable-udev --enable-static=yes
    #make
done
