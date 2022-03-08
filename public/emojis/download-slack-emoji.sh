#!/bin/bash -eo pipefail
# Log in to Slack in a web browser and open the network tools to inspect the traffic.
# Filter the requests with "/api/" and pick one to inspect.
# You need the xoxc token from the request body, and a copy of the cookies. It is the "d" cookie that is important, but you can copy all of them. Make sure that the cookie value is percent encoded!
# Paste the values below.
# You need to have curl and jq installed.

# You can also get the xoxc token from localStorage. Run this in the JavaScript console:
# Object.entries(JSON.parse(localStorage.localConfig_v2)["teams"]).reduce((o,e) => Object.assign(o, { [e[1]["name"]]: e[1]["token"] }), {})

SLACK_TOKEN="xoxc-17014573287-341002726132-2695054343333-f4a63a7920e80edd8340d9171b698ca2934ae5a75137f635909767abb0550787"
COOKIES="b=.7x3soce6nonl6bacbzv03mm11; shown_ssb_redirect_page=1; ssb_instance_id=72ca9437-20bd-5011-9b8b-75f5e70d3d12; optimizelyEndUserId=oeu1612816652101r0.716638353575783; _li_dcdm_c=.slack.com; _lc2_fpi=e00b11ac9c9b--01ey1nt71w8g2ackhjp78vz3h9; _ga=GA1.3.1747553094.1611069678; shown_download_ssb_modal=1; show_download_ssb_banner=1; no_download_ssb_banner=1; __pdst=a448808ed5b2486f9ce174cd950e1501; __adroll_fpc=f4579505046baffe65688001b8dff5de-1617886126830; OptanonAlertBoxClosed=2021-05-07T15:15:48.449Z; _cs_c=1; _ga=GA1.1.1747553094.1611069678; _cs_id=95a41703-7438-a811-c3c4-7fb27cc27853.1627595027.36.1636988593.1636988593.1.1661759027706; __ar_v4=4UHU5P4P3FESHLUMNBLWAU%3A20211105%3A5%7CQCM34G7NBZEHHATIFDIUBJ%3A20211105%3A5%7CKDMBLDIYHFHI5NUNKGJ4LV%3A20211105%3A2%7CK2HN2U4VSJGOVKC2WJLQNH%3A20211112%3A3; _ga_QTJQME5M5D=GS1.1.1636988593.98.1.1636990485.0; PageCount=560; utm=%7B%22utm_source%22%3A%22in-prod%22%2C%22utm_medium%22%3A%22inprod-apps_link-slack_menu-cl%22%7D; OptanonConsent=isIABGlobal=false&datestamp=Mon+Feb+14+2022+15%3A17%3A39+GMT-0500+(Eastern+Standard+Time)&version=6.22.0&hosts=&consentId=89084db9-122d-474e-9610-d0080becf073&interactionCount=1&landingPath=NotLandingPage&groups=C0004%3A1%2CC0002%3A1%2CC0003%3A1%2CC0001%3A1&AwaitingReconsent=false&geolocation=US%3BDE&isGpcEnabled=0; d=zgm8GAaaOBV6C9CaWeBBhsIhQ5MSiDi5f6KMwopeYsDYTbHF6f8tq1TJL904TCLnXepiuXSSqMRrZqT4CyCFJ14XkAXee%2BaO3Y0fC4MgW%2Fgr0Na2tRK90VKQoGuP0Nk61N67gPPh7taSljJ34FSaQPfVbwTr9t%2FWPmKDnPtC8UgzYX1l2n%2BUoY0%3D; d-s=1644950326; lc=1644950326; x=7x3soce6nonl6bacbzv03mm11.1645021298"

data=$(curl -q -sS -b "$COOKIES" "https://slack.com/api/emoji.list?token=$SLACK_TOKEN")

if echo "$data" | jq -e '.error?' > /dev/null; then
  echo "$data"
  exit 1
fi

echo "$data" > data.json

echo "$data" | jq -Mr '.emoji | to_entries | .[] | select(.value | startswith("http")) | "\(.key) \(.value)"' | sort | while read name url; do
  fn="$name.${url##*.}"
  [[ -f "$fn" ]] && continue
  echo "$fn"
  curl -q -sS -o "$fn" "$url"
done
