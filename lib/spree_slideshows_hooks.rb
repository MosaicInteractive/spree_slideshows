class SpreeSlideshowsHooks < Spree::ThemeSupport::HookListener
  # Admin Hooks
  insert_after :admin_configurations_menu do
    %(<%= configurations_menu_item t('slideshow_slides'), admin_slides_path, t("manage_slideshow") %>)
  end

  insert_after :slideshow do
    %(<%== insert_slideshow(:max => 2, :gorup => 'Home') %>)
  end

  insert_after :banners do
    %(<%== insert_slideshow(:max => 2, :group => 'Home') %>)
  end

  # Homepage hooks for default homepage slideshow
  insert_before :homepage_products, 'shared/display_gallery'

end
