class SumSpellGetter
  # populate Summoner's Spells db
  def get_summoners
    url = ''
    JSON.load(open(url))['data']
  end
end