# 2022-09-07-14-08-22 How to Sync Upstream with Fork
Created: 2022-09-07 14:08:22

To check if your fork of a repo has a upstream remote configured, run:
```bash
git remote -v
```

Repo with upstream remote:
```bash
> origin  https://github.com/Blouinc/grazing-interaction (fetch)
> origin  https://github.com/Blouinc/grazing-interaction (push)
> upstream        https://github.com/amantaya/grazing-interaction.git > (fetch)
>upstream        https://github.com/amantaya/grazing-interaction.git (push) 
```

Repo without upstream remote:
```bash
origin  https://github.com/amantaya/grazing-interaction (fetch)
origin  https://github.com/amantaya/grazing-interaction (push) 
```

To add an upstream remote to a repo, run:
```bash
git remote add upstream https://github.com/amantaya/grazing-interaction
```

To merge commits from upstream repo to your local fork:
```bash
# switches to your fork's 'main' branch
git checkout main

# merges the upstream changes into your fork
git merge upstream/main

# pushes the changes to your fork
git push
```

## Tags
#git #github #dev 

## References
1. https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork
2. https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/configuring-a-remote-for-a-fork