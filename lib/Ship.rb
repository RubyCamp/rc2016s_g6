class Ship < Sprite

	attr_reader :clear

	def initialize(a, b)
		super
		self.x, self.y = a, b
		self.image = Image.load("images/hune.png")
		self.image.set_color_key(C_WHITE)
		@clear = false
		self.scale_x = 1.5
		self.scale_y = 1.5
		self.collision = [-1, 0, self.image.width + 1, self.image.height + 5]
	end

	def hit(obj)
		if obj.is_a?(Player)
			@clear = true
		end
	end

end
