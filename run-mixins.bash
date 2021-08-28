#!/bin/bash

go get github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb
echo "$HOME/go/bin" >> "$GITHUB_PATH"

jb
jsonnet
git
./jb