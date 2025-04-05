{
  lib,
  beamPackages,
  overrides ? (x: y: { }),
}:
let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages =
    with beamPackages;
    with self;
    {
      castore = buildMix rec {
        name = "castore";
        version = "1.0.14";

        src = fetchHex {
          pkg = "castore";
          version = "${version}";
          sha256 = "7bc1b65249d31701393edaaac18ec8398d8974d52c647b7904d01b964137b9f4";
        };

        beamDeps = [ ];
      };

      earmark_parser = buildMix rec {
        name = "earmark_parser";
        version = "1.4.44";

        src = fetchHex {
          pkg = "earmark_parser";
          version = "${version}";
          sha256 = "4778ac752b4701a5599215f7030989c989ffdc4f6df457c5f36938cc2d2a2750";
        };

        beamDeps = [ ];
      };

      ex_doc = buildMix rec {
        name = "ex_doc";
        version = "0.38.2";

        src = fetchHex {
          pkg = "ex_doc";
          version = "${version}";
          sha256 = "732f2d972e42c116a70802f9898c51b54916e542cc50968ac6980512ec90f42b";
        };

        beamDeps = [
          earmark_parser
          makeup_elixir
          makeup_erlang
        ];
      };

      jason = buildMix rec {
        name = "jason";
        version = "1.4.4";

        src = fetchHex {
          pkg = "jason";
          version = "${version}";
          sha256 = "c5eb0cab91f094599f94d55bc63409236a8ec69a21a67814529e8d5f6cc90b3b";
        };

        beamDeps = [ ];
      };

      makeup = buildMix rec {
        name = "makeup";
        version = "1.2.1";

        src = fetchHex {
          pkg = "makeup";
          version = "${version}";
          sha256 = "d36484867b0bae0fea568d10131197a4c2e47056a6fbe84922bf6ba71c8d17ce";
        };

        beamDeps = [ nimble_parsec ];
      };

      makeup_eex = buildMix rec {
        name = "makeup_eex";
        version = "2.0.2";

        src = fetchHex {
          pkg = "makeup_eex";
          version = "${version}";
          sha256 = "30ac121dda580298ff3378324ffaec94aad5a5b67e0cc6af177c67d5f45629b9";
        };

        beamDeps = [
          makeup
          makeup_elixir
          nimble_parsec
        ];
      };

      makeup_elixir = buildMix rec {
        name = "makeup_elixir";
        version = "1.0.1";

        src = fetchHex {
          pkg = "makeup_elixir";
          version = "${version}";
          sha256 = "7284900d412a3e5cfd97fdaed4f5ed389b8f2b4cb49efc0eb3bd10e2febf9507";
        };

        beamDeps = [
          makeup
          nimble_parsec
        ];
      };

      makeup_erlang = buildMix rec {
        name = "makeup_erlang";
        version = "1.0.2";

        src = fetchHex {
          pkg = "makeup_erlang";
          version = "${version}";
          sha256 = "af33ff7ef368d5893e4a267933e7744e46ce3cf1f61e2dccf53a111ed3aa3727";
        };

        beamDeps = [ makeup ];
      };

      makeup_syntect = buildMix rec {
        name = "makeup_syntect";
        version = "0.1.3";

        src = fetchHex {
          pkg = "makeup_syntect";
          version = "${version}";
          sha256 = "a27bd3bd8f7b87465d110295a33ed1022202bea78701bd2bbeadfb45d690cdbf";
        };

        beamDeps = [
          makeup
          rustler
          rustler_precompiled
        ];
      };

      nimble_options = buildMix rec {
        name = "nimble_options";
        version = "1.1.1";

        src = fetchHex {
          pkg = "nimble_options";
          version = "${version}";
          sha256 = "821b2470ca9442c4b6984882fe9bb0389371b8ddec4d45a9504f00a66f650b44";
        };

        beamDeps = [ ];
      };

      nimble_parsec = buildMix rec {
        name = "nimble_parsec";
        version = "1.4.2";

        src = fetchHex {
          pkg = "nimble_parsec";
          version = "${version}";
          sha256 = "4b21398942dda052b403bbe1da991ccd03a053668d147d53fb8c4e0efe09c973";
        };

        beamDeps = [ ];
      };

      rustler = buildMix rec {
        name = "rustler";
        version = "0.36.2";

        src = fetchHex {
          pkg = "rustler";
          version = "${version}";
          sha256 = "93832a6dbc1166739a19cd0c25e110e4cf891f16795deb9361dfcae95f6c88fe";
        };

        beamDeps = [
          jason
          toml
        ];
      };

      rustler_precompiled = buildMix rec {
        name = "rustler_precompiled";
        version = "0.8.2";

        src = fetchHex {
          pkg = "rustler_precompiled";
          version = "${version}";
          sha256 = "63d1bd5f8e23096d1ff851839923162096364bac8656a4a3c00d1fff8e83ee0a";
        };

        beamDeps = [
          castore
          rustler
        ];
      };

      toml = buildMix rec {
        name = "toml";
        version = "0.7.0";

        src = fetchHex {
          pkg = "toml";
          version = "${version}";
          sha256 = "0690246a2478c1defd100b0c9b89b4ea280a22be9a7b313a8a058a2408a2fa70";
        };

        beamDeps = [ ];
      };
    };
in
self
