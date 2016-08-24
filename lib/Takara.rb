#宝用のクラス特に
#動作はない
class Takara < Sprite

	#宝が当たってからカウント開始（-1で初期化する)
	#-1の時は
	attr_accessor :cnt
	private :cnt

	#お化けが出現するか否か
	attr_accessor :isAppear

	#お化けが出現する時間[秒]
	OBAKE_APPEAR_TIME = 3

	#えさを生成する座標が引数
	def initialize(a, b)
		super
		self.image = Image.load(image_path("takara.png"))
		self.x, self.y = a, b
		self.isAppear = false
	end

	def image_path(filename)
  		return File.join(File.dirname(__FILE__), "..", "images", filename)
 	end

 	def hit(obj)
		self.visible = false
 		if obj.is_a?(Player)
 			self.cnt = Window.fps * OBAKE_APPEAR_TIME
 		end
 	end

 	def update
 		if self.cnt > 0
 			self.cnt -= 1
 		end

 		#このときインスタンス事態は消えていない
 		if self.cnt == 0
			self.isAppear = false
 		end
 	end
end