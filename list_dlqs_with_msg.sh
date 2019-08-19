#!/usr/bin/env bash

function getNumMsg() {
    url=${1/\,/}
    url=${url/\"/}
    url=${url/\"/}
    numMsg=$(aws sqs get-queue-attributes --queue-url $url --attribute-names ApproximateNumberOfMessages | grep ApproximateNumberOfMessages | grep -v '"0"')
    if ! test -z "$numMsg"
    then
        echo "$url$numMsg"
    fi
}

qs=$(aws sqs list-queues | grep "dead\|letter\|dlq")
for i in ${qs[@]}; do
    getNumMsg $i 
done
