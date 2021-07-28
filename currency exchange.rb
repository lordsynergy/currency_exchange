# encoding: utf-8
#
# Программа «Бивалютный портфель», помогающая сбалансировать ваши сбережения
#
# курс валют берём с сайта ЦБР - http://www.cbr.ru/scripts/XML_daily.asp
#
# Этот код необходим только при использовании русских букв на Windows
if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require 'net/http'
require 'rexml/document'

puts "Программа \"Бивалютный портфель v.2\""

URL = 'http://www.cbr.ru/scripts/XML_daily.asp'.freeze

# Достаем данные с сайта Центробанка и записываем их в XML
response = Net::HTTP.get_response(URI.parse(URL))
doc = REXML::Document.new(response.body)

date = doc.root.attributes['Date']

rate = doc.get_elements('ValCurs/Valute[@ID="R01235"]/Value').first.text.gsub(',', '.').to_f

puts "#{date}: 1$ = #{rate} руб."
puts

puts "Сколько у Вас долларов?"
usd = gets.to_f

puts "Сколько у Вас рублей?"
rub = gets.to_f

usd = usd * rate

differrence = ((usd - rub) / 2).abs.round(2)

if  differrence < 0.01
  abort "Ваш портфель сбалансирован"
elsif usd > rub
  puts "Вам надо купить #{differrence.to_s} руб."
else
  puts "Вам надо продать #{differrence.to_s} руб."
end