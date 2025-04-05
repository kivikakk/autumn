{
  pkgs,
  beamPackages,
  erlang,
  elixir,
  rust,
}:
let
  basePackages = with pkgs; [
    git
    erlang
    elixir
    # Fetch all via beamPackages where available so everything's built with the same Erlang.
    beamPackages.hex
    beamPackages.elixir-ls
    beamPackages.rebar3
    # This is Nix-specific.
    (mix2nix.override { inherit erlang elixir; })
    # NIF/Rust dev.
    rust
    rust-analyzer
  ];

  inputs = with pkgs; basePackages ++ lib.optionals stdenv.isLinux [ inotify-tools ];

  hooks = ''
    mkdir -p .nix-mix .nix-hex
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex
    export PATH=$MIX_HOME/bin:$HEX_HOME/bin:$PATH

    export LANG=en_AU.UTF-8
    export ERL_AFLAGS="-kernel shell_history enabled"
  '';
in
pkgs.mkShell {
  name = "autumn";
  buildInputs = inputs;
  shellHook = hooks;
}
