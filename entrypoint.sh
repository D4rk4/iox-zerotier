#!/bin/sh
data="${CAF_APP_PERSISTENT_DIR}"

grepzt() {
  [ ! -n "$(cat ${data}/zerotier-one.pid)" -a -d "/proc/$(cat ${data}/zerotier-one.pid)" ]
  return $?
}

mkztfile() {
  file=$1
  mode=$2
  content=$3

  mkdir -p /data
  echo "$content" > "${data}/$file"
  chmod "$mode" "${data}/$file"
}

if [ "x$ZEROTIER_API_SECRET" != "x" ]
then
  mkztfile authtoken.secret 0600 "$ZEROTIER_API_SECRET"
fi

if [ "x$ZEROTIER_IDENTITY_PUBLIC" != "x" ]
then
  mkztfile identity.public 0644 "$ZEROTIER_IDENTITY_PUBLIC"
fi

if [ "x$ZEROTIER_IDENTITY_SECRET" != "x" ]
then
  mkztfile identity.secret 0600 "$ZEROTIER_IDENTITY_SECRET"
fi

mkztfile zerotier-one.port 0600 "9993"

killzerotier() {
  echo "Killing zerotier"
  kill $(cat ${data}/zerotier-one.pid)  
  exit 0
}

trap killzerotier INT TERM

echo "starting zerotier"
nohup /usr/sbin/zerotier-one ${data} &

while ! grepzt
do
  echo "zerotier hasn't started, waiting a second"
  sleep 1
done

echo "joining networks: $@"

for i in "$@"
do
  echo "joining $i"

  while ! zerotier-cli join "$i" -D${data}
  do 
    echo "joining $i failed; trying again in 1s"
    sleep 1
  done
done

echo "Creating L2 bridge"
while ! ifconfig | grep zt
do
  echo "Waiting for first ZeroTier interface"
  sleep 3
done

ifconfig eth1 up \
	&& brctl addbr br0 \
	&& brctl addif br0 eth1 \
	&& brctl addif br0 $(ifconfig | grep zt | head -1 | awk '{print $1}')

sleep infinity
