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
      lines = panel.draw(max_width, max_height)
      lines.each_with_index do |line, idy|
        winline = acc[panel.top_left_y + idy]

        break if winline.nil?

        winline = winline[0..panel.top_left_x] + line + (winline[panel.top_left_x + line.size + 1..] || '')

        acc[panel.top_left_y + idy] = winline
      end
    end
  end

  def max_width
    win.maxx - 1
  end

  def max_height
    win.maxy - 1
  end

  def update
    win.setpos(0, 0)

    draw.each do |line|
      win << line
      clrtoeol
      win << "\n"
    end

    win.refresh
  end

  def open
    init_screen
    start_color
    curs_set(0)
    noecho

    init_pair(1, 1, 0)

    @win = Curses::Window.new(0, 0, 0, 0)

    input_loop
  ensure
    close
  end

  def close
    close_screen
  end

  def input_loop
    @mode = :none

    loop do
      update

      char = @win.getch.to_s

      case char
      when 'q' then exit(0)
      end
    end
  end
end
