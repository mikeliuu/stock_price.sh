#Get US stock price
#Please run "brew install jq" if using macOS / haven't installed

#extract from json https://cameronnokes.com/blog/working-with-json-in-bash-using-jq/

openUrl() {
  read -p "domain:" domain

  #check domain if valid
  if [ ! -z "$domain" ]; then
    the_url="https://www.$domain.com"
    printf "opening $the_url\n"
    open $the_url
  else
    echo "domain is not valid"
  fi
}

get_stock_price() {
  read -p "Ticker: " ticker

  if [ -z "$ticker" ]; then
    echo "Please fill in ticker\n"
    exit
  fi

  json_data=$(curl -s "https://query1.finance.yahoo.com/v7/finance/quote?lang=en-US&region=US&corsDomain=finance.yahoo.com&symbols=${ticker}" | jq ".quoteResponse")

  symbol=$(echo $json_data | jq ".result[0].symbol")
  price=$(echo $json_data | jq ".result[0].regularMarketPrice")
  low_high=$(echo $json_data | jq ".result[0].regularMarketDayRange")

  printf "\nSymbol: $symbol\nPrice: $price\nLow-high range: $low_high\n\n"

  read -p "Get more ticker info [optional]? (y/n) " get_link

  if [ -z "$get_link" ] || [ $get_link == "n" ]; then
    printf "\n!=== end ===!\n"
    exit
  fi
  if [ $get_link == "y" ]; then
    open "https://finance.yahoo.com/quote/${ticker}?p=${ticker}&.tsrc=fin-srch"
  fi
}

get_stock_price
