class Map
  # マップチップ毎の画像イメージ
  CELL_IMAGES = Image.loadToArray(File.join(File.dirname(__FILE__), "..", "images", "map_chips.png"), 4, 4)

  # @map_data の各要素の意味
  FLOOR = 0
  WALL = 1

  def initialize(map_file)
    @map_data = []
    map_load(map_file)
    @target = RenderTarget.new(800,600)
  end

  # マップ全体の描画
  def draw
    @map_x_size.times do |x|
      @map_y_size.times do |y|
        draw_cell(x, y)
      end
    end
    return @target
  end

  # 任意の座標x, y におけるマップチップの種類を取得
  def [](x, y)
    return @map_data[y][x].to_i
  end

  def movable?(x, y)
    return self[x,y] == 0
  end

  def height
    return @map_y_size * CELL_IMAGES.first.height
  end


  private

  # マップデータの読み込み
  def map_load(map_file)
    open(map_file).each do |line|
      cols = line.chomp.split(/\s*,\s*/).map(&:to_i)
      @map_data << cols
      @map_x_size = cols.size unless @map_x_size
    end
    @map_y_size = @map_data.size
  end

  # マップの1マスの描画
  def draw_cell(x, y)
    image = CELL_IMAGES[self[x, y]]
    @target.draw(x * image.width, y * image.height, image)
  end


end
