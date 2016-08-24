class Map
  # �}�b�v�`�b�v���̉摜�C���[�W
  CELL_IMAGES = Image.loadToArray(File.join(File.dirname(__FILE__), "..", "images", "map_chips.png"), 4, 4)

  # @map_data �̊e�v�f�̈Ӗ�
  FLOOR = 0
  WALL = 1

  def initialize(map_file)
    @map_data = []
    map_load(map_file)
  end

  # �}�b�v�S�̂̕`��
  def draw
    @map_x_size.times do |x|
      @map_y_size.times do |y|
        draw_cell(x, y)
      end
    end
  end

  # �C�ӂ̍��Wx, y �ɂ�����}�b�v�`�b�v�̎�ނ��擾
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

  # �}�b�v�f�[�^�̓ǂݍ���
  def map_load(map_file)
    open(map_file).each do |line|
      cols = line.chomp.split(/\s*,\s*/).map(&:to_i)
      @map_data << cols
      @map_x_size = cols.size unless @map_x_size
    end
    @map_y_size = @map_data.size
  end

  # �}�b�v��1�}�X�̕`��
  def draw_cell(x, y)
    image = CELL_IMAGES[self[x, y]]
    Window.draw(x * image.width, y * image.height, image)
  end


end
