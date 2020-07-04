class Strokes::Window
  include Curses
  include Strokes::Role::Positionable

  attr_reader :win, :panels, :prompt

  def initialize(width: 0, height: 0, prompt: ' > ')
    @width = width
    @height = height
    @prompt = prompt
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
    win.setpos 0, 0

    draw.each do |line|
      win << line
      win.clrtoeol
      win << "\n"
    end

    # print prompt
    win.setpos max_height, 0
    win.addstr prompt

    win.refresh
  end

  def open
    init_screen
    start_color
    curs_set(0)
    noecho

    init_pair(1, 1, 0)

    @win = Curses::Window.new(width, height, 0, 0)

    input_loop
  ensure
    close
  end

  def close
    close_screen
  end

  def input_loop
    @input = ''

    loop do
      update

      char = win.getch.to_s
      case char
      when '27[A' # Up
      when '27[B' # Down
      when '27[C' # Right
      when '27[D' # Left
      when '127' # Delete
        @input = @input[0..-2]
      when '27' # Esc
        set_normal_mode
      when '10' # ENTER
        set_normal_mode

        process_user_input

        @input = ''
      else
        next if char.is_a? Integer

        @input += char

        # TODO: agregar recomendaciones de comandos en el status bar
      end

      display_status_bar
    end
  end

  def display_status_bar
    if @input.start_with? '/'
      set_search_mode
    elsif @input.start_with? ':'
      set_command_mode
    end

    win.setpos max_height, prompt.size
    win.attron(color_pair(1)) { win << @input }
    win.clrtoeol

    # status message
    status_msg = mode
    status_msg += " | #{status}" unless status.empty?

    win.setpos max_height, max_width - status_msg.size - 2
    win.attron(color_pair(1)) { win << status_msg }
    win.clrtoeol
  end

  def process_user_input
    if @input.start_with? ':'
      # command mode
      process_command @input[1..]
    elsif @input.start_with? '/'
      # search mode
      process_search @input[1..]
    else
      set_status 'unable to process command'
    end
  end

  def process_search(value)
  end

  def process_command(value)
    case value
    when /^(q|quit|exit)$/
      exit(0)
    end
  end

  def status
    @status ||= ''
  end

  def set_status(value)
    @status = value
  end

  def clear_status
    @status = ''
  end

  def set_search_mode
    @mode = 'search mode'
  end

  def set_command_mode
    @mode = 'command mode'
    clear_status
  end

  def set_normal_mode
    @mode = 'normal mode'
    clear_status
  end

  def mode
    @mode ||= 'normal mode'
  end
end
