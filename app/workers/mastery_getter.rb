class MasteryGetter
  # populate mastery db
  def get_masteries_data
    url = 'https://global.api.pvp.net/api/lol/static-data/lan/v1.2/' +
        'mastery?masteryListData=all&api_key=' + ENV['LOL_KEY']
    JSON.load(open(url))['data']
  end
  def parse_mastery(data)
    name = data.second['name']
    game_num  = data.second['id']
    description = data.second['description']
    mastery_tree = data.second['masteryTree']
    ranks = data.second['ranks']

    { name: name, game_num: game_num, ranks: ranks,
     description: description, mastery_tree: mastery_tree }
  end

  def save_mastery(rune)
    Mastery.create(rune)
  end

  def run
    get_masteries_data.each do |data|
      mastery = parse_mastery(data)
      save_mastery(mastery)
    end
  end
end
mg = MasteryGetter.new
mg.run