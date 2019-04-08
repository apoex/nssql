# NSSQL

[![Gem Version](https://badge.fury.io/rb/nssql.svg)](https://badge.fury.io/rb/nssql)
[![Build Status](https://travis-ci.org/apoex/nssql.svg?branch=master)](https://travis-ci.org/apoex/nssql)
[![Maintainability](https://api.codeclimate.com/v1/badges/0bc97f0e7fef36bcf922/maintainability)](https://codeclimate.com/github/apoex/nssql/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/0bc97f0e7fef36bcf922/test_coverage)](https://codeclimate.com/github/apoex/nssql/test_coverage)

NSSQL allows you to query directly against NetSuite through an ODBC connection. Define your tables, primary keys and columns and query away!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nssql'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nssql

## Usage

Follow the steps below to start using NSSQL.

### Settings

```ruby
NSSQL::Settings.configure do |config|
  config.user     = 'USER'
  config.password = 'PASSWORD'
end
```

### Table

```ruby
class TestTable < NSSQL::Table
  table_name   'test_table'
  primary_keys 'id', 'line_id'
  columns      'id', 'line_id', 'name'
end
```

### Select columns

`TestTable.select_columns_query` will generate:

```SQL
SELECT
  id,line_id,name
FROM
  test_table
ORDER BY
  id
```

We can pass options, like `TestTable.select_columns_query(where: 'id > 500')` and this will generate:

```SQL
SELECT
  id,line_id,name
FROM
  test_table
WHERE id > 500
ORDER BY
  id
```

### Other selects

Select to file

```ruby
NSSQL.select_to_file('SELECT 1+1')
```

Select array

```ruby
NSSQL.select_array('SELECT 1+1')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/apoex/nssql. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Nssql project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/apoex/nssql/blob/master/CODE_OF_CONDUCT.md).
