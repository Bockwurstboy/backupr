# Backupr

Backupr is a simple Docker container that runs a cron job to backup your PostgreSQL, MySQL/MariaDB, or MongoDB databases.

## Usage

### Docker - Self Build

1. Clone the repository:

   ```bash
   git clone https://github.com/bockwurstboy/backupr.git
   ```

2. Build the Docker image:

   ```bash
   docker build -t backupr .
   ```

3. Create a `.env` file in the root directory of the project with the following contents:

   ```bash
   # Project name for which the backups are being made
   PRJ_NAME="projekt"

   # Database type (postgres, mysql, mariadb, mongo)
   DB_TYPE="<postgres | mysql | mariadb | mongo>"

   # Postgres
   DB_HOST=<localhost>
   DB_PORT=<1234>
   DB_USER=<db-user>
   DB_PASSWORD=<db-password>
   DB_NAME=<db-name>
   ```

4. Run the Docker container:

   ```bash
   docker run -d --name backupr -v /path/to/backup:/backup backupr --env-file .env
   ```

5. Access the backup directory:

   ```bash
   # Inside the container
   docker exec -it backupr bash
   ls /backup

   # Outside the container
   ls /backup
   ```

---

### Docker Compose - Self Build

1. Clone the repository:

   ```bash
   git clone https://github.com/bockwurstboy/backupr.git
   ```

2. Create a `.env` file in the root directory of the project with the following contents:

   ```bash
   # Project name for which the backups are being made
   PRJ_NAME="projekt"

   # Database type (postgres, mysql, mariadb, mongo)
   DB_TYPE="<postgres | mysql | mariadb | mongo>"

   # Postgres
   DB_HOST=<localhost>
   DB_PORT=<1234>
   DB_USER=<db-user>
   DB_PASSWORD=<db-password>
   DB_NAME=<db-name>
   ```

3. Create a `docker-compose.yml` file in the root directory of the project with the following contents:

   ```yaml
   # Version of Docker Compose if still needed
   version: '3.8'

   services:
     backupr:
       image: backupr
       container_name: backupr-${PRJ_NAME:-noname}
       volumes:
         - /path/to/backup:/backup
       restart: always
       environment:
         DB_TYPE: ${DB_TYPE}
         DB_HOST: ${DB_HOST}
         DB_PORT: ${DB_PORT}
         DB_USER: ${DB_USER}
         DB_PASSWORD: ${DB_PASS}
         DB_NAME: ${DB_NAME}
   ```

4. Run the Docker Compose stack:

   ```bash
   docker-compose up -d --env-file .env
   ```

5. Access the backup directory:

   ```bash
   # Inside the container
   docker exec -it backupr bash
   ls /backup

   # Outside the container
   ls /backup
   ```

6. Optional: Configure a cron job to run the script periodically:

   ```bash
   crontab -e
   ```

   Add the following line to the crontab file:

   ```bash
   0 0 * * * /usr/src/app/script.sh >> /var/log/cron.log 2>&1
   ```

   Replace the cron schedule with your desired schedule. (Only supported with docker-compose.yml)

   The standard configureation is to run the script every day at midnight.

---

### Docker Image - Docker

1. Pull the Docker image from GitHub:

   ```bash
   docker pull ghcr.io/bockwurstboy/backupr:latest
   ```

2. Create a `.env` file in the root directory of the project with the following contents:

   ```bash
   # Project name for which the backups are being made
   PRJ_NAME="projekt"

   # Database type (postgres, mysql, mariadb, mongo)
   DB_TYPE="<postgres | mysql | mariadb | mongo>"

   # Postgres
   DB_HOST=<localhost>
   DB_PORT=<1234>
   DB_USER=<db-user>
   DB_PASSWORD=<db-password>
   DB_NAME=<db-name>
   ```

   Replace the values with your own database credentials and database names.

3. Run the script:

   ```bash
   docker run -it --rm -v $PWD:/backup backupr
   ```

   This will start the script and mount the current directory as the backup directory. The script will create a backup of the specified database and store it in the backup directory.

---

### Docker Image - Docker Compose

1. Create a `.env` file in the root directory of the project with the following contents:

   ```bash
   # Project name for which the backups are being made
   PRJ_NAME="projekt"

   # Database type (postgres, mysql, mariadb, mongo)
   DB_TYPE="<postgres | mysql | mariadb | mongo>"

   # Postgres
   DB_HOST=<localhost>
   DB_PORT=<1234>
   DB_USER=<db-user>
   DB_PASSWORD=<db-password>
   DB_NAME=<db-name>
   ```

   Replace the values with your own database credentials and database names.

2. Create a `docker-compose.yml` file in the root directory of the project with the following contents:

   ```yaml
   # Version of Docker Compose if still needed
   version: '3.8'

   services:
     backupr:
       image: ghcr.io/bockwurstboy/backupr:latest
       container_name: backupr-${PRJ_NAME:-noname}
       volumes:
         - /path/to/backup:/backup
       restart: always
       environment:
         DB_TYPE: ${DB_TYPE}
         DB_HOST: ${DB_HOST}
         DB_PORT: ${DB_PORT}
         DB_USER: ${DB_USER}
         DB_PASSWORD: ${DB_PASS}
         DB_NAME: ${DB_NAME}
   ```

## License

This project is licensed under the MIT License - see the [LICENSE](https://opensource.org/license/mit) for details.
