require 'json'

require 'websocket-eventmachine-client'
require_relative 'utils'

COLWIDTH=20

EM.run do
  config = get_config
  puts config

  @account = config["account"]
  @venue = config["venue"]
  @stock = config["stock"]
  @count = 0

  @logfile = File.open('ticker.csv', 'w+')
  @logfile.sync = true

  ws_uri = "wss://api.stockfighter.io/ob/api/ws/#{@account}/venues/#{@venue}/tickertape/stocks/#{@stock}"
  ws = WebSocket::EventMachine::Client.connect(uri: ws_uri)

  ws.onopen do
    puts
    puts
    puts "#{@account} connected to #{@venue}@#{@stock} (live)"
    puts "Count".ljust(10) + "| Bid".ljust(COLWIDTH) + "| Ask".ljust(COLWIDTH) + "| Last"
    puts "-" * 65
  end

  ws.onmessage do |msg, type|
    msg = JSON.parse(msg)
    if msg["ok"] then
      q = msg["quote"]

      csv_line = [@count, q["bid"] || 0, q["last"] || 0, q["ask"] || 0].join(", ")
      @logfile.puts(csv_line)

      #count = @count.to_s.ljust(10)
      #bid = "| #{q["bid"]} (#{q["bidSize"]}/#{q["bidDepth"]})".ljust(20)
      #ask = "| #{q["ask"]} (#{q["askSize"]}/#{q["askDepth"]})".ljust(20)
      #last = "| #{q["last"]} (#{q["lastSize"]})".ljust(20)

      #print count + bid + ask + last + "\r"
    end

    @count += 1
  end

  ws.onclose do |code, reason|
    puts code
    puts reason
    @logfile.close
  end
end
