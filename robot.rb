# FROZEN_STRING_LITERAL: true

class InvalidPlacementError < StandardError
end

class Robot
  REGEX_FOR_VALID_PLACEMENT = /PLACE ([0-5]),([0-5]),(NORTH|SOUTH|EAST|WEST)/.freeze
  DIRECTIONS = %w[NORTH EAST SOUTH WEST].freeze

  attr_reader :x, :y, :direction

  def go
    instructions.each do |instruction|
      case instruction
      when REGEX_FOR_VALID_PLACEMENT then place(instruction)
      when 'MOVE' then move
      when 'LEFT' then turn('left')
      when 'RIGHT' then turn('right')
      when 'REPORT' then report
      end
    end
  end

  def self.read_instructions(filename = 'instructions.txt')
    instructions = File.readlines(filename).map(&:strip)

    raise InvalidPlacementError unless instructions.any? { |instruction| instruction.match?(REGEX_FOR_VALID_PLACEMENT) }

    Robot.new(instructions)
  end

  private

  attr_reader :instructions

  def initialize(instructions)
    index_of_placement = instructions.find_index { |instruction| instruction.match?(REGEX_FOR_VALID_PLACEMENT) }
    @instructions = instructions[index_of_placement..]
  end

  def place(instruction)
    capture_groups = instruction.match(REGEX_FOR_VALID_PLACEMENT).captures

    @x, @y, @direction = capture_groups.map.each_with_index { |value, index| index < 2 ? value.to_i : value }
  end

  def move
    case direction
    when 'NORTH' then @y += 1 unless y == 5
    when 'EAST' then @x += 1 unless x == 5
    when 'SOUTH' then @y -= 1 unless y.zero?
    when 'WEST' then @x -= 1 unless x.zero?
    end
  end

  def report
    puts "#{x},#{y},#{direction}"
  end

  def turn(left_or_right)
    index_current_direction = DIRECTIONS.index(direction)
    index_new_direction = left_or_right == 'left' ? index_current_direction - 1 : index_current_direction + 1

    @direction = DIRECTIONS[index_new_direction % 4]
  end
end
