# frozen_string_literal: true

require 'fileutils'
require_relative 'filed'

# Class responsible for main logic of Robot
class Robot
  ROBOT_POSITION_DIR = '../data'
  ROBOT_POSITION_PATH = '../data/robot_position'
  INVALID_COMMAND = 'invalid command. Robot can\'t move in this direction'

  def initialize
    @field = Field.new
  end

  def initialize_field(x_size, y_size)
    @field.save_new_field(x_size, y_size)
    File.delete(ROBOT_POSITION_PATH) if File.exist?(ROBOT_POSITION_PATH)
  end

  def place(x_position, y_position, direction)
    new_field_if_not_exist

    raise 'Invalid options' unless valid_place_args(x_position, y_position, direction)
    raise 'Invalid position' unless valid_place_position(x_position, y_position)

    @x_position = x_position
    @y_position = y_position
    @direction = direction
    save_position
  end

  def left
    raise 'You must place robot' unless position_exists?

    read_position
    if @direction == 'NORTH'
      @direction = 'WEST'
    elsif @direction == 'WEST'
      @direction = 'SOUTH'
    elsif @direction == 'SOUTH'
      @direction = 'EAST'
    elsif @direction == 'EAST'
      @direction = 'NORTH'
    end
    save_position
    display_position
  end

  def right
    raise 'You must place robot' unless position_exists?

    read_position
    if @direction == 'NORTH'
      @direction = 'EAST'
    elsif @direction == 'WEST'
      @direction = 'NORTH'
    elsif @direction == 'SOUTH'
      @direction = 'WEST'
    elsif @direction == 'EAST'
      @direction = 'SOUTH'
    end
    save_position
    display_position
  end

  def move
    raise 'You must place robot' unless position_exists?

    read_position
    @field.load_field

    if @direction == 'NORTH'
      raise INVALID_COMMAND if @x_position == @field.x_size - 1
      @x_position += 1
    elsif @direction == 'WEST'
      raise INVALID_COMMAND if @y_position.zero?
      @y_position -= 1
    elsif @direction == 'SOUTH'
      raise INVALID_COMMAND if @x_position.zero?
      @x_position -= 1
    elsif @direction == 'EAST'
      raise INVALID_COMMAND if @y_position == @field.y_size - 1
      @y_position += 1
    end

    save_position

    @field.draw(@x_position, @y_position)
  end

  def report
    raise 'You must place robot' unless position_exists?

    read_position
    puts "x_position: #{@x_position}"
    puts "y_position: #{@y_position}"
    puts "direction: #{@direction}"
    puts '-----------------'
    display_position
  end

  private

  def save_position
    FileUtils.mkdir_p ROBOT_POSITION_DIR
    File.write(ROBOT_POSITION_PATH, "#{@x_position},#{@y_position},#{@direction}")
  end

  def read_position
    file_data = File.read(ROBOT_POSITION_PATH).split(',')
    @x_position = file_data.first.to_i
    @y_position = file_data[1].to_i
    @direction = file_data.last
  end

  def new_field_if_not_exist
    @field.save_default_field unless @field.field_exists?
  end

  def display_position
    @field.load_field
    @field.draw(@x_position, @y_position)
  end

  def position_exists?
    File.exists?(ROBOT_POSITION_PATH)
  end

  def valid_place_args(x_position, y_position, direction)
    x_valid = x_position.count("^0-9").zero? # only contain numbers
    y_valid = y_position.count("^0-9").zero?
    direction_valid = false
    if direction == 'NORTH'
      direction_valid = true
    elsif direction == 'WEST'
      direction_valid = true
    elsif direction == 'SOUTH'
      direction_valid = true
    elsif direction == 'EAST'
      direction_valid = true
    end


    return true if x_valid && y_valid && direction_valid
    false
  end

  def valid_place_position(x_position, y_position)
    @field.load_field

    place_valid = true
    place_valid = false if x_position.to_i > @field.x_size - 1 || x_position.to_i.negative?
    place_valid = false if y_position.to_i > @field.y_size - 1 || y_position.to_i.negative?

    return true if place_valid
    false
  end
end
