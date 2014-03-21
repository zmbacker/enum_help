# EnumHelp

Help ActiveRecord::Enum feature to work fine with I18n and simple_form.

Make Enum field correctly generate select field.

As you know in Rails 4.1.0 , ActiveRecord supported Enum method. But it doesn't work fine with I18n and simple_form.

This gem can help you work fine with Enum feather, I18n and simple_form


## Installation

Add this line to your application's Gemfile:

    gem 'enum_help'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install enum_help

## Usage


required Rails 4.1.x

In model file:

    class Order < ActiveRecord::Base
      enum status: { "nopayment" => 0, "finished" => 1 }
    end

You can call:

    order = Order.first
    order.update_attribute :status, 0
    order.status
    # > nopayment
    order.status_i18n
    # > nopayment or 未支付

In _form.html.erb using simple form:

    <%= f.input :status %>

This will generate select field with translations automaticlly.

Other arguments for simple_form are supported perfectly.

e.g.

    <%= f.input :status, prompt: 'Please select a stauts' %>
    
    <%= f.input :status, as: :string %>


I18n local file example:

    # config/locals/model/order.zh-cn.yml
    zh-cn:
      enums:
        order:
          status:
            finished: 完成
            nopayment: 未支付



## Contributing

1. Fork it ( http://github.com/zmbacker/enum_help/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
