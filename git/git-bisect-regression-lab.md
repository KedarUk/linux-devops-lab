# Find a regression with `git bisect`

**Goal:** Locate the commit that introduced a bug by checking a sequence of commits.

**Prerequisites:** Git and a terminal. This exercise creates a disposable repository in the current directory.

## 1. Create a small history

```bash
mkdir git-bisect-demo
cd git-bisect-demo
git init -b main
git config user.name "DevOps Learner"
git config user.email "learner@example.test"
printf '#!/bin/sh\nprintf "%s\\n" "$((2 + 3))"\n' > calculate.sh
chmod +x calculate.sh
git add calculate.sh
git commit -m "Add correct calculation"
git tag known-good
```

The script should print `5`. Add one healthy commit, then a commit with a regression:

```bash
printf '\nThis file is a harmless change.\n' > NOTES.md
git add NOTES.md
git commit -m "Add notes"
printf '#!/bin/sh\nprintf "%s\\n" "$((2 + 4))"\n' > calculate.sh
git add calculate.sh
git commit -m "Change calculation"
```

## 2. Mark the known bad and good points

The current commit is broken; the tagged first commit is known to work:

```bash
git bisect start
git bisect bad HEAD
git bisect good known-good
```

Git checks out a commit between those points. Test it:

```bash
./calculate.sh
```

If it prints `5`, mark that revision good. If it prints `6`, mark it bad:

```bash
git bisect good
# or, if the output was 6:
git bisect bad
```

Git reports the first commit that introduced the regression. With this tiny history, the result should be `Change calculation`.

## 3. Finish the bisect session

```bash
git bisect reset
```

This returns the worktree to the branch and commit where you started.

## Automate the check

For repeatable bugs, pass `git bisect run` a command that exits with status 0 when the revision is good and nonzero when it is bad:

```bash
git bisect start
git bisect bad HEAD
git bisect good known-good
git bisect run sh -c '[ "$(./calculate.sh)" = 5 ]'
git bisect reset
```

**Expected result:** Git prints the first bad commit without requiring you to inspect every revision manually.

## Key takeaway

`git bisect` uses binary search over commit history. A reliable, repeatable test lets it narrow a regression to one commit much faster than checking commits one by one.
