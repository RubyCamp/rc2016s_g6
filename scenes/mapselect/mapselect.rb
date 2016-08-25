require 'singleton'
class MapSelect
	include Singleton
	attr_reader :map
	def initialize
		@font = Font.new(40)
		@fontsub = Font.new(30)
		@mapfiles = []
		dir = Dir.open("images") do |dir|
			dir.each do |name|
				if /^map.*\.dat$/ =~ name
					@mapfiles << name
				end
			end
		end
		@select = 0
		@mapfiles.length
#		@bg_imag = Image.load("images/??????.png")
	end

	def play
		if Input.keyPush?(K_RIGHT)
			@select += 1
		elsif Input.keyPush?(K_LEFT)
			@select -= 1
		end
		@select %= @mapfiles.length
		@prev = (@select + @mapfiles.length - 1) % @mapfiles.length
		@next = (@select + 1) % @mapfiles.length
		Window.draw_font(300, 230, "<-  map  ->", @font)
		Window.draw_font(300, 305, "#{@prev}", @fontsub)
		Window.draw_font(370, 300, "[#{@select}]", @font)
		Window.draw_font(470, 305, "#{@prev}", @fontsub)
#		Window.draw(0, 0, @bg_imag)
		if Input.keyPush?(K_SPACE)
			@map = "images/" << @mapfiles[@select].to_s
			Scene.set_current_scene(:play)
		end
	end
end
