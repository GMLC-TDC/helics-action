#!/bin/bash

# To run locally, set HELICS_VERSION, INSTALL_PREFIX, and sudo_cmd environment variables; make sure the INSTALL_PREFIX folder already exists

# Set up a temporary directory
echo "Creating temporary directory"
tmpdir="$(mktemp -d)"
pushd "$tmpdir" || exit

# Download HELICS release based on the platform
case "$(uname -s)" in
Linux*) platname="Linux-x86_64" && ext="tar.gz" ;;
Darwin*)
	version_full="${HELICS_VERSION:1}"
	major_ver=$(echo "${version_full}.0" | cut -d "." -f1)
        minor_ver=$(echo "${version_full}.0" | cut -d "." -f2)
	if [[ "${major_ver}" -gt "3" || ("${major_ver}" -eq "3" && "${minor_ver}" -ge "1") ]]
	then
		platname="macOS-universal2"
	else
		platname="macOS-x86_64"
	fi
	ext="zip"
	;;
MINGW*) platname="win64" && ext="zip" ;;
*) exit 1 ;;
esac
INSTALLER_DIRNAME="Helics-${HELICS_VERSION:1}-${platname}"
INSTALLER_ARCHIVE="${INSTALLER_DIRNAME}.${ext}"

echo "Downloading HELICS archive ($INSTALLER_ARCHIVE)"
curl -O -L "https://github.com/GMLC-TDC/HELICS/releases/download/v${HELICS_VERSION:1}/${INSTALLER_ARCHIVE}"

# Extract HELICS archive
echo "Extracting HELICS archive"
case "$ext" in
"tar.gz") tar xf "${INSTALLER_ARCHIVE}" ;;
"zip") unzip "${INSTALLER_ARCHIVE}" ;;
*) exit 1 ;;
esac

# "Install" HELICS
echo "Installing HELICS to INSTALL_PREFIX"
cd "${INSTALLER_DIRNAME}" || exit
tar -czf "$tmpdir/helics.tar.gz" -- *
${sudo_cmd:-} tar -xf "$tmpdir/helics.tar.gz" -C "$INSTALL_PREFIX"

# Clean-up tmpdir
echo "Cleaning-up temporary directory"
popd || exit
rm -rf "$tmpdir"
