module EnumHelp

  module I18n

    # overwrite the enum method
    def enum( definitions )
      super( definitions )
      definitions.each do |name, _|
        Helper.define_attr_i18n_method(self, name)
        Helper.define_collection_i18n_method(self, name)
      end
    end

    def self.extended(receiver)
      # receiver.class_eval do
      #   # alias_method_chain :enum, :enum_help
      # end
    end

  end

  module Helper

    def self.define_attr_i18n_method(klass, attr_name)
      attr_i18n_method_name = "#{attr_name}_i18n"

      klass.class_eval <<-METHOD, __FILE__, __LINE__
      def #{attr_i18n_method_name}
        enum_label = self.send(:#{attr_name})
        if enum_label
          ::EnumHelp::Helper.translate_enum_label(self.class, :#{attr_name}, enum_label)
        else
          nil
        end
      end
      METHOD
    end

    def self.define_collection_i18n_method(klass, attr_name)
      collection_method_name = "#{attr_name.to_s.pluralize}"
      collection_i18n_method_name = "#{collection_method_name}_i18n"

      klass.instance_eval <<-METHOD, __FILE__, __LINE__
      def #{collection_i18n_method_name}(*args)
        options = args.extract_options!
        collection = args[0] || send(:#{collection_method_name})
        collection.except! options[:except] if options[:except]

        collection.map do |label, value|
          [::EnumHelp::Helper.translate_enum_label(self, :#{attr_name}, label), value]
        end.to_h
      end
      METHOD
    end

    def self.translate_enum_label(klass, attr_name, enum_label)
      ::I18n.t("enums.#{klass.to_s.underscore}.#{attr_name}.#{enum_label}", default: enum_label)
    end

  end
end
