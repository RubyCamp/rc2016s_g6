class Ghost < Sprite
  UPDATE_THRESHOLD = 5
    def initialize(x, y)
    image = Image.load(image_path("ghost.png"))
    image.set_color_key(C_BLACK)
    super(x , y, image)
    @count = 0
  end

  def update
    if @count < UPDATE_THRESHOLD
      @count += 1
      return
    end
    @count = 0

    move
  end

  def hit(obj)
    if obj.is_a?(player)
  end
  private

  def move
    map = Director.instance.map
    player = Director.instance.player
    tresure = Director.instance.takara
    start = [@x, @y]
    goal = [player.x, player.y]
    route = map.calc_route(start, goal)
    dest = route[1]
    if dest
      dx = dest[0]
      dy = dest[1]
    end
  end
 end