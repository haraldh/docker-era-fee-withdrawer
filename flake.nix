{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixsgx-flake = {
      url = "github:haraldh/nixsgx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      package-namespace = "efw";

      overlays = with inputs; [
        nixsgx-flake.overlays.default
      ];

      alias = {
        packages = {
          default = "docker-era-fee-withdrawer-azure";
        };
      };

      outputs-builder = channels: {
        formatter = channels.nixpkgs.nixpkgs-fmt;
      };
    };
}
