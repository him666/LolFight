class SumSpellGetter
  # populate Summoner's Spells db
  def get_summoners_data
    url = 'https://global.api.pvp.net/api/lol/static-data/lan/v1.2/' +
        'summoner-spell?spellData=cooldownBurn&api_key=' + ENV['LOL_KEY']
    JSON.load(open(url))['data']
  end
  def parse_summoners(data)
    name = data.second['name']
    game_num  = data.second['id']
    description = data.second['description']
    cooldown = data.second['cooldownBurn']

    {name: name, game_num: game_num,
     description: description, cooldown: cooldown }
  end

  def save_summoners(summoners)
    SumSpell.create(summoners)
  end

  def run
    get_summoners_data.each do |data|
      summoners = parse_summoners(data)
      save_summoners(summoners)
    end
  end
end
ssg = SumSpellGetter.new
ssg.run