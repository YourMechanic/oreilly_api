# OreillyApi

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/oreilly_api`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'oreilly_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oreilly_api

## Usage

After installing the gem create a file oreilly.rb in config/initializers with following content:

```ruby
OreillyApi.config do |c|
    c.domain = 'https://sms-test-1.firstcallonline.com'
    c.client_id = 'client_id'
    c.client_secret = 'client_sercet'
    c.identity = 'IDENTITY'
    c.version = 'sms-external-partner/services'
    c.account_number = '123456'
end
```

to Place an Order
```ruby
OreillyApi.place_order(payload)
```

to Fetch Quote
```ruby
OreillyApi.fetch_quote(items)
```


to get sample requuest
```ruby
OreillyApi.sample_request
```

to test place order
```ruby
OreillyApi.test_place_order
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/oreilly_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the OreillyApi project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/oreilly_api/blob/master/CODE_OF_CONDUCT.md).
