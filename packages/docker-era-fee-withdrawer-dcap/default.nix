{ pkgs
, busybox
, curl
, nixsgx
, efw
, ...
}:
pkgs.dockerTools.buildLayeredImage {
  name = "era-fee-withdrawer-dcap";
  tag = "latest";

  contents = pkgs.buildEnv {
    name = "image-root";
    paths = with nixsgx; with efw; [
      busybox
      curl
      sgx-psw
      gramine
      restart-aesmd
      sgx-dcap.default_qpl
      sgx-dcap.quote_verify
      era-fee-withdrawer
    ];
    pathsToLink = [ "/bin" "/lib" "/etc" ];
    postBuild = ''
      mkdir -p $out/var/run
      mkdir -p $out/${nixsgx.sgx-psw.out}/aesm/
      ln -s ${curl.out}/lib/libcurl.so $out/${nixsgx.sgx-psw.out}/aesm/
      # ln -s ${nixsgx.sgx-dcap.default_qpl}/lib/libdcap_quoteprov.so $out/${nixsgx.sgx-psw.out}/aesm/
    '';
  };
}

