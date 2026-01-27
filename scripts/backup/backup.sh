#!/bin/bash

# =============================================
# SCRIPT CONFIGURATION
# =============================================

set -euo pipefail  # Stop script if error

# Storage location
RAID="/media/raid"
BACKUP_INTERNAL_HDD="/tmp/backup/internal_hdd" #"/mnt/backup_hdd"
BACKUP_EXTERNAL_HDD="/tmp/backup/external_hdd" #"/mnt/backup_ssd"
LOG_FILE="/var/log/raid_backup/backup_$(date +%Y-%m-%d-%Hh-%Mm-%Ss).log"

# Folder structure
BACKUP_BASE_FOLDER="backup/$(date +%Y-%m-%d-%Hh-%Mm-%Ss)"

# Script mode
SCRIPT_MODE="NONE"
DRY_RUN=false

# Service list to backup
SERVICES=("immich")
# SERVICES=("immich" "vaultwarden")

# Immich docker assets
IMMICH_RAW_LIBRARY_FOLDER="/media/raid/immich/library"
IMMICH_DATABASE_DOCKER_VOLUME="/var/lib/docker/volumes/pictures_immich_database/_data"
IMMICH_DB_SERVICE="pictures_immich_postgresql"
IMMICH_DB_CONTAINER=$(docker container ls --filter "label=com.docker.swarm.service.name=pictures_immich_postgresql" --format '{{.Label "com.docker.swarm.task.name"}}')

# Vaultwarden docker assets
VAULTWARDEN__DOCKER_VOLUME="/var/lib/docker/volumes/miscellaneous_vaultwarden_data/_data"

# =============================================
# UTIL FUNCTIONS
# =============================================

show_help() {
  echo "Usage: $0 [-h help] [-d Daily] [-m Monthly]
  [--daily] to run the script in Daily mode
  [--monthly] to run the script in Monthly mode
  [-h, --help] to get some help
  "
}

log() {
  local level=$1
  local message=$2
  local timestamp=$(date +"%Y-%m-%dT%H:%M:%S%z")
  if $DRY_RUN; then
    local run_type="dry-run"
  else
    local run_type="default"
  fi

  echo -e "$timestamp\t:\t[$level]\t[$run_type]\t$message"
  echo "{timestamp: $timestamp, level: $level, run_type: $run_type, message: $message}" >> $LOG_FILE
} # log "INFO" "This is a demo on how to use the logger"

verify_mount() {
  if [ "$SCRIPT_MODE" = "DAILY" ]; then
    if ! mountpoint -q "$BACKUP_INTERNAL_HDD"; then
      log "FATAL" "$dest is not mounted"
      exit 1
    fi
    log "INFO" "Disks : $BACKUP_INTERNAL_HDD are mounted, continuing..."
  elif [ "$SCRIPT_MODE" = "MONTHLY" ]; then
    for dest in $BACKUP_INTERNAL_HDD $BACKUP_EXTERNAL_HDD ; do
      if ! mountpoint -q "$dest"; then
        log "FATAL" "$dest is not mounted"
        exit 1
      fi
    done
    log "INFO" "Disks : $BACKUP_INTERNAL_HDD, $BACKUP_EXTERNAL_HDD are mounted, continuing..."
  else
    log "FATAL" "Can't define the script mode. Unknown value : $SCRIPT_MODE"
  fi
}

verify_volumes() {
  if [ "$SCRIPT_MODE" = "DAILY" ]; then
    log "INFO" "Volumes are not used in the $SCRIPT_MODE, continuing..."
  elif [ "$SCRIPT_MODE" = "MONTHLY" ]; then
    for dest in $IMMICH_DATABASE_DOCKER_VOLUME $VAULTWARDEN__DOCKER_VOLUME; do
      if [ ! -d $dest ]; then
        log "FATAL" "$dest docker volume does not exists"
      fi
    done
  else
    log "FATAL" "Can't define the script mode. Unknown value : $SCRIPT_MODE"
  fi

}

# =============================================
# BACKUP IMMICH
# =============================================

backup_immich() {
  log "INFO" "Starting backup $SCRIPT_MODE for Immich..."

  if [ "$SCRIPT_MODE" = "DAILY" ]; then
    backup_immich_raw
  elif [ "$SCRIPT_MODE" = "MONTHLY" ]; then
    backup_immich_raw
    backup_immich_database
  else
    log "FATAL" "Can't define the script mode. Unknown value : $SCRIPT_MODE"
  fi
}

backup_immich_raw() {
  # Raw files backup
  if "$DRY_RUN"; then
    if [ -d "$IMMICH_RAW_LIBRARY_FOLDER" ] \
    && [ 'rsync -aq --dry-run --checksum "$IMMICH_RAW_LIBRARY_FOLDER" "$BACKUP_INTERNAL_HDD/$BACKUP_BASE_FOLDER/immich/photos/"' ] \
    && [ 'rsync -aq --dry-run --checksum "$IMMICH_RAW_LIBRARY_FOLDER" "$BACKUP_EXTERNAL_HDD/$BACKUP_BASE_FOLDER/immich/photos/"' ]; then
      log "INFO" "Immich raw files could be backed-up on $SCRIPT_MODE mode"
    else
      log "FATAL" "Can't define if Immich raw files can be backed-up. Exiting !"
      exit 1
    fi
  else
    log "INFO" "Immich raw files backed-up on the HDD, continuing..."
    rsync -aq --checksum "$IMMICH_RAW_LIBRARY_FOLDER" "$BACKUP_INTERNAL_HDD/$BACKUP_BASE_FOLDER/immich/photos/"
    if [ "$?" -eq "0" ];then
      log "INFO" "Immich raw files backed-up on the HDD, continuing..."
    else
      log "FATAL" "Can't backup Immich raw files to HDD. Exiting !"
      exit 1
    fi
    log "INFO" "Immich raw files backed-up on the HDD, continuing..."
    rsync -aq --checksum "$IMMICH_RAW_LIBRARY_FOLDER" "$BACKUP_EXTERNAL_HDD/$BACKUP_BASE_FOLDER/immich/photos/"
    if [ "$?" -eq "0" ];then
      log "INFO" "Immich raw files backed-up on the SSD, continuing..."
    else
      log "FATAL" "Can't backup Immich raw files to HDD. Exiting !"
      exit 1
    fi
    log "INFO" "Immich raw files $SCRIPT_MODE backup completed"
  fi
}

