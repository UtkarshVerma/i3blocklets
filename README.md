# i3blocklets
![Demo](/scrot.jpeg)

This repository contains the bash scripts which I use with [i3blocks](https://github.com/vivien/i3blocks).

## Dependencies
To use these scripts, the following dependencies need to be satisfied:
* **Volume Block:**
  - pamixer - [cdemoulins/pamixer](https://github.com/cdemoulins/pamixer)

* **Music Block:**
  - playerctl - [acrisci/playerctl](https://github.com/acrisci/playerctl)
  - ~~formatTime - [UtkarshVerma/scripts/formatTime](https://github.com/UtkarshVerma/scripts/blob/master/formatTime)~~

> Some additional fonts might be required to render the unicode emojis.

## Usage
### Music Block
```
[music]
label= 🎧
interval=1
instance=""
signal=3
```
You can also pass arguments to `playerctl` through the `instance` config variable. For example, `instance="-p audacious"` will be interpreted as `playerctl -p audacious <random command>`.

#### The following actions can be performed via the mouse
* Left click - Switch to the previous song;
* Right click - Switch to the next song;
* Middle click - Pause/play the current song.
* Scroll up - Seek song forward by 5 seconds;
* Scroll down - Seek song backward by 5 seconds.

~~This seeking capability is only available for `audacious` currently.~~

The seeking capability has now been extended to all music players.

This script focuses only on MPRIS media players. Therefore this script won't work for `cmus`< v2.8.0. You may either update `cmus` or just add a bit of code as a workaround as done in this [older commit](https://github.com/UtkarshVerma/i3blocklets/blob/77ec353d01a12539edb3a3b211dd06f275807d2d/music).

---

### GMail Block
```
[gmail]
label=📧
instance=~/.randomfile
interval=1800
signal=2
```
This block will check your gmail account for mails every 1800 seconds, that is the `interval` time. 
To specify your credentials, store them in a separate file, in my case `.randomfile`, as follows:
```
MAIL_USER="<your email id>"
MAIL_PASSWORD="<your password>"
```
Once done, specify the location of your credentials-file through the `instance` config variable.

#### The following actions can be performed via the mouse
* Left click - Open GMail in the default browser;
* Right click - Update mail count.

---

### Average Load Block
```
[load_average]
label=
interval=10
```
Shows the average load of the processor.

#### The following actions can be performed via the mouse:
* Left click- Refresh average load value.

---

### Storage Block
```
[disk]
label=🗄
interval=3600
instance=""
```
This block shows the remaining space on your disk. By default, the free space of `$HOME` partition will be shown, however, you may specify other partitions as well using the `instance` config variable. For exampe, `instance="/dev/sda2"`.

---

### Volume Block
```
[volume]
interval=once
signal=1
```
This block shows the volume level in percent. To reduce load, this script is loaded only once and then triggered on the press of **media keys** and block clicks. Therefore, it is **highly important** to bind the following command to your *volume keys* on the keyboard, otherwise the changes won't appear on the i3bar.
```
pkill -RTMIN+1 i3blocks
```
#### The following actions can be performed via the mouse
* Left click - Mute;
* Scroll up - Increase volume by 5%;
* Scroll down - Decrease volume by 5%.

---

### Internet Block
```
[internet]
interval=5
```
This block shows whether your PC is connected to the internet or not. It relies on the `ping` command.

For additional insight, you may also look into my i3blocks config file: [i3blocks.conf](https://github.com/UtkarshVerma/dotfiles/blob/master/i3/i3blocks.conf)