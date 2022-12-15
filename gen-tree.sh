#!/bin/bash

CONTAINER_SHARE=/container_share
IMAGE_NAME=tex-tree
HOST_SHARE=/tmp/tex_share
PATH_TO_TREE_TEX="$1"
STAGE_NAME=to_tex
PDF_NAME=tree.pdf

if [ $# -ne 1 ]; then
    echo "[!] Usage: $0 <path/to/tree.tex>"
    exit 1
fi

if ! ls "${PATH_TO_TREE_TEX}" &>/dev/null; then
    echo "[!] Supplied path to tex file (${PATH_TO_TREE_TEX}) is invalid"
    exit 1
fi

mkdir -p "${HOST_SHARE}"
rm -rf --preserve-root "${HOST_SHARE:?}/{.*,*}"
cp "${PATH_TO_TREE_TEX}" "${HOST_SHARE}/${STAGE_NAME}"

docker build \
    --build-arg CONTAINER_SHARE="${CONTAINER_SHARE}" \
    --build-arg STAGE_NAME="${STAGE_NAME}" \
    -t "${IMAGE_NAME}" \
    .

docker run \
    --rm \
    -v "${HOST_SHARE}":"${CONTAINER_SHARE}" \
    "${IMAGE_NAME}"

cp "${HOST_SHARE}/${STAGE_NAME}.pdf" ./"${PDF_NAME}"
