#require 'slideshows_helper'
#
class SpreeSlideshowsHooks < Spree::ThemeSupport::HookListener
  # Admin Hooks
  insert_after :admin_configurations_menu do
    %(<%= configurations_menu_item t('slideshow_slides'), admin_slides_path, t("manage_slideshow") %>)
  end

  insert_after :slideshow do
    %(<%= insert_slideshow(:max => 2, :gorup => 'Home') %>)
  end

  insert_after :inside_head do
    %(<%= stylesheet_link_tag 'slideshow.css' %>
      <%= javascript_include_tag 'slides.min.jquery.js' %>
      <% javascript_tag do %>
        $(function(){
          $('.slideshow').slides({
            preload: true,
            preloadImage: '/images/loading.gif',
            play: 5000,
            pause: 2500,
            hoverPause: true
          });
        });
      <% end %>)


  # Homepage hooks for default homepage slideshow
  insert_before :homepage_products, 'shared/display_gallery'

end
