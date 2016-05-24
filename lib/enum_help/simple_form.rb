require 'simple_form'

module EnumHelp
  module SimpleForm
    module BuilderExtension

      def default_input_type(*args, &block)
        att_name = (args.first || @attribute_name).to_s
        options = args.last
        return :enum_radio_buttons if options.is_a?(Hash) && options[:as] == :radio_buttons &&
                                      is_enum_attributes?( att_name )

        return :enum if (options.is_a?(Hash) ? options[:as] : @options[:as]).nil? &&
                        is_enum_attributes?( att_name )

        super
      end


      def is_enum_attributes?( attribute_name )
        object.class.respond_to?(:defined_enums) &&
          object.class.defined_enums.key?(attribute_name) &&
          attribute_name.pluralize != "references"
      end


    end

    module InputExtension

      def initialize(*args)
        super
        enum = input_options[:collection] || @builder.options[:collection]
        raise "Attribute '#{attribute_name}' has no enum class" unless enum ||= object.class.send(attribute_name.to_s.pluralize)

        enum = enum.keys if enum.is_a? Hash

        collect = begin
          collection = object.class.send("#{attribute_name.to_s.pluralize}_i18n")
          collection.slice!(*enum) if enum
          collection.invert.to_a
        end

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


class EnumHelp::SimpleForm::EnumRadioButtons < ::SimpleForm::Inputs::CollectionRadioButtonsInput
  include EnumHelp::SimpleForm::InputExtension

end


SimpleForm::FormBuilder.class_eval do
  prepend EnumHelp::SimpleForm::BuilderExtension

  map_type :enum,               :to => EnumHelp::SimpleForm::EnumInput
  map_type :enum_radio_buttons, :to => EnumHelp::SimpleForm::EnumRadioButtons
  alias_method :collection_enum_radio_buttons, :collection_radio_buttons
  alias_method :collection_enum, :collection_select
end
