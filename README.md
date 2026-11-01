## Description

This web GUI is designed to be deployed to routers, but you can pick any other supported platform. For example in Android you can use [termux](https://termux.dev/) to run server in the background and then access GUI layout via browser.

## Running in debug mode (Linux/Android)
 
First of all you need to install [git](https://git-scm.com/), [nodejs](https://nodejs.org/) and `openssl` cli tool.

The next step is to clone repo using (for termux use it's root directory to clone the repo there):

```
git clone --recurse-submodules https://github.com/de-things/de-gui.git
```

Go to clonned directory and run:

```sh
chmod +x ./start.sh && ./start.sh
```

During "clean run" this script creates `config.json` and asks you to define public server IP address. It will be used to generate SSL certificate after you set it up.

So define it and start the server again.

After the server is online, you can enter de-gui GUI (ha-ha).

In entered GUI you need to gain server access to fetch cluster data created upon clean start. To do so, in web interface go to settings (gear button) and in `Access key` field specify secret value located in `config.json` under `secret` variable. That private key was randomly generated and wanted to be used as an encryption provider for further communication.

After specifying an `Access key` press `Sync` button to apply changes. Web interface should fetch server data and if an `Access key` was fine server will respond with presets data. It will be empty if you're on just clean start though.

If `Access key` is invalid, presets tab show `Access denied` message, otherwise you may see presets list with a `+` button.

From now and on you can start working on presets by pressing a `+` button.

## About GUI presets

In web interface each preset can be modified by holding it.

Each tile in preset can be modified by holding it as well. Inproper values in tile fields will drop tip messages into GUI logs.

## SSL certificate

Since this project relies on encrypted client<>server communication, HTTPS is **required**.

By default server uses self-signed `server.*` key/crt pair located in `.cert/` directory, but if you plan to deploy this project into some serious environment you need to worry about getting better certificate solution. You can buy a domain and reverse-proxy traffic to it using `nginx` or `caddy`.

In my case, I deploy this project in my local network, so default server certificate is fine enough.

If you plan to use default certificate you need to make it *trusted*. That means you need to install it on a destination device you plan to use to connect to the server. For such problem `.cert/` directory contains `trusted.crt` which is the one you need to install on your device to trust server's public IP.

But yea, don't use this method for serious deploys please.

## Deploying to a prefered environment (Router example)

The best way to deploy the project is to build it into a standalone executable. It prevents destination device from owning dev packages like `nodejs`, `git` and etc. Just a server executable and few files to make it work.

I'll describe steps for deploying it into a router, but other platforms are the same.

First of all, check router's architecture and container's OS you plan to run this project on. For example, my MikroTik router operate on ARM64 architecture with Alpine Linux as a container environment.

So in order to build this project for such router you need to find some *computer* with a described setup and then run this project there in a debug mode following steps above.

After setting things up and successful start, you can build the project on a *computer* running:

```sh
./build.sh
```

This script bundles javascript into a standalone executable using *node SEA* and clones everything server need to work with into a destination folder.

For setup above build files will be located at `bin/arm64`. All you need to do after is to clone this `bin/arm64` files to the router and run an executable inside:

```sh
./server
```

It should work the same way as in dev environment when you start a server using `./start.sh` script.

## Overview

<img src=./misc/overview.png>