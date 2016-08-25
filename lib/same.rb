class Same < Sprite
	attr_accessor :isFind_Player
	attr_accessor :dx, :dy
	attr_accessor :dash_dx, :dash_dy

	SEARCH_AREA_X = 32 * 5
	SEARCH_AREA_Y = 32 * 2

	#今表示しているサメの画像
	attr_accessor :image_num

	#サメの向きtrueは右,falseは左
	#flagの値を変更したら向きが変わる
	attr_accessor :shark_direction_flag
	#サメの実際の向き
	attr_accessor :shark_direction

	#サメが生成されたときの初期値
	attr_accessor :init_x, :init_y

	@@images = []
 	#サメを生成する座標値を引数として受け取る
 	def initialize(a, b)
 		super(a, b)
 		@@images << Image.load("images/same.png")
 		@@images << Image.load("images/same_open.png")
 		self.image = @@images[0]
 		self.image.set_color_key(C_WHITE)
 		@@images[1].set_color_key(C_WHITE)
 		self.isFind_Player = false #プレイヤーを発見していない状態にする
 		self.dx, self.dy = [1,-1].sample, 1 #最初の進行方向をランダム
 		self.dash_dx, self.dash_dy = 3, 3
 		self.shark_direction = true	#最初は右向き
 		self.collision = [0, 0, image.width, image.height]
 		self.init_x, self.init_y = a, b
 		self.image_num = 0
 		self.shark_direction = 0
		@count = 0
 		@stop_cnt = nil
 	end

 	def update
		unless @stop_cnt
  	player = Director.instance.player
 		map = Director.instance.map
 		#self.collision = [self.x, self.y, self.x + 64, self.y + 32]
 		#サメが移動する方向に合わせて画像を反転させる
 		if dx > 0
 			self.shark_direction_flag = true
 		else
			self.shark_direction_flag = false
 		end
 		self.image_num += 0.1
 		self.image = @@images[self.image_num % 2]


 		nx = self.x + self.image.width / 2
 		ny = self.y + self.image.width / 2
 		px = player.x + player.image.width / 2
 		py = player.y + player.image.height / 2

 		#プレイヤーを見つけていない場合は左右を往復する
 		unless self.isFind_Player
 			#プレイヤーが目の前にいたら発見状態にする
 			if dx > 0 #右を向いている場合

 				if (px - nx) < SEARCH_AREA_X && (px - nx) > 0 && (py - ny).abs < SEARCH_AREA_Y
 					self.isFind_Player = true
	 			end
 			else	#左を向いている場合
	 			if (px - nx) > -SEARCH_AREA_X && (px - nx) < 0 && (py - ny).abs < SEARCH_AREA_Y
 					self.isFind_Player = true
 				end
 			end

 			self.x += self.dx
			unless self.movable?(map,:left,self.dx)
 				self.dx = self.dx.abs
 			end
			unless self.movable?(map,:right,self.dx)
				self.dx = -self.dx
			end
 		else		#敵を発見した場合
 			#サメは敵を見つけるとスピードを上げてプレイヤーを追いかける
 			self.move
 		end

 		#サメの向きの変更を適用する
 		self.direction
		else
			@count+=1
			if @count > @stop_cnt
				@count = 0
				@stop_cnt = nil
			end
		end
 	end

 	#あたり判定
 	def hit(obj)
 		#もしイソギンチャクにぶつかったら向きを変えて逃げる
 		if obj.is_a?(Ginchaku)
 			self.x = self.init_x
 			self.y = self.init_y
 			self.isFind_Player = false
 		end

 		if obj.is_a?(Esa)
 			self.isFind_Player = false
 			@stop_cnt = 30
 		end
 	end

 	def move
 		player = Director.instance.player
 		map = Director.instance.map

 		x = self.x - player.x
 		y = self.y - player.y

 		if x > 0 && self.movable?(map, :left, self.dash_dx)
 			self.x -= self.dash_dx #if map.movable?(self.x - self.dash_dx, self.y)
 			self.shark_direction_flag = false
 		elsif x <= 0 && self.movable?(map, :right, self.dash_dx)
 			self.x += self.dash_dx #if map.movable?(self.x + self.image.width + self.dash_dx, self.y)
 			self.shark_direction_flag = true
 		end

 		if y > 0 && self.movable?(map, :up, self.dash_dy)
 			self.y -= self.dash_dy #if map.movable?(self.x, self.y - self.dash_dy)
 		elsif y < 0 && self.movable?(map, :down, self.dash_dy)
 			self.y += self.dash_dy #if map.movable?(self.x, self.y + self.image.height + self.dash_dy)
 		end
 	end

  def movable?(map,d,sp) #(Director.instance.map,d方向,spスピード)
		x,x_mid,x_end = self.x ,self.x+self.image.width/2, self.x+self.image.width
    y,y_mid,y_end = self.y ,self.y+self.image.height/2, self.y+self.image.height
    case d
    when :left  then return map.movable?(x-sp, y)       && map.movable?(x-sp, y_end-1)      && map.movable?(x-sp, y_mid)
    when :right then return map.movable?(x_end+sp, y)   && map.movable?(x_end+sp, y_end-1)  && map.movable?(x_end+sp, y_mid)
    when :down  then return map.movable?(x, y_end+sp-1) && map.movable?(x_end, y_end+sp-1)  && map.movable?(x_mid, y_end+sp-1)
    when :up    then return map.movable?(x, y-sp)       && map.movable?(x_end, y-sp)        && map.movable?(x_mid, y-sp)
    when :g     then return map.movable?(x, y_end)      && map.movable?(x_end, y_end)       && map.movable?(x_mid, y_end)
    end
  end

  def direction
  	if self.shark_direction_flag
  		#フラグが右でかつ向きが変わっていなければ向きを変更する
  		if self.shark_direction == 1
  			self.shark_direction = 0
  			self.scale_x = 1
  		end
  	else
  		if self.shark_direction == 0
  			self.shark_direction = 1
  			self.scale_x = -1
  		end
  	end
  end

end
