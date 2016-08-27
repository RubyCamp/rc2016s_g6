require 'singleton'
require_relative 'Ginchaku'
require_relative 'map'
require_relative 'Obake'
require_relative 'Player'
require_relative 'Same'
require_relative 'Takara'
require_relative 'awa'
require_relative 'esa'
require_relative 'info_window'
require_relative 'Ship'

class Director
	TIME_LIMIT = 200
	GHOST_APPEAR_TIME = 1 * 60
	ESA_LIMIT = 5
	SAME = 5
	AWA = 4
	TAKARA = 15
	GINCHAKU = 3
	include Singleton
	attr_reader :map, :same, :player, :time_count, :esacount

	def initialize
		@new_flg = true
	end
	def new_all
		@ranges = []
		@red = Image.new(800, 600, [255, 0, 0])
		@start_time = Time.now
		@time_count = TIME_LIMIT
		@map = Map.new(MapSelect.instance.map)
		@render_target = RenderTarget.new(@map.width, @map.height)
		@info_window = InfoWindow.new(@time_count)
		@characters = []
		ship_new
		possible_new
		@takaras = []
	    TAKARA.times do |i|
			pos = setpos
			@takaras << Takara.new(pos[0], pos[1])
			x = @takaras[i].x
			y = @takaras[i].y
			img = @takaras[i].image
			@ranges << [x..(x + img.width), y..(y + img.height)]
		end
		@characters += @takaras
		@ginchakus = []
		GINCHAKU.times do |i|
			pos = setpos
			@ginchakus << Ginchaku.new(pos[0], pos[1])
			x = @ginchakus[i].x
			y = @ginchakus[i].y
			img = @ginchakus[i].image
			@ranges << [x..(x + img.width), y..(y + img.height)]
		end
		@characters += @ginchakus
		@awas = []
		AWA.times do |i|
			pos = setpos_ex(64, 64)
			@awas << Awa.new(pos[0], pos[1])
			x = @awas[i].x
			y = @awas[i].y
			img = @awas[i].image
			@ranges << [x..(x + img.width), y..(y + img.height)]
		end
		@characters += @awas
		@sames = []
		SAME.times do |i|
			pos = setpos_ex(92, 46, top_y: @map.height / 3)
			@sames << Same.new(pos[0], pos[1])
			x = @sames[i].x
			y = @sames[i].y
			img = @sames[i].image
			@ranges << [x..(x + img.width), y..(y + img.height)]
		end
		@characters += @sames
		ship_x = (@ship.x - 32)..(@ship.x + @ship.image.width + 32)
		ship_y = (@ship.y - 32)..(@ship.y + @ship.image.height + 32)
		begin
			pos = setpos_ex(61, 30, end_y: @map.height / 4)
		end while pos == [ship_x, ship_y]
		@player = Player.new(pos[0],pos[1])
		@characters << @player
		@characters.each do |char|
			char.target = @render_target
		end
		@esas = []
		@esacount = ESA_LIMIT
		@ghosts_pos_x = []
		@ghosts_pos_y = []
		@ghosts_count = []
		@ghosts = []
	end

	def play
		if @new_flg
			new_all
			@new_flg = false
		end
		count_down
		if Input.keyPush?(K_X)
			esa_new
		end
		Sprite.update(@characters)
		Sprite.check(@characters, @characters)
		takara_to_obake
		Sprite.clean(@characters)
		Sprite.clean(@takaras)
		@render_target.draw(0,0,@map.draw)
		Sprite.draw(@characters)
		window
		Window.draw(@window_x,@window_y,@render_target)
		@info_window.draw
		if game_over? || @ship.clear
			Scene.set_current_scene(:ending)
		end
		Window.draw_alpha(0, 0, @red, (Player::LIFE - @player.life) / 2)
	end

	def pos_limit?(x,y,image_width, image_height)
		x < 0 || x - image_width > @map.width || y < 0 || y - image_height > @map.height
	end

	def dxdy(size)
		d = size % 32
		if d == 0
			d = 1
		elsif d >= 2
			d = 2
		end
		d += size / 32
		return d
	end

	def setpos_ex(image_width, image_height, top_y: 0, end_y: @map.height - image_height)
		begin
			x = rand(@map.width - image_width)
			y = rand(top_y..end_y)
			redo if doubling?(@ranges, [x..(x + image_width), y..(y + image_height)])
			block = false
			dx = dxdy(image_width)
			dy = dxdy(image_height)
			(image_width / 32 + dx).times do |i|
				(image_height / 32 + dy).times do |j|
					if x / 32 + i > @map.map_x_size - 1 || y / 32 + j > @map.map_y_size - 1
						block = true
						next
					end
					if @map.block(x / 32 + i, y / 32 + j) != 0
						block = true
					end
				end
			end
		end while pos_limit?(x,y,image_width,image_height) || block
		return [x,y]
	end

	def doubling?(ranges, range)
		flg = false
		range_x = [range[0].first, range[0].end]
		range_y = [range[1].first, range[1].end]
		ranges.each do |s|
			2.times do |i|
				if s[0].cover?(range_x[i])
					2.times do |j|
						if s[1].cover?(range_y[j])
							flg = true
							break
						end
					end
				end
			end if flg
		end if flg
		return flg
	end

	private

	def count_down
		@time_count = TIME_LIMIT - (Time.now - @start_time).to_i
		@info_window.count = @time_count
	end

	def game_over?
		flg = false
		if @time_count <= 0 || @player.life <= 0 || @player.vanished?
			@time_count = 0
			flg = true
		end
		return flg
	end

	def setpos
		point = rand(@possible.length)
		x = @possible[point][0]
		y = @possible[point][1]
		d = dxdy(64)
		4.times do |i|
			4.times do |j|
				@possible.delete([x - 32 + i * 32, y - 32 + j * 32])
			end
		end
		return [x, y]
	end

	def ship_new
		pos = [-1, -1]
		@map.map_y_size.times do |y|
			if @map.block(0, y) == 3
				pos[1] = y
				break
			end
		end
		if pos[1] != -1
			begin
				x = rand((@map.map_x_size / 4)..((@map.map_x_size - 4) * 3 / 4))
				block = false
				3.times do |i|
					block = true if @map.block(x + i, pos[1] + 1) != 0
				end
				pos[0] = x unless block
			end while block
			pos[0] = pos[0] * 32
			pos[1] = pos[1] * 32 - 55
			@ship = Ship.new(pos[0], pos[1])
			@ship.target = @render_target
			@characters << @ship
		end
	end

	def possible_new
		@possible = Array.new { Array.new(3) }
		@map.map_x_size.times do |x|
			@map.map_y_size.times do |y|
				if x + 1 < @map.map_x_size && y - 2 >= 0 
					if @map.block(x, y) == 1
						if @map.block(x, y - 1) == 0 && @map.block(x + 1, y - 1) == 0
							if map.block(x, y - 2) == 0 && @map.block(x + 1, y - 2) == 0
								@possible << [x * 32, (y - 2) * 32]
							end
						end
					elsif @map.block(x - 1, y) == 1
						x -= 1
						if @map.block(x, y - 1) == 0 && @map.block(x + 1, y - 1) == 0
							if map.block(x, y - 2) == 0 && @map.block(x + 1, y - 2) == 0
								@possible << [x * 32, (y - 2) * 32]
							end
						end
					end
				end
			end
		end
	end

	def takara_to_obake
		@takaras.each do |takara|
			if takara.vanished?
				@ghosts_pos_x << takara.x
				@ghosts_pos_y << takara.y
				@ghosts_count << GHOST_APPEAR_TIME
			end
		end
		@ghosts_count.each_with_index do |count, i|
			@ghosts_count[i] -= 1 if count >= 0
			if count == 0
				x = @ghosts_pos_x[i]
				y = @ghosts_pos_y[i]
				@ghost = Ghost.new(x,y)
				@ghost.target = @render_target
				@ghosts << @ghost
				@characters << @ghost
			end
		end
	end

	def esa_new
		if @esacount > 0
			@esacount -= 1
			esa = Esa.new(@player.x, @player.y)
			esa.target = @render_target
			@esas << esa
			@characters << esa
		end
	end

	def window
		player_x = @player.x + @player.image.width / 2
		player_y = @player.y + @player.image.height / 2
		if player_x < Window.width / 2
			player_x = Window.width / 2
		elsif player_x > @map.width - Window.width / 2
			player_x = @map.width - Window.width / 2
		end
		if player_y < Window.height / 2
			player_y = Window.height / 2
		elsif player_y > @map.height - Window.height / 2
			player_y = @map.height - Window.height / 2
		end
		@window_x = Window.width / 2 - player_x
		@window_y = Window.height / 2 - player_y
	end
end
