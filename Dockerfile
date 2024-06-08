FROM ubuntu:22.04

# Set environment variables to avoid user interaction during installation
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y cron

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    ca-certificates \
    python3.10-dev \
    python3.10-venv \
    python3.10-distutils \
    python3-pip \
    python3-setuptools \
    npm \
    redis-server \
    mariadb-server \
    curl \
    sudo \
    && apt-get clean
# Install Node.js 18
RUN apt-get remove -y libnode-dev \
    && apt-get autoremove -y \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# Install Yarn
RUN npm install -g yarn
# Create user for Frappe
RUN useradd -ms /bin/bash frappe

# Switch to frappe user
USER frappe
WORKDIR /home/frappe

# Install Frappe Bench CLI tool
RUN pip3 install frappe-bench

# Add pip installation directory to PATH
ENV PATH="${PATH}:/home/frappe/.local/bin"

# Initialize Frappe Bench
RUN bench init frappe-bench --skip-assets --python python3.10
USER root
RUN apt-get update
RUN apt-get install libmysqlclient-dev -y
RUN echo "[mysqld]\n\
character-set-client-handshake = FALSE\n\
character-set-server = utf8mb4\n\
collation-server = utf8mb4_unicode_ci\n\
\n\
[mysql]\n\
default-character-set = utf8mb4\n" > /etc/mysql/my.cnf
USER frappe
# Move to frappe-bench directory
WORKDIR /home/frappe/frappe-bench

# Get Frappe and ERPNext

RUN bench get-app --branch version-13 erpnext
RUN bench set-config -g MARIADB_HOST mariadb
RUN bench set-config -g redis_cache redis://redis-cache:6379
RUN bench set-config -g redis_queue redis://redis-queue:6379
RUN bench set-config -g redis_socketio redis://redis-queue:6379
RUN bench config set-common-config -c root_login postgres
RUN bench config set-common-config -c root_password '"root"'


USER root
# Ensure MariaDB is ready and create new site
RUN service mariadb start \
    && mysqladmin -u root password 'root'

USER frappe
RUN  bench new-site site1.local --admin-password admin --mariadb-root-password root 


# Install ERPNext on the new site
RUN bench --site site1.local install-app erpnext



# Expose the default port
EXPOSE 8000

# Start Frappe
CMD ["bench", "start"]
                                                                                       
