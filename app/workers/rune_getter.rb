class RuneGetter
  # populate rune db
  def get_runes_data
    url = 'https://global.api.pvp.net/api/lol/static-data/lan/v1.2' +
        '/rune?runeListData=basic&api_key=' +
        ENV['LOL_KEY']
    JSON.load(open(url))['data']
  end

  def parse_rune(data)
    name = data.second['name']
    game_num  = data.second['id']
    description = data.second['description']
    tier = data.second['rune']['tier']
    type2 = data.second['rune']['type']
    {name: name, game_num: game_num,
     description: description, tier: tier, type2: type2 }
  end

  def save_rune(rune)
    Rune.create(rune)
  end

  def run
    get_runes_data.each do |data|
      rune = parse_rune(data)
      save_rune(rune)
    end
  end
end
runeget = RuneGetter.new
runeget.run