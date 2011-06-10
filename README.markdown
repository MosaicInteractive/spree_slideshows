# SUMMARY #

This extension allows easy addition and administration of slideshows in Spree.
#NOTE
This version works for heroku and it has been tested with Spree 0.60.x


# NOTE #


This version works for heroku and it has been tested with Spree 0.60.x

# INSTALLATION #

   Add the spree_slideshows gem to your Gemfile

	gem 'spree_slideshows', :git => 'git://github.com/nebulaideas/spree_slideshows.git', :branch => '0-50-x'

   Migrate the database

	rake db:migrate

   Copy assets

	rake spree_slideshows:install

   Restart server

# USAGE #

   add slideshow helper method in your view:

	<%= insert_slideshow %>

   add slides for the slideshow in the admin section

   Additional options:

	<%= insert_slideshow :group => "home" %>

   displays slides for which the groups column is empty or includes the value "home"

	<%= insert_slideshow :max => 10 %>

   limits the number of slides shown to 10 (default 5)
