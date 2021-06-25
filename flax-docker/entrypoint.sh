if [[ -n "${TZ}" ]]; then
  echo "Setting timezone to ${TZ}"
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
fi

cd /flax-blockchain

. ./activate

flax init

if [[ ${keys} == "generate" ]]; then
  echo "to use your own keys pass them as a text file -v /path/to/keyfile:/path/in/container and -e keys=\"/path/in/container\""
  flax keys generate
elif [[ ${keys} == "copy" ]]; then
  if [[ -z ${ca} ]]; then
    echo "A path to a copy of the farmer peer's ssl/ca required."
	exit
  else
  flax init -c ${ca}
  fi
else
  flax keys add -f ${keys}
fi

for p in ${plots_dir//:/ }; do
    mkdir -p ${p}
    if [[ ! "$(ls -A $p)" ]]; then
        echo "Plots directory '${p}' appears to be empty, try mounting a plot directory with the docker -v command"
    fi
    flax plots add -d ${p}
done

sed -i 's/localhost/127.0.0.1/g' ~/.flax/mainnet/config/config.yaml

flax configure -log-level INFO

if [[ ${farmer} == 'true' ]]; then
  flax start farmer-only
elif [[ ${harvester} == 'true' ]]; then
  if [[ -z ${farmer_address} || -z ${farmer_port} || -z ${ca} ]]; then
    echo "A farmer peer address, port, and ca path are required."
    exit
  else
    flax configure --set-farmer-peer ${farmer_address}:${farmer_port}
    flax start harvester
  fi
else
  flax start farmer
fi

while true; do sleep 30; done;