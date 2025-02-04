# Use Alpine as a base image
FROM alpine:latest

# Install necessary tools for PostgreSQL, MySQL/MariaDB, MongoDB, and cron
RUN apk add --no-cache bash postgresql-client mysql-client mongodb-tools busybox-extras

# Set up working directory
WORKDIR /usr/src/app

# Copy the backup script
COPY script.sh /usr/src/app/script.sh
RUN chmod +x /usr/src/app/script.sh

# Copy cron job file
COPY cron /etc/crontabs/root

# Create a backup directory
RUN mkdir -p /backup

# Start cron in the foreground
CMD ["crond", "-f", "-l", "2"]
