class Strokes::Window
  include Curses
  include Strokes::Role::Positionable

  attr_reader :win, :panels

  def initialize
    @panels = []
  end

  def add_panel(panel, x, y)
    panel.top_left_x = x
    panel.top_left_y = y

    panels << panel
  end

  def draw
    rows = max_height.times.map { ' ' * max_width }

    panels.each_with_object(rows) do |panel, acc|
      lines = panel.draw
      lines.each_with_index do |line, idy|
        winline = acc[panel.top_left_y + idy]

        winline = winline[0..panel.top_left_x] + line + winline[panel.top_left_x + line.size + 1..]

        acc[panel.top_left_y + idy] = winline
      end
    end

    rows
  end

  def max_width
    80 # win.maxx
  end

  def max_height
    50 # win.maxy
  end

  def open
    init_screen
    start_color
    curs_set(0)
    noecho

    init_pair(1, 1, 0)

    @win = Curses::Window.new(0, 0, 1, 2)
  end

  def close
    close_screen
  end
end
