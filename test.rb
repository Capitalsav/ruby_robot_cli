class RobotControl
  YES_CHOICE          = 1
  NO_CHOICE           = 0
  EMPTY_FIELD_ELEMENT = 0
  ROBOT_FIELD_ELEMENT = 1
  DEFAULT_SIZE_X      = 5
  DEFAULT_SIZE_Y      = 6

  USER_COMMAND_MOVE   = 'MOVE'
  USER_COMMAND_LEFT   = 'LEFT'
  USER_COMMAND_RIGHT  = 'RIGHT'
  USER_COMMAND_REPORT = 'REPORT'
  USER_COMMAND_PLACE  = 'PLACE'

  DIRECTION_NORTH     = 'NORTH'
  DIRECTION_SOUTH     = 'SOUTH'
  DIRECTION_EAST      = 'EAST'
  DIRECTION_WEST      = 'WEST'

  CONTROL_COMMAND_PLACE = 0

  TURN_DIRECTION_LEFT   = 'LEFT'
  TURN_DIRECTION_RIGHT  = 'RIGHT'

  @is_place_command = false

  @field_array = []

  @robot_direction = ''

  @robot_position_x = 0

  @robot_position_y = 0

  def self.get_field_size_commands
    puts 'Do you want to select table size 1 - YES 0 - NO'
    user_choice = Integer(gets.chomp)
    if user_choice == YES_CHOICE
      puts 'Enter field size_x'
      field_x_size = Integer(gets.chomp)
      puts 'Enter field size_y'
      field_y_size = Integer(gets.chomp)
      @field_array = Array.new(field_x_size, EMPTY_FIELD_ELEMENT) { Array.new(field_y_size, EMPTY_FIELD_ELEMENT) }
    elsif user_choice == NO_CHOICE
      @field_array = Array.new(DEFAULT_SIZE_X, EMPTY_FIELD_ELEMENT) { Array.new(DEFAULT_SIZE_Y, EMPTY_FIELD_ELEMENT) }
    end
  end

  def self.get_control_commands
    loop do
      puts '==========================================================================================================='
      draw
      control_command = String(gets.chomp)
      command_router(control_command)
    end
  end

  def self.command_router(command)
    command_as_array = command.split(' ')
    case command_as_array[CONTROL_COMMAND_PLACE]
      when USER_COMMAND_PLACE
        if @is_place_command
          puts 'PLACE ALREADY SET'
        else
          execute_command_place(command)
          @is_place_command = true
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
    command_place_data = command_as_array[1].split(',')
    x_robot_position = command_place_data[0]
    y_robot_position = command_place_data[1]
    @robot_direction  = command_place_data[2]

    y_place = 0
    @field_array.each { |a|
      x_place = 0
      a.each {
        if (Integer(x_robot_position) == x_place) && (Integer(y_robot_position) == y_place)
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
        move_by_x =  0
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
  end

  def self.draw
    puts 'NORTH ->'
    @field_array.each { |a| a.each { |x| print x }; puts}
  end
end

RobotControl.get_field_size_commands
RobotControl.get_control_commands