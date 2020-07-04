class Strokes::DataSource::HashDataSource
  attr_accessor :data

  def initialize(hash_data)
    @data = hash_data
  end

  def draw(width, height)
    max_key_width = data.keys.map { |key| key.size }.max

    lines = data.map do |key, value|
      "#{key.to_s.ljust(max_key_width, ' ')}: #{value}"
    end

    height.times.map do |row_idx|
      lines.fetch(row_idx, '').slice(0, width).ljust(width, ' ')
    end
  end
end
