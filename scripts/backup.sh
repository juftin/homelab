#!/usr/bin/env bash

set -e

show_help() {
    echo -e "Usage: ${0} [source_directory] [target_directory]\n"
    echo -e "This script backs up a specified directory into a .tar.gz file"
    echo -e "located in the target directory with a timestamped name. 📦\n"
    echo -e "Arguments:"
    echo -e "  source_directory   The directory to back up."
    echo -e "  target_directory   The directory where the backup file will be saved.\n"
    echo -e "Options:"
    echo -e "  --no-timestamp     Do not append a timestamp to the backup file name."
    echo -e "  -h, --help         Display this help message and exit.\n"
    echo -e "Example:"
    echo -e "  ${0} /path/to/source /path/to/target\n"
    echo -e "The script uses 'tar' for archiving and gzip compression. 🗜️"
}


if [[ "${1}" == "-h" || "${1}" == "--help" ]]; then
    show_help
    exit 0
elif [[ "${1}" == "" || "${2}" == "" ]]; then
    show_help
    exit 1
fi

SOURCE_DIR=$(readlink -f "${1}")
TARGET_DIR=$(readlink -f "${2}")

# if --no-timestamp is passed as any argument, the backup will not have a timestamp
if [[ "${@}" == *"--no-timestamp"* ]]; then
  TIMESTAMP_SUFFIX=""
else
  TIMESTAMP=$(date +%Y%m%d%H%M)
  TIMESTAMP_SUFFIX="_${TIMESTAMP}"
fi

BACKUP_NAME="$(basename "${SOURCE_DIR}")${TIMESTAMP_SUFFIX}.tar.gz"
BACKUP_PATH="${TARGET_DIR}/${BACKUP_NAME}"

echo -e "Preparing backup... 🚀"
echo -e "Source: ${SOURCE_DIR} 📂"
echo -e "Target: ${BACKUP_PATH} 📦"

tar -czf \
  "${BACKUP_PATH}" \
  --exclude "acme.json" \
  --exclude "portainer" \
  -C "$(dirname "${SOURCE_DIR}")" \
  "$(basename "${SOURCE_DIR}")"

if [ ${?} -eq 0 ]; then
    echo -e "Backup size: $(du -h "${BACKUP_PATH}" | cut -f1) ⚖️"
    echo -e "Backup successful ✅"
else
    echo -e "Backup failed ❌"
    exit 2
fi
