#!/bin/sh

get_temp() {
    local DD_API_KEY=$1
    local DD_APP_KEY=$2
    local FROM_TIME=$3
    local TO_TIME=$4

    temp=$(curl -sG \
        "https://app.datadoghq.com/api/v1/query" \
        -d "api_key=${DD_API_KEY}" \
        -d "application_key=${DD_APP_KEY}" \
        -d "from=${FROM_TIME}" \
        -d "to=${TO_TIME}" \
        -d "query=arduino.temperature{*}by{host}" \
        | jq '.series[].pointlist[-1][1]' \
        | xargs printf "%.2f")

    echo $temp
}

get_humid() {
    local DD_API_KEY=$1
    local DD_APP_KEY=$2
    local FROM_TIME=$3
    local TO_TIME=$4

    humid=$(curl -sG \
        "https://app.datadoghq.com/api/v1/query" \
        -d "api_key=${DD_API_KEY}" \
        -d "application_key=${DD_APP_KEY}" \
        -d "from=${FROM_TIME}" \
        -d "to=${TO_TIME}" \
        -d "query=arduino.humidity{*}by{host}" \
         | jq '.series[].pointlist[-1][1]' \
         | xargs printf "%.2f")
    echo $humid
}


notify_to_slack() {
  local TEMP=${1:-"null"}
  local HUMID=${2:-"null"}
  local COLOR=${3:-"#439FE0"}
  local CHANNEL="#test_ikemonn"
  local USER_NAME="arduino"
  local MSG="現在の温度は${TEMP}度、湿度は${HUMID}%です。"
  local WEBHOOK="your web hook"
  # リッチなフォーマットでpostする(https://api.slack.com/docs/attachments)
  post_data=`cat <<-EOF
  payload={
    "channel": "$CHANNEL",
    "username": "$USER_NAME",
    "attachments": [
      {
        "fallback": "Fallback $MSG",
        "color": "$COLOR",
        "title": "$MSG"
      }
    ]
  }
EOF`

  curl -X POST $WEBHOOK --data-urlencode "$post_data"
}

main () {
    local DD_API_KEY="your api key"
    local DD_APP_KEY="your app key"
    local TO_TIME=$(date +%s)
    local FROM_TIME=$(date -v -1d +%s)

    local temp=$(get_temp $DD_API_KEY $DD_APP_KEY $FROM_TIME $TO_TIME)
    local humid=$(get_humid $DD_API_KEY $DD_APP_KEY $FROM_TIME $TO_TIME)

    notify_to_slack $temp $humid
}

main
