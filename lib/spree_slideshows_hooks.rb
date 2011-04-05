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

  insert_after :inside_head do
    %(<%= stylesheet_link_tag 'slider' %>
      <% javascript_tag do %>
        function slideSwitch() {
          var $active = $('.slideshow a.active');

          if( $active.length == 0 ) $active = $('.slideshow a:last');
          
          var $next = $active.next().length ? $active.next() : $('.slideshow a:first' );

          $next.addClass('last-active');
                                                        
          $next.css({opacity: 0.0})
            .addClass('active')
            .animate({opacity: 1.0}, 1000, function() {
                $active.removeClass('active last-active');
          });
        }
        $(function() {
          setInterval( "slideSwitch()", 5000 );
        });
      <% end %>)
  end

  # Homepage hooks for default homepage slideshow
  insert_before :homepage_products, 'shared/display_gallery'

end
