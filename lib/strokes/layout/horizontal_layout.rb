class Strokes::Layout::HorizontalLayout
  include Strokes::Role::Positionable

  attr_accessor :proportions, :panels

  def initialize(proportions = [], panels = [])
    raise 'Proportions for all panels are required' if proportions.size != panels.size

    @proportions = proportions
    @panels = panels
  end

  def draw(max_width, max_height)
    panel_widths = proportions.map { |percentage| ((max_width - 1) * percentage / 100.0).round.to_i }
    current_x = 0
    rows = panel_widths.zip(panels).map do |width, panel|
      panel.top_left_x = current_x
      panel.top_left_y = 0
      panel.width = width - 1
      panel.height = max_height

      current_x = width

      panel.draw
    end

    rows
      .reduce { |acc, lines| acc.zip(lines) }
      .map(&:flatten)
      .map { |segments| segments.join(' ') }
  end
end
