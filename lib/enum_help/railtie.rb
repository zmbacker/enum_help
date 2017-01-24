module EnumHelp
  class Railtie < Rails::Railtie
    initializer "enum_help.i18n" do
      ActiveSupport.on_load(:active_record) do
        extend EnumHelp::I18n
      end
    end
  end
end
