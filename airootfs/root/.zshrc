echo '********************************************************************'
echo '*                                                                  *'
echo '*   Welcome to Gabriel'\''s Custom Arch ISO!                          *'
echo '*                                                                  *'
echo '*   Useful commands:                                               *'
echo '*   (Note: Replace /dev/sdaX with your disk/partition)             *'
echo '*                                                                  *'
echo '*   - Check your disk partitions : lsblk                           *'
echo '*   - Edit your disk partitions  : cfdisk /dev/sda                 *'
echo '*   - Recreate disk from scratch : cfdisk -z /dev/sda              *'
echo '*   - Make a file system         : mkfs.ext4 /dev/sdaX -L "Arch"   *'
echo '*   - Mount your partitions      : mount /dev/sdaX /mnt            *'
echo '*   - Install Arch Linux         : ./install.sh                    *'
echo '*                                                                  *'
echo '*   Optional commands:                                             *'
echo '*                                                                  *'
echo '*   - Edit default install info  : vim env.sh                      *'
echo '*   - Start a graphical display  : startx                          *'
echo '*   - Test your GPU performance  : glxgears                        *'
echo '*   - Get information of your PC : lspci                           *'
echo '*                                                                  *'
echo '********************************************************************'

loadkeys la-latin1
setxkbmap latam > /dev/null 2>&1

