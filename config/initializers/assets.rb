# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '2.0'

%w( home instances registrations sessions account pages tickets records admin ).each do |controller|
  Rails.application.config.assets.precompile += ["#{controller}.js.coffee","#{controller}.js","#{controller}.scss","#{controller}.css"]
end
# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
