{ lib
, nodejs
, fetchFromGitHub
, mkYarnPackage
, fetchYarnDeps
, makeWrapper
}:

let

  pname = "era-fee-withdrawer";
  version = "2.2.33";

  src = fetchFromGitHub {
    owner = "matter-labs";
    repo = pname;
    # tag v2.2.33
    rev = "0dac52050c27a344aae5e48f30857a81f0a5f04d";
    sha256 = "sha256-vyNldcUErQ/aD/Oprbs0OocTv0ARQ0/WG05WrN13IO8=";
  };
in
mkYarnPackage {
  inherit version src pname;

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-V2Qev42NMA0i+07J6h+WZhO+g0gX/7rEf2HpaVcu6Ts=";
  };

  nativeBuildInputs = [
    nodejs
    makeWrapper
  ];

  postInstall = ''
    rm -fr $out/libexec/fee-withdrawer-v2/deps/fee-withdrawer-v2/.github
    makeWrapper '${nodejs}/bin/node' "$out/bin/${pname}" \
      --add-flags "$out/libexec/fee-withdrawer-v2/node_modules/ts-node/dist/bin.js" \
      --add-flags "$out/libexec/fee-withdrawer-v2/deps/fee-withdrawer-v2/src/index.ts" \
  '';
  distPhase = "true";
}
