class Gilbert < Chingu::GameObject
  traits :velocity, :timer, :collision_detection, :bounding_box
  attr_accessor :subiendo
  def initialize(options)
    super
    @gilbertAnimations = {}
    @gilbertAnimations[:static] = Animation.new(file: 'media/Gilbert_Animacion.png', size: [85,100], delay: 100)
    @gilbertAnimations[:static].frame_names = {left: 5..5, right: 6..6}

    @gilbertAnimations[:run] = Animation.new(file: 'media/Gilbert_Animacion.png', size: [86, 100], delay: 100)
    @gilbertAnimations[:run].frame_names = {left: 0..5, right: 6..10}
    @animation = @gilbertAnimations[:static]
    @direcction = :right
    self.scale = 1
    self.input = {holding_left: :izquierda, holding_right: :derecha, holding_up: :arriba}
    @start_y = self.y
    @subiendo = false
  end

  def izquierda
    @x -= 3
    @animation = @gilbertAnimations[:run][:left]
    @direcction = :left
  end
  def derecha
    @x += 3
    @animation = @gilbertAnimations[:run][:right]
    @direcction = :right
  end
  def arriba
    return if @subiendo
    @subiendo = true
    self.velocity_y = -10
    self.acceleration_y = 0.5
  end
  def update
    @image = @animation.next!
    if outside_window?
      @x = @last_x
      @y = @last_y
    end
    @animation = @gilbertAnimations[:static][@direcction] unless moved?
    @last_x, @last_y = @x, @y
  end
end