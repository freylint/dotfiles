#!/usr/bin/env sh

# clone project
git clone https://github.com/sumneko/lua-language-server build/lua-language-server
cd build/lua-language-server
git submodule update --init --recursive

# build project
cd 3rd/luamake
./compile/install.sh
cd ../..
./3rd/luamake/luamake rebuild
