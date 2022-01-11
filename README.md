# EnumHelp

[![Gem Version](https://badge.fury.io/rb/enum_help.svg)](https://rubygems.org/gems/enum_help)
[![Build Status](https://github.com/zmbacker/enum_help/actions/workflows/ci.yml/badge.svg)](https://github.com/zmbacker/enum_help/actions/workflows/ci.yml)

Help ActiveRecord::Enum feature to work fine with I18n and simple_form.

Make Enum field correctly generate select field.

As you know in Rails 4.1.0 , ActiveRecord supported Enum method. But it doesn't work fine with I18n and simple_form.

This gem can help you work fine with Enum feather, I18n and simple_form

## Breaking Changes

Version 0.0.15 changes the behaviour of namespaced modules as per [this commit](https://github.com/zmbacker/enum_help/commit/fd1c09bcc5402b97bbf4d35313ce84cdffbe47d3): standard en.yml structures for enums `Foo::Bar::Baz#abc` and `Foo::Bar::Bat#def` change from

    enums:
      foo/bar/baz:
        abc:
          lorem: 'Ipsum'
      foo/bar/bat:
        def:
          lorem: 'Ipsum'

To

    enums:
      foo:
        bar:
          baz:
            abc:
              lorem: 'Ipsum'
          bat:
            def:
              lorem: 'Ipsum'

For different I18n backends, adjust accordingly as namespaced modules are now referenced by `.` rather than `/`.

## Installation

Add this line to your application's Gemfile:

    gem 'enum_help'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install enum_help

## Usage


Required Rails 4.1.x

In model file:

```ruby
class Order < ActiveRecord::Base
  enum status: { "nopayment" => 0, "finished" => 1, "failed" => 2, "destroyed" => 3 }

  def self.restricted_statuses
    statuses.except :failed, :destroyed
  end
end
```

You can call:

```ruby
order = Order.first
order.update_attribute :status, 0
order.status
# > nopayment
order.status_i18n # if you have an i18n file defined as following, it will return "未支付".
# > 未支付
```

You can also fetch the translated enum collection, if you need to:

```ruby
Order.statuses_i18n
```

In `_form.html.erb` using `simple_form`:

```erb
<%= f.input :status %>
```

This will generate select field with translations automatically.

And if you want to generate select except some values, then you can pass a collection option.

```erb
<%= f.input :status, Order.restricted_statuses %>
```

Other arguments for `simple_form` are supported perfectly.

e.g.

```erb
<%= f.input :status, prompt: 'Please select a status' %>

<%= f.input :status, as: :string %>
```

From version 0.0.10, enum_help can automatically generate radio buttons with i18n labels.

e.g.
```erb
<%= f.input :status, as: :radio_buttons %>
```




I18n local file example:

```yaml
# config/locales/model/order.zh-cn.yml
zh-cn:
  enums:
    order:
      status:
        finished: 完成
        nopayment: 未支付
        failed: 失败
        destroyed: 已删除
```


## Notice
If you want to use enum feature, field of your table can't be named with `reference`.
When it is named with 'reference' and define enum in model file, there will be raised an error as below:

    NoMethodError: super: no superclass method `enum' for...


## Thanks

Thanks for all the [contributors](https://github.com/zmbacker/enum_help/graphs/contributors).

## Contributing

1. Fork it ( http://github.com/zmbacker/enum_help/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Run test `rspec`
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
