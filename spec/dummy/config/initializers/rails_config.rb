require 'rails_config'
RailsConfig.setup do |config|
  config.const_name = "Settings"
end
# Need to load rails config up in dummy app.
ActiveSupport.on_load(:before_initialize) do
  other_files = ["capistrano", "#{Rails.env}"]
  RailsConfig.load_and_set_settings(
    Rails.root.join("config", "settings.yml").to_s,
    *other_files.collect { |setting| Rails.root.join("config", "settings", "#{setting}.yml").to_s })
end