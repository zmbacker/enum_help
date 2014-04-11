module EnumHelp
  module I18n

    # overwrite the enum method
    def enum( definitions )
      klass = self
      super( definitions )
      definitions.each do |name, values|
        # def status_i18n() statuses.key self[:status] end
        i18n_method_name = "#{name}_i18n".to_sym
        define_method(i18n_method_name) do
          enum_value = self.send(name)
          ::I18n.t("enums.#{klass.to_s.underscore}.#{name}.#{enum_value}", default: enum_value)
        end
      end
    end


    def self.extended(receiver)
      # receiver.class_eval do
      #   # alias_method_chain :enum, :enum_help
      # end
    end

  end
end

