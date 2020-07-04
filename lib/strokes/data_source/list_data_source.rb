class Strokes::DataSource::ListDataSource
  attr_accessor :data

  def initialize(list_data)
    @data = list_data
  end

  def draw(width, height)
    height.times.map do |row_idx|
      data.fetch(row_idx, '').slice(0, width).ljust(width, ' ')
    end
  end
end
