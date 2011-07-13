require 'spree_core'
require 'spree_slideshows_hooks'

module SpreeSlideshows
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app[/**/*_decorator*.rb")) do |c|
        Rails.env.produciton? ? require(c) : load(c)
      end
      Spree::BaseController.class_eval do
        helper SlideshowsHelper
      end
      ProductsController.class_eval do
        helper SlideshowsHelper
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
