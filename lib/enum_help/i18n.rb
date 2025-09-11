module EnumHelp

  module I18n

    if ActiveRecord::VERSION::MAJOR >= 7
      # overwrite the enum method
      def enum(name = nil, values = nil, **options)
        definitions = super

        if name # For new syntax in Rails7
          Helper.define_attr_i18n_method(self, name)
          Helper.define_collection_i18n_method(self, name)
        else
          definitions = options.slice!(:_prefix, :_suffix, :_scopes, :_default)
          definitions.each do |name, _|
            Helper.define_attr_i18n_method(self, name)
            Helper.define_collection_i18n_method(self, name)
          end
        end

        definitions
      end
    else
      # overwrite the enum method
      def enum( definitions )
        super( definitions )
        definitions.each do |name, _|
          Helper.define_attr_i18n_method(self, name)
          Helper.define_collection_i18n_method(self, name)
        end
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
          ::EnumHelp::Helper.translate_enum_label('#{klass}', :#{attr_name}, enum_label)
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
      def #{collection_i18n_method_name}
        collection_array = #{collection_method_name}.collect do |label, _|
          [label, ::EnumHelp::Helper.translate_enum_label('#{klass}', :#{attr_name}, label)]
        end
        Hash[collection_array].with_indifferent_access
      end
      METHOD
    end

    def self.translate_enum_label(klass, attr_name, enum_label)
      ::I18n.t("enums.#{klass.to_s.underscore.gsub('/', '.')}.#{attr_name}.#{enum_label}", default: enum_label.humanize)
    end

  end
end
