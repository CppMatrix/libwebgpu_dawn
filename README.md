libwebgpu_dawn.so
==

Build:

    docker build -t dawn .

Copy to host:

    docker create --name dawn-tmp dawn --
    docker cp dawn-tmp:/dawn/out/libwebgpu_dawn.so .
    docker cp dawn-tmp:/dawn/out/webgpu.h .
    docker rm dawn-tmp
