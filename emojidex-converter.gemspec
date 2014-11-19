Gem::Specification.new do |s|
  s.name          = 'emojidex-converter'
  s.version       = '0.0.6'
  s.license       = 'emojiOL'
  s.summary       = 'Image conversion modules for emojidex'
  s.description   = 'Adds the convert method to Emojidex::Collection and Emojidex::Emoji, which\
                    allows you to convert an emoji collection or a single emoji to the specified\
                    image format.'
  s.authors       = ['Rei Kagetsuki', 'Rika Yoshida']
  s.email         = ['zero@genshin.org', 'nazuki@genshin.org']
  s.files         = `git ls-files`.split("\n")
  s.homepage      = 'http://dev.emojidex.com'

  s.add_dependency 'rsvg2'
  s.add_dependency 'rmagick'
  s.add_dependency 'ruby-filemagic'
  s.add_dependency 'rapngasm'
  s.add_dependency 'nokogiri'
  s.add_dependency 'cairo'
  s.add_dependency 'emojidex'
  s.add_dependency 'phantom_svg'
end
