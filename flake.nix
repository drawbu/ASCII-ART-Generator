{
  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system} = rec {
      default = client;
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

      server = let
        pyenv = pkgs.python3.withPackages (p: with p; [
            numpy flask opencv4 pillow gunicorn
        ]);
      in pkgs.stdenvNoCC.mkDerivation {
        name = "ascii-server";
        version = "1.0.0";

        src = pkgs.lib.cleanSource ./.;

        buildPhase = ''
          runHook preBuild

          cat <<EOF > runner_script
          #!${pkgs.runtimeShell}

          ${pyenv}/bin/gunicorn --workers 3 --bind \$1 -m 007 wsgi:app
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
          cp runner_script $out/bin/server
          chmod +x $out/bin/server

          runHook postInstall
        '';
      };
    };
  };
}
