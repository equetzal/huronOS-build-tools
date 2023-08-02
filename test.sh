IP_MASK=255.255.255.0

if [[ $IP_MASK =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "IP_MASK is in decimal form"
else
    echo "IP_MASK is not in decimal form"
fi
