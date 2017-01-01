class GuestController < ApplicationController
  def get_pro(champion)
    r_url = 'http://lan.op.gg'
    url = r_url + '/champion/statistics'
    doc = Nokogiri::HTML(open(url))
    links = doc.css('.Champion.Link').select do |champ|
      !champ[:href].nil? && champ[:href].include?(champion)
    end
    doc = Nokogiri::HTML(open(r_url + links.first[:href]))
    doc.css('.Table .Cell')
  end

  def get_tips(player, enemy)
    url = "http://www.lolcounter.com/tips/#{enemy}/#{player}"
    doc = Nokogiri::HTML(open(url))
    doc.css('._tip')
  end

  def search

  end

  def match_history

  end

  def match_info

  end

  def training_advice

  end

  def current_match

  end
end
