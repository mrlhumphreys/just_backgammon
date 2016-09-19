# JustBackgammon

A backgammon engine written in ruby. It provides a representation of a backgammon game complete with rules enforcement and serialisation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'just_backgammon'
```

Or install it yourself as:

    $ gem install just_backgammon

## Usage

To start, a new game state can be instantiated with the default state:

```ruby
  game_state = JustBackgammon::GameState.default
```

Rolls can be made by calling the roll method, passing in the player number.

```ruby
  game_state.roll(1)
```

Moves can be made by passing in the player number, and an array of moves each consisting of the from point number and to point number. It will return true if the move is valid, otherwise it will return false.

```ruby
  game_state.move(1, [{from: 1, to: 2}]])
```

If something happens errors may be found in the errors attribute

```ruby
  game_state.errors
```

The Winner can be found by calling winner on the object.

```ruby
  game_state.winner
```

Also, the game can be serialized into a hash.

```ruby
  game_state.as_json
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mrlhumphreys/just_backgammon. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

