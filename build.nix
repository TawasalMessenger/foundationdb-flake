{ pkgs, rocksdb-src, src, version }:

with pkgs;
let
  lz4 = pkgs.lz4.override { enableStatic = true; };
  self = stdenv.mkDerivation rec {
    inherit src version;
    pname = "foundationdb";

    nativeBuildInputs = [
      pkg-config
      bash
      cmake
      ninja
      openjdk
      python3
      mono4
    ];

    buildInputs = [ boost172 makeWrapper bzip2 lz4 snappy zlib zstd jemalloc ];

    separateDebugInfo = true;
    enableParallelBuilding = true;
    dontFixCmake = true;

    cmakeFlags =
      [
        "-DCMAKE_BUILD_TYPE=Release"
        "-DFDB_RELEASE=TRUE"

        "-DRocksDB_ROOT=${rocksdb-src}"

        "-DDISABLE_TLS=off"
        "-DUSE_LD=GOLD"
      ];

    prePatch = ''
      substituteInPlace build/get_version.sh --replace "/usr/bin/env bash" "${bash}/bin/bash"
      substituteInPlace build/get_package_name.sh --replace "/usr/bin/env bash" "${bash}/bin/bash"

      sed -e 's;PORTABLE_ROCKSDB 1;PORTABLE_ROCKSDB 0;g' -i fdbserver/CMakeLists.txt
    '';

    postInstall = ''
      mkdir -p $dev $lib $bin/libexec

      mv $out/bin $bin/
      mv $out/usr/lib/foundationdb/*.py $bin/libexec/
      ln -s $bin/bin/fdbbackup $bin/libexec/backup_agent
      mv $out/sbin/* $bin/bin/

      # java bindings
      mkdir -p $lib/share/java
      mv ./packages/fdb-java-${version}.jar $lib/share/java/fdb-java.jar

      rm -rf $out/lib/systemd $out/usr $out/bin $out/sbin $out/var $out/log $out/etc $out/lib/foundationdb $out/lib/cmake $out/lib/pkgconfig

      # move results into multi outputs
      mv $out/include $dev/
      mv $out/lib $lib/
    '';

    outputs = [ "bin" "out" "dev" "lib" ];

    passthru.jar = "${self.lib}/share/java/fdb-java.jar";
  };
in
self
