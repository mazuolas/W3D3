require 'launchy'
puts 'Input your email'
email = gets.chomp

user = User.find_by(email: email)
user = User.create(email: email) unless user
while true
  puts 'What do you want to do?'
  puts '0. Create shortened URL'
  puts '1. Visit shortened URL'
  want_to_do = gets.chomp

  if want_to_do == '0'
    puts 'Type in your long url'
    long_url = gets.chomp

    ShortenedUrl.create_short_url(user, long_url)
    Visit.record_visit!(user, ShortenedUrl.last.short_url)
    puts "Short url is: #{ShortenedUrl.last.short_url}"
    puts 'Goodbye!'

  elsif want_to_do == '1'
    puts 'Type in the shortened URL'
    short_url = gets.chomp

    shortened = ShortenedUrl.find_by(short_url: short_url)
    Visit.record_visit!(user, short_url)
    puts "Launching #{shortened.long_url} ..."
    Launchy.open(shortened.long_url)
    puts 'Goodbye!'
  end
end
