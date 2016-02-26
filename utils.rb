require 'json'
require 'readline'

def input(prompt="", newline=false)
    prompt += "\n" if newline
    Readline.readline(prompt, true).squeeze(" ").strip
end

def get_config
  config = {}
  File.open('config.json', 'r') do |f|
    config = JSON.parse(f.read)
  end

  use_existing = input "Use existing config #{config} (Y/n)? "
  if use_existing == 'n'
    config = {
      "account": input("Account: "),
      "venue": input("Venue: "),
      "stock": input("Stock: ")
    }

    File.open('config.json', 'w') do |f|
      f << JSON.pretty_generate(config)
    end
  end

  config
end
