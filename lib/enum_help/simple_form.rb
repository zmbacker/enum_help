module EnumHelp
  module SimpleForm
    module BuilderExtension

      def default_input_type_with_enum(*args, &block)
        att_name = (args.first || @attribute_name).to_s
        return :enum if (args.last.is_a?(Hash) ? args.last[:as] : @options[:as]).nil? &&
                        object.class.respond_to?(att_name.pluralize)

        default_input_type_without_enum(*args, &block)
      end

    end

    module InputExtension

      def initialize(*args)
        super
        enum = input_options[:collection] || @builder.options[:collection]
        raise "Attribute '#{attribute_name}' has no enum class" unless enum ||= object.class.send(attribute_name.to_s.pluralize)

        collect = enum.collect{|k,v| [::I18n.t("enums.#{object.class.to_s.underscore}.#{attribute_name}.#{k}", default: k),k] }
        # collect.unshift [args.last[:prompt],''] if args.last.is_a?(Hash) && args.last[:prompt]

        if respond_to?(:input_options)
          input_options[:collection] = collect
        else
          @builder.options[:collection] = collect
        end
      end

    end

  end
end


class EnumHelp::SimpleForm::EnumInput < ::SimpleForm::Inputs::CollectionSelectInput
  include EnumHelp::SimpleForm::InputExtension
  def input_html_classes
    super.push('form-control')
  end
end

SimpleForm::FormBuilder.class_eval do
  include EnumHelp::SimpleForm::BuilderExtension

  map_type :enum, :to => EnumHelp::SimpleForm::EnumInput
  alias_method :collection_enum, :collection_select
  alias_method_chain :default_input_type, :enum
end
