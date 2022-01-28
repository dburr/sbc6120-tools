#!/bin/bash
#
# Copyright (c) 2021, Donald Burr
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.

# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.

# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

DEVICE="$1"
PART_NO="$2"
FILE="$3"

PART_SIZE=2097152
BLK_SIZE=1

if [ -z "$PART_NO" -o -z "$FILE" ]; then
  echo "usage: $(basename $0) device partition_no file"
  exit 1
fi

re='^[0-9]+$'
if ! [[ $PART_NO =~ $re ]] ; then
  echo "ERROR: \`$PART_NO': not a number"
  exit 1
fi

if [ ! -e "$DEVICE" ]; then
  echo "ERROR: no such device: $DEVICE"
  exit 1
fi

if [ -b "$DEVICE" ]; then
  DEVSIZE=$(blockdev --getsize64 "$DEVICE")
else
  DEVSIZE=$(stat -c %s "$DEVICE")
fi

if ! [[ $PART_NO =~ ^[0-7]+$ ]]; then
  echo "ERROR: partition must be specified as octal"
  exit 1
fi

echo "partition number is $PART_NO"
PART_DEC=$((8#$PART_NO))
echo "in decimal that's $PART_DEC"
OFFSET=$(((PART_DEC * PART_SIZE) / $BLK_SIZE))
echo "offset is $OFFSET"
echo "devsize $DEVSIZE"

if [ $OFFSET -ge $DEVSIZE ]; then
  echo "ERROR: partition $PART_NO canot exist on a device of size $DEVSIZE"
  exit 1
fi

echo "Copying partition $PART_NO (dec: $PART_DEC) of device $DEVICE to \`$FILE'..."
echo "part_size=$PART_SIZE"
C=$((PART_SIZE / $BLK_SIZE))

dd if="$DEVICE" bs=$BLK_SIZE skip=$OFFSET count=$C 2>/dev/null | pv -s $PART_SIZE | dd of="$FILE" bs=$BLK_SIZE 2>/dev/null

echo "Done!"
