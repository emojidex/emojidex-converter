Gem::Specification.new do |s|
  s.name          = 'emojidex-converter'
  s.version       = '0.4.0'
  s.license       = 'emojiOL'
  s.summary       = 'Image conversion modules for emojidex'
  s.description   = 'Adds the convert method to Emojidex::Collection and Emojidex::Emoji, which\
                    allows you to convert an emoji collection or a single emoji to the specified\
                    image format.'
  s.authors       = ['Rei Kagetsuki', 'Rika Yoshida']
  s.files         = Dir.glob('lib/**/*.rb') +
                    ['emojidex-converter.gemspec']
  s.homepage      = 'https://github.com/emojidex/emojidex-converter'

  s.add_dependency 'rsvg2'
  s.add_dependency 'rmagick'
  s.add_dependency 'ruby-filemagic'
  s.add_dependency 'rapngasm'
  s.add_dependency 'nokogiri'
  s.add_dependency 'cairo'
  s.add_dependency 'emojidex', '~> 0.5', '~> 0.5.0'
  s.add_dependency 'phantom_svg'
end
