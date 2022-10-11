# Brandon's Environment

Last Update:

- Date: 10/11/2022
- macOS: Monterey 12.6

## Automated Steps

The scripts should be faily idempotent and can be run multiple times safely.

```shell
# Clone this repo...
git clone https://github.com/brandoncole/environment
cd environment

# Choose your own adventure...
./bootstrap/brews.sh
./bootstrap/casks.sh
./bootstrap/defaults.sh
./bootstrap/oh-my-zsh.sh
```

## Manual Steps

The following steps aren't currently automated yet when transfering an old environment to a new computer but should be.

1. Add `./shell/zshrc` to `~/.zshrc`
2. Copy `~/.zsh_history` from old computer
3. Copy `./private` from old computer
