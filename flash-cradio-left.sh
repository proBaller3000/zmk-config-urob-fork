#!/usr/bin/env bash
set -euo pipefail

UF2="build/nice_nano_v2_cradio_left/zephyr/zmk.uf2"
DEV="/dev/disk/by-label/NICENANO"
TIMEOUT=1800
INTERVAL=0.2

echo "Waiting for NICENANO device (timeout: ${TIMEOUT}s)..."

SECONDS=0
while [[ ! -e "$DEV" ]]; do
  if (( SECONDS >= TIMEOUT )); then
    echo "Timeout: NICENANO not detected."
    exit 1
  fi
  sleep "$INTERVAL"
done

echo "NICENANO detected — mounting..."
udisksctl mount -b "$DEV" >/dev/null 2>&1 || true

MNT=$(findmnt -n -o TARGET "$DEV" 2>/dev/null)
if [[ -z "$MNT" ]]; then
  MNT="/run/media/$USER/NICENANO"
fi

echo "Flashing cradio left to $MNT..."
cp -f "$UF2" "$MNT/" >/dev/null 2>&1 || true
sync >/dev/null 2>&1 || true
echo "Done (unplug when finished)"
