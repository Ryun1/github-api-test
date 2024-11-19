#!/bin/bash

# Define variables
ORG_NAME="IntersectMBO"
GITHUB_API="https://api.github.com"

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "Error: jq is not installed. Please install jq to run this script."
  exit 1
fi

# Fetch organization information and save to a CSV
echo "Fetching organization information for $ORG_NAME..."
ORG_INFO=$(curl -s "$GITHUB_API/orgs/$ORG_NAME")
echo "$ORG_INFO" | jq -r '
  ["id", "login", "name", "description", "url", "html_url", "created_at", "updated_at"],
  [.id, .login, .name, .description, .url, .html_url, .created_at, .updated_at] | @csv
' > organization_info.csv
echo "Organization information saved to organization_info.csv"

# Fetch repositories of the organization and save to a CSV
echo "Fetching public repositories for $ORG_NAME..."
REPOS=$(curl -s "$GITHUB_API/orgs/$ORG_NAME/repos?per_page=100")
echo "$REPOS" | jq -r '
  ["id", "name", "full_name", "description", "html_url", "created_at", "updated_at", "language", "forks_count", "stargazers_count"],
  (.[] | [.id, .name, .full_name, .description, .html_url, .created_at, .updated_at, .language, .forks_count, .stargazers_count]) | @csv
' > repositories.csv
echo "Repositories saved to repositories.csv"

# Fetch public members of the organization and save to a CSV
echo "Fetching public members of $ORG_NAME..."
MEMBERS=$(curl -s "$GITHUB_API/orgs/$ORG_NAME/public_members")
echo "$MEMBERS" | jq -r '
  ["id", "login", "html_url", "type"],
  (.[] | [.id, .login, .html_url, .type]) | @csv
' > public_members.csv
echo "Public members saved to public_members.csv"

echo "Data fetched and saved successfully!"