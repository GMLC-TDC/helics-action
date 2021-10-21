#!/bin/bash

# To run locally, set HELICS_VERSION, INSTALL_PREFIX, and sudo_cmd environment variables; make sure the INSTALL_PREFIX folder already exists

# Set up a temporary directory
echo "Creating temporary directory"
tmpdir="$(mktemp -d)"
pushd "$tmpdir"

# Download HELICS release based on the platform
case "$(uname -s)" in
  Linux*) platname="Linux-x86_64" && ext="tar.gz";;
  Darwin*) platname="macOS-x86_64" && ext="zip";;
  MINGW*) platname="win64" && ext="zip";;
  *) exit 1
esac
INSTALLER_DIRNAME="Helics-${HELICS_VERSION:1}-${platname}"
INSTALLER_ARCHIVE="${INSTALLER_DIRNAME}.${ext}"

echo "Downloading HELICS archive ($INSTALLER_ARCHIVE)"
curl -O -L "https://github.com/GMLC-TDC/HELICS/releases/download/v${HELICS_VERSION:1}/${INSTALLER_ARCHIVE}"

# Extract HELICS archive
echo "Extracting HELICS archive"
case "$ext" in
  "tar.gz") tar xf "${INSTALLER_ARCHIVE}";;
  "zip") unzip "${INSTALLER_ARCHIVE}";;
  *) exit 1
esac

# "Install" HELICS
echo "Installing HELICS to INSTALL_PREFIX"
cd "${INSTALLER_DIRNAME}"
tar -czf "$tmpdir/helics.tar.gz" *
$sudo_cmd tar -xf "$tmpdir/helics.tar.gz" -C "$INSTALL_PREFIX"

# Clean-up tmpdir
echo "Cleaning-up temporary directory"
popd
rm -rf "$tmpdir"

