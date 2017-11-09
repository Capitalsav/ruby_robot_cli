require_relative 'constants'

class CommandChecker
  def self.valid_control_command(control_command)
    split_command = control_command.split(' ')
    is_valid_first_part = false
    CONTROL_COMMANDS_ARRAY.each do |valid|
      if split_command[CONTROL_COMMAND_PLACE] == valid
        is_valid_first_part = true
        break
      end
    end

    if !is_valid_first_part
      return is_valid_first_part
    end

    if split_command[CONTROL_COMMAND_PLACE] == USER_COMMAND_PLACE
      if valid_command_place(control_command)
        return true
      else
        return false
      end
    else
      return true
    end
  end

  def self.valid_command_place(control_command)

    split_command = control_command.split(' ')
    if split_command.size != VALID_SPLIT_COMMAND_SIZE
      return false
    end

    second_command_part = split_command[PARAM_PLACE_COMMAND_POSITION]

    begin
      split_second_part = second_command_part.split(',')
    rescue NoMethodError
      return false
    end

    if split_second_part.size != VALID_PARAMS_PLACE_SIZE
      return false
    end

    begin
      split_second_part[X_PLACE_PARAMETER].to_i
      split_second_part[Y_PLACE_PARAMETER].to_i
    rescue ArgumentError
      return false
    end

    case split_second_part[DIRECTION_PLACE_PARAMETER]
    when DIRECTION_NORTH
      return true
    when DIRECTION_SOUTH
      return true
    when DIRECTION_EAST
      return true
    when DIRECTION_WEST
      return true
    else
      return false
    end
  end
end
