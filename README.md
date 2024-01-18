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
#9 6.689     b2f0bbac27a644c97dc212dd9d20ba52e09f29d32e5863ca4164a03e6462f83c
[...]
```
as the github actions build does.
