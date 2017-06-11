# ArchISOMaker
A custom Arch Linux ISO Maker (Just a bunch of scripts)

## Instructions

* Login as root

* Create a `pkg` folder in airootfs/etc/skel.
```bash
# mkdir -p airootfs/etc/skel/pkg
```

* Put the `custom.*` files and all of your Arch Linux packages (that were downloaded using the list in `airootfs/etc/skel/commands-all.sh`) in the `pkg` folder.

* Go back to where you cloned this repo.

* Run the command
```bash
# ./build -v
```

* Get your new ISO from `out` folder

