FROM ubuntu:24.04

RUN apt update && apt install -y \
        cmake \
        git \
        g++ \
        python-is-python3 \
        libxrandr-dev \
        libxinerama-dev \
        libxcursor-dev \
        mesa-common-dev \
        libx11-xcb-dev \
        libxi-dev

WORKDIR /dawn

RUN git init && \
    git remote add origin https://github.com/google/dawn.git && \
    git fetch --depth 1 origin fbe37c15226180b3cda9f1e8b2abbedc20949334 && \
    git checkout FETCH_HEAD && \
    python tools/fetch_dawn_dependencies.py

WORKDIR /dawn/out

RUN cmake -DDAWN_ENABLE_PIC=ON -DCMAKE_CXX_FLAGS="-DDAWN_DISABLE_LOGGING" .. && \
    make -j`nproc` webgpu_dawn && \
    strip -s ./src/dawn/native/libwebgpu_dawn.so

FROM scratch
WORKDIR /dawn/out
COPY --from=0 /dawn/out/src/dawn/native/libwebgpu_dawn.so /dawn/out/
COPY --from=0 /dawn/out/gen/include/dawn/webgpu.h /dawn/out/
