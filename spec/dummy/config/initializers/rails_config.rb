require 'rails_config'
RailsConfig.setup do |config|
  config.const_name = "Settings"
end
# Need to load rails config up in dummy app.
ActiveSupport.on_load(:before_initialize) do
  RailsConfig.load_and_set_settings(
    Rails.root.join("config", "settings.yml").to_s,
    Rails.root.join("config", "settings", "#{Rails.env}.yml").to_s )
end