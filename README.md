# Linux Kernel Build for RPi4

A script for building a kernel targeting the Raspberry Pi 4. Inspiration for this method comes from [gg7/gentoo-kernel-guide](https://github.com/gg7/gentoo-kernel-guide)

# Managing the kernel source

1. Creates a local mirror at `/usr/src/linux.git` 

       cd /usr/src
       git clone --mirror --bare git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git

2. Clone specific tag/branch into `/usr/src/linux-git-5.11.16`

       cd /usr/src
       git clone --single-branch --branch 5.11.16 linux.git linux-git-5.11.16

3. (Optional) Create symlink for `/usr/src/linux -> /usr/src/linux-git-5.11.16`
        
        test ! -e /usr/src/linux && ln -s /usr/src/linux /usr/src/linux-git-5.11.16

## Updating
Update kernel source to get new commits/branches/tags.

    cd /usr/src/linux.git
    git fetch --all --tags

Afterward repeat step 2 and 3 above to update the source.

# Configuring kernel

    cd /usr/src/linux
    git clean -xdf && git reset --hard HEAD # this is faster than mrproper
    make tinyconfig
    ~/rpi_kernel_build/kconfig.sh
    make olddefconfig
    make KCFLAGS="-march=armv8-a+crc+simd -mtune=cortex-a72 -ftree-vectorize" -j"$(nproc)" all
    
The Raspberry PI 4 has a cortex-a72. The cortex-a72 requires SIMD in each core. The `KCFLAGS` are optimizations that make this kernel build incompatible with most hardware other than the rpi4, this includes all previous version of the Raspberry Pi 1, 2, and 3.
