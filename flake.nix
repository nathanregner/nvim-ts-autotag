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
        inherit (nixpkgs) lib;
        pkgs = nixpkgs.legacyPackages.${system};
        nvim =
          (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
            plugins = with pkgs.vimPlugins; [
              (nvim-treesitter.withPlugins (
                plugins: with plugins; [
                  html
                  javascript
                  typescript
                  svelte
                  vue
                  tsx
                  php
                  glimmer
                  rescript
                  templ
                  embedded_template
                ]
              ))
              plenary-nvim
            ];
          }).overrideAttrs
            {
              dontStrip = true;
              dontFixup = true;
              # postInstall = ''
              #   mv $out/bin/nvim $out/bin/nvim-test
              # '';
            };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            gnumake
            nvim
            stylua
          ];
        };

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "nvim-ts-autotag";
          version = "0.0.0";
          src = ./.;

          nativeBuildInputs = [ nvim ];

          buildPhase = ''
            export HOME=$(mktemp -d)
            export LUA_PATH="./?.lua;$LUA_PATH"

            mkdir .git
            nvim --headless \
              -c "PlenaryBustedDirectory tests/specs/ { init = 'tests/minimal_init.lua', nvim_cmd = '${lib.getExe nvim}', sequential = true }" \
              |& tee $out
          '';

          dontInstall = true;
        };
      }
    );
}
