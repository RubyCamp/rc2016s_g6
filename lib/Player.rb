class Player < Sprite
  attr_reader :life, :score

  def initialize(image = nil)
    image = Image.load("images/player.png")
    image.set_color_key(C_WHITE)
    @center_x = Window.width/2  - image.width/2
    @center_y = Window.height/2 - image.height/2
    super(@center_x, @center_y, image)
    @life = 100.0
    @score = 0
  end

  def update
    # @life -= 0.1 #時間経過でライフ減少
    return if @life <= 0
    # map = Director.instance.map
    dx = 0
    dy = -1                             #沈む
    dx = 3 if Input.key_down?(K_LEFT) #&& map.movable?(self.x, self.y-1)
    dx = -3 if Input.key_down?(K_RIGHT) #&& map.movable?(self.x, self.y+1)
    dy -= 3 if Input.key_down?(K_DOWN) #&& map.movable?(self.x+1, self.y)
    dy += 3 if Input.key_down?(K_UP) #&& map.movable?(self.x-1, self.y)
    move(dx, dy)
  end

  def move(dx,dy)
    if (Window.ox + Window.width/2 - self.image.width/2 > 0 || dx < 0) && (Window.ox - Window.width*3/2 + self.image.width/2 < 0 || dx > 0)
      Window.ox -= dx
      self.x = @center_x + Window.ox
    end
    if (Window.oy + Window.height/2 > 0 || dy < 0) && (Window.oy - Window.height*3/2  < 0 || dy > 0)
      Window.oy -= dy
      self.y = @center_y + Window.oy
    end
  end

  # 当たり判定
  def hit(obj)
    if obj.is_a?(Same) #サメにあたったとき
      @life -= 3
      if @life <= 0
        vanish
        return
      end
    end
    if obj.is_a?(Obake) #おばけにあたったとき
      @score -= 10
    end
    if obj.is_a?(Awa) #泡をとったとき
      life = 100.0
    end
    if obj.is_a?(Takara) #宝をとったとき
      @score += 100
    end
  end

  private

  def image_path(filename)
    return File.join(File.dirname(__FILE__), "..", "images", filename)
  end
end
