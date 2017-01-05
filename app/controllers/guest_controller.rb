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
      @champion = Champion.find_by_game_num(info[:champion])
      @lane_enemy = lane_enemy(@champion, @enemies).first
      @enemy = Champion.find_by_game_num(@lane_enemy[:champion])
      @enemy_champions = enemy_champs(@enemies)
      @tips_you = get_tips(@champion.name, @enemy.name)
      @tips_vs = get_tips(@enemy.name, @enemy.name)
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
  def enemy_champs(enemies)
    enemies.map do |e|
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

  def pro_analytics(champion)
    pro = ProPlayer.find_by_most_played(champion)
    cs = ProPlayer.average(pro.id, 'minions')
    max_cs = ProPlayer.max(pro.id, 'minions')
    kills = ProPlayer.average(pro.id, 'kills')
    deaths = ProPlayer.average(pro.id, 'deaths')
    assists = ProPlayer.average(pro.id, 'assists')
    vision = ProPlayer.average(pro.id, 'vision')
    {cs: cs, max_cs: max_cs, kills: kills, deaths: deaths,
     assists: assists, vision: vision}
  end

  def get_tips(player, enemy)
    url = "http://www.lolcounter.com/tips/#{enemy}/#{player}"
    doc = Nokogiri::HTML(open(url))
    doc.css('._tip')
  end

  def champions_pool # todo fix this to do eager load for views
    pool = {}
    Champion.all.map do |champion|
      pool["#{champion.game_num}"] = champion.name
    end
  end
end
