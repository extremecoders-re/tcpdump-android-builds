# Tcpdump Android Builds

Precompiled Tcpdump binaries for Android are provided for ARM, ARM64, X86, X86-64. Download from [releases](https://github.com/extremecoders-re/tcpdump-android-builds/releases).

```
Tcpdump version: 4.9.2
Libpcap version: 1.9.0
Default android API: 23
```

## Compilation Steps

1. Download the Android NDK from https://developer.android.com/ndk/downloads/.
    Extract the zip to a suitable location.

    ```
    $ wget https://dl.google.com/android/repository/android-ndk-r18b-linux-x86_64.zip
    ```

2. Clone the repository

    ```
    $ git clone https://github.com/extremecoders-re/tcpdump-android-builds.git
    $ cd tcpdump-android-builds
    ```

3. For compiling, set `NDK` to the location of the android sdk directory and run the corresponding build script.
    ```
    $ NDK=/home/ubuntu/workspace/android-ndk-rxxx/ ./build_x86.sh
    $ NDK=/home/ubuntu/workspace/android-ndk-rxxx/ ./build_x86_64.sh
    $ NDK=/home/ubuntu/workspace/android-ndk-rxxx/ ./build_arm.sh
    $ NDK=/home/ubuntu/workspace/android-ndk-rxxx/ ./build_arm64.sh
    ```

4. Compiled binaries will be located in the corresponding `tcpdumpbuild` directory.


## Compile libpcap for multiple targets and API versions

You can use the `build_libpcap_all.sh` script to run the scripts mentioned above for multiple targets and Android API versions.
This can be useful if you need to buid libpcap for multiple targets / API versions.

1. Run the script `build_libpcap_all.sh` and set `NDK` to the location of the android sdk directory.

2. You can also specify the following parameters:

  - `OUTPUT_DIR` for the output directory. The default is `libpcap_all_targets`.
  - `TARGETS` one or more targets from this list: `arm arm64 x86 x86_64`. The default is all of them.
  - `API_MIN` min API version. The default is 21.
  - `API_MAX` max API version. The default is 30.

3. Examples:
    ```
    $ NDK=/home/ubuntu/workspace/android-ndk-rxxx/ ./build_libpcap_all.sh
    $ NDK=/home/ubuntu/workspace/android-ndk-rxxx/ OUTPUT_DIR=my_dir ./build_libpcap_all.sh
    $ NDK=/home/ubuntu/workspace/android-ndk-rxxx/ TARGETS="x86 x86_64" ./build_libpcap_all.sh
    $ NDK=/home/ubuntu/workspace/android-ndk-rxxx/ API_MIN=21 API_MAX=30 /build_libpcap_all.sh
    ```

## How to use tcpdump?

- https://www.tcpdump.org/manpages/tcpdump.1.html
- https://www.andreafortuna.org/technology/android/how-to-install-and-run-tcpdump-on-android-devices/

## References

- https://github.com/eakteam/tcpdump-android
- https://github.com/chatch/tcpdump-android
- https://github.com/imrivera/build-android-tcpdump
- https://developer.android.com/ndk/guides/standalone_toolchain