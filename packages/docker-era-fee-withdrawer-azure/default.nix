{ pkgs
, busybox
, curl
, nixsgx
, efw
, ...
}:
pkgs.dockerTools.buildLayeredImage {
  name = "era-fee-withdrawer-azure";
  tag = "latest";

  contents = pkgs.buildEnv {
    name = "image-root";
    paths = with nixsgx; with efw; [
      busybox
      sgx-psw
      gramine
      restart-aesmd
      azure-dcap-client
      libsgx-dcap-quote-verify
      era-fee-withdrawer
    ];
    pathsToLink = [ "/bin" "/lib" "/etc" ];
    postBuild = ''
      mkdir -p $out/var/run
      mkdir -p $out/${nixsgx.sgx-psw.out}/aesm/
      ln -s ${curl.out}/lib/libcurl.so $out/${nixsgx.sgx-psw.out}/aesm/
      ln -s ${nixsgx.azure-dcap-client.out}/lib/libdcap_quoteprov.so $out/${nixsgx.sgx-psw.out}/aesm/libdcap_quoteprov.so.1
    '';
  };
}
