#!/bin/bash

# check 'esbuild' dependency
if ! test -f "node_modules/esbuild/install.js" ; then
    echo "Cannot find 'esbuild' dependency. Installing..."
    npm install esbuild --save-dev
fi

chmod +x ./bundle.sh
chmod +x ./mkcert.sh
chmod +x ./build.sh

./bundle.sh
node server.js