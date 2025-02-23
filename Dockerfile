# Use Ubuntu as the base image
FROM ubuntu:latest

# Install dependencies 
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        build-essential \
        cmake \
        curl \
        nodejs \
        git \
        npm \
        python3 \
        python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Installing libtcc from source : C compiler
RUN git clone https://github.com/TinyCC/tinycc.git \
    && cd tinycc \
    && ./configure --prefix=/usr \
    && make \
    && make install \
    && cd .. \
    && rm -rf tinycc

# Set working directory
WORKDIR /root

# Clone the repository
RUN git clone https://github.com/metacall/polyglot-tree-traversal-example.git

# Change working directory to polyglot-tree-traversal-example
WORKDIR /root/polyglot-tree-traversal-example

# Clone and build METACALL 
RUN git clone --branch v0.8.7 https://github.com/metacall/core \
    && cd core \
    && ./tools/metacall-environment.sh release base nodejs c python \
    && mkdir build && cd build \
    && cmake \
        -DOPTION_BUILD_LOADERS_C=On \
        -DOPTION_BUILD_LOADERS_NODE=On \
        -DOPTION_BUILD_LOADERS_PY=On \
        -DOPTION_BUILD_PORTS=On \
        -DOPTION_BUILD_PORTS_NODE=On \
        -DOPTION_BUILD_PORTS_PY=On \
        -DOPTION_BUILD_DETOURS=Off \
        -DOPTION_BUILD_SCRIPTS=Off \
        -DOPTION_BUILD_TESTS=Off \
        -DOPTION_BUILD_EXAMPLES=Off \
        .. \
    && cmake --build . --target install \
    && ldconfig /usr/local/lib \
    && cd ../../ \
    && rm -rf core

# Set environment variables for METACALL
ENV LOADER_LIBRARY_PATH="/usr/local/lib" \
    LOADER_SCRIPT_PATH="/root/polyglot-tree-traversal-example"

# testing the build 
RUN ["metacallcli", "rootNode.py"]

# Run the application
CMD ["metacallcli", "rootNode.py"]
