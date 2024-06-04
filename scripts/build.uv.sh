#!/bin/sh -e

UV_VERSION="1.48.0"
echo $ANDROID_NDK_PATH # 替换为你的 Android NDK 路径

# 设置交叉编译工具链路径
export PATH="$ANDROID_NDK_PATH/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH"

# 设置交叉编译目标
export TARGET="aarch64-linux-android"

mkdir -p deps
mkdir -p deps/include
mkdir -p deps/lib

mkdir -p build && cd build

# 下载 libuv 源码
wget https://dist.libuv.org/dist/v${UV_VERSION}/libuv-v${UV_VERSION}.tar.gz -O v${UV_VERSION}.tar.gz
tar -xzf v${UV_VERSION}.tar.gz

cd libuv-v${UV_VERSION}
sh autogen.sh

# 配置交叉编译环境
./configure --host=$TARGET --disable-shared

# 编译并安装
make -j$(nproc || sysctl -n hw.ncpu || sysctl -n hw.logicalcpu)
make install DESTDIR="../../deps"

cd ../..

# 如果需要，可以复制静态库到 Android 项目中
# cp deps/lib/libuv.a /path/to/your/android/project/libs

# 如果需要，可以将头文件复制到 Android 项目中
# cp -fr deps/include/* /path/to/your/android/project/include
