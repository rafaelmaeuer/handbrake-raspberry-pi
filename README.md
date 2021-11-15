# HandBrake on Raspberry Pi

Building HandBrake CLI and GUI on Raspberry Pi 4 including x265 codec

![HandBrake on RPi4](images/HandBrake-on-RPi4.png)

Does it make sense to build HandBrake on Raspberry Pi? Be warned it wont be fast. Many times slower than Intel CPU laptop. But it works so why not.

I have managed successfully to compile it on RPi 2B+, 3, 3B+ and 4 running Raspbian based on Debian 9 and 10.

**This repository includes [scripts](./scripts) and [desktop-shortcuts](./desktop) to:**

- monitor temperature while encoding
- limit CPU usage for encoding
- automatic shutdown after encoding
- send notification (ifttt) before shutdown
- delay countdown for user interruption
- eject/spindown of HDD when shutdown
- scan h264 level of MKV (recursively)

### 1. Install all dependencies

```sh
sudo apt-get install autoconf automake build-essential cmake git libass-dev libbz2-dev libfontconfig1-dev libfreetype6-dev libfribidi-dev libharfbuzz-dev libjansson-dev liblzma-dev libmp3lame-dev libnuma-dev libogg-dev libopus-dev libsamplerate-dev libspeex-dev libtheora-dev libtool libtool-bin libvorbis-dev libx264-dev libxml2-dev libvpx-dev m4 make ninja-build patch pkg-config python tar zlib1g-dev patch libvpx-dev xz-utils bzip2 zlib1g libturbojpeg0-dev appstream
```

For GUI version add:

```sh
sudo apt-get install intltool libappindicator-dev libdbus-glib-1-dev libglib2.0-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgtk-3-dev libgudev-1.0-dev libnotify-dev
```

On Debian 9 add:

```sh
sudo apt-get install libwebkitgtk-3.0-dev
```

On Debian 10 add:

```sh
sudo apt-get install libwebkit2gtk-4.0-dev
```

### 2. Install nasm and meson

On Debian 9 nasm and meson are too old so we need newer ones:

  - Install nasm

    ```sh
    sudo curl -L 'http://ftp.debian.org/debian/pool/main/n/nasm/nasm_2.14-1_armhf.deb' -o /var/cache/apt/archives/nasm_2.14-1_armhf.deb && \
    sudo dpkg -i /var/cache/apt/archives/nasm_2.14-1_armhf.deb
    ```

  - Install meson

    ```sh
    sudo add-apt-repository -s 'deb http://deb.debian.org/debian stretch-backports main' && \
    sudo apt-get update && \
    sudo apt-get -t stretch-backports install meson
    ```

On Debian 10 things are easier:

```sh
sudo apt-get install meson nasm
```

### 3. Get the HandBrake source code

Get version 1.4.2 of HandBrake from github repo

```sh
git clone -b 1.4.2 https://github.com/HandBrake/HandBrake.git && cd HandBrake
```

### 4. Add extra configure parameters to X265 module

Without it compilation will fail on RPi

```sh
echo "X265_8.CONFIGURE.extra +=  -DENABLE_ASSEMBLY=OFF -DENABLE_PIC=ON -DENABLE_AGGRESSIVE_CHECKS=ON -DENABLE_TESTS=ON -DCMAKE_SKIP_RPATH=ON" >> ./contrib/x265_8bit/module.defs \
&& \
echo "X265_10.CONFIGURE.extra +=  -DENABLE_ASSEMBLY=OFF -DENABLE_PIC=ON -DENABLE_AGGRESSIVE_CHECKS=ON -DENABLE_TESTS=ON -DCMAKE_SKIP_RPATH=ON" >>  ./contrib/x265_10bit/module.defs \
&& \
echo "X265_12.CONFIGURE.extra +=  -DENABLE_ASSEMBLY=OFF -DENABLE_PIC=ON -DENABLE_AGGRESSIVE_CHECKS=ON -DENABLE_TESTS=ON -DCMAKE_SKIP_RPATH=ON" >>  ./contrib/x265_12bit/module.defs \
&& \
echo "X265.CONFIGURE.extra  +=  -DENABLE_ASSEMBLY=OFF -DENABLE_PIC=ON -DENABLE_AGGRESSIVE_CHECKS=ON -DENABLE_TESTS=ON -DCMAKE_SKIP_RPATH=ON" >>  ./contrib/x265/module.defs
```

