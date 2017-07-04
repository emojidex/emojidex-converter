Gem::Specification.new do |s|
  s.name          = 'emojidex-converter'
  s.version       = '0.4.1'
  s.license       = 'emojiOL'
  s.summary       = 'Image conversion modules for emojidex'
  s.description   = 'Adds the convert method to Emojidex::Collection and Emojidex::Emoji, which\
                    allows you to convert an emoji collection or a single emoji to the specified\
                    image format.'
  s.authors       = ['Rei Kagetsuki', 'Rika Yoshida']
  s.email         = 'info@emojidex.com'
  s.files         = Dir.glob('lib/**/*.rb') +
                    ['emojidex-converter.gemspec']
  s.homepage      = 'https://github.com/emojidex/emojidex-converter'

  s.add_dependency 'rsvg2', '~> 3.1', '~> 3.1.6'
  s.add_dependency 'rmagick', '~> 2.16'
  s.add_dependency 'ruby-filemagic'
  s.add_dependency 'rapngasm', '~> 3.2', '~> 3.2.0'
  s.add_dependency 'nokogiri', '~> 1.8', '~> 1.8.0'
  s.add_dependency 'cairo', '~> 1.15', '~> 1.15.9'
  s.add_dependency 'emojidex', '~> 0.5', '~> 0.5.1'
  s.add_dependency 'phantom_svg', '~> 1.2', '~> 1.2.7'
end
