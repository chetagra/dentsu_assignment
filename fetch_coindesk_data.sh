#!/bin/bash

# Function to fetch JSON data from the API
fetch_data() {
  local url=$1
  curl -s --fail "$url"
}

# Function to extract the time the information was updated from the JSON data
extract_updated_time() {
  local json=$1
  echo "$json" | grep -o '"updated":"[^"]*' | sed 's/"updated":"//'
}

# Function to extract the GBP rate from the JSON data
extract_gbp_rate() {
  local json=$1
  echo "$json" | grep -o '"GBP":{"code":"GBP","symbol":"[^"]*","rate":"[^"]*' | sed 's/.*"rate":"\([^"]*\).*/\1/'
}

# Main script execution
main() {
  if [ -z "$1" ]; then
    echo "Error: No API URL provided"
    echo "Usage: $0 <api_url>"
    exit 1
  fi

  local api_url=$1

  # Fetch the JSON data
  json_data=$(fetch_data "$api_url")
  if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch data from $api_url"
    exit 1
  fi

  # Extract the time the information was updated
  updated_time=$(extract_updated_time "$json_data")
  if [ -z "$updated_time" ]; then
    echo "Error: Failed to extract updated time from JSON data"
    exit 1
  fi

  # Extract the GBP rate
  gbp_rate=$(extract_gbp_rate "$json_data")
  if [ -z "$gbp_rate" ]; then
    echo "Error: Failed to extract GBP rate from JSON data"
    exit 1
  fi

  # Print the results
  echo "Time Updated: $updated_time"
  echo "GBP Rate: £$gbp_rate"
}

# Execute the main function
main "$@"