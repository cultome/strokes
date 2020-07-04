RSpec.describe Strokes::Panel do
  let(:window) { Strokes::Window.new }

  it 'draws a panel' do
    panel_1 = Strokes::Panel.new(20, 10)
    panel_2 = Strokes::Panel.new(10, 5)
    panel_3 = Strokes::Panel.new(10, 5)

    window.add_panel panel_1, 0, 0
    window.add_panel panel_2, 2, 2
    window.add_panel panel_3, 5, 4

    puts window.draw
  end
end
