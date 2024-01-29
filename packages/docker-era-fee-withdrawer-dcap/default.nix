{ pkgs
, busybox
, curl
, nixsgx
, efw
, cacert
, ...
}:
pkgs.dockerTools.buildLayeredImage {
  name = "era-fee-withdrawer-dcap";
  tag = "latest";

  config.Env = [ "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt" ];
  config.Entrypoint = [ "/bin/sh" ];

  contents = pkgs.buildEnv {
    name = "image-root";
    paths = with nixsgx; with efw; [
      busybox
      cacert
      curl
      era-fee-withdrawer
      gramine
      restart-aesmd
      sgx-dcap.default_qpl
      sgx-dcap.quote_verify
      sgx-psw
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

