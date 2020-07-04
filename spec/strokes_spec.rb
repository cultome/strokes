RSpec.describe Strokes do
  let(:window) { Strokes::Window.new }

  it 'draw a composed horizontal layout' do
    ds_list_1 = Strokes::DataSource::ListDataSource.new(["uno", "dos", "tres"])
    ds_list_2 = Strokes::DataSource::ListDataSource.new(["a", "be", "ce"])
    ds_hash_1 = Strokes::DataSource::HashDataSource.new(name: "Carlos Soria", edad: "37 años", direccion: "Av Iman 580", esposa: "Susana Alvarado")
    ds_hash_2 = Strokes::DataSource::HashDataSource.new(name: "Noel Soria", edad: "10 años", direccion: "Av Iman 580")

    panel_1 = Strokes::Panel.new(ds_list_1)
    panel_2 = Strokes::Panel.new(ds_list_2)
    panel_3 = Strokes::Panel.new(ds_hash_1)
    panel_4 = Strokes::Panel.new(ds_hash_2)

    h1 = Strokes::Layout::VerticalLayout.new([30, 70], [panel_1, panel_3])
    h2 = Strokes::Layout::VerticalLayout.new([50, 50], [panel_2, panel_4])

    vertical_layout = Strokes::Layout::HorizontalLayout.new([40, 60], [h1, h2])

    window.add_panel vertical_layout, 0, 0

    window.open
  end

  it 'draw a composed vertical layout' do
    ds_list_1 = Strokes::DataSource::ListDataSource.new(["uno", "dos", "tres"])
    ds_list_2 = Strokes::DataSource::ListDataSource.new(["a", "be", "ce"])
    ds_hash_1 = Strokes::DataSource::HashDataSource.new(name: "Carlos Soria", edad: "37 años", direccion: "Av Iman 580", esposa: "Susana Alvarado")
    ds_hash_2 = Strokes::DataSource::HashDataSource.new(name: "Noel Soria", edad: "10 años", direccion: "Av Iman 580")

    panel_1 = Strokes::Panel.new(ds_list_1)
    panel_2 = Strokes::Panel.new(ds_list_2)
    panel_3 = Strokes::Panel.new(ds_hash_1)
    panel_4 = Strokes::Panel.new(ds_hash_2)

    h1 = Strokes::Layout::HorizontalLayout.new([30, 70], [panel_1, panel_3])
    h2 = Strokes::Layout::HorizontalLayout.new([50, 50], [panel_2, panel_4])

    vertical_layout = Strokes::Layout::VerticalLayout.new([20, 80], [h1, h2])

    window.add_panel vertical_layout, 0, 0

    window.open
  end

  it 'draw a horizontal layout' do
    ds_list_1 = Strokes::DataSource::ListDataSource.new(["Susana Alvarado", "Carlos Soria", "Noel Soria"])
    ds_list_2 = Strokes::DataSource::ListDataSource.new(["Update Alvarado", "Update Soria"])
    ds_hash = Strokes::DataSource::HashDataSource.new(name: "Carlos Soria", edad: "37 años", direccion: "Av Iman 580", esposa: "Susana Alvarado")

    panel_1 = Strokes::Panel.new(ds_list_1)
    panel_2 = Strokes::Panel.new(ds_list_2)
    panel_3 = Strokes::Panel.new(ds_hash)

    horizontal_layout = Strokes::Layout::HorizontalLayout.new([30, 30, 40], [panel_1, panel_2, panel_3])

    window.add_panel horizontal_layout, 0, 0

    window.open
  end

  it 'draw a vertical layout' do
    ds_list = Strokes::DataSource::ListDataSource.new(["Susana Alvarado", "Carlos Soria", "Noel Soria"])
    ds_hash = Strokes::DataSource::HashDataSource.new(name: "Carlos Soria", edad: "37 años", direccion: "Av Iman 580", esposa: "Susana Alvarado")

    panel_1 = Strokes::Panel.new(ds_list)
    panel_2 = Strokes::Panel.new(ds_hash)

    vertical_layout = Strokes::Layout::VerticalLayout.new([30, 70], [panel_1, panel_2])

    window.add_panel vertical_layout, 0, 0

    window.open
  end

  it 'draws a single panel' do
    ds_list = Strokes::DataSource::ListDataSource.new(["Susana Alvarado", "Carlos Soria", "Noel Soria"])
    ds_hash = Strokes::DataSource::HashDataSource.new(name: "Carlos Soria", edad: "37 años", direccion: "Av Iman 580", esposa: "Susana Alvarado")

    panel_1 = Strokes::Panel.new(ds_list, 20, 7)
    panel_2 = Strokes::Panel.new(ds_list ,20, 7)
    panel_3 = Strokes::Panel.new(ds_hash, 41, 7)

    window.add_panel panel_1, 0, 0
    window.add_panel panel_2, 21, 0
    window.add_panel panel_3, 0, 7

    window.open
  end
end
