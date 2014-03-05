module EnumHelp
  class Railtie < Rails::Railtie
    initializer "enum_help.i18n" do
      ActiveRecord::Base.send :extend, EnumHelp::I18n
    end
  end
end