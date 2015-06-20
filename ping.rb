domains = ['jp1', 'jp2', 'jp3', 'us1', 'us2', 'us3', 'sg1', 'sg2', 'tw1']

domains.each do |domain|
  puts `ping #{domain}.seeplease.com`
end
