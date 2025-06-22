{
  pkgs,
  lib,
  beamPackages,
  elixir,
  rust,
}:
let
  mixNixDeps = import ./deps.nix { inherit lib beamPackages; };

  autumnus_nif = pkgs.rustPlatform.buildRustPackage {
    pname = "autumnus_nif";
    version = "0.1.0";
    src = ../native/autumnus_nif;
    cargoLock.lockFile = ../native/autumnus_nif/Cargo.lock;
  };
in
beamPackages.buildMix {
  name = "autumn";
  version = "0.1.0";
  src = ../.;

  beamDeps = builtins.attrValues mixNixDeps;

  buildInputs = [ elixir ];

  appConfigExs = pkgs.writeText "config.exs" ''
    import Config

    config :autumn, Autumn.Native,
      crate: :autumnus_nif,
      skip_compilation?: true
  '';

  postConfigure = ''
    mkdir -p priv/native
    cp ${autumnus_nif}/lib/libautumnus_nif.* priv/native/libautumnus_nif.so

    mkdir -p config
    cp $appConfigExs config/config.exs
  '';

  env.RUSTLER_PRECOMPILED_FORCE_BUILD_ALL = "true";
  env.RUSTLER_PRECOMPILED_GLOBAL_CACHE_PATH = "fake";
}
