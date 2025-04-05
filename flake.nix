{
  description = "Autumn";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # need unstable for 1.86.0
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      rust-overlay,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
        erlang = pkgs.beam_minimal.interpreters.erlang_27;
        beamPackages = pkgs.beam_minimal.packagesWith erlang;
        elixir = beamPackages.elixir_1_18;
        rust-ver = pkgs.rust-bin.stable.latest;
      in
      {
        formatter = pkgs.nixfmt-rfc-style;

        packages = rec {
          default = autumn;

          autumn = pkgs.callPackage ./nix/package.nix {
            inherit beamPackages elixir;
            rust = rust-ver.minimal;
          };
        };

        devShells.default = import ./nix/shell.nix {
          inherit
            pkgs
            beamPackages
            erlang
            elixir
            ;
          rust = rust-ver.default;
        };
      }
    );
}
