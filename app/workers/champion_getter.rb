require 'json'
require 'active_record'
require 'pp'
require 'open-uri'
class ChampionGetter
# populate champions db
  def get_champions_data
    url = 'https://global.api.pvp.net/api/' +
        'lol/static-data/lan/v1.2/champion?champData=all&api_key=' +
        ENV['LOL_KEY']
    JSON.load(open(url))['data']
  end

  def parse_champions_data(data)
    game_num = data.second['id']
    name = data.second['name']
    title = data.second['title']
    tags = data.second['tags']
    stats = data.second['stats']
    basic_dmg = stats['attackdamage']
    lore = data.second['lore']
    passive = data.second['passive']
    { game_num: game_num, name: name, title: title, basic_dmg: basic_dmg,
    tags: tags, stats: stats, lore: lore, passive: passive }
  end

  def parse_tips_for_champion_data(data)
    enemytips = data.second['enemytips']
    allytips = data.second['allytips']
    { atip: allytips, btip: enemytips }
  end

  def parse_spells_for_champion_data(data)
    data.second['spells'].map do |spell|
      { name: spell['name'], effect: spell['leveltip']['label'],
      base_dmg: spell['effectBurn'], cooldown: spell['cooldownBurn'],
      bonus_dmg: spell['vars'], description: spell['sanitizedTooltip'] }
    end
  end

  def save_champion(champion, tips, spells)
    c1 = Champion.create(champion)
    c1.tips << Tip.create(tips)
    spells.each do |spell|
      c1.spells<< Spell.create(spell)
    end
  end

  def run
    get_champions_data.each do |data|
      champion = parse_champions_data(data)
      spells = parse_spells_for_champion_data(data)
      tips = parse_tips_for_champion_data(data)
      save_champion(champion, tips,spells)
    end
  end
end
cg = ChampionGetter.new
cg.run

