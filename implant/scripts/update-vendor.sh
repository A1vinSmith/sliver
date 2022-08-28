#!/bin/sh

set -e

# we are expecting from run from sliver/implant via 'go generate'
cd scripts

# copy Go module related files
pwd="$(pwd)"
tempDir="$(mktemp -d)"
cp ../go-mod "${tempDir}/go.mod"
cp ../go-sum "${tempDir}/go.sum"
mv ../vendor "${tempDir}/vendor"

# build Go file with all imported packages
go run update-vendor.go "$tempDir"
cd "$tempDir"
# update vendor dir
go mod tidy -compat=1.17
go mod vendor

# move updated files back
mv "${tempDir}/vendor" "${pwd}/../vendor"
mv "${tempDir}/go.mod" "${pwd}/../go-mod"
mv "${tempDir}/go.sum" "${pwd}/../go-sum"
cd ..
rm -rf "$tempDir"
