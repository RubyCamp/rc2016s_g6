require 'dxruby'
require_relative 'scenes/scene'
require_relative 'scenes/load_scenes'


Window.width = 800
Window.height = 600
#Window.windowed = true #フルスクリーンモード
Scene.set_current_scene(:title)
Window.caption = "宍道湖"
Window.load_icon("images/icon.ico")

Window.loop do
	break if Input.keyPush?(K_ESCAPE)
	Scene.play_scene
end
