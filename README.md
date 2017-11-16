# Basic Usage

Basic backup of `/home` to `/mnt/backup_drive`

    docker run -d --name rsync-backup \
      --volume /home:/home \
      --volume /mnt/backup_drive:/backup \
      jswetzen/rsync-backup

The container can then be stopped with `docker kill rsync-backup`.

## Supported tags and architectures

For use on a normal machine, use the `latest` tag.
For ARM computers (like the Raspberry Pi) use `arm32v7`.

# Details

## Handling SSH keys

For remote backup, public key authentication used. SSH keys can be reused from
the host computer using a mounted volume, or they will be created automatically.
The generated public key is written to the log shown with `docker logs rsync-backup`.

Example backup of `/home` on `user@remote-server.com` to `/mnt/backup_drive`

    docker run -d --name rsync-backup \
      --volume /mnt/backup_drive:/backup \
      --volume /home/hostuser/.ssh:/ssh-keys \
      --env SSH_IDENTITY_FILE=/ssh-keys/id_rsa \
      --env BACKUPDIR=user@remote-server.com:/home \
      jswetzen/rsync-backup

This setup uses the `id_rsa` key found in `/home/hostuser/.ssh/`. It's mounted
to `/ssh-keys` rather than `/root/.ssh` because ssh stops if it finds a `config`
file with the wrong owner.

## Environment variables

The backup can be configured using the environment variables, as show in the
examples. Here is a full list of the variables, default values and uses.

    REMOTE_HOSTNAME (""): Server being backed up. SSH host keys for this will be
      scanned and added to known_hosts. For the actual backup, set BACKUPDIR.
    BACKUPDIR ("/home"): Directory path to be archived. Usually remote or a
      mounted volume.
    SSH_PORT ("22"): Change if a non-standard SSH port number is used.
    SSH_IDENTITY_FILE ("/root/.ssh/id_rsa"): Change to use a key mounted from
      the host.
    ARCHIVEROOT ("/backup"): It's good to mount a volume at this path. A folder
      structure like this will be created:
        /backup
        ├── 2017-11-06 #Incremental backup for each day
        ├── 2017-11-07
        ├── 2017-11-08
        └── main # The latest backup, full
    EXCLUDES (""): Semicolon separated list of exclude patterns. Use the format
      described in the FILTER RULES section of the rsync man page. A limitation
      is that semicolon may not be present in any of the patterns.
    CRON_TIME ("0 1 * * *"): The time to do backups. The default is at 01:00
      every night.


# Support

Add a [GitHub issue](https://github.com/jswetzen/docker-rsync-backup/issues).
