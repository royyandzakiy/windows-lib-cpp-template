\page installation Installation

To build this library, use the following steps. You will need CMake and a compiler/linker isntalled, as a minimum. The Ninja build tool is recommended as well. The library will be first configured, then compiled, and finally installed. We can optionally install Doxygen through Conan, if required, which would be done before the configuration step.

### Install dependencies

Create a `build/` folder in the root directory, if not already present. If you wish to build the documentation, then install Doxygen through Conan first:

```bash
conan install . --output-folder=build --build=missing
```

This assumes that you have a terminal opened and have changed into the root directory of the project.

### Configuration

Next, let's configure the project. First, we need to change into the `build/` folder, and then we can execute the configure step with

```bash
cmake -DCMAKE_BUILD_TYPE=Debug -DBUILD_DOCS=ON -G Ninja ..
```

Here we are using Ninja as our build generator. If you don't have Ninja installed, omit the `-G Ninja` flag and let CMake chose the default compiler based on your platform. We require the documentation to be build as well, so we turn the `BUILD_DOCS` variable on.

### Compilation

Next, we need to compile the project, this is achieved using the following instructions:

```bash
cmake --build . --config Debug
```
### Installation

And finally, let's install the library into a desired location on our system. The following assumes that we are on Windows and want to install into the `C:\temp` directory, but you may change that depending on yoru preference and platform. For example, on UNIX, you may want to use `~/temp` instead.

```bash
cmake --install . --prefix C:\temp --config Debug
```

The library will now be installed in the specified directory, along with the documentation