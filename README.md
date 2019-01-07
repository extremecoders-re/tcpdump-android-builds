# Tcpdump Android Builds

Precompiled Tcpdump binaries for Android are provided for ARM, ARM64, X86, X86-64. Download from [releases](https://github.com/extremecoders-re/tcpdump-android-builds/releases).

```
Tcpdump version: 4.9.2
Libpcap version: 1.9.0
Android API: 23
NDK: android-ndk-r18b
```

## Compilation Steps

1. Download the Android NDK from https://developer.android.com/ndk/downloads/. The latest available at the time of writing is `ndk-r18b`.
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
    $ NDK=/home/ubuntu/workspace/android-ndk-r18b/ ./build_x86.sh
    $ NDK=/home/ubuntu/workspace/android-ndk-r18b/ ./build_x86_64.sh
    $ NDK=/home/ubuntu/workspace/android-ndk-r18b/ ./build_arm.sh
    $ NDK=/home/ubuntu/workspace/android-ndk-r18b/ ./build_arm64.sh
    ```

4. Compiled binaries will be located in the corresponding `tcpdumpbuild` directory.

## How to use tcpdump?

- https://www.tcpdump.org/manpages/tcpdump.1.html
- https://www.andreafortuna.org/technology/android/how-to-install-and-run-tcpdump-on-android-devices/

## References

- https://github.com/eakteam/tcpdump-android
- https://github.com/chatch/tcpdump-android
- https://github.com/imrivera/build-android-tcpdump
- https://developer.android.com/ndk/guides/standalone_toolchain