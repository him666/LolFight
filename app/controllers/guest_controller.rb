class GuestController < ApplicationController


  def search

  end

  def player_history
    @matches = player_history_info(player_id(params[:sn]))
    @ranked = player_matches(player_id(params[:sn]))


  end

  def analytics_match
    @match = params[:match]
  end


  def current_match
    @players = current_match_info(player_id(params[:format]))

  end

  private

  def player_id(name)
    name2 = name.gsub(' ', '%20')
    name3 = name.tr(' ', '')
    url = "https://lan.api.pvp.net/api/lol/lan/v1.4/" +
        "summoner/by-name/#{name2}?api_key=#{ENV['LOL_KEY']}"
    JSON.load(open(url))[name3]['id']
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
      {champion: champion, queue: queue, match: match_id, role: role, lane: lane}
    end
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
    cs = ProPlayer.cs_prom(pro.id)
    kills = ProPlayer.k_prom(pro.id)
    deaths = ProPlayer.d_prom(pro.id)
    assists = ProPlayer.a_prom(pro.id)
    wards = ProPlayer.w_prom(pro.id)
    {cs: cs, kills: kills, deaths: deaths, assists: assists, wards: wards}
  end

  def get_tips(player, enemy)
    url = "http://www.lolcounter.com/tips/#{enemy}/#{player}"
    doc = Nokogiri::HTML(open(url))
    doc.css('._tip')
  end
end
