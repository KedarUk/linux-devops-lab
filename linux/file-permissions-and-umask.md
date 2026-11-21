# Set safe file permissions with `chmod` and `umask`

**Goal:** Read permission bits, restrict a new file to its owner, and grant a group read-only access to a sample file.

**Prerequisites:** A Linux shell with GNU `chmod` and `stat`. The exercise writes only inside a new temporary directory.

## 1. Create a private practice file

Run these commands in one shell session:

```bash
lab_dir="$(mktemp -d)"
cd "$lab_dir"
umask 077
printf 'sample value\n' > private.txt
stat -c '%a %n' private.txt
```

Expected output: `600 private.txt`. The owner can read and write the file; group and other users get no permissions.

The `umask` removes permissions from the defaults applications request when creating files. Setting it to `077` in this shell keeps new files private to their owner. It does not change files that already exist.

## 2. Read and set permission bits

Each digit represents owner, group, and other users. Within a digit, read is `4`, write is `2`, and execute is `1`; add the values to combine permissions.

Set a sample configuration file to owner read/write and group read:

```bash
printf 'MODE=demo\n' > shared-config.txt
chmod 640 shared-config.txt
stat -c '%a %n' shared-config.txt
```

Expected output: `640 shared-config.txt`. Mode `640` means owner `rw-`, group `r--`, and others `---`.

The same permissions can be written symbolically:

```bash
chmod u=rw,g=r,o= shared-config.txt
ls -l shared-config.txt
```

Here, `u` means owner, `g` means group, and `o` means everyone else.

## 3. Add execute permission to a script

```bash
printf '#!/bin/sh\necho "permissions lab"\n' > run.sh
chmod u+x run.sh
ls -l run.sh
```

The listing should show an `x` in the owner's permission column. Execute permission on a directory has a different role: it allows traversing or accessing entries in that directory.

## Key takeaway

Choose the narrowest permissions that let the intended users do their work. Avoid broad recursive changes such as `chmod -R 777`; they can expose files and make private or executable content writable by everyone.

References: [GNU Coreutils permission modes](https://www.gnu.org/software/coreutils/manual/html_node/Mode-Structure.html) · [Bash `umask`](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins)
