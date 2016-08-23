require_relative 'title/director'
require_relative 'play/director'
require_relative 'ending/director'

Scene.add_scene(Title::Director.new, :title)
Scene.add_scene(Play::Director.new, :play)
Scene.add_scene(Ending::Director.new, :ending)
