# sbc6120-tools
A set of tools for reading/writing image files for the Spare Time Gizmos SBC6120 single board computer

These tools should work on most Unix/Linux systems. The commands `blockdev`, `stat` and `pv` are required.
Most Linux distributions should have these, if not installed by default, then somewhere in their package
repository. Unfortunately it does NOT work on OS X, as OS X is completely missing the `blockdev` command,
and its `stat` command uses a different syntax than the Linux `stat` command.

### `from_sbc.sh [device] [partition] [output_image_file]`

Copies a partition from an SBC6120 format drive into an image file. `partition` must be specified in octal.

### `to_sbc.sh [image_file] [device] [partition]`

Writes an image file to a given partition of an SBC6120 format drive. `partition` must be specified in octal.

# TODO

* more error checking
