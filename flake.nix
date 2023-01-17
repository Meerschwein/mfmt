{
  description = "";

  inputs = {
    nixpkgs.url = "nixpkgs/22.11";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
  };

  outputs = {self, ...} @ inputs:
    inputs.utils.lib.mkFlake {
      inherit self inputs;
      outputsBuilder = channels: let
        mfmt = channels.nixpkgs.writeShellApplication {
          name = "mfmt";
          text = ''
            treefmt \
              --config-file ${./treefmt.toml} \
              --tree-root ./
          '';
          runtimeInputs = with channels.nixpkgs; [
            treefmt
            gofumpt
            alejandra
            luaformatter
          ];
        };
      in {
        apps.default = inputs.utils.lib.mkApp {drv = mfmt;};
        apps.mfmt = inputs.utils.lib.mkApp {drv = mfmt;};
        packages.default = mfmt;
        packages.mfmt = mfmt;
      };
    };
}
