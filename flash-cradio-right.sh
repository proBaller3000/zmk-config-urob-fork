#!/usr/bin/env bash
set -euo pipefail

VOL="/run/media/proballer3000/NICENANO"
UF2="build/nice_nano_v2_cradio_right/zephyr/zmk.uf2"

TIMEOUT=1800
INTERVAL=0.2

echo "Waiting for $VOL (timeout: ${TIMEOUT}s)..."

SECONDS=0
while [[ ! -d "$VOL" ]]; do
  if (( SECONDS >= TIMEOUT )); then
    echo "Timeout: $VOL not mounted."
    exit 1
  fi
  sleep "$INTERVAL"
done

echo "NICENANO detected — flashing cradio right..."
cp -f "$UF2" "$VOL/" >/dev/null 2>&1 || true
sync >/dev/null 2>&1 || true
echo "Done"
