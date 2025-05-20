# SWGEmu Core3 - Nix Development Environment

A reproducible Nix development environment for building and developing the SWGEmu Core3/MMOCoreORB project.

## Prerequisites

- [Nix Package Manager](https://nixos.org/download.html) with flakes enabled
- (Optional) [direnv](https://direnv.net/) for automatic environment activation

## Quick Start

### Setting up with direnv (recommended)

1. Clone this repository and your Core3 repository:
   ```bash
   git clone https://github.com/Aliman00/SWGEmu-NixFlake.git
   cd SWGEmu-NixFlake
   # Clone Core3 in this directory or separately
   ```

2. Allow direnv to use the flake environment:
   ```bash
   direnv allow
   ```

3. Build Core3:
   ```bash
   # Navigate to Core3 directory if needed
   build-core3
   ```

### Without direnv

1. Clone this repository and your Core3 repository
2. Enter the development environment:
   ```bash
   nix develop
   ```

3. Build Core3:
   ```bash
   build-core3
   ```

## What's Included

This development environment includes all dependencies needed to build Core3:

- C++ Compiler (GCC + LLVM/Clang)
- Build tools (CMake, Ninja)
- Libraries:
  - Boost
  - MySQL Connector/C
  - Berkeley DB
  - OpenSSL
  - Lua 5.3
  - zlib

## How It Works

The `flake.nix` provides:

- A fully reproducible development environment with all dependencies
- Properly configured include paths and library paths
- A convenient `build-core3` function that handles the build process

The `build-core3` command:
- Automatically finds the MMOCoreORB directory
- Sets up the build directory
- Configures CMake with all required options
- Builds the project using all available CPU cores

## Environment Variables Set

The development environment sets these variables:

- `LD_LIBRARY_PATH` - For runtime library loading
- `CPLUS_INCLUDE_PATH` / `C_INCLUDE_PATH` - For compiler include paths
- `CMAKE_PREFIX_PATH` - For CMake package finding

## Updating Dependencies

To update the Nix packages to newer versions:

```bash
nix flake update
```

## Advanced Usage

### Customizing the Build

You can modify the `flake.nix` file to:
- Add or remove dependencies
- Change compiler options
- Modify build flags

### Manual Build Steps

If you need more control over the build process:

```bash
cd Core3/MMOCoreORB
mkdir -p build/unix
cd build/unix
cmake -G "Unix Makefiles" \
  -DBUILD_IDL=ON \
  -DRUN_GIT=ON \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  ../..
make -j$(nproc)
```

## Troubleshooting

### Missing Dependencies
If you encounter missing dependencies, you might need to add them to the `buildInputs` section in `flake.nix`.

### Build Errors
For CMake or compilation errors, make sure you're using the `build-core3` command from within the development environment.

## License

This Nix configuration is provided under [your license choice].

The SWGEmu Core3 project has its own license and is not included in this repository.