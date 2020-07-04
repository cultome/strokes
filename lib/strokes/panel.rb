class Strokes::Panel
  include Strokes::Role::Positionable

  attr_accessor :datasource, :options

  def initialize(datasource, width: 0, height: 0, options: default_options)
    @width, @height, @datasource, @options = width, height, datasource, default_options.merge(options)
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
      title: '',
      title_position: :left,
      has_border: true,
      corner_char: '+',
      vertical_border_char: '|',
      horizontal_top_border_char: '=',
      horizontal_bottom_border_char: '-',
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
    if title.empty?
      [corner_char + (horizontal_top_border_char * (width-2)) + corner_char]
    else
      padded_title = " #{title} "
      title_padding_size = 1
      bar_title = case title_position
                  when :left
                    (horizontal_top_border_char * title_padding_size) + padded_title.ljust(width - 2 - title_padding_size, horizontal_top_border_char)
                  when :right
                    padded_title.rjust(width - 2 - title_padding_size, horizontal_top_border_char) + (horizontal_top_border_char * title_padding_size)
                  when :center
                    padded_title.center(width-2, horizontal_top_border_char)
                  end

      [corner_char + bar_title + corner_char]
    end
  end

  def bottom_border
    [corner_char + (horizontal_bottom_border_char * (width-2)) + corner_char]
  end

  def method_missing(name, *args)
    return super unless @options.key?(name)

    @options[name]
  end
end
