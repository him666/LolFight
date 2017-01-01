class ItemGetter
  # populate Items db only SR
  def get_items
    url = 'https://global.api.pvp.net/api/lol/static-data/lan/v1.2/' +
        'item?api_key=' + ENV['LOL_KEY']
    JSON.load(open(url))['data']
  end
  def run
    get_items.each do |data|
      item = get_item(data['id'])
      pp item
    end
  end
end
item_getter = ItemGetter.new
item_getter.run