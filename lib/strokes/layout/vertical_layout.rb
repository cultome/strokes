class Strokes::Layout::VerticalLayout
  include Strokes::Role::Positionable

  attr_accessor :proportions, :panels

  def initialize(proportions = [], datasources = [])
    raise "Panels should have a datasource" if proportions.size != datasources.size

    @proportions = proportions
    @panels = proportions.zip(datasources).map { |_, ds| Strokes::Panel.new(0, 0, ds) }
  end

  def draw(max_width, max_height)
    panel_heights = proportions.map { |percentage| (max_height * percentage / 100.0).round.to_i }
    current_y = 0
    panel_heights.zip(panels).flat_map do |height, panel|
      panel.top_left_x = 0
      panel.top_left_y = current_y
      panel.width = max_width
      panel.height = height

      current_y = height

      panel.draw
    end
  end
end
