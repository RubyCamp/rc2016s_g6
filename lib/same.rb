class Same < Sprite
	attr_accessor :isFind_Player
	attr_accessor :dx, :dy
	attr_accessor :dash_dx, :dash_dy
	#サメの索敵範囲
	SEARCH_AREA_X = 32 * 6
	SEARCH_AREA_Y = 32 * 2

	#サメの向きtrueは左,falseは左
	attr_accessor :shark_direction



 	#サメを生成する座標値を引数として受け取る
 	def initialize(a, b)
 		self.image = Image.load("images/same.png")
 		self.image.set_color_key(C_WHITE)
 		super
 		self.x, self.y = a, b
 		self.isFind_Player = false #プレイヤーを発見していない状態にする
 		self.dx, self.dy = 1, 1
 		self.dash_dx, self.dash_dy = 3, 3
 		self.shark_direction = true	#最初は右向き
 	end

 	def update
 		#サメが移動する方向に合わせて画像を反転させる
 		if dx > 0
 			self.shark_direction = false
 		else
			self.shark_direction = true 			
 		end

 		player = Director.instance.player
 		map = Director.instance.map

 		nx = self.x# + self.center_x
 		ny = self.y# + self.center_y
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
 			if map.width >= self.x + self.center_x * 2 ||
 				32 <= self.x + self.center_x
 				self.dx = -self.dx
 			end
 		end
 	end

 	#あたり判定
 	def hit(obj)
 		#もしイソギンチャクにぶつかったら向きを変えて逃げる
 		if obj.is_a?(Ginchaku)
 			self.dx = -self.dx
 		end


 	end

 	def move
 		player = Director.instance.player
 		map = Director.instance.player

 		x = self.x - player.x
 		y = self.y - palyer.y

 		if x > 0
 			self.x -= self.dash_dx if map.movable?(self.x - 1, self.y)
 		elsif x < 0
 			self.x += self.dash_dx if map.movable?(self.x + 1, self.y)
 		end

 		if y > 0
 			self.y -= self.dash_dy if map.movable?(self.x, self.y - 1)
 		elsif y < 0
 			self.y += self.dash_dy if map.movable?(self.x, self.y - 1)
 		end
 	end
end