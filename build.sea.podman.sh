# THIS SCRIPT BUILDS DE-GUI USING PODMAN + QEMU 
# AND EMULATE DESIRED ARCHITECTURE.
# YOU CAN CROSS-COMPILE THIS APPLICATION USING THESE TOOLS
# IN ORDER YOU'VE INSTALLED THEM

if [[ -z "${1:-}" ]]; then
  echo "You need to specify build architecture to emulate." >&2
  echo "Example: './build.sea.podman.sh arm64'" >&2
  echo "Also make sure 'qemu' is installed on your machine." >&2
  exit 1
fi

arch=$1

if ! test -f ".cert/trusted.crt" ; then
    echo "Run the server in debug mode first using './start.sh' and finish setup."
    exit 1
fi

echo "Building a standalone executable for $arch architecture."

./bundle.sh

mkdir -p -- bin

rm -rf bin/$arch
mkdir bin/$arch

npx esbuild server.js \
  --bundle \
  --platform=node \
  --format=cjs \
  --outfile=sea-server.cjs

podman run --rm --platform linux/$arch \
  -v "$PWD:/work:Z" \
  -w /work \
  docker.io/library/node:25.5-bookworm \
  node --build-sea sea-config.podman.json

rm sea-server.cjs
mv server bin/$arch/server

cp -r public bin/$arch/public
cp -r .cert bin/$arch/.cert
cp config.json bin/$arch/config.json

# YOU CAN TEST YOUR BUILD RUNNING THIS IN BUILD DIRECTORY:
# podman run --rm --platform linux/arm64 \ # SPECIFY DESIRED ARCHITECTURE
#   -p 1984:1984 \ # SPECIFY DESIRED SERVER PORT
#   -v "$PWD:/work:Z" \
#   -w /work \
#   docker.io/library/node:25.5-bookworm \
#   ./server