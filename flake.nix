{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        libraryPaths = [
          "${pkgs.boost181}/lib"
          "${pkgs.gcc.cc.lib}/lib"
          "${pkgs.lua5_3}/lib"
          "${pkgs.db.out}/lib"
          "${pkgs.openssl.out}/lib"
          "${pkgs.mysql80.connector-c}/lib"
          "${pkgs.zlib}/lib"
        ];
        libraryPath = builtins.concatStringsSep ":" libraryPaths;

        includePaths = with pkgs; [
          "${boost181.dev}/include"
          "${gcc-unwrapped}/include/c++/${gcc-unwrapped.version}"
          "${gcc-unwrapped}/include/c++/${gcc-unwrapped.version}/${stdenv.hostPlatform.config}"
          "${gcc-unwrapped}/include/c++/${gcc-unwrapped.version}/backward"
          "${gcc-unwrapped}/lib/gcc/${stdenv.hostPlatform.config}/${gcc-unwrapped.version}/include"
          "${gcc-unwrapped}/lib/gcc/${stdenv.hostPlatform.config}/${gcc-unwrapped.version}/include-fixed"
          "${gcc.cc.lib}/include"
          "${glibc.dev}/include"
          "${lua5_3}/include"
          "${db.dev}/include"
          "${openssl.dev}/include"
          "${zlib.dev}/include"
        ];
        includePath = builtins.concatStringsSep ":" includePaths;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            llvmPackages_18.llvm
            llvmPackages_18.clang
            llvmPackages_18.clang-unwrapped
            llvmPackages_18.lld
            gcc
            gcc.cc.lib
            gccStdenv
            db
            db.dev
            mysql80.connector-c
            mysql80
            openssl.dev
            git
            openssh
            cmake
            jdk11
            boost
            boost.dev
            ninja
            readline.dev
            lua5_3
            lua53Packages.lua
            zlib
          ];

          shellHook = ''
            export LD_LIBRARY_PATH="${libraryPath}:$LD_LIBRARY_PATH"
            export CPLUS_INCLUDE_PATH="${includePath}:$CPLUS_INCLUDE_PATH"
            export C_INCLUDE_PATH="${includePath}:$C_INCLUDE_PATH"
            export CMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH:/nix/store"

            build-core3() {
              if [ -d "Core3" ]; then
                cd Core3/MMOCoreORB
              elif [ -d "MMOCoreORB" ]; then
                cd MMOCoreORB
              elif [ ! -f "CMakeLists.txt" ]; then
                echo "Error: Please navigate to the Core3 directory or MMOCoreORB directory first"
                return 1
              fi

              mkdir -p build/unix
              cd build/unix

              cmake -G "Unix Makefiles" \
                -DBUILD_IDL=ON \
                -DRUN_GIT=ON \
                -DCMAKE_BUILD_TYPE=RelWithDebInfo \
                -DMYSQL_INCLUDE_DIR=${pkgs.mysql80.connector-c}/include/mysql \
                -DLUA_INCLUDE_DIR=${pkgs.lua5_3}/include \
                -DDB_INCLUDE_DIR=${pkgs.db.dev}/include \
                -DOPENSSL_INCLUDE_DIR=${pkgs.openssl.dev}/include \
                -DZLIB_INCLUDE_DIR=${pkgs.zlib.dev}/include \
                ../.. && make -j$(nproc)
            }

            echo "Use 'build-core3' command to build the project"
            echo "Make sure you're in the Core3/MMOCoreORB directory before running build-core3"
          '';
        };
      });
}
