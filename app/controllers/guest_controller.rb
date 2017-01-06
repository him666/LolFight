class GuestController < ApplicationController


  def search

  end

  def player_history
    @matches = player_history_info(player_id(params[:sn]))
    @ranked = player_matches(player_id(params[:sn]))
    @pool = champions_pool

  end

  def analytics_match
    @match = params
    @champ = Champion.find_by_game_num(@match[:champion]).name
    @analytics = match_analytics(@match)
  end


  def current_match
    @players = current_match_info(player_id(params[:format]))
    @player = params[:format]
    info = player_info(@player, @players)
    @player_team = info[:team]
    @enemies = against_champions(@players, @player_team)
    @allies = @players - @enemies
    @champion = Champion.find_by_game_num(info[:champion])
    @lane_enemy = lane_enemy(@champion, @enemies).first
    @enemy = Champion.find_by_game_num(@lane_enemy[:champion])
    @ally_champions = team_champs(@allies)
    @enemy_champions = team_champs(@enemies)
    @tips_you = get_tips(@champion.name, @enemy.name)
    @tips_vs = get_tips(@enemy.name, @champion.name)
    @allydmg_6 = dmg_per_team(@allies, 6)
    @allydmg_11 = dmg_per_team(@allies, 11)
    @allydmg_18 = dmg_per_team(@allies, 18)
    @enemydmg_6 = dmg_per_team(@enemies, 6)
    @enemydmg_11 = dmg_per_team(@enemies, 11)
    @enemydmg_18 = dmg_per_team(@enemies, 18)
    @items_advice
  end

  private

  def player_id(name)
    name2 = name.gsub(' ', '%20').downcase
    name3 = name.tr(' ', '').downcase
    url = "https://lan.api.pvp.net/api/lol/lan/v1.4/" +
        "summoner/by-name/#{name2}?api_key=#{ENV['LOL_KEY']}"
    JSON.load(open(url))[name3]['id']
  end

  def player_info(player, players)
    players.select do |p|
      p[:sn].downcase == player
    end.first
  end

  def lane_enemy(champion, enemies)
    enemies.select do |enemy|
      Champion.find_by_game_num(enemy[:champion])
          .lane == champion.lane
    end
  end

  def player_matches(player_id)
    url = "https://lan.api.pvp.net/api/lol/lan/v2.2/matchlist/by-summoner/" +
        "#{player_id}?api_key=#{ENV['LOL_KEY']}"
    JSON.load(open(url))['matches'].map do |match|
      champion = match['champion']
      queue = match['queue']
      match_id = match['matchId']
      role = match['role']
      lane = match['lane']
      {champion: champion, queue: queue, match: match_id, role: role,
       lane: lane, player: player_id}
    end
  end

  def match_analytics(match)
    url = "https://lan.api.pvp.net/api/lol/lan/v2.2/match/" +
        "#{match[:match]}?api_key=#{ENV['LOL_KEY']}"
    info = JSON.load(open(url))
    player = info['participantIdentities'].select do |p|
      p['player']['summonerId'].equal?(match[:player].to_i)
    end
    player_stats = info['participants'].select do |p|
      p['participantId'].equal?(player.first['participantId'])
    end
    timeline = player_stats.first['timeline']
    stats = player_stats.first['stats']
    team = player_stats.first['teamId']
    team_stats = info['teams'].select do |t|
      t['teamId'].equal?(team)
    end.first
    {timeline: timeline, stats: stats, team_stats: team_stats}
  end

  def player_history_info(player_id)
    url = "https://lan.api.pvp.net/api/lol/lan/v1.3/game/by-summoner/" +
        "#{player_id}/recent?api_key=#{ENV['LOL_KEY']}"
    JSON.load(open(url))['games'].map do |game|
      match = game['subType']
      win = game['stats']['win']
      champion = game['championId']
      pos = game['stats']['playerPosition']
      total_dmg = game['stats']['totalDamageDealtToChampions'] #damage done
      total_gold = game['stats']['goldEarned']
      total_dmg_taken = game['stats']['totalDamageTaken']
      level = game['stats']['level']
      kills = game['stats']['championsKilled']
      deaths = game['stats']['numDeaths']
      assists = game['stats']['assists']
      wards = game['stats']['wardPlaced']
      cs = game['stats']['minionsKilled'].to_i +
          game['stats']['neutralMinionsKilled'].to_i

      {match: match, win: win, champion: champion, total_dmg: total_dmg,
       total_gold: total_gold, dmg_taken: total_dmg_taken, level: level,
       kills: kills, deaths: deaths, assists: assists, wards: wards, cs: cs,
       position: pos}
    end
  end

  def team_champs(players)
    players.map do |e|
      Champion.find_by_game_num(e[:champion])

    end
  end

  def against_champions(players, player_team)
    enemy = players.select do |p|
      !p[:team].equal?(player_team)
    end
  end

  def current_match_info(player_id)
    url = "https://lan.api.pvp.net/observer-mode/rest/consumer/" +
        "getSpectatorGameInfo/LA1/#{player_id}?api_key=#{ENV['LOL_KEY']}"
    game_data = JSON.load(open(url))
    game_data['bannedChampions']
    game_data['gameType']
    game_data['participants'].map do |participant|
      sn = participant['summonerName']
      champion = participant['championId']
      sn_id = participant['summonerId']
      team = participant['teamId']
      {sn: sn, champion: champion, sn_id: sn_id, team: team}
    end
  end


  def get_tips(player, enemy)
    url = "http://www.lolcounter.com/tips/#{enemy.gsub(' ', '%20')}/#{player.gsub(' ', '%20')}"
    doc = Nokogiri::HTML(open(url))
    doc.css('._tip')
  end

  def dmg_per_team(champions, level)
    team_dmg = 0
    champions.each do |champion|
      c = Champion.find_by_game_num(champion[:champion])
      team_dmg += dmg_per_champion(c, level)
    end
    team_dmg
  end

  def dmg_per_champion(champion, level)
    if level == 6
      dmg = 0
      dmg += dmg_spell(champion.spells[0], 2)
      dmg += dmg_spell(champion.spells[1], 2)
      dmg += dmg_spell(champion.spells[2], 2)
      dmg += dmg_spell(champion.spells[3], 1)

    elsif level == 11
      dmg = 0
      dmg += dmg_spell(champion.spells[0], 3)
      dmg += dmg_spell(champion.spells[1], 3)
      dmg += dmg_spell(champion.spells[2], 3)
      dmg += dmg_spell(champion.spells[3], 2)
    else
      dmg = 0
      dmg += dmg_spell(champion.spells[0], 5)
      dmg += dmg_spell(champion.spells[1], 5)
      dmg += dmg_spell(champion.spells[2], 5)
      dmg += dmg_spell(champion.spells[3], 3)
    end
    dmg
  end

  def dmg_spell(spell, level)
    damage = 0
    bonus_damage = 0
    if spell.effect.include?('Daño')
      damage = spell.base_dmg.split('/')[level-1].match(/([\d]+)/)[1].to_i
      spell.coefficients.pluck(:percent).each do |percent|
        bonus_damage += percent[1...-1].to_f * 100
      end
    else
    end
    if spell.coefficients.pluck(:percent).size.zero?
      damage + bonus_damage / 1
    else
      damage + bonus_damage / spell.coefficients.pluck(:percent).length
    end
  end

  def champions_pool # todo fix this to do eager load for views
    pool = {}
    Champion.all.map do |champion|
      pool["#{champion.game_num}"] = champion.name
    end
  end
end
