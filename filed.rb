# frozen_string_literal: true

require 'fileutils'

# Class represent field (table) where robot move
class Field
  DEFAULT_SIZE_X = 5
  DEFAULT_SIZE_Y = 6
  FIELD_FILE_DIR = '../data'
  FIELD_FILE_PATH = '../data/field'

  attr_reader :x_size
  attr_reader :y_size

  def save_new_field(x_size, y_size)
    @x_size = x_size
    @y_size = y_size
    save_field
  end

  def save_default_field
    @x_size = DEFAULT_SIZE_X
    @y_size = DEFAULT_SIZE_Y
    save_field
  end

  def field_exists?
    File.exists?(FIELD_FILE_PATH)
  end

  def load_field
    read_field
  end

  def draw(x_position, y_position)
    field = Array.new(@y_size) { Array.new(@x_size) }
    field = field.map { |y| y.map { |x| x = 0 }; }
    field[y_position][x_position] = 1

    puts 'NORTH ->'
    field.each { |a| a.each { |x| print x }; puts }
  end

  private

  def save_field
    FileUtils.mkdir_p FIELD_FILE_DIR
    File.write(FIELD_FILE_PATH, "#{@x_size},#{@y_size}")
  end

  def read_field
    file_data = File.read(FIELD_FILE_PATH).split(',')
    @x_size = file_data.first.to_i
    @y_size = file_data.last.to_i
  end
end
