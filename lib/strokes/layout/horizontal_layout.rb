class Strokes::Layout::HorizontalLayout
  include Strokes::Role::Positionable

  attr_accessor :proportions, :panels

  def initialize(proportions = [], datasources = [])
    raise "Panels should have a datasource" if proportions.size != datasources.size

    @proportions = proportions
    @panels = proportions.zip(datasources).map { |_, ds| Strokes::Panel.new(0, 0, ds) }
  end

  def draw(max_width, max_height)
    panel_widths = proportions.map { |percentage| ((max_width - 1) * percentage / 100.0).round.to_i }
    current_x = 0
    rows = panel_widths.zip(panels).map do |width, panel|
      panel.top_left_x = current_x
      panel.top_left_y = 0
      panel.width = width - 1
      panel.height = max_height - 1

      current_x = width

      panel.draw
    end

    rows
      .reduce { |acc, lines| acc.zip(lines) }
      .map(&:flatten)
      .map { |segments| segments.join(' ') }
  end
end
