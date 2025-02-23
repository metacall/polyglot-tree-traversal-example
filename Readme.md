# Traversing a polyglot tree

![Tree](./polyglot%20tree.png)

This example demonstrates traversing a tree, where nodes are implemented in different programming languages.

## Overview

The tree starts with a root node written in Python. The root node:
- Uses MetaCall to import and execute a child node written in JavaScript.
- Passes a `CurrentNode` variable to the JavaScript node to track the node number.

The JavaScript node, in turn:
- Imports and executes a child node written in C.
- Passes the `CurrentNode` variable forward.

This chain demonstrates how different languages interact within a unified workflow.

## Steps to Run

### 1. Fork and Clone the Repository

1. Fork this repository.
2. Clone your fork to your local machine:
   ```bash
   git clone https://github.com/<your-username>/polyglot-tree-traversal.git
   cd polyglot-tree-traversal
   ```

### 2. Set Up Dependencies (Linux)

Install the necessary dependencies:

```bash
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  ca-certificates \
  git \
  liburing-dev \
  cmake \
  curl
```

### 3. Clone and Build MetaCall

Clone and build MetaCall from its repository:

```bash
git clone --branch v0.8.7 https://github.com/metacall/core
cd core
./tools/metacall-environment.sh release base nodejs c python
sudo mkdir build && cd build
sudo cmake \
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
  ..
sudo cmake --build . --target install
sudo ldconfig /usr/local/lib
cd ../..
sudo rm -rf core
```

### 4. Set Up Environment Variables

Export the required environment variables:

```bash
export LOADER_LIBRARY_PATH="/usr/local/lib"
export LOADER_SCRIPT_PATH="$(pwd)" # Path to the scripts in your project
```

### 5. Run the Root Node

Use the MetaCall CLI to execute the root node:

```bash
metacallcli rootNode.py
```

This will initiate the traversal of the polyglot tree, starting with the Python root node.

## Project Structure

- `rootNode.py`: The Python script that acts as the root node.
- `middleNode.js`: The JavaScript script imported by the root node.
- `leaf_Node.c`: The C code imported by the JavaScript node.

## Notes

- Ensure that MetaCall loaders for Python, Node.js, and C are enabled during the build.
- Ensure that MetaCall ports for Nodejs and Python are enabled during the build.
- Scripts should be placed in the directory specified by the `LOADER_SCRIPT_PATH` environment variable.

## 🚀 Running with Docker
You can run the Polyglot Tree Traversal Example inside a Docker container without installing dependencies manually.
📌 Build the Docker Image
Run the following command to build the Docker image:
```sh
  docker build --tag metacall/polyglot-tree-traversal-example .
```
▶️ Run the Container
Execute the container with:
```sh
  docker run --rm -e LOADER_LIBRARY_PATH="/usr/local/lib" -e LOADER_SCRIPT_PATH="/root/polyglot-tree-traversal-example" metacall/polyglot-tree-traversal-example 
```