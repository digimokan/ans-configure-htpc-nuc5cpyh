# ans-configure-htpc-nuc5cpyh

_ansible_ script that configures an Arch Linux system for use as an
[HTPC](https://en.wikipedia.org/wiki/Home_theater_PC).

[![Release](https://img.shields.io/github/release/digimokan/ans-configure-htpc-nuc5cpyh.svg?label=release)](https://github.com/digimokan/ans-configure-htpc-nuc5cpyh/releases/latest "Latest Release Notes")
[![License](https://img.shields.io/badge/license-MIT-blue.svg?label=license)](LICENSE.txt "Project License")

## Table Of Contents

* [Motivation](#motivation)
* [Hardware](#hardware)
* [Pre-Configuration Steps](#pre-configuration-steps)
    * [Create Archiso Live USB](#create-archiso-live-usb)
    * [Install Minimal Arch Linux To HTPC](#install-minimal-arch-linux-to-htpc)
* [Configuration Steps](#configuration-steps)
* [Full Usage / Options](#full-usage--options)
* [Source Code Layout](#source-code-layout)
* [Contributing](#contributing)

## Motivation

Configure an Intel NUC running a minimal/base Arch Linux installation. Set up
[Kodi](https://kodi.tv/) with some add-ons.

## Hardware

* [Intel NUC5CPYH Dual-Core 2.16 GHz Celeron N3050 NUC](https://www.amazon.com/dp/B00XPVRR5M)
* [Crucial 8GB DDR3 RAM](https://www.amazon.com/gp/product/B00LTV2BBK)
* [Samsung 860 Pro 256GB SSD](https://www.amazon.com/gp/product/B07864XMTK)

## Pre-Configuration Steps

### Create Archiso Live USB

Create an [Archiso Live USB Stick](https://wiki.archlinux.org/index.php/USB_flash_installation_media).
This project used [digimokan/make-archiso-zfs](https://github.com/digimokan/make-archiso-zfs)
and an empty USB flash drive at /dev/sdx:

   ```shell
   $ sudo ./make-archiso-zfs.sh --build-iso \
                                --add-and-enable-stable-zfs-kernel \
                                --extra-packages="git,ansible" \
                                --write-iso-to-device=/dev/sdx
   ```

### Install Minimal Arch Linux To HTPC

Use the Live USB stick to install a minimal, working Arch Linux to the HTPC.
This project used [digimokan/ansible-install-arch-zfs](https://github.com/digimokan/ansible-install-arch-zfs),
for the Samsung 860 Pro at /dev/sdb:

   ```shell
   $ ansible-playbook --inventory='hosts' \
                      --extra-vars='{"user_var_install_devices":["sdb"],"user_var_zpool_name":"htpcpool","arch_install_def_time_zone_file":"US/Central","arch_install_def_hostname":"htpc"}' \
                      playbook.yml
   ```

## Configuration Steps

1. As required: use `pacman` to install `git` and `ansible` packages:

   ```shell
   $ pacman -S git ansible
   ```

2. Clone project into a local project directory:

   ```shell
   $ git clone https://github.com/digimokan/ans-configure-htpc-nuc5cpyh.git
   ```

3. Change to the local project directory:

   ```shell
   $ cd ans-configure-htpc-nuc5cpyh
   ```

4. Run the _ansible_ configuration script:

   ```shell
   $ ansible-playbook -i hosts -e '{"admin_user_def_pass_salt":"secret123"}' playbook.yml
   ```

## Full Usage / Options

Instead of specifying variables on the command line (with `-e`), you can create
a variables file, like this example:

   ```
   # vars_file.txt
   admin_group_def_group_name: "admin"
   admin_user_def_user_name: "admin"
   admin_user_def_pass_salt: "secret123"
   admin_user_prompt_user_password: "mypass123"
   ```

Then you can use `vars_file.txt` when running the playbook:

   ```shell
   $ ansible-playbook -i hosts -e '@vars_file.txt' playbook.yml
   ```

See the role `vars` files for a full listing of available vars:

  * [admin-group](#../roles/admin-group/defaults/main.yml)
  * [admin-user](#../roles/admin-user/defaults/main.yml)

## Source Code Layout

```
├─┬ ans-configure-htpc-nuc5cpyh/
│ │
│ ├─┬ roles/
│ │ ├── admin-group/      # create an admin group for the system
│ │ ├── admin-user/       # create a admin user for the system
│ │ ├── cpu-ucode/        # configure intel/amd cpu microcode to load at boot
│ │ └── mirrors-update/   # update pacman mirrorlist file, if it's too old
│ │
│ ├── ansible.cfg         # play-wide ansible meta-config
│ ├── hosts               # ansible inventory (configured for local host)
│ └── playbook.yml        # main ansible playbook
│
```

## Contributing

* Feel free to report a bug or propose a feature by opening a new
  [Issue](https://github.com/digimokan/ans-configure-htpc-nuc5cpyh/issues).
* Follow the project's [Contributing](CONTRIBUTING.md) guidelines.
* Respect the project's [Code Of Conduct](CODE_OF_CONDUCT.md).

