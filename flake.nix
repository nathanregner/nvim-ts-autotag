{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            gnumake
            stylua
            (
              (pkgs.wrapNeovimUnstable neovim-unwrapped {
                plugins = with pkgs.vimPlugins; [
                  nvim-treesitter
                  plenary-nvim
                ];
              }).overrideAttrs
              {
                dontStrip = true;
                dontFixup = true;
                postInstall = ''
                  mv $out/bin/nvim $out/bin/nvim-test
                '';
              }
            )
          ];
        };

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "nvim-ts-autotag";
          version = "0.0.0";
          src = ./.;

          nativeBuildInputs = with pkgs; [
          ];

          buildPhase = ''
            export HOME="$(mktemp -d)"
            nvim --headless --clean -u tests/test.lua
          '';

          dontInstall = true;
        };
      }
    );
}
