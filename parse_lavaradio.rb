# coding: utf-8
require 'nokogiri'
require 'open-uri'

PROGRAM_URI = 'http://www.lavaradio.com/radio/program'
subscribe_uri = 'http://www.lavaradio.com/account/subscribe?_sz=40&_t=1453991786638'
subscribe_doc = Nokogiri::HTML(open(subscribe_uri, 'Cookie' => 'lid=b49ba91c758f454e96131f54a0ee7449; _gat=1; luid=NgDXJv3Ua8Wq88x0rmrYaSRSgHW7x2DRsvfJYqpmxXh9AI5t7Z88gr7%2FyXisfsFzeRSSfuTQM9Wk8MF8rXjCeS9Dx3auz2GGpfLOfaErl390F5J9rMA%3D; _ga=GA1.2.570024079.1453992485'))

subscribe_programs = subscribe_doc.css('.subscribe-module .content-style .item').map do |program|
  program['id'][7..-1]
end

def program_info(id)
  t = (Time.now.to_f * 1000).to_i
  uri = "#{PROGRAM_URI}?program_id=#{id}&_sz=40&_t=#{t}"
  doc = Nokogiri::HTML(open(uri).read)
  doc.encoding = 'utf-8'
  info = {}
  info['节目'] = doc.css('.pro-info .top-music-name span').text
  info['节目标签'] = doc.css('.pro-info .top-music-type span').map(&:text)
  info['音乐列表'] = doc.css('.program-body li.song-list .ssl-info').map do |song_info|
    {
      '音乐' => song_info.css('.ssl-song-name').text,
      '艺术家' => song_info.css('.no-permition2').text
    }
  end
  info
end

subscribe_programs.each do |id|
  puts program_info(id)
end

