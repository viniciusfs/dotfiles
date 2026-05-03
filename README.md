# dotfiles

My dotfiles. I keep them in sync using [homeshick](https://github.com/andsens/homeshick).

    homeshick clone git@github.com:viniciusfs/dotfiles.git
    homeshick link

## Testing

Run the post-install script in a clean Ubuntu 24.04 Docker container:

```bash
./test/run.sh
```

First run downloads all tools (~2 GB). Subsequent runs reuse the cache and complete in 2–5 minutes.

To clear the mise tool cache:

```bash
docker volume rm dotfiles-mise-cache
```
