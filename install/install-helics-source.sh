#!/bin/bash

# To run locally, set HELICS_VERSION, INSTALL_PREFIX, and sudo_cmd environment variables; make sure the INSTALL_PREFIX folder already exists

# Set up a temporary directory
echo "Creating temporary directory"
tmpdir="$(mktemp -d)"
pushd "$tmpdir"

# Download HELICS release source archive
SOURCE_ARCHIVE="Helics-${HELICS_VERSION}-source.tar.gz"
echo "Downloading HELICS source archive ($SOURCE_ARCHIVE)"
curl -o "helics.tar.gz" -L "https://github.com/GMLC-TDC/HELICS/releases/download/${HELICS_VERSION}/${SOURCE_ARCHIVE}"

# Extract HELICS source code
echo "Extracting HELICS archive"
tar xf "helics.tar.gz"

# Install Boost
echo "Installing Boost"
BOOST_VERSION="1.74.0"
BOOST_ROOT="$PWD/boost-prefix"
BOOST_URL="https://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION}/boost_${BOOST_VERSION//./_}.tar.bz2/download"
(
  tmp_boost="$(mktemp -d)"
  pushd "$tmp_boost"
  curl --insecure --location --output "download.tar.bz2" "$BOOST_URL"
  tar xfj "download.tar.bz2"
  mkdir -p "$BOOST_ROOT"
  cp -r boost_*/* "$BOOST_ROOT"
  popd
  rm -rf "$tmp_boost"
) || exit
export BOOST_ROOT

# Build HELICS
echo "Building HELICS"
mkdir build
cd build || exit
cmake .. -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}" -DCMAKE_BUILD_TYPE=Release -DHELICS_BUILD_CXX_SHARED_LIB=ON -DHELICS_BUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF -DHELICS_ZMQ_SUBPROJECT=ON
cmake --build . --parallel

# Install HELICS
echo "Installing HELICS"
${sudo_cmd:-} cmake --build . --target install

# Clean-up tmpdir
echo "Cleaning-up temporary directory"
popd
rm -rf "$tmpdir"

