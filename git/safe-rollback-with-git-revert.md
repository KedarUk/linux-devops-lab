# Roll back a change safely with `git revert`

**Goal:** Undo a committed change while keeping the commit history intact.

**Prerequisites:** Git and a terminal. This exercise creates a disposable repository in the current directory.

## 1. Create a small example history

```bash
mkdir git-revert-lab
cd git-revert-lab
git init -b main
git config user.name "DevOps Learner"
git config user.email "learner@example.test"
printf 'APP_MODE=stable\n' > app.env
git add app.env
git commit -m "Set stable application mode"
printf 'APP_MODE=experimental\n' > app.env
git commit -am "Enable experimental mode"
```

Check the current value:

```bash
cat app.env
```

Expected output: `APP_MODE=experimental`.

## 2. Revert the latest commit

```bash
git revert --no-edit HEAD
cat app.env
git log --oneline -3
```

Expected output: `app.env` now contains `APP_MODE=stable`. The log includes a new commit whose subject starts with `Revert`. The original commit remains in history.

## Why use `revert`?

`git revert` makes a new commit that applies the inverse of an earlier commit. This is useful when the original change has already been pushed or shared, because teammates do not need their branch history rewritten. By comparison, reset moves a branch to another commit and can discard local changes if used with destructive options.

## If Git reports a conflict

A later change may overlap with the change you are reverting. Inspect `git status`, resolve each conflict to the content you intend to keep, then run:

```bash
git add <resolved-file>
git revert --continue
```

To cancel an in-progress revert and return to its starting state, run `git revert --abort`.

## Key takeaway

Use `git revert <commit>` to record a public rollback as a new commit. Explain the operational reason in the commit message when reverting a real change.

Reference: [Git revert documentation](https://git-scm.com/docs/git-revert)
