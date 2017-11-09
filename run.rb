require_relative 'constants'
require_relative 'command_checker'
require_relative 'field_drawer'

class RobotControl

  @is_place_command = false

  @field_array = []

  @robot_direction = ''

  @robot_position_x = 0

  @robot_position_y = 0

  def self.take_field_size_commands
    loop do
      puts 'Do you want to select table size 1 - YES 0 - NO'
      begin
      user_choice = Integer(gets.chomp)
      rescue ArgumentError
        next
      end
      if user_choice == YES_CHOICE
        puts 'Enter field size_x'
        begin
        field_x_size = Integer(gets.chomp)
        rescue ArgumentError
          next
        end
        puts 'Enter field size_y'
        begin
        field_y_size = Integer(gets.chomp)
        rescue ArgumentError
          next
        end
        @field_array = Array.new(field_x_size, EMPTY_FIELD_ELEMENT) {
          Array.new(field_y_size, EMPTY_FIELD_ELEMENT)
        }
        break
      elsif user_choice == NO_CHOICE
        @field_array = Array.new(DEFAULT_SIZE_X, EMPTY_FIELD_ELEMENT) { Array.new(DEFAULT_SIZE_Y, EMPTY_FIELD_ELEMENT) }
        break
      end
    end
    take_control_commands
  end

  def self.take_control_commands
    loop do
      puts '=================================================='
      FieldDrawer.draw(@field_array)
      control_command = String(gets.chomp)
      if CommandChecker.valid_control_command(control_command)
        command_router(control_command)
      else
        puts 'INVALID COMMAND'
      end
    end
  end

  def self.command_router(command)
    command_as_array = command.split(' ')
    case command_as_array[CONTROL_COMMAND_PLACE]
    when USER_COMMAND_PLACE
      if @is_place_command
        puts 'PLACE ALREADY SET'
      elsif execute_command_place(command)
        @is_place_command = true
      else
        puts 'NO ROBOT WILL FALL'
      end
    when USER_COMMAND_MOVE
      move_robot_direction_router
    when USER_COMMAND_LEFT
      turn_robot(TURN_DIRECTION_LEFT)
    when USER_COMMAND_RIGHT
      turn_robot(TURN_DIRECTION_RIGHT)
    when USER_COMMAND_REPORT
      print_robot_report
    end
  end

  def self.execute_command_place(command)
    command_as_array = command.split(' ')
    command_place_data = command_as_array[PARAM_PLACE_COMMAND_POSITION].split(',')
    x_robot_position = Integer(command_place_data[X_PLACE_PARAMETER])
    y_robot_position = Integer(command_place_data[Y_PLACE_PARAMETER])
    @robot_direction = command_place_data[DIRECTION_PLACE_PARAMETER]

    if x_robot_position < 0 || x_robot_position > @field_array.size
      return false
    end

    if y_robot_position < 0 || y_robot_position > @field_array[FIRST_FIELD_ARRAY_ELEMENT].size
      return false
    end
    place_robot(x_robot_position, y_robot_position)
    true
  end

  def self.place_robot(x_robot_position, y_robot_position)
    y_place = 0
    @field_array.each { |a|
      x_place = 0
      a.each {
        if x_robot_position == x_place && y_robot_position == y_place
          @field_array[x_place][y_place] = ROBOT_FIELD_ELEMENT
        end
        x_place += 1
      }
      y_place += 1
    }
  end

  def self.move_robot_direction_router
    move_by_x = 0
    move_by_y = 0
    case @robot_direction
    when DIRECTION_EAST
      move_by_x = 0
      move_by_y = 1
    when DIRECTION_WEST
      move_by_x = 0
      move_by_y = -1
    when DIRECTION_SOUTH
      move_by_x = -1
      move_by_y = 0
    when DIRECTION_NORTH
      move_by_x = 1
      move_by_y = 0
    end

    count_y = 0
    while count_y < @field_array.size
      x_line_array = @field_array[count_y]
      count_x = 0
      while count_x < x_line_array.size
        if @field_array[count_y][count_x] == ROBOT_FIELD_ELEMENT
          if check_robot_not_fall(count_x, count_y, move_by_x, move_by_y)
            @field_array[count_y][count_x] = EMPTY_FIELD_ELEMENT
            new_position_y = count_y + move_by_y
            new_position_x = count_x + move_by_x
            @field_array[new_position_y][new_position_x] = ROBOT_FIELD_ELEMENT
            @robot_position_y = new_position_y
            @robot_position_x = new_position_x
            return
          end
        end
        count_x += 1
      end
      count_y += 1
    end
  end

  def self.check_robot_not_fall(robot_position_x, robot_position_y, move_by_x, move_by_y)
    if ((robot_position_y + move_by_y) < 0) || ((robot_position_y + move_by_y) > @field_array.size - 1)
      return false
    end
    x_array_size = @field_array[0].size - 1
    if ((robot_position_x + move_by_x) < 0) || ((robot_position_x + move_by_x) > x_array_size)
      return false
    end
    true
  end

  def self.turn_robot(turn_direction)
    if turn_direction == TURN_DIRECTION_LEFT
      case @robot_direction
      when DIRECTION_WEST
        @robot_direction = DIRECTION_SOUTH
      when DIRECTION_SOUTH
        @robot_direction = DIRECTION_EAST
      when DIRECTION_NORTH
        @robot_direction = DIRECTION_WEST
      when DIRECTION_EAST
        @robot_direction = DIRECTION_NORTH
      end
    elsif turn_direction == TURN_DIRECTION_RIGHT
      case @robot_direction
      when DIRECTION_WEST
        @robot_direction = DIRECTION_NORTH
      when DIRECTION_SOUTH
        @robot_direction = DIRECTION_WEST
      when DIRECTION_NORTH
        @robot_direction = DIRECTION_EAST
      when DIRECTION_EAST
        @robot_direction = DIRECTION_SOUTH
      end
    end
  end

  def self.print_robot_report
    print 'robot_position_x = ', @robot_position_x
    puts
    print 'robot_position_y = ', @robot_position_y
    puts
    print 'robot_direction = ', @robot_direction
    puts
  end
end

RobotControl.take_field_size_commands
RobotControl.take_control_commands
