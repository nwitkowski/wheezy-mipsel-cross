FROM debian:wheezy

RUN echo "deb-src http://ftp.ch.debian.org/debian/ wheezy main contrib non-free" >> /etc/apt/sources.list

RUN apt-get update

RUN mkdir /usr/src/mipsel-toolchain

WORKDIR /usr/src/mipsel-toolchain

RUN apt-get -y build-dep --no-install-recommends binutils
RUN apt-get -y source binutils
RUN cd binutils-2.*/  \
    && DEB_TARGET_ARCH=mipsel TARGET=mipsel dpkg-buildpackage -b
RUN dpkg -i binutils-mips*.deb

RUN apt-get -y build-dep --no-install-recommends gcc-4.7
RUN apt-get source gcc-4.7
RUN apt-get -y install --no-install-recommends xapt binutils-multiarch
RUN cd gcc-4.7-4.7.*/ \
    && DEB_TARGET_ARCH=mipsel DEB_CROSS_NO_BIARCH=yes with_deps_on_target_arch_pkgs=yes dpkg-buildpackage -d -T control \
    && xapt -a mipsel -m libc6-dev \
    && DEB_TARGET_ARCH=mipsel DEB_CROSS_NO_BIARCH=yes with_deps_on_target_arch_pkgs=yes dpkg-buildpackage -b

RUN dpkg -i *.deb


RUN ln -s /usr/bin/mipsel-linux-gnu-cpp-4.7 /usr/bin/mipsel-linux-gnu-cpp
RUN ln -s /usr/bin/mipsel-linux-gnu-gcc-ar-4.7 /usr/bin/mipsel-linux-gnu-gcc-ar
RUN ln -s /usr/bin/mipsel-linux-gnu-gcc-ranlib-4.7 /usr/bin/mipsel-linux-gnu-gcc-ranlib
RUN ln -s /usr/bin/mipsel-linux-gnu-g++-4.7 /usr/bin/mipsel-linux-gnu-g++
RUN ln -s /usr/bin/mipsel-linux-gnu-gccgo-4.7 /usr/bin/mipsel-linux-gnu-gccgo
RUN ln -s /usr/bin/mipsel-linux-gnu-gcov-4.7 /usr/bin/mipsel-linux-gnu-gcov
RUN ln -s /usr/bin/mipsel-linux-gnu-gcc-4.7 /usr/bin/mipsel-linux-gnu-gcc
RUN ln -s /usr/bin/mipsel-linux-gnu-gcc-nm-4.7 /usr/bin/mipsel-linux-gnu-gcc-nm
RUN ln -s /usr/bin/mipsel-linux-gnu-gfortran-4.7 /usr/bin/mipsel-linux-gnu-gfortran

ENV AS=/usr/bin/mipsel-linux-gnu-as \
    AR=/usr/bin/mipsel-linux-gnu-gcc-ar \
    CC=/usr/bin/mipsel-linux-gnu-gcc \
    CPP=/usr/bin/mipsel-linux-gnu-cpp \
    CXX=/usr/bin/mipsel-linux-gnu-g++ \
    LD=/usr/bin/mipsel-linux-gnu-ld

CMD ["/bin/bash"]
