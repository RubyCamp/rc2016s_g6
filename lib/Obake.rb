class Ghost < Sprite
  UPDATE_THRESHOLD = 600
  attr_accessor :dx, :dy
  def initialize(a, b)
    super
    self.image = Image.load("images/ghost2.png")
    self.image.set_color_key(C_WHITE)
    self.x, self.y = a, b
    self.dx, self.dy = 0.5, 0.5
    Sprite#cllision=[self.center_x,self.center_y,16]
    @count = 0
    @swi = 0
    @warp_d = 200
  end
  def update
    self.move
  end
  def move
	player = Director.instance.player
 	map = Director.instance.player

 		x = self.x - player.x
 		y = self.y - player.y

 		if x > 0
 			self.x -= self.dx
 		elsif x < 0
 			self.x += self.dx
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
    end
  end
end