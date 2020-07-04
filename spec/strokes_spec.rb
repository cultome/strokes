RSpec.describe Strokes::Panel do
  let(:window) { Strokes::Window.new }

  it 'draws a panel' do
    ds_list = Strokes::DataSource::ListDataSource.new(["Susana Alvarado", "Carlos Soria", "Noel Soria"])
    ds_hash = Strokes::DataSource::HashDataSource.new(name: "Carlos Soria", edad: "37 años", direccion: "Av Iman 580", esposa: "Susana Alvarado")

    panel_1 = Strokes::Panel.new(20, 7, ds_list)
    panel_2 = Strokes::Panel.new(20, 7, ds_list)
    panel_3 = Strokes::Panel.new(41, 7, ds_hash)

    window.add_panel panel_1, 0, 0
    window.add_panel panel_2, 21, 0
    window.add_panel panel_3, 0, 7

    window.open
  end
end
