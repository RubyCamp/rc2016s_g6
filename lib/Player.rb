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
		@font = Font.new(48)
    @dx = 0
    @dy = -1 #沈む
  end

  def update
    # @life -= 0.1 #時間経過でライフ減少
    return if @life <= 0
    map = Director.instance.map
    dx,dy,sp = @dx,@dy,10
    dx =  sp   if Input.key_down?(K_LEFT) && self.movable?(map,:left,sp)
    dx = -sp   if Input.key_down?(K_RIGHT) && self.movable?(map,:right,sp)
    dy = -sp-1 if Input.key_down?(K_DOWN) && self.movable?(map,:down,sp)
    dy = 0     unless self.movable?(map,:g,1)
    dy = sp-1 if Input.key_down?(K_UP) && self.movable?(map,:up,sp)
    Window.draw_font(self.x-Window.width/3, self.y-Window.height/3, "life: #{@life.to_i}", @font, {z:255})
    Window.draw_font(self.x+Window.width/3, self.y-Window.height/3, "score: #{@score}", @font, {z:255})

    move(dx, dy)
  end

  def movable?(map,d,sp) #(Director.instance.map,d方向,spスピード)
    x,x_end = self.x, self.x+self.image.width
    y,y_end = self.y, self.y+self.image.height
    case d
      when :left  then return map.movable?(x-sp, y) && map.movable?(x-sp, y_end-1)
      when :right then return map.movable?(x_end+sp, y) && map.movable?(x_end+sp, y_end-1)
      when :down  then return map.movable?(x, y_end+sp) && map.movable?(x_end-sp, y_end-1)
      when :up    then return map.movable?(x, y-sp) && map.movable?(x_end, y-sp)
      when :g     then return map.movable?(x, y_end) && map.movable?(x_end, y_end)
    end
  end

  def move(dx,dy)
    if (dx < 0 || Window.ox + Window.width/2 - self.image.width > 0) && ( dx > 0 || Window.ox - Window.width*3/2 + self.image.width < 0)
      Window.ox -= dx
      self.x = @center_x + Window.ox
    end
    if (dy < 0 || Window.oy + Window.height/2 > 0) && (dy > 0 || Window.oy - Window.height*3/2  < 0)
      Window.oy -= dy
      self.y = @center_y + Window.oy
    end
  end

  # 当たり判定
  def hit(obj)
    if obj.is_a?(Same) #サメにあたったとき
      vanish
    end
    if obj.is_a?(Ghost) #おばけにあたったとき
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
