#!/bin/bash
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin


trigger=$(ssh c3 pcs status | grep mariadb:pcmklatest -A3 | grep -o Master | wc -l)

if [ "$trigger" -ne 2 ]; then
  echo "The Master count is not equal to 2"
  echo "************* failure time: $(date) *********************"
  # Function to get the sequence number from a node
  get_sequence_number() {
      ssh "$1" docker exec "$(ssh "$1" docker ps -q -f name=gal)" cat /var/lib/mysql/grastate.dat | grep seqno | awk '{print $2}'
  }

  # Find the node with the highest sequence number
  highest_sequence_node=""
  highest_sequence_value=0
  for i in c{2..3}; do
      dd=$(get_sequence_number "$i")
      if ((dd > highest_sequence_value)); then
          highest_sequence_value=$dd
          highest_sequence_node=$i
      fi
  done

  if [ "$highest_sequence_node" = "" ]; then
      echo "No nodes found with sequence numbers."
      exit 1
  fi

  echo "Node with the highest sequence number: $highest_sequence_node"
  echo "Sequence number: $highest_sequence_value"

  # Run the command on the node with the highest sequence number
  ssh "$highest_sequence_node" docker exec $(ssh "$highest_sequence_node" docker ps -q -f name=gal) sed -i "/safe_to_bootstrap/s/0/1/" /var/lib/mysql/grastate.dat
  #ssh "$highest_sequence_node" pcs resource restart galera-bundle

  ssh "$highest_sequence_node" pcs resource restart galera-bundle
else
  echo " $(date +"%Y-%m-%d--%H-%M") - Master number is equal $trigger and ignoring"
fi
