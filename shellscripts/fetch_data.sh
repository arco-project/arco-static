#!/bin/bash

echo "fetching transkriptions from data_repo"
rm -rf data/
curl -LO https://github.com/arco-project/arco-data/archive/refs/heads/main.zip
unzip main

mv ./arco-data-main/data/ .

rm main.zip
rm -rf ./arco-data-main

echo "fetch imprint"
./shellscripts/dl_imprint.sh
