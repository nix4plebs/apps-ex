{
  description = "nix starter flake pinned to 22.11";

  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11"; };

  outputs = { self, nixpkgs }:
    let
      allSystems = [
        "x86_64-linux" # AMD/Intel Linux
        "aarch64-linux" # ARM Linux
        "aarch64-darwin" # ARM macOS
      ];

      forAllSystems = fn:
        nixpkgs.lib.genAttrs allSystems
        (system: fn { pkgs = import nixpkgs { inherit system; }; });

    in {
      # used when calling `nix fmt <path/to/flake.nix>`
      formatter = forAllSystems ({ pkgs }: pkgs.nixfmt);

      # nix run|build <flake-ref>#<pkg-name>
      # -- 
      # $ nix run <flake-ref>#hello
      apps = forAllSystems ({ pkgs }: {
        pydoc = {
          type = "app";
          program = "${pkgs.python311}/bin/pydoc3";
        };
      });
    };
}