backup_immich_database() {
  # Database extract and backup
  if "$DRY_RUN"; then
    docker exec "$IMMICH_DB_CONTAINER" pg_isready -d immich -h localhost -p 5432 -U postgres >> /dev/null
    if [ "$?" == "0" ]; then
      log "INFO" "PostgreSQL database accepting requests, continuing..."
    elif [ "$?" == "1" ]; then
      log "FATAL" "Can't connect to the database database. Exiting !"
      exit 1
    else
      log "FATAL" "Can't define database state. Exiting !"
      exit 1
    fi
    if [ -d "$BACKUP_INTERNAL_HDD/$BACKUP_BASE_FOLDER/immich/database" ]; then
      log "INFO" "Backup folder exists on HDD, continuing..."
    else
      log "FATAL" "Can't define if HDD database backup destination exists. Exiting !"
      exit 1
    fi
    if [ -d "$BACKUP_EXTERNAL_HDD/$BACKUP_BASE_FOLDER/immich/database" ]; then
      log "INFO" "Backup folder exists on SSD, continuing..."
    else
      log "FATAL" "Can't define if SSD database backup destination exists. Exiting !"
      exit 1
    fi
    log "INFO" "Immich database can be backed-up on $SCRIPT_MODE mode"
  else
    docker exec "$IMMICH_DB_CONTAINER" pg_dump -U postgres -d immich > "$BACKUP_INTERNAL_HDD/$BACKUP_BASE_FOLDER/immich/database/immich_$(date +%Y-%m-%d).sql"
    log "INFO" "Immich database extracted from docker to HDD, continuing..."
    rsync -a "$BACKUP_INTERNAL_HDD/$BACKUP_BASE_FOLDER/immich/database/immich_*.sql" "$BACKUP_EXTERNAL_HDD/$BACKUP_BASE_FOLDER/immich/database/"
    log "INFO" "Immich database extracted from HDD to SSD, continuing..."
    log "INFO" "Immich database $SCRIPT_MODE backup completed !"
  fi
}

# =============================================
# BACKUP VAULTWARDEN
# =============================================

backup_vaultwarden() {
  log "INFO" "Starting backup for Vaultwarden..."

  # Docker volume extract
  rsync -av --checksum "$VAULTWARDEN_DATA" "$BACKUP_INTERNAL_HDD/$BACKUP_BASE_FOLDER/vaultwarden/" | tee -a "$LOG_FILE"
  rsync -av --checksum "$VAULTWARDEN_DATA" "$BACKUP_EXTERNAL_HDD/$BACKUP_BASE_FOLDER/vaultwarden/" | tee -a "$LOG_FILE"

  log "INFO" "Vaultwarden backup completed !"
}

# =============================================
# MAIN FUNCTION
# =============================================

main() {
  log "INFO" "Starting backup routine in $SCRIPT_MODE mode"

  verify_mount
  verify_volumes

  # For each service calling the dedicated function
  for service in "${SERVICES[@]}"; do
    "backup_$service"
  done

  log "INFO" "Copying logs on disks"
  rsync -aq "$LOG_FILE" "$BACKUP_INTERNAL_HDD/$BACKUP_BASE_FOLDER/"
  rsync -aq "$LOG_FILE" "$BACKUP_EXTERNAL_HDD/$BACKUP_BASE_FOLDER/"
}

# =============================================
# RUN
# =============================================

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --daily)
      SCRIPT_MODE="DAILY"
      log "INFO" "Script set on $SCRIPT_MODE mode"
      shift
      ;;
    --monthly)
      SCRIPT_MODE="MONTHLY"
      log "INFO" "Script set on $SCRIPT_MODE mode"
      shift
      ;;
    --help|-h)
      show_help
      exit 0
      ;;
    *)
      echo "Usage: $0 [-h, --help help] [--daily Daily] [--monthly Monthly]"
      exit 1
      ;;
  esac
done


if [ "$SCRIPT_MODE" = "NONE" ]; then
  log "FATAL" "Script mode not selected! Use [-h, --help help] [--daily Daily] [--monthly Monthly]!"
  exit 1
fi

mkdir -p $BACKUP_INTERNAL_HDD/$BACKUP_BASE_FOLDER/immich/photos/
mkdir -p $BACKUP_INTERNAL_HDD/$BACKUP_BASE_FOLDER/immich/database/
mkdir -p $BACKUP_EXTERNAL_HDD/$BACKUP_BASE_FOLDER/immich/photos/
mkdir -p $BACKUP_EXTERNAL_HDD/$BACKUP_BASE_FOLDER/immich/database/

main