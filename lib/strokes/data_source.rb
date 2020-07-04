class Strokes::DataSource
  def draw(width, height)
    height.times.map do |row|
      '.' * width
    end
  end
end