### 5. Configure the project

For CLI only:

```sh
./configure --launch-jobs=$(nproc) --disable-gtk --disable-nvenc --disable-qsv --enable-fdk-aac
```

For CLI and GUI:

```sh
./configure --launch-jobs=$(nproc) --disable-nvenc --disable-qsv --enable-fdk-aac
```

### 6. Make quick-and-dirty hack to x265 source code

Code compiles with `DENABLE_ASSEMBLY=OFF` but x265 code does not take into account that it is not handled correctly for ARMv7 (I have reported it to X265 guys so maybe in the future it wont be required if they modify their code)

But first start building so things get downloaded

```sh
cd build
```

```sh
make x265
```

Wait until you see that files have been downloaded and patched. It is the first thing happening. Then stop the rest by pressing CTRL-C.

Now we can make it raspberry pi compatible:

```sh
nano ./contrib/x265/x265_3.5/source/common/primitives.cpp
```

*Note: `x265_3.5` folder can be different as x265 software is an active project and its version can change. Modify it accordingly.*

Change the following pre-compiler directive - at the end of the file:

```cpp
#if X265_ARCH_ARM == 0
void PFX(cpu_neon_test)(void) {}
int PFX(cpu_fast_neon_mrc_test)(void) { return 0; }
#endif // X265_ARCH_ARM
```

to

```cpp
#if X265_ARCH_ARM != 0
void PFX(cpu_neon_test)(void) {}
int PFX(cpu_fast_neon_mrc_test)(void) { return 0; }
#endif // X265_ARCH_ARM
```

Just change `==` condition in the first line to `!=`

### 7. Let's build

If you see some errors after `make clean` you can safely ignore them. This step is only needed to clean x265 interrupted build.

```sh
make clean
```

Now start the full HandBrake build.

```sh
make -j $(nproc)
```

Take a break - it takes some time. Approximately 25 min on RPi 4. And much longer on older RPi models.

### 8. When finished executable binaries should be ready

- CLI: `build/HandBrakeCLI`
- GUI: `build/gtk/src/ghb`

### 9. Use it straight away or install properly

```sh
sudo make --directory=. install
```

### 10. Basic CLI usage

```sh
HandBrakeCLI -i PATH-OF-SOURCE-FILE -o NAME-OF-OUTPUT-FILE --"preset-name"
```

To see available profiles:

```sh
HandBrakeCLI --preset-list
```

Example:

```sh
./HandBrakeCLI -i /media/Films/test.avi -o /media/Films/test.mkv --preset="H.264 MKV 720p30"
```

### Sources

- [Handbrake v1.3.2 on RaspberryPi 4 with Raspian Buster](https://github.com/kapitainsky/handbreak-RaspberryPi/issues/2)
- [HandBrake Documentation (1.3.0) - Installing dependencies on Debian](https://handbrake.fr/docs/en/1.3.0/developer/install-dependencies-debian.html)
- [HandBrake Documentation (1.3.0) - Building HandBrake for Linux](https://handbrake.fr/docs/en/1.3.0/developer/build-linux.html)
- [HandBrake 0.10.5 nightly and ARM (ARMv7) – short benchmark and how-to](https://mattgadient.com/2016/06/20/handbrake-0-10-5-nightly-and-arm-armv7-short-benchmark-and-how-to/)
- [Scrape videos and reencode them directly on the Raspberry Pi with sselph's scraper](https://retropie.org.uk/forum/topic/13092/scrape-videos-and-reencode-them-directly-on-the-raspberry-pi-with-sselph-s-scraper)
- [How to Convert Videos in Linux Using the Command Line](https://www.linux.com/learn/how-convert-videos-linux-using-command-line)
[HandBrake Documentation - CLI Options](https://handbrake.fr/docs/en/1.3.0/cli/cli-options.html)
