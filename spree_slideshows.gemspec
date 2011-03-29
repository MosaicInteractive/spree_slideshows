Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_slideshows'
  s.version     = '1.5.0'
  s.summary     = 'Adds slideshow support to Spree'
  s.description = 'Add slideshows to your Spree store'
  s.required_ruby_version = '>= 1.8.7'
  
  # s.author            = 'Valentino Stoll'
  # s.email             = 'valentino@mosaicwebsite.com'
  # s.homepage          = 'http://www.mosaicwebsite.com'
  
  s.files        = Dir['CHANGELOG', 'README.md', 'LICENSE', 'lib/**/*', 'app/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'
  
  s.has_rdoc = true

  s.add_dependency('spree_core', '>= 0.30.0')
end
