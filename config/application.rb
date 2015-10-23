require File.expand_path('../boot', __FILE__)
require 'rails/all'
Bundler.require(*Rails.groups)
require_relative '../lib/trimmer'

module Epin
  class Application < Rails::Application
    config.active_record.default_timezone = :local
    config.time_zone = 'Beijing'
    config.i18n.default_locale = "zh-CN"
    config.active_record.raise_in_transactional_callbacks = true
    config.middleware.use PDFKit::Middleware, :print_media_type => true
    config.middleware.insert_after ActionDispatch::ParamsParser, ActionDispatch::XmlParamsParser
    config.autoload_paths += %W(#{config.root}/app/models/money_transfers)
    config.autoload_paths += %W(#{config.root}/app/models/users)
    config.middleware.use Trimmer
  end
end

ROOT_URL = "http://#{Settings.domain.host}:#{Settings.domain.port}"
