#!/bin/bash

URL=$1

/usr/bin/curl -w '{"http_code":%{http_code},"size_download":%{size_download},"size_header":%{size_header},"size_request":%{size_request},"size_upload":%{size_upload},"speed_download":%{speed_download},"speed_upload":%{speed_upload},"connect":%{time_connect},"namelookup":%{time_namelookup},"starttransfer":%{time_starttransfer},"appconnect":%{time_appconnect},"pretransfer":%{time_pretransfer},"redirect":%{time_redirect},"total":%{time_total}}' -o /dev/null -s -H "Accept-Encoding: gzip" -H "Content-Type: text/xml" $URL
