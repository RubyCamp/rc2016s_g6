﻿require 'singleton'
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
	GHOST_APPEAR_TIME = 1.5 * 60
	ESA_LIMIT = 5
	SAME = 5
	AWA = 4
	TAKARA = 15
	include Singleton
	attr_reader :map, :same, :player, :time_count, :esacount

	def initialize
		@newflg = true
	end
	def newall
		@font = Font.new(25)
		@start_time = Time.now
		@time_count = TIME_LIMIT
		@map = Map.new(MapSelect.instance.map)
		@render_target = RenderTarget.new(@map.width, @map.height)
		@info_window = InfoWindow.new(@time_count)
		@characters = []
		pos = [-1, -1]
		@map.map_x_size.times do |x|
			@map.map_y_size.times do |y|
				if @map.block(x, y) == 6
					pos = [x * 32, y * 32 - 55]
					break
				end
			end
			if pos != [-1, -1]
				break
			end
		end
		if pos != [-1, -1]
			@ship = Ship.new(pos[0], pos[1])
			@ship.target = @render_target
			@characters << @ship
		end
		@takaras = []
		@possible = Array.new { Array.new(3) }
		0.step(@map.map_x_size, 2) do |x|
			(@map.map_y_size - 1).times do |y|
				if @map.block(x, y) == 1
					if @map.block(x, y - 1) == 0
						@possible << [0, x * 32, (y - 2) * 32]
					end
				end
			end
		end
	    TAKARA.times do
			pos = setpos
			@takaras << Takara.new(pos[0], pos[1])
		end
		@characters += @takaras
		@enemies = []
		@objects = []
		@ghosts_pos_x = []
		@ghosts_pos_y = []
		@ghosts_count = []
		@ghosts = []
		pos = setpos
		@objects << Ginchaku.new(pos[0], pos[1])
		AWA.times do
			pos = setpos_ex(64, 64)
			@objects << Awa.new(pos[0], pos[1])
		end
		@characters += @objects
		SAME.times do
			pos = setpos_ex(92, 46)
			redo if pos[1] < Window.height * 3 / 4
			@enemies << Same.new(pos[0], pos[1])
		end
		@characters += @enemies
		@player = Player.new
		@characters << @player
		@characters.each do |char|
			char.target = @render_target
		end
		@esas = []
		@esacount = ESA_LIMIT

		@red = Image.new(800, 600, [255, 0, 0])
	end

	def play
		if @newflg
			newall
			@newflg = false
		end
		count_down
		if Input.keyPush?(K_X)
			if @esacount > 0
				@esacount -= 1
				esa = Esa.new(@player.x, @player.y)
				esa.target = @render_target
				@esas << esa
				@objects << esa
				@characters << esa
			end
		end
		Sprite.update(@characters)
		Sprite.check(@characters, @characters)
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
				@enemies << @ghost
				@characters << @ghost
			end
		end
		Sprite.clean(@characters)
		Sprite.clean(@takaras)
		@render_target.draw(0,0,@map.draw)
		Sprite.draw(@characters)
		Window.draw(-@player.pos_x,-@player.pos_y,@render_target)
		@info_window.draw
#		Window.draw_font(10, 550,"#{Window.real_fps}",@font)
		if game_over? || @ship.clear
			Scene.set_current_scene(:ending)
		end


		Window.draw_alpha(0, 0, @red, (Player::LIFE - @player.life) / (Player::LIFE / 2))
	end

	def pos_limit?(x,y,image_width, image_height)
		x < 0 || x - image_width > @map.width || y < 0 || y - image_height > @map.height
	end

	def setpos_ex(image_width, image_height)
		begin
			x = rand(@map.width)
			y = rand(@map.height)
			block = false
			4.times do |i|
				3.times do |j|
					if x + i * 32 < 0 || x + i * 32 > @map.width || y + j * 32 < 0 || y + j * 32 > @map.height
						block = true
    				elsif @map.block(x / 32 + i, y / 32 + j) != 0
						block = true
					end
				end
			end
		end while pos_limit?(x,y,image_width,image_height) || block
		return [x,y]
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
		begin
			point = rand(@possible.length)
		end while @possible[point][0] == 1
		@possible[point][0] = 1
		x = @possible[point][1]
		y = @possible[point][2]
		return [x, y]
	end
end
