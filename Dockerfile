# Use the python:alpine3.18 image as base
FROM python:alpine3.18

# Create a directory for the app
WORKDIR /app

# Install cron and curl
RUN apk add --no-cache curl dcron

# Copy your script into the container
COPY update_dns.sh /app/update_dns.sh
COPY start.sh /start.sh

# Make the script executable
RUN chmod +x /app/update_dns.sh
RUN chmod +x /start.sh

# Add a crontab file
COPY crontab /etc/crontabs/root

#ENTRYPOINT ["tail", "-f", "/dev/null"]

# Start the cron service
CMD ["sh", "/start.sh"]
