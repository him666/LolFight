class ItemGetter
  # populate Items db only SR
  def get_items_data
    url = 'https://global.api.pvp.net/api/lol/static-data/lan/v1.2/' +
        'item?itemListData=all&api_key=' + ENV['LOL_KEY']
    JSON.load(open(url))['data']
  end

  def parse_item(data)
    name = data.second['name']
    game_num  = data.second['id']
    description = data.second['description']
    plaintext = data.second['plaintext']
    stats = data.second['stats']
    gold = data.second['gold']['total']
    sell_price = data.second['gold']['sell']
    { name: name, game_num: game_num, stats: stats, sell_price: sell_price,
     description: description, plaintext: plaintext, gold: gold }
  end

  def save_item(item)
    Item.create(item)
  end

  def run
    get_items_data.each do |data|
      item = parse_item(data)
      save_item(item)
    end
  end
end
item_getter = ItemGetter.new
item_getter.run