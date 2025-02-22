#!/usr/bin/env bash

BASE="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"
WORKSPACE="/home/ubuntu/results"
F_NAME="$(basename -- $1)"


cd ~

echo "Copy fullnode folder... (this may take couple minutes)"

rsync -avh --delete --info=progress2 ~/fullnode_bak/ ~/fullnode
rsync -avh --delete --info=progress2 ~/fullnode_bak/ ~/import

$BASE/parity/target/release/parity --accounts-refresh=0 \
   --fast-unlock --no-warp --no-consensus --config \
   $BASE/parity/configs/config.dev-insecure.toml \
   --chain $BASE/parity/configs/foundation.json  \
   --base-path=/home/ubuntu/fullnode --logging=error \
   --unsafe-expose --jsonrpc-cors=all --no-discovery  --cache-size 8096 &

parity_pid=$!

sleep 10

~/.local/bin/psrecord $parity_pid --interval 0.1 --log $WORKSPACE/$F_NAME-$3.cpu.txt &
psrecord=$!


python3 $2 /home/ubuntu/fullnode/jsonrpc.ipc $3 \
  $1 $BASE/scripts/keys/leo123leo987 $BASE/scripts/keys/leo123leo456 &
replay=$!

sleep 1

python3 $BASE/scripts/miner.py /home/ubuntu/fullnode/jsonrpc.ipc &
miner=$!

wait $replay

killall psrecord
killall parity
sleep 5
kill $miner
killall -9 parity


$BASE/parity/target/release/parity export blocks \
  --config $BASE/parity/configs/config.dev-insecure.toml  --chain $BASE/parity/configs/foundation.json \
 --base-path=/home/ubuntu/fullnode $WORKSPACE/$F_NAME-$3-mainchain.bin  --from 5052259

$BASE/parity/target/release/parity import $WORKSPACE/$F_NAME-$3-mainchain.bin\
  --config $BASE/parity/configs/config.dev-insecure.toml  --chain $BASE/parity/configs/foundation.json \
  --base-path=/home/ubuntu/import --logging=error > $WORKSPACE/$F_NAME-$3.db.txt
