class Strokes::Panel
  include Strokes::Role::Positionable

  attr_accessor :width, :height

  def initialize(width, height)
    @width, @height = width, height
  end

  def draw
    content = draw_content(width - 2, height - 2).map { |line| [vertical_border_char + line + vertical_border_char] }

    [
      top_border,
      *content,
      bottom_border,
    ].flatten
  end

  private

  def top_border
    [corner_char + (horizontal_border_char * (width-2)) + corner_char]
  end

  def bottom_border
    top_border
  end

  def draw_content(width, height)
    # TODO: implement
    height.times.map do |row|
      ' ' * width
    end
  end

  def corner_char
    '+'
  end

  def vertical_border_char
    '|'
  end

  def horizontal_border_char
    '-'
  end
end
