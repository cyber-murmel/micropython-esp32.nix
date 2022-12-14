{ pkgs ? import
    (builtins.fetchGit {
      name = "nixos-22.11-2022_12_12";
      url = "https://github.com/nixos/nixpkgs/";
      ref = "refs/heads/nixos-22.11";
      rev = "dfef2e61107dc19c211ead99a5a61374ad8317f4";
    })
    { }
}:

with pkgs;
with import
    (builtins.fetchGit {
      url = "https://github.com/cyber-murmel/esp-idf.nix";
      rev = "dc15bc151fde966ac7df0e756bea5097c59cd306";
    })
    { };
let
  # we only need this submodule for ESP32
  berkeley-db-1_xx = fetchFromGitHub {
    owner = "pfalcon";
    repo = "berkeley-db-1.xx";
    rev = "35aaec4418ad78628a3b935885dd189d41ce779b";
    sha256 = "sha256-XItxmpXXPgv11LcnL7dty6uq1JctGokHCU8UGG9ic04=";
  };
in
stdenv.mkDerivation {
  name = "micropython-esp32";
  nativeBuildInputs = [
    git
    esp32-toolchain
    esp-idf
    esp-idf.python_env
  ];
  src = fetchFromGitHub {
    owner = "micropython";
    repo = "micropython";
    rev = "d7919ea71e7b7cc203ca984cc2f4a55019634835"; # v1.19
    sha256 = "sha256-hULVN6gpl0o/C5NAw5omYxr0mLR2K6h5n6Q6GCGTWFk=";
  };
  IDF_PATH = esp-idf.src;

  phases = [ "unpackPhase" "patchPhase" "buildPhase" "installPhase" ];
  patchPhase = ''
    rmdir lib/berkeley-db-1.xx
    ln -s ${berkeley-db-1_xx} lib/berkeley-db-1.xx
  '';
  buildPhase = ''
    make -C mpy-cross
    make -C ports/esp32 V=1
  '';
  installPhase = ''
    mkdir -p $out
    cp -r ports/esp32/build-GENERIC/bootloader $out/
    cp -r ports/esp32/build-GENERIC/micropython.{bin,map,elf} $out
    cp -r ports/esp32/build-GENERIC/partition_table $out
    cp -r ports/esp32/build-GENERIC/firmware.bin $out
  '';
}
