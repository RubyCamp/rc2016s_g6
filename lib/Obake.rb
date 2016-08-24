class Ghost < Sprite
  attr_accessor :dx, :dy
  def initialize(a, b)
    super
    image = Image.load("images/ghost.png")
    image.set_color_key(C_BLACK)
    self.x, self.y = a, b
    self.dx, self.dy = 1, 1
  end

  def update

  end

  def move
	player = Director.instance.player
 	map = Director.instance.player

 		x = self.x - player.x
 		y = self.y - palyer.y

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
    if obj.is_a?(player)
    end
  end
end