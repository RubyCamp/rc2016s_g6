#宝用のクラス特に
#動作はない
class Takara < Sprite
=begin
	#宝が当たってからカウント開始（-1で初期化する)
	#-1の時は
	attr_accessor :cnt

	#お化けが出現するか否か
	attr_accessor :isAppear

	#お化けが出現する時間[秒]
	OBAKE_APPEAR_TIME = 3

	#えさを生成する座標が引数
=end
	def initialize(a, b)
		super
		self.image = Image.load(image_path("takara.png"))
		self.image.set_color_key(C_WHITE)
		self.x, self.y = a, b
#		self.isAppear = false
#		self.cnt = -1
#		self.collision = [0, 0, image.width, image.height]
	end

	def image_path(filename)
  		return File.join(File.dirname(__FILE__), "..", "images", filename)
 	end

 	def hit(obj)
 		if obj.is_a?(Player)
 			self.vanish
# 			self.visible = false
# 			self.cnt = Window.fps * OBAKE_APPEAR_TIME
 		end
 	end
=begin
 	def update
 		if @cnt > 0
 			@cnt -= 1
 		end

 		#このときインスタンス事態は消えていない
 		if self.cnt == 0
			self.isAppear = false
 		end
 	end
=end
end