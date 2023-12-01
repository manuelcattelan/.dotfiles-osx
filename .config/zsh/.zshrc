#!/bin/zsh
#
# .zshrc - Zsh file loaded on interactive shell sessions.
#

# Zsh options.
setopt extended_glob

# Autoload functions you might want to use with antidote.
ZFUNCDIR=${ZFUNCDIR:-$ZDOTDIR/functions}
fpath=($ZFUNCDIR $fpath)
autoload -Uz $fpath[1]/*(.:t)

# Source zstyles you might use with antidote.
[[ -e ${ZDOTDIR:-~}/.zstyles ]] && source ${ZDOTDIR:-~}/.zstyles

# Clone antidote if necessary.
[[ -d ${ZDOTDIR:-~}/.antidote ]] ||
  git clone https://github.com/mattmc3/antidote ${ZDOTDIR:-~}/.antidote

# Set the name of the static .zsh plugins file antidote will generate.
static_plugins=${ZDOTDIR:-~}/.zplugins.zsh

# Ensure you have a .zplugins file where you can add plugins.
[[ -f ${static_plugins:r} ]] || touch ${static_plugins:r}

# Lazy-load antidote.
fpath+=(${ZDOTDIR:-~}/.antidote)
autoload -Uz $fpath[-1]/antidote

# Generate static file in a subshell when .zplugins is updated.
if [[ ! $static_plugins -nt ${static_plugins:r} ]]; then
  (antidote bundle <${static_plugins:r} >|$static_plugins)
fi

# Source your static plugins file.
source $static_plugins
