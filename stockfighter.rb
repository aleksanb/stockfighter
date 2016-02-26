require 'httparty'
require 'typhoeus'

require_relative 'utils'

APIKEY = "d1358748473005c83e60a48af62adf031b8b3d75 "
BASE_URL = "https://api.stockfighter.io/ob/api"

class Stockfighter
  attr_accessor :account, :venue, :stock

  def initialize account, venue, stock
    @account = account
    @venue = venue
    @stock = stock
  end

  def buy qty, price, batch: 1, orderType: 'limit'
    order = base_order.merge({
      qty: qty,
      price: price,
      direction: 'buy',
      orderType: orderType
    })

    puts order

    execute_orders order, batch
  end

  private

  def execute_orders order, batch
    hydra = Typhoeus::Hydra.hydra

    batch.times do |b|
      request = Typhoeus::Request.new(
        "#{BASE_URL}/venues/#{@venue}/stocks/#{@stock}/orders",
        method: :post,
        body: JSON.dump(order),
        headers: {
          'X-Starfighter-Authorization': APIKEY
        }
      )
      request.on_complete do |response|
        puts response.body
      end

      hydra.queue request
    end

    hydra.run
  end

  def base_order
    {
      account: @account,
      venue: @venue,
      symbol: @stock
    }
  end

  def heartbeat
    response = HTTParty.get("#{BASE_URL}/venues/TESTEX/heartbeat")
    response.parsed_response["ok"]
  end
end

#puts "Qty:"
#qty = gets.chomp.to_i
#puts "Price:"
#price = gets.chomp.to_f
#puts "Transactions:"
#transactions = gets.chomp.to_i
#qty=100000

puts "Stockfighter 3000 IEX"
config = get_config

sf = Stockfighter.new(
  config["account"],
  config["venue"],
  config["stock"]
)

while true
  command = input "sf."
  if %w(exit quit q x).include? command
    break
  end

  begin
    eval("sf." + command)
  rescue Exception => e
    puts e
  end
end
