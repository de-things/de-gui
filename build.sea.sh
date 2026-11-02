# THIS SCRIPT BUILDS DE-GUI USING MACHINE NATIVE ARCHITECTURE
# [i. e. uname -m output]
# IF YOU WANT TO BUILD APPLICATION FOR OTHER ARCHITECTURE
# USE 'build.podman.sh' INSTEAD!

arch=$(uname -m)

if ! test -f ".cert/trusted.crt" ; then
    echo "Run the server in debug mode first using './init.sh' and finish setup."
    exit 1
fi

echo "Building a standalone executable for $arch architecture."

./bundle.sh

mkdir -p -- bin

rm -rf bin/$arch
mkdir bin/$arch

npx esbuild ./server.js --bundle --platform=node --format=esm --outfile=sea-server.js
node --build-sea sea-config.json
rm sea-server.js
mv server bin/$arch/server

cp -r public bin/$arch/public
cp -r .cert bin/$arch/.cert
cp config.json bin/$arch/config.json