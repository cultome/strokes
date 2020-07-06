class Strokes::Window
  include Curses
  include Strokes::Role::Positionable

  attr_reader :win, :elements, :prompt

  def initialize(width: 0, height: 0, prompt: ' > ')
    @width = width
    @height = height
    @prompt = prompt
    @elements = []
  end

  def add_drawable(element, x, y)
    element.top_left_x = x
    element.top_left_y = y

    elements << element
  end

  def draw
    rows = max_height.times.map { ' ' * max_width }

    elements.each_with_object(rows) do |element, acc|
      lines = element.draw(max_width, max_height)
      lines.each_with_index do |line, idy|
        winline = acc[element.top_left_y + idy]

        break if winline.nil?

        winline = winline[0..element.top_left_x] + line + (winline[element.top_left_x + line.size + 1..] || '')

        acc[element.top_left_y + idy] = winline
      end
    end
  end

  def max_width
    win.nil? ? IO.console.winsize.last : win.maxx - 1
  end

  def max_height
    win.nil? ? IO.console.winsize.first : win.maxy - 1
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

        @input = ''
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
    when /^sh ([\d]+)$/
      # split horizontally
      elem_id = $1.to_i
      elem = elements[elem_id]
      if elem.is_a? Strokes::Panel
        # build a layout, insert this a new one onto it
        new_ds = Strokes::DataSource::ListDataSource.new(["Nuevo panel", "inserta contenido aqui"])
        new_panel = Strokes::Panel.new(new_ds, options: { full_screen: true })
        new_layout = Strokes::Layout::HorizontalLayout.new([50, 50], [elem, new_panel])

        new_layout.top_left_x = elem.top_left_x
        new_layout.top_left_y = elem.top_left_y

        elements[elem_id] = new_layout
      else
        set_status "invalid element ID [#{elem_id}]"
      end
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
