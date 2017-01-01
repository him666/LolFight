require 'json'
require 'active_record'
require 'pp'
require 'open-uri'
class ChampionGetter
# populate champions db
  def get_champions(url)
    JSON.load(open(url))
  end

  def get_spells_per_champion(champion_id)
    url = 'https://global.api.pvp.net/api/lol/static-data/lan/v1.2/' +
        'champion/99champData=spells&api_key=' +
        ENV['LOL_KEY']
    JSON.load(open(url))
  end

  def save_champion(champion, spells)
    game_num = champion['id']
    key = champion['key']
    name = champion['name']
    title = champion['title']
    pp spells
  end
end
url = 'https://global.api.pvp.net/api/' +
    'lol/static-data/lan/v1.2/champion?api_key=' +
    ENV['LOL_KEY']

sc_champ = ChampionGetter.new
champions = sc_champ.get_champions(url)
champions['data'].each do |hash|
  ids = hash.select do |champion|
    !champion['id'].nil?
  end
  ids.each do |champion_id|
    spells =sc_champ.get_spells_per_champion(champion_id['id'])
    sc_champ.save_champion(champion_id, spells)
    break
  end
end
