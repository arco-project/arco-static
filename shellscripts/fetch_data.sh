#!/bin/bash

# echo "fetching transkriptions from data_repo"
# rm -rf data/
# curl -LO https://github.com/arco-project/arco-data/archive/refs/heads/main.zip
# unzip main

# mv ./arco-data-main/data/ .

# rm main.zip
# rm -rf ./arco-data-main

echo "fetch imprint"
./shellscripts/dl_imprint.sh

echo "adding xml:id and next/prev attributes into root element of tei-docs"
uv run add-attributes -g "./data/editions/*.xml" -b "https://arco.acdh.oeaw.ac.at"
uv run add-attributes -g "./data/indices/*.xml" -b "https://arco.acdh.oeaw.ac.at"
uv run add-attributes -g "./data/meta/*.xml" -b "https://arco.acdh.oeaw.ac.at"