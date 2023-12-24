set -u

PROJECT_NAME="syft"
OWNER=anchore
REPO="${PROJECT_NAME}"
GITHUB_DOWNLOAD_PREFIX=https://github.com/${OWNER}/${REPO}/releases/download
INSTALL_SH_BASE_URL=https://raw.githubusercontent.com/${OWNER}/${PROJECT_NAME}
PROGRAM_ARGS=$@

# do not change the name of this parameter (this must always be backwards compatible)
DOWNLOAD_TAG_INSTALL_SCRIPT=${DOWNLOAD_TAG_INSTALL_SCRIPT:-true}

#
# usage [script-name]
#
usage() (
  this=$1
  cat <<EOF
$this: download go binaries for anchore/syft

Usage: $this [-b] dir [-d] [tag]
  -b  the installation directory (dDefaults to ./bin)
  -d  turns on debug logging
  -dd turns on trace logging
  [tag] the specific release to use (if missing, then the latest will be used)
EOF
  exit 2
)
