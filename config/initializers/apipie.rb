Apipie.configure do |config|
  config.app_name                = "TodoBackend"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/docs"
  config.validate                = false
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/v1/**/*.rb"
end
