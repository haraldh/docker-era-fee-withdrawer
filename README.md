# Reproduce the NixOS build
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
# Build the Docker image
```bash
$ docker load < era-fee-withdrawer-azure.tar.gz
$ docker build --no-cache --progress=plain -t efw -f Dockerfile-azure .
```

Should output something like:
```bash
[...]
#9 6.689 Measurement:
#9 6.689     629aade720205420117d96d436141f98b1b5ec0363f0d85dd133a80dfac7169d
[...]
```
as the github actions build does.
