# LambdaParty
LambdaParty is an extension of HTTParty with use for making signed request to AWS


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lambda_party'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lambda_party

## Usage

In the class you will be making the http request call you will include
LambdaParty and define the class variables necessary for your AWS signing example.
To make a call you will use LambdaParty.get (url) (or other appropriate http verb)

	class Requester
		include LambdaParty
			LambdaParty.aws_key 'key'
			LambdaParty.aws_secret 'secret'
			LambdaParty.aws_region 'us-east-1'
			LambdaParty.aws_service 'execute-api'

			#rest of your code here
		def request
			LambdaParty.get("http://request-url.com/id/3")
		end
	end

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/lambda_party. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the LambdaParty project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/lambda_party/blob/master/CODE_OF_CONDUCT.md).
