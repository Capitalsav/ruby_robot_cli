# frozen_string_literal: true

require 'thor'
require_relative '../robot'

# Class responsible for command line interface
class RubyRobotCli < Thor
  def initialize(*args)
    super
    @robot = Robot.new
  end

  desc 'initialize_field x_size y_size', 'Initialize size of field'
    def initialize_field(x_size, y_size)
      @robot.initialize_field(x_size, y_size)
    end

  desc 'place x_position y_position direction', 'Place robot on the table'
    def place(x_position, y_position, direction)
      @robot.place(x_position, y_position, direction.upcase)
    end

  desc 'move', 'Move robot forward'
    def move
      @robot.move
    end

  desc 'left', 'Turn robot left'
    def left
      @robot.left
    end

  desc 'right', 'Turn robot right'
    def right
      @robot.right
    end

  desc 'report', 'Report robot position'
    def report
      @robot.report
    end
end

RubyRobotCli.start(ARGV)
