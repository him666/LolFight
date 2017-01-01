require 'json'
require 'pp'
require 'active_record'
require 'open-uri'

class Seeder
  # analytics from seeds provided by lol api
  def get_seeds(url)
    JSON.load(open(url))
  end

  def show_game_stats(game)

  end

  def save_game_stats(game)

  end
end
url = 'https://s3-us-west-1.amazonaws.com/riot-api/seed_data/matches1.json'
seeder = Seeder.new
seed = seeder.get_seeds(url)
pp seed['matches'].first
# continue with data per match processing