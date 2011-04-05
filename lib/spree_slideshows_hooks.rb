class SpreeSlideshowsHooks < Spree::ThemeSupport::HookListener
  # Admin Hooks
  insert_after :admin_configurations_menu do
    %(<%= configurations_menu_item t('slideshow_slides'), admin_slides_path, t("manage_slideshow") %>)
  end

  insert_after :slideshow do
    %(<%= insert_slideshow(:max => 2, :gorup => 'Home') %>)
  end

  insert_after :banners do
    %(<%= insert_slideshow(:max => 2, :group => 'Home') %>)
  end

  insert_after :head do
    %(<%= stylesheet_link_tag 'slider' %>
      <%= javascript_include_tag 'jquery.easing.1.2.js', 'jquery.anythingslider.js', 'jquery.anythingslider.fx.min.js' %>
      <% javascript_tag do %>
        function formatText(index, panel) {
          return index + "";
        }
      <% end %>)
  end

  # Homepage hooks for default homepage slideshow
  insert_before :homepage_products, 'shared/display_gallery'

end
