class MasteryGetter
  # populate mastery db
  def get_masteries
    url = ''
    JSON.load(open(url))['data']
  end
end