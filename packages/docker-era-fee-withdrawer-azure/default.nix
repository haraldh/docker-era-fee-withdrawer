{ pkgs
, busybox
, curl
, nixsgx
, efw
, cacert
, ...
}:
pkgs.dockerTools.buildLayeredImage {
  name = "era-fee-withdrawer-azure";
  tag = "latest";

  config.Env = [
    "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
    "UV_USE_IO_URING=0"
  ];
  config.Entrypoint = [ "/bin/sh" ];

  contents = pkgs.buildEnv {
    name = "image-root";
    paths = with nixsgx; with efw; [
      azure-dcap-client
      busybox
      cacert
      curl
      era-fee-withdrawer
      gramine
      restart-aesmd
      sgx-dcap.quote_verify
      sgx-psw
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
