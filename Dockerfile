FROM ubuntu:18.04 as base

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NOWARNINGS yes

RUN mkdir /fuzzenv
WORKDIR /fuzzenv

RUN apt-get update && apt-get install -y \
        git \
        wget \
        build-essential \
        cmake \
        zlib1g-dev \
        clang \
        libexpat1-dev && \
        rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/google/AFL && \
        cd AFL && \
        make && \
        make install

# RUN git clone https://github.com/fuzzitdev/exiv2 --branch libfuzzer_integration_vanilla exiv2 && \
#         cd exiv2 && \
#         export CC=`which afl-gcc` && \
#         export CXX=`which afl-g++` &&\
#         mkdir build && \
#         cd build && \
#         cmake .. -DCMAKE_BUILD_TYPE=Release && \
#         cmake --build . && \
#         mkdir in && mkdir out && \
#         wget -O in/1.png https://www.fnordware.com/superpng/pnggrad8rgb.png
#         afl-fuzz -i in -o out ./bin/exiv2 @@

RUN git clone https://github.com/fuzzitdev/exiv2 --branch libfuzzer_integration_vanilla exiv2 && \
        cd exiv2 && \
        export CC=clang && \
        export CXX=clang++ && \
        mkdir build && \
        cd build && \
        cmake .. -G "Unix Makefiles" "-DEXIV2_BUILD_FUZZ_TESTS=ON" "-DEXIV2_TEAM_USE_SANITIZERS=ON" && \
        make
        # ./bin/read-metadata -exact_artifact_path=crash
