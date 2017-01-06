require 'watir'
require 'phantomjs'

class ProHistoryGetter
# get the 10 best players atm for each champ
  def get_champions_link
    r_url = 'http://lan.op.gg'
    url = r_url + '/champion/statistics'
    doc = Nokogiri::HTML(open(url))
    doc.css('.Champion.Link').select do |champ|
      !champ[:href].nil?
    end
  end

  def get_best_players(link)
    url = 'http://lan.op.gg' + link
    browser = Watir::Browser.new :phantomjs
    browser.goto(url)
    page = browser.html
    browser.close
    doc = Nokogiri::HTML(page)
    pros = doc.css('.Cell .Link').select do |pro|
      !pro.text.include?('\\n\\t\\t\\t\\t')
    end
    pros.map do |pro|
      {link: pro[:href]}
    end.uniq
  end

  def get_player_data(link, champion)
    url ='http://' + link[2..-1]
    browser = Watir::Browser.new :phantomjs
    browser.goto(url)
    page = browser.html
    browser.close
    doc = Nokogiri::HTML(page)
    name = doc.css('.Information .Name').text
    tier = doc.css('.tierRank').text
    rank = doc.css('.Link.__tipped__').text
    most_played = champion
    {name: name, tier: tier, rank: rank, most_played: most_played}
  end

  def get_match_data(link, champion)
    url ='http://' + link[2..-1]
    doc = Nokogiri::HTML(open(url))
    doc.css('.GameItemWrap').map do |match|
      champion = match.css('.ChampionName a').text
      kills = match.css('.KDA .Kill').text.match(/([\d]+)/)[1]
      deaths = match.css('.KDA .Death').text
      assists = match.css('.KDA .Assist').text
      cs = match.css('.CS .CS.tip').text.match(/([\d]+)\s/)[1]
      dmg_dealt = match.css('.CKRate').text.match(/([\d]+)/)[1]
      vision = match.css('.Ward .wards.vision').text
      vision = 0 if vision == ''
      {champion: champion, kills: kills.to_i, deaths: deaths.to_i,
       assists: assists.to_i, dmg_dealt: dmg_dealt.to_i, vision: vision.to_i, minions: cs.to_i}
    end
  end

  def save_pro(data, matches)
    pro = ProPlayer.create(data)
    matches.each do |match|
      pro.game_stats << GameStat.create(match)
    end
  end

  def run
    get_champions_link.each do |link|
      champion = link[:href].match(/champion\/([a-zA-Z]*)/)[1]
      next if  ProPlayer.where(most_played: champion).count > 2
      pro_players = get_best_players(link[:href])
      pro_players.each do |player|
        data = get_player_data(player[:link], champion)
        matches = get_match_data(player[:link], champion)
        save_pro(data, matches)
      end
    end
  end
end
phg = ProHistoryGetter.new
phg.run
