require "enum_help/version"

simple_form_exist = true
begin
  require 'simple_form'
rescue LoadError
  simple_form_exist = false
end
if simple_form_exist
  require "enum_help/simple_form"
end
require "enum_help/i18n"
require "enum_help/railtie"

