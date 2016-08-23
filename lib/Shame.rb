class Same < Sprite
	attr_reader :isFind_Player
	attr_reader :dx, :dy

	#サメの索敵範囲
	SEARCH_AREA_X = 32 * 6
	SEARCH_AREA_Y = 32 * 2

	#サメの移動範囲

	def image_path(filename)
  	return File.join(File.dirname(__FILE__), "..", "images", filename)
 	end

 	#x座標とY座標を引数として受け取る
 	def initialize(a, b)
 		image = Image.load(image_path("same.png"))
 		image.set_color_key(C_WHITE)
 		super
 		self.x, self.y = a, b
 		self.isFind_Player = false #プレイヤーを発見していない状態にする
 		self.dx, self.dy = 1, 1
 	end

 	def update
 		player = Director.instance.player
 		map = Director.instance.map

 		nx = self.x + self.center_x
 		ny = self.y + self.center_y
 		px = player.x + player.center_x
 		py = player.y + player.center_y

 		#プレイヤーを見つけていない場合は左右を往復する
 		unless self.isFind_Player
 			#プレイヤーが目の前にいたら発見状態にする
 			if dx > 0 #右を向いている場合
 				if (px - nx) < SEARCH_AREA_X && (py - ny).abs < SEARCH_AREA_Y
 					self.isFind_Player = true
	 			end
 			else
	 			if (px - nx) < -SEARCH_AREA_X && (py - ny).abs < SEARCH_AREA_Y
 					self.isFind_Player = true 				
 				end
 			end
 		else		#敵を発見した場合
 			#不完全
 			#サメは敵を見つけるとスピードを上げてプレイヤーを追いかける
 			self.dx *= 3
 			if Director.instance.map.WIDTH >= self.x + self.center_x * 2 ||
 				32 <= self.x + self.center_x
 				self.dx = -self.dx
 			end
 		end
 	end

