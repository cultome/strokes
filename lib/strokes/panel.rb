class Strokes::Panel
  include Strokes::Role::Positionable

  attr_accessor :width, :height, :datasource, :options

  def initialize(datasource, width = 0, height = 0, options = default_options)
    @width, @height, @datasource, @options = width, height, datasource, options
  end

  def draw(max_width = 0, max_height = 0)
    content_width = width - (((has_border ? 1 : 0) * 2) + (left_padding + right_padding))
    content_height = height - (((has_border ? 1 : 0) * 2) + (top_padding + bottom_padding))

    content = datasource.draw(content_width, content_height).map { |line| prepare_content line }

    screen = []

    screen << top_border if has_border
    screen << prepare_content(top_padding_char * content_width)
    content.each { |line| screen << line }
    screen << prepare_content(bottom_padding_char * content_width)
    screen << bottom_border if has_border

    screen.flatten
  end

  private

  def prepare_content(line)
    res = ""

    res += has_border ? vertical_border_char : ''
    res += left_padding_char * left_padding
    res += line
    res += right_padding_char * right_padding
    res += has_border ? vertical_border_char : ''

    res
  end

  def default_options
    {
      has_border: true,
      corner_char: '+',
      vertical_border_char: '|',
      horizontal_border_char: '-',
      top_padding_char: ' ',
      bottom_padding_char: ' ',
      left_padding_char: ' ',
      right_padding_char: ' ',
      top_padding: 1,
      bottom_padding: 1,
      left_padding: 1,
      right_padding: 1,
    }
  end

  def top_border
    [corner_char + (horizontal_border_char * (width-2)) + corner_char]
  end

  def bottom_border
    top_border
  end

  def method_missing(name, *args)
    return super unless @options.key?(name)

    @options[name]
  end
end
