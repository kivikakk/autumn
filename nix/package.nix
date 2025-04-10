{
  pkgs,
  lib,
  beamPackages,
  elixir,
  rust,
}:
let
  mixNixDeps = import ./deps.nix { inherit lib beamPackages; };

  cargoToml = builtins.fromTOML (builtins.readFile ../native/autumnus_nif/Cargo.toml);
  version = cargoToml.package.version;

  rustPlatform = pkgs.makeRustPlatform {
    cargo = rust;
    rustc = rust;
  };

  autumnus_nif = rustPlatform.buildRustPackage {
    pname = "autumnus_nif";
    inherit version;
    src = ../native/autumnus_nif;
    cargoLock = {
      lockFile = ../native/autumnus_nif/Cargo.lock;
      outputHashes = {
        "autumnus-0.4.0" = "sha256-YyT9TQ5rtTohIuK/O/VRuDwpyNWvYfq9p8CH984xiiI=";
      };
    };
  };

  mixExsVersion =
    let
      mixExs = builtins.readFile ../mix.exs;
      groups = builtins.match ".*@version \"([^\"]+)\".*" mixExs;
    in
    builtins.elemAt groups 0;
in
beamPackages.buildMix {
  name = "autumn";
  version = mixExsVersion;
  src = ../.;

  beamDeps = builtins.attrValues mixNixDeps;

  buildInputs = [ elixir ];

  appConfigExs = pkgs.writeText "config.exs" ''
    import Config

    config :autumn, Autumn.Native,
      crate: :autumnus_nif,
      skip_compilation?: true
  '';

  preConfigure = ''
    mkdir -p priv/native
    cp ${autumnus_nif}/lib/libautumnus_nif.* priv/native/libautumnus_nif.so

    mkdir -p config
    cp $appConfigExs config/config.exs
  '';

  env.RUSTLER_PRECOMPILED_FORCE_BUILD_ALL = "true";
  env.RUSTLER_PRECOMPILED_GLOBAL_CACHE_PATH = "fake";
}
