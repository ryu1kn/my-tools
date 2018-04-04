#!/bin/bash
# Create dotfiles as symlinks that point backup/source dotfiles

set -euo pipefail

WALK_DOTFILES_SCRIPT=$(dirname "$0")/../lib/shell/walk-dotfiles.sh

$WALK_DOTFILES_SCRIPT "ln -s"
