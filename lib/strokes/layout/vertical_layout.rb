class Strokes::Layout::VerticalLayout
  include Strokes::Role::Positionable

  attr_accessor :proportions, :panels

  def initialize(proportions = [], panels = [])
    raise 'Proportions for all panels are required' if proportions.size != panels.size

    @proportions = proportions
    @panels = panels
  end

  def draw(max_width, max_height)
    panel_heights = proportions.map { |percentage| ((max_height - 1) * percentage / 100.0).round.to_i }
    current_y = 0
    panel_heights.zip(panels).flat_map do |height, panel|
      panel.top_left_x = 0
      panel.top_left_y = current_y
      panel.width = max_width - 1
      panel.height = height

      current_y = height

      panel.draw
    end
  end
end
