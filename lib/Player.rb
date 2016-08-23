class Player < Sprite
  attr_reader :life, :score

  def initialize(image = nil)
    image = Image.load("images/player.png") #image_path("player.png"))
    image.set_color_key(C_WHITE)
      @center_x = Window.width/2  - image.width/2
      @center_y = Window.height/2 - image.height/2
    super(@center_x, @center_y, image)
    @life = 3.0
    @score = 0
  end

  def update
    @life -= 0.01
    return if @life <= 0
    # map = Director.instance.map
    # dy = -1 if Input.key_push?(K_UP) && map.movable?(self.x, self.y-1)
    # dy = 1  if Input.key_push?(K_DOWN) && map.movable?(self.x, self.y+1)
    # dx = 1  if Input.key_push?(K_RIGHT) && map.movable?(self.x+1, self.y)
    # dx = -1 if Input.key_push?(K_LEFT) && map.movable?(self.x-1, self.y)
    dx = 3 if Input.key_down?(K_LEFT)
    dx = -3 if Input.key_down?(K_RIGHT)
    dy = -1
    dy -= 3 if Input.key_down?(K_DOWN)
    dy += 3 if Input.key_down?(K_UP)
    move(dx, dy)
  end

  def move(dx,dy)
    if dx
      Window.ox -= dx
      self.x = @center_x + Window.ox
    end
    if (Window.oy + Window.height/2 > 0 || dy < 0) && (Window.oy - Window.height*3/2 + self.image.height/2 < 0 || dy > 0)
      Window.oy -= dy
      self.y = @center_y + Window.oy
    end
  end

  # コインを取ったとき
  def shot(obj)
    @score += 1
  end

  # 敵に当たったとき
  def attacked(obj)
    @life -= 3
    if @life < 1
      vanish
      return
    end

  end

  private

  def image_path(filename)
    return File.join(File.dirname(__FILE__), "..", "images", filename)
  end
end
