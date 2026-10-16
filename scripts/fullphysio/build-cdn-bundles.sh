#!/bin/zsh
set -euo pipefail
out_dir=${1:?usage: build-cdn-bundles.sh <out-dir>}
repo=$(git -C "$(dirname "$0")" rev-parse --show-toplevel)
cd "$repo"
npx lerna run build --scope @firebase/remote-config --scope @firebase/messaging --scope @firebase/functions --include-dependencies
cd packages/firebase
version=$(node -p "require('./package.json').version")
commit=$(git rev-parse --short HEAD)
npx rollup -c rollup.fullphysio.config.js
mkdir -p "$out_dir"
for bundle in firebase-remote-config.js firebase-messaging.js firebase-functions.js; do
  {
    echo "/* Fullphysio/firebase-js-sdk@$commit (firebase $version) */"
    sed -E "s#(['\"])@firebase/app(['\"])#\1https://www.gstatic.com/firebasejs/$version/firebase-app.js\2#g; /^\/\/# sourceMappingURL=/d" "$bundle"
  } > "$out_dir/$bundle"
  rm -f "$bundle" "$bundle.map"
done
