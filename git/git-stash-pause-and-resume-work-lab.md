# Git stash lab: pause and resume local work

Use a stash when you need to switch tasks before your current changes are ready to commit. This lab uses a disposable local repository so it will not affect project work.

## Goal

Save tracked and untracked changes, inspect the saved work, then restore it without losing the stash entry.

## Prerequisites

- Git installed and available in a terminal.
- A shell in which you can create a temporary directory.
- Git author name and email configured if this is your first local commit.

## 1. Create a disposable repository

Run these commands in a new terminal session:

```sh
mkdir git-stash-demo
cd git-stash-demo
git init
printf 'version 1\n' > app.txt
git add app.txt
git commit -m "Add baseline file"
```

If Git asks for your identity, configure it for this repository only:

```sh
git config user.name "Your Name"
git config user.email "you@example.com"
```

Then repeat the `git commit` command.

## 2. Make tracked and untracked changes

```sh
printf 'version 2\n' > app.txt
printf 'temporary notes\n' > notes.txt
git status --short
```

Expected status includes a modified `app.txt` and an untracked `notes.txt`.

## 3. Stash both kinds of changes

```sh
git stash push -u -m "pause demo changes"
git status --short
git stash list
git stash show --stat 'stash@{0}'
```

The `-u` flag includes untracked files. After stashing, `git status --short` should be empty, and the stash list should show the message `pause demo changes`.

## 4. Restore and verify

Use `apply` first so the stash remains available until you confirm the files came back:

```sh
git stash apply 'stash@{0}'
git status --short
cat app.txt
cat notes.txt
git stash list
```

You should see both changes again, and the stash entry should still be listed. If applying a stash reports conflicts, resolve them as normal merge conflicts; the stash is retained.

After confirming the restored work, remove only this lab's stash entry:

```sh
git stash drop 'stash@{0}'
git stash list
```

The final list should no longer contain `pause demo changes`. Check the message before dropping an entry if you have other stashes.

## Key takeaway

`git stash push` saves working-tree changes and returns the checkout to `HEAD`. Use `git stash list` and `git stash show` to inspect entries. `git stash apply` restores changes but keeps the entry; `git stash pop` restores and removes it when successful. Prefer `apply` when you want time to verify the restoration.

## Reference

- [Git documentation: git-stash](https://git-scm.com/docs/git-stash)
