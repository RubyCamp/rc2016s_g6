class Player < Sprite
  attr_reader :life, :score, :pos_x, :pos_y

  def initialize(image = nil)
    image = Image.load("images/player.png")
    image.set_color_key(C_WHITE)
    super(800/2 - image.width/2, 600/2 - image.height/2, image)
    @sounds = {}
    @sounds[:eat] = Sound.new("music/eat-meat1.wav")
    @sounds[:fear] = Sound.new("music/fear1.wav")
    @sounds[:poin] = Sound.new("music/touch1.wav")
    @sounds[:kira] = Sound.new("music/kira2.wav")
    @sounds[:dive] = Sound.new("music/splash-big1.wav")
    @sounds[:dive].play
    @life = 100
    @cnt = 0 #ライフを減少させるまでのカウント
    @score = 0
		@font = Font.new(48)
    @dx = 0
    @dy = 1 #沈む
    @pos_x = 0
    @pos_y = 0
  end

  def update
    self.life_decrease #時間経過でライフ減少
    vanish if @life <= 0
    map = Director.instance.map
    dx,dy,sp = @dx,@dy,2
    if Input.key_down?(K_C) # cダッシュ
      sp += 2
      @cnt += 2 #ライフ減少速度増加
    end
    (dx = -sp ;self.scale_x =  1 ) if Input.key_down?(K_LEFT) && self.movable?(map,:left,sp)
    (dx =  sp ;self.scale_x = -1 ) if Input.key_down?(K_RIGHT) && self.movable?(map,:right,sp)
    dy =  sp+1 if Input.key_down?(K_DOWN) && self.movable?(map,:down,sp+1)
    dy = 0     unless self.movable?(map,:g,1)
    dy = -sp+1 if Input.key_down?(K_UP) && self.movable?(map,:up,sp-1)

    #上に壁があるとき壁との距離分つめる
    dy = self.y%32 if Input.key_down?(K_UP) && !self.movable?(map,:up,dy)

    move(dx, dy)
  end

  def movable?(map,d,sp) #(Director.instance.map,d方向,spスピード)
    x,x_end = self.x , self.x+self.image.width
    y,y_end = self.y , self.y+self.image.height
    case d
      when :left  then return map.movable?(x-sp, y) && map.movable?(x-sp, y_end-1)
      when :right then return map.movable?(x_end+sp, y) && map.movable?(x_end+sp, y_end-1)
      when :down  then return map.movable?(x, y_end+sp) && map.movable?(x_end-sp, y_end-1)
      when :up    then return map.movable?(x, y-sp) && map.movable?(x_end, y-sp)
      when :g     then return map.movable?(x, y_end) && map.movable?(x_end, y_end)
    end
  end

  def move(dx,dy)
=begin
    if (dx < 0 || @x + Window.width/2 > 0) && ( dx > 0 || @x - Window.width*3/2 + self.image.width < 0)
      @pos_x -= dx
      self.x += Window.width/2
    end
    if (dy < 0 || @y + Window.height/2 > 0) && (dy > 0 || @y - Window.height*3/2  < 0)
      @pos_y -= dy
      self.y += Window.height/2
    end
=end
    @pos_x += dx
    @pos_y += dy
    self.x += dx
    self.y += dy
  end

  def life_decrease
    @cnt += 1
    if @cnt > 10
      @life -= 1
      @cnt = 0
    end
  end

  # 当たり判定
  def hit(obj)
    if obj.is_a?(Same) #サメにあたったとき
      @sounds[:eat].play
      vanish
    end
    if obj.is_a?(Ghost) #おばけにあたったとき
      @sounds[:fear].play
      @score -= 10
    else
      @sounds[:fear].stop
    end
    if obj.is_a?(Awa) #泡をとったとき
      @sounds[:poin].play
      @life = 100
    end
    if obj.is_a?(Takara) #宝をとったとき
      @sounds[:kira].play
      @score += rand(100..1000)
    end
  end

  private

  def image_path(filename)
    return File.join(File.dirname(__FILE__), "..", "images", filename)
  end
end
