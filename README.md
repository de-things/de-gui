> [!IMPORTANT]
> It's my first attempt in cross-compile/deploy stuff,
> so I do not guarantee my toolchain stable work.
> A guide I wrote below is based on experience I received
> working on this project.

## Description

This is web interface to manage de:things requests. It's primarly designed to be deployed to routers (a MikroTik router tbh), but you can pick any other platform. For example in Android you can use [termux](https://termux.dev/) to run a server in the background and then access it's GUI via browser.

## Running in debug mode (Linux/Android)
 
First of all you need to install [git](https://git-scm.com/), [nodejs](https://nodejs.org/) and `openssl` cli tool.

The next step is to clone repo using (for termux use it's `~/` directory and clone there):

```sh
git clone --recurse-submodules https://github.com/de-things/de-gui.git
```

Go to clonned directory and run:

```sh
chmod +x ./init.sh && ./init.sh
```

During "clean run" this script creates `config.json` and asks you to define public server IP address. It will be used to generate SSL certificate after you set it up.

So define it and init the server again.

After the server is online, you can enter de-gui GUI (ha-ha).

In entered GUI you need to gain server access to fetch cluster data created upon a clean start. To do so, in web interface go to settings (gear button) and in `Access key` field specify secret value located in `config.json` under `secret` variable. That private key was randomly generated and wanted to be used as an encryption provider for further communication.

After specifying an `Access key` press `Sync` button to apply changes. Web interface should fetch server data and if an `Access key` was fine server will respond with presets data. It will be empty if you're on just clean start though.

If `Access key` is invalid, presets tab show `Access denied` message, otherwise you may see presets list with a `+` button.

From now and on you can start working on presets by pressing a `+` button.

## About GUI presets

In web interface each preset can be modified by holding it.

Each tile in preset can be modified by holding it as well. Inproper values in tile fields will drop tip messages into GUI logs.

## SSL certificate

Since this project relies on encrypted client<>server communication, HTTPS is **required**.

By default server uses self-signed `server.*` key/crt pair located in `.cert/` directory, but if you plan to deploy this project into some serious environment you need to worry about getting better *trusted* certificate solution. You can rent a domain with SSL and reverse-proxy traffic to it using `nginx` or `caddy` (more info -> internet).

In my case, I deploy this project over my local network, so default server certificate is fine enough.

Well, if you plan to use default `server.*` certificate you need to make it *trusted*. That means you need to install it on a destination device you plan to use to connect to the server. For such problem `.cert/` directory contains `trusted.crt` file which is the one you need to install on your device to trust server's public IP.

For example you start a server, clone `trusted.crt` to your Android device, go to Settings -> ... -> Install certificate, agree with a devil's contract and aha, you can connect to a server without warnings! (more info -> internet)

But yeah, don't use this method in serious deploys, please.

## Deploying to a preferred environment (Router example)

Some scripts below require `podman` and `qemu` packages being installed on your machine to emulate build architectures. You don't need any of them on a destination device though.

So we do have several options:

### Build SEA (single executable application) build and run without dependencies

* **+** Almost everything is included into the one executable file.
* **-** Existence of `libatomic`, `glibc` or `musl` may become a hardly breakable wall for this deploy.

The idea of building this way is to run:

```sh
 # if you build for your native architecture
./build.sea.sh
```

or run:

``` sh
# if you want to build for speciefic architecture you don't have
# (replace 'some_arch' with an architecture of a destination device)
./build.sea.podman.sh some_arch
```

So this build option generates `bin/{arch}` directory with everything server need to run with. Just clone a created directory into your environment and try to run it. If it runs - sweet!

### Create container image and run it via container environment

* **+** It just works!
* **-** Setting up a container is doomed and a size will be huge.

Run:

```sh
# replace 'some_arch' with an architecture of a destination device
build.tar.podman.sh some_arch
```

This script generates single `de-gui.tar` file in `bin/{arch}` which is ready to be deployed into a container.

I use this method for my MikroTik router, because it just works!

For everyone interested in steps of deploying `de-gui` container into a MikroTik router (RouterOS) I wrote a [mikrotik-deploy](./mikrotik-deploy.rsc) document. Feel free to examine.

## Overview

<img src=./misc/overview.png>