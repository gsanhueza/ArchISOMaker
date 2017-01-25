# ArchISOMaker
A custom Arch Linux ISO Maker (Just a bunch of scripts)

## Standard Instructions

* Login as root
* Create a `pkg` folder in airootfs/etc/skel.
```bash
# mkdir -p airootfs/etc/skel/pkg
```

* Go to that folder
```bash
# cd airootfs/etc/skel/pkg
```
* Put all your Arch Linux packages (that were downloaded using the list in `airootfs/etc/skel/commands-all.sh`
* Create your database by running
```bash
# repo-add custom.db.tar.gz *.xz
```
* Go back to this repo's home-page
* Run the command
```bash
# ./build -v
```

* Get your new ISO from `out` folder
