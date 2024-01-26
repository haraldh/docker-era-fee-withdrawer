# tee-era-fee-withdrawer

This is a reproducible build of https://github.com/matter-labs/era-fee-withdrawer
with the gramine runtime to be run on SGX in Azure.

## Reproduce the NixOS build
```bash
$ docker run -it -v .:/mnt nixos/nix:2.17.0
```
Inside the container:
```bash
$ echo 'experimental-features = nix-command flakes' >> /etc/nix/nix.conf
$ cd /mnt
$ nix build
$ cp result era-fee-withdrawer-azure.tar.gz
$ exit
```
## Build the Docker image
```bash
$ docker load < era-fee-withdrawer-azure.tar.gz
$ docker build --no-cache --progress=plain -t efw -f Dockerfile-azure .
```

Should output something like:
```bash
[...]

#9 6.572 Measurement:
#9 6.572     5ab35973a1dd39b049bc11dabf0a699f2d21695417c547e3da88e1ec39b0207b
[...]
```
as the github actions build does.
