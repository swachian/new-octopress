p ARGV

images = `ls #{ARGV[0]}*.jpg`.split(/\s+/)
images.each do |img|
   puts img
   `convert -resize 20%x20% #{img} #{img}`
end
