#!/usr/bin/env bash
#
# Install rustlang
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# Install crates
xargs -0 -n 1 cargo install < <(tr \\n \\0 <crates)
# rustup installs
rustup update
rustup component add \
  clippy \
  llvm-tools \
  rust-analyzer \
  rust-src \
  rustfmt
