{
  description = "Meli Dev";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem
    (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      rustc_version = "stable";
    in {
      packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
      packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

      devShell = with pkgs;
        mkShell {
          buildInputs = [
            # rust
            openssl
            pkg-config
            glibc

            # cargo
            gnumake
            gnum4
            man
            perl

            podman
            podman-compose
          ];
          RUSTC_VERSION = "${rustc_version}";
          RUSTUP_TOOLCHAIN = "${rustc_version}";
          RUST_BACKTRACE = 1;
          RUST_LOG = "trace";
          RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";

          CARGO_NET_GIT_FETCH_WITH_CLI = "true";
          # PATH = "/home/phile/.rustup/toolchains/${rustc_version}-x86_64-unknown-linux-gnu/bin/:${PATH}";

          shellHook = ''
            export PATH="/home/phile/.rustup/toolchains/$RUSTC_VERSION-x86_64-unknown-linux-gnu/bin/:$PATH"
          '';
        };
    });
}
