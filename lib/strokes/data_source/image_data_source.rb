class Strokes::DataSource::ImageDataSource
  attr_accessor :data

  def initialize(image_path)
    @data = image_path
  end

  def draw(width, height)
    img_data = generate_image_data(width, height)

    height.times.map do |row_idx|
      line = img_data.fetch(row_idx, '').split(' ').slice(0, width)

      res = line.join(' ')

      if line.size < width
        padding = (width - line.size + 1) / 2
        (' ' * padding) + res + (' ' * padding)
      else
        res
      end
    end
  end

  def generate_image_data(width, height)
    image_data = []
    line = ""
    size = width < height ? width : height

    img = Magick::Image.read(data)[0]
    img.change_geometry!("#{size}x#{size}") { |cols, rows| img.thumbnail! cols, rows }
    img.each_pixel do |pixel, col, row|
      c = [pixel.red, pixel.green, pixel.blue].map { |v| 256 * (v / 65535.0) }
      line += pixel.magenta == 65535 ? ' ' : ' '.bg(c)
      if col >= img.columns - 1
        image_data << line
        line = ""
      end
    end

    image_data
  end
end
