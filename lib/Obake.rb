class Ghost < Sprite
  UPDATE_THRESHOLD = 600
  DX = 1.5
  DY = 1.5
  attr_accessor :dx, :dy
  attr_accessor :image_num
  attr_accessor :ghost_direction_flag
  @@images = []
  def initialize(a, b)
    super
    @@images << Image.load("images/ghost2.png")
    @@images << Image.load("images/ghost3.png")
    @@images << Image.load("images/ghost4.png")
    self.image = @@images[0]
    self.image.set_color_key(C_WHITE)
    @@images[1].set_color_key(C_WHITE)
    @@images[2].set_color_key(C_WHITE)
    self.x, self.y = a, b
    self.dx, self.dy = DX, DY
    @count = 0
    @swi = 0
    @warp_d = 200
    @toumei = 255
    self.ghost_direction_flag = true
    self.image_num = 0
  end
  def update
    self.image_num += 0.1
    self.image = @@images[self.image_num % 2]
    self.move
    self.direction
  end
  def move
    player = Director.instance.player
 	  map = Director.instance.player

    x = self.x - player.x
    y = self.y - player.y

    if x > 0
	self.x -= self.dx
	self.ghost_direction_flag = true
    elsif x < 0
	self.x += self.dx
	self.ghost_direction_flag = false
    end

 	  if y > 0
      self.y -= self.dy
 	  elsif y < 0
      self.y += self.dy
 	  end
    @count += 1
    if @count > UPDATE_THRESHOLD 
      @count = 0
    end

    if @count == 0
      swi = rand(3)
      if swi == 0
        self.x = player.x + rand(-150)-@warp_d
        self.y = player.y + rand(150)+@warp_d
       elsif swi == 1
        self.x = player.x + rand(150)+@warp_d
        self.y = player.y + rand(-150)-@warp_d
      elsif swi == 2
        self.x = player.x + rand(-150)-@warp_d
        self.y = player.y + rand(-150)-@warp_d
      elsif swi == 3
        self.x = player.x + rand(150)+@warp_d
        self.y = player.y + rand(150)+@warp_d
      end
    end
  end

  def hit(obj)
    if obj.is_a?(Player)

      self.dx, self.dy = 0.4, 0.4
      self.image = @@images[2]
     else
	self.dx, self.dy = 0.8, 0.8
    end
  end

  def direction
  	if self.ghost_direction_flag
  		#フラグが右でかつ向きが変わっていなければ向きを変更する
  			self.scale_x = 1
  	else
  			self.scale_x = -1
  	end
  end
end