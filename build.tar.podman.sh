# !!!CHECK 'Dockerfile' FOR DETAILS!!!

if [[ -z "${1:-}" ]]; then
  echo "No architecture specified." >&2
  echo "Try $0 arm64." >&2
  exit 1
fi

arch=$1

echo "Building for [$arch] architecture..."

rm -rf bin/$arch
mkdir -p -- bin/$arch

podman build --platform linux/$arch -t de-gui:latest .
podman save --format docker-archive -o bin/$arch/de-gui.tar de-gui:latest