class Ghost < Sprite
  attr_accessor :dx, :dy
  def initialize(a, b)
    super
    self.image = Image.load("images/ghost2.png")
    self.image.set_color_key(C_WHITE)
    self.x, self.y = a, b
    self.dx, self.dy = 0.5, 0.5
    Sprite#cllision=[self.center_x,self.center_y,16]
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
  end
  def hit(obj)
    if obj.is_a?(Player)
    end
  end
end