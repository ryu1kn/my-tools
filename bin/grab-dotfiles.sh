#!/bin/bash
# Copy dotfiles from backup location to your HOME

set -euo pipefail

WALK_DOTFILES_SCRIPT=$(dirname "$0")/../lib/shell/walk-dotfiles.sh

$WALK_DOTFILES_SCRIPT "cp -r"
