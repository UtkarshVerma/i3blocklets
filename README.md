# i3blocklets
![Demo](/scrot.png)

This repository contains the bash scripts which I use with [i3blocks](https://github.com/vivien/i3blocks).

## Dependencies
To use these scripts, the following dependencies need to be satisfied:

* **Volume Block:**
  - pamixer - [cdemoulins/pamixer](https://github.com/cdemoulins/pamixer)

* **Music Block:**
  - playerctl - [acrisci/playerctl](https://github.com/acrisci/playerctl)
  - ~~formatTime - [UtkarshVerma/scripts/formatTime](https://github.com/UtkarshVerma/scripts/blob/master/formatTime)~~

* **Gmail Block:**
  - jq - [stedolan/js](https://github.com/stedolan/jq)

* **[FontAwesome](https://fontawesome.com/)** fonts(tested with v4.7.0) are required to render the unicode emojis, therefore specify it in i3bar config as shown:
```
bar {
    # .... other stuff
    font pango:DejaVu Sans Mono, FontAwesome 9
}
```

## Installation
  * Place [`example.conf`](/resources/example.conf) as `i3blocks.conf` in your i3 config directory.
  * Replace `PATH_TO_BLOCKLETS` in the `i3blocks.conf` file with the directory's path which contains your blocklets.

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

### Gmail Block
```
[gmail]
label=📧
interval=1800
instance=.gmail
```
This block will check your gmail account for mails every 1800 seconds, that is the `interval` time.
This blocket uses [OAuth2](https://oauth.net/2/) for authorizing itself. To use this blocklet:
* Create a project on [Google API Console](https://console.developers.google.com/), [enable Gmail API](https://developers.google.com/identity/protocols/OAuth2InstalledApp#enable-apis) for your project, and [create authorization credentials](https://developers.google.com/identity/protocols/OAuth2InstalledApp#creatingcred) for this blocklet. Choose **Other** as *Application Type* while creating the OAuth client ID. Make sure to provide your application `read-only` access.
* Once created, take note of the **Client ID** and **Client Secret**. These will be used later on.
* Edit the [`configFile`](/resources/gmail/configFile) for this blocklet according to your needs and place it in the `$HOME` directory. You may rename it if you like. I personally prefer `.gmail`.
  > The `tokenFile` variable must contain the path to the file which you want to create for storing access tokens for the API.
* Now, generate your access token using [genToken.sh](/resources/gmail/genToken.sh) by running `./genToken.sh -c <configFile>` in the terminal. For example:

  ```bash
  ./genToken.sh -c ~/.gmail
  ```
  Google's user consent webpage will open up in your default browser. Allow this application there. This will generate a JSON file at the path specified in `tokenFile` variable in `configFile`.

Everything's done now. Just add the `gmail` block to your `i3blocks` config as shown above.
> Note that the `instance` variable only holds the name of the `configFile`, and not its path. 

#### The following actions can be performed via the mouse
* Left click - Open GMail in the default browser;
* Right click - Update mail count.

---

### Average Load Block
```
[loadavg]
label=
interval=10
markup=pango
instance=3
```
Shows the average load of the processor. The output is colored **red** if the *average load* exceeds the *threshold value*. The threshold value can be provided through `instance` variable, which defaults to `5`.

#### The following actions can be performed via the mouse:
* Left click- Refresh average load value.

---

### Storage Block
```
[disk]
label=🗄
interval=3600
markup=pango
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
interval=1800
markup=pango
```
This block shows whether your PC is connected to the internet or not. It relies on the `ping` command.

#### The following actions can be performed via the mouse
* Left click - Refresh internet status.

---

For additional insight, you may also look into my i3blocks config file: [i3blocks.conf](https://github.com/UtkarshVerma/dotfiles/blob/master/i3/i3blocks.conf).
