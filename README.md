# Ruby robot cli
### ruby 2.7.1

### This is exercise to check your skills in development command line applications with ruby programming language.
### It simulates movement of small robot on the table.

## Usage

In the root directory of the project run 

```bundle install```

To run this program: `cd bin/`
and input next command:
```ruby ./ruby_robot_cli.rb```

You will see list of available commands:
```bigquery
  ruby_robot_cli.rb help [COMMAND]                         # Describe available commands or one specific command
  ruby_robot_cli.rb initialize_field x_size y_size         # Initialize size of field
  ruby_robot_cli.rb left                                   # Turn robot left
  ruby_robot_cli.rb move                                   # Move robot forward
  ruby_robot_cli.rb place x_position y_position direction  # Place robot on the table
  ruby_robot_cli.rb report                                 # Report robot position
  ruby_robot_cli.rb right                                  # Turn robot right
```

### Available directions
`NORTH`

`SOUTH`

`EAST`

`WEST`

### Available positions
Field size and position can be only integers > 0

## Example
```bigquery
ruby ./ruby_robot_cli.rb place 1 1 north
ruby ./ruby_robot_cli.rb report
ruby ./ruby_robot_cli.rb move
```