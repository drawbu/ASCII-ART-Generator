{
  outputs = { self, nixpkgs, }:
    let
      forAllSystems = function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ]
          (system: function nixpkgs.legacyPackages.${system});

      py = pkgs: rec {
        deps = p: with p; [ numpy opencv4 pillow ] ++ [ flask gunicorn ];
        env = pkgs.python3.withPackages deps;
      };
    in
    {
      devShells = forAllSystems (pkgs: {
        default =
          let
            pyenv = (py pkgs).env;
            node = pkgs.nodejs_20;
          in
          pkgs.mkShell {
            buildIputs = [ pyenv node ];

            shellHook = ''
              echo "python env path -> ${pyenv}"
              echo "node env path -> ${node}"
            '';
          };
      });

      formatter = forAllSystems (pkgs: pkgs.nixpkgs-fmt);
      packages = forAllSystems (pkgs: rec {
        default = server;

        client = pkgs.buildNpmPackage {
          name = "ascii-client";
          version = "1.0.0";

          src = ./client;
          npmDepsHash = "sha256-wOF13k4rqv7VMaH7YLsO821cqXJ4+cFk/PQrQJRQ0Rg";

          builtinsInputs = with pkgs; [ nodejs_20 ];

          installPhase = ''
            runHook preInstall

            mkdir -p $out
            cp -r public $out/

            runHook postInstall
          '';
        };

        server =
          let pyenv = (py pkgs).env;
          in pkgs.stdenvNoCC.mkDerivation {
            name = "ascii-server";
            version = "1.0.0";

            src = pkgs.lib.cleanSource ./.;

            buildPhase = ''
              runHook preBuild

              cat <<EOF > runner_script
              #!${pkgs.runtimeShell}

              ${pyenv}/bin/gunicorn --workers 3 --bind unix:\$1 -m 007 wsgi:app
              EOF

              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall

              mkdir -p $out

              cp app.py $out
              cp -r img_tools $out

              cp -r ${client}/public $out

              mkdir -p $out/bin
              cp runner_script $out/bin/ascii-server
              chmod +x $out/bin/ascii-server

              runHook postInstall
            '';
          };
      });
    };
}
