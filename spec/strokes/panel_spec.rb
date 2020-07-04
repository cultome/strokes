RSpec.describe Strokes::Panel do
  let(:window) { Strokes::Window.new }

  it 'draws a panel' do
    panel_1 = Strokes::Panel.new(20, 10, 0, 0)
    panel_2 = Strokes::Panel.new(10, 5, 2, 2)
    panel_3 = Strokes::Panel.new(10, 5, 5, 4)

    window.add_panel panel_1
    window.add_panel panel_2
    window.add_panel panel_3

    puts window.draw
  end
end
