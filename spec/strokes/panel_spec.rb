RSpec.describe Strokes::Panel do
  let(:window) { Strokes::Window.new }

  it 'draws a panel' do
    ds = Strokes::DataSource::ListDataSource.new(["Susana Alvarado", "Carlos Soria", "Noel Soria"])
    panel_1 = Strokes::Panel.new(20, 10, ds)
    panel_2 = Strokes::Panel.new(10, 5, ds)
    panel_3 = Strokes::Panel.new(10, 5, ds)

    window.add_panel panel_1, 0, 0
    window.add_panel panel_2, 4, 2
    window.add_panel panel_3, 6, 4

    puts window.draw
  end
end
