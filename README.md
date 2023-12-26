# Cloudflare Dynamic DNS Setup

This guide explains how to set up dynamic DNS with Cloudflare using Bash inside a Docker container. Before you start, you need to have a domain name that's set up to use Cloudflare's nameservers.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Create a Subdomain](#create-a-subdomain)
3. [Set Up the .env File](#set-up-the-env-file)
4. [Create the API Token](#create-the-api-token)
5. [Obtain Necessary Information](#obtain-necessary-information)
6. [Docker Setup](#docker-setup)

## Prerequisites

- A domain name set up to use Cloudflare's nameservers.
- Docker installed on your server.

## Create a Subdomain

1. Log in to your Cloudflare account and select your domain.
2. Go to the DNS settings.
3. Click "Add Record".
4. Choose "A" as the type.
5. Enter your desired subdomain in the "Name" field.
6. Enter your current public IP address in the "IPv4 address" field.
7. Save the record.

## Set Up the .env File
Create a .env file to store your ZONE_ID, RECORD_ID, EMAIL, and API_TOKEN. Your file should look like this:

```
ZONE_ID=your_zone_id
RECORD_ID=your_record_id
EMAIL=your_email
API_KEY=your_api_token
SUBDOMAIN=your_subdomain
```
## Obtain Necessary Information
In order to run the docker container you need to gatter some information and save them in the .env file. 

## Create the API Token
1. Log in to your Cloudflare account.
2. Go to the "My Profile" page.
3. Click on "API Tokens".
4. Click on "Create Token".
5. From here, you can use a template or create a custom token. For updating DNS records, you could use the "Edit Zone DNS" template.
6. To get the record ID your token need to have "Read Zone DNS" permission too, you can enable it while configuring this script them remove the permission later.  
7. Select the specific zone (your domain) you want this token to have access to.
8. Once you've set all the permissions, click "Continue to Summary", and then "Create Token".
9. You'll then see the token once, and this is the only time you'll see it. Make sure to copy it somewhere safe. If you lose it, you'll have to create a new token.

### Get the Zone ID

The Zone ID is on the right-hand side of the overview page, at the bottom of the API section. 

### Get the Record ID

The Record ID is not visible in the Cloudflare dashboard. You will need to retrieve it via the Cloudflare API. Use the following `curl` command, replacing `<email>`, `<api_key>`, and `<zone_id>` with your actual email, API key, and Zone ID:

Without two auth factor enabled: 
```bash
curl -X GET "https://api.cloudflare.com/client/v4/zones/<zone_id>/dns_records" \
 -H "X-Auth-Email: <email>" \
 -H "X-Auth-Key: <api_key>" \
 -H "Content-Type: application/json"
 ```
With two auth factor enabled: 
 ```bash
curl -X GET "https://api.cloudflare.com/client/v4/zones/<zone_id>/dns_records" \
 -H "Authorization: Bearer <api_token>" \
 -H "Content-Type: application/json"
 ```
 
This command will return a list of all DNS records for the zone. Find your DNS record in the list and note down its id - this is the Record ID.

| If you want a better experience searching / reading JSON output in a CLI we recommand the usage of [jq](https://jqlang.github.io/jq/download/)
