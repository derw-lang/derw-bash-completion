# derw-bash-completion

Bash completion for Derw

## Installation

-   Clone this repo
-   Source the `_derw_completions.sh` files in your `~/.bashrc` or `~/.bash_profile`, using `source`
-   Restart bash or open a new terminal session

If you're using Linux, you probably want `.bashrc`. If you're using OS X, you probably want `.bash_profile`.

Example .bashrc or .bash_profile file:

```bash
for f in ~/dev/derw-bash-completion/_*; do source $f; done
```

## Oh My Zsh

Use `bashcompinit`.

```
autoload bashcompinit
bashcompinit
for f in ~/dev/derw-bash-completion/_*; do source $f; done
```
