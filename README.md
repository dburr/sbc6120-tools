# sbc6120-tools
A set of tools for reading/writing image files for the Spare Time Gizmos SBC6120 single board computer

I needed a way to set up the CF card of my newly built [SBC6120](http://www.sparetimegizmos.com/Hardware/SBC6120-2.htm)
single-board computer. Steve Gibson has an excellent set of [SBC6120 Windows utilities](https://www.grc.com/pdp-8/os8utils-sbc.htm)
but unfortunately they are incompatible with Windows 10+, and I couldn't get them to work properly in an XP virtual machine.
Besides which, I'm a Linux guy, and I'd rather do as much as possible in Linux and not have to run VMs or
boot to Windows. So I hacked up my own set of tools. :)

These tools should work on most Unix/Linux systems. The commands `blockdev`, `stat`, `dd` and `pv` are required.
Most Linux distributions should have these, if not installed by default, then somewhere in their package
repository. Unfortunately they do NOT work on OS X, as OS X is completely missing the `blockdev` command,
and its `stat` command uses a different syntax than the Linux variant.

**You will most likely need to run these commands as the `root` user.** Most Linux/Unix distros come with
the `sudo` command that makes this relatively easy. E.g. `sudo ./from_sbc.sh /dev/sdc 0001 system_backup.img`

### `from_sbc.sh [device] [partition] [output_image_file]`

Copies a partition from an SBC6120 format drive into an image file. `partition` must be specified in octal.
This is roughly equivalent to Steve's `AtaToWin` tool.

Example: `from_sbc.sh /dev/sdc 0001 system_backup.img` writes partition `0001` from the SBC6120 formatted
disk at `/dev/sdc` to a file named `system_backup.img`.

### `to_sbc.sh [image_file] [device] [partition]`

Writes an image file to a given partition of an SBC6120 format drive. `partition` must be specified in octal.
This is roughly equivalent to Steve's `WinToAta` tool.

Example: `to_sbc.sh games.img /dev/sdc 0010` writes the contents of the file `games.img` onto partition `0010`
of the SBC6120 formatted disk at `/dev/sdc`.

# NOTES

Unfortunately I do not have an equivalent to Steve's `InstallOS8` utility. To initially set up your card, just
download the raw OS/8 system and (optionally) games partitions from [Steve's page](https://www.grc.com/pdp-8/os8utils-sbc.htm)
and use `to_sbc.sh` to write them to partition `0000` (and optionally `0001`) of your card.

# TODO

* more error checking
