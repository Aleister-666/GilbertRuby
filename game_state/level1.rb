class Level1 < Chingu::GameState
  traits :viewport, :timer
  def initialize(options = {})
    super
    self.input = {e: :edit}
    @background = Image['paisaje.png']
    self.viewport.lag = 0
    self.viewport.game_area = [0, 0, 3000, 600]
    load_game_objects
    @gilbert = Gilbert.create(x: 50, y: 300)
    @contador = 0
    @marcador = Chingu::Text.create(@contador, x: 5, y: 5, size: 25)
  end

  def edit
    push_game_state(Chingu::GameStates::Edit.new(except: [Gilbert]))
  end

  def draw
    super
    @background.draw(0, 0, 0)
  end

  def update
    super
    self.viewport.center_around(@gilbert)
    @gilbert.each_collision(Moneda) do |gilbert, moneda|
      moneda.play_sound
      @contador += 1
      @marcador.text = @contador
      moneda.destroy
    end
  end
end

# class Red < Chingu::GameObject
#   traits :velocity, :timer, :collision_detection
#   def initialize(options = {})
#     super(options)
#     @red_Animation = {}
#     @red_Animation[:stop] = Animation.new(file: 'media/char.png', size: [72, 72], delay: 1000)
#     @red_Animation[:stop].frame_names = {derecha: 0..6, izquierda: 3..3}
#     @red_Animation[:run] = Animation.new(file: "media/char.png", size: [72, 70])
#     @red_Animation[:run].frame_names = {derecha: 4..7, izquierda: 0..3}
#     @current_animation = @red_Animation[:run]
#     self.input = {holding_left: :izquierda, holding_right: :derecha}
#     @direccion = :derecha
#     self.scale = 1
#   end
#
#   def derecha
#     @x += 4
#     @current_animation = @red_Animation[:run][:derecha]
#     @direccion = :derecha
#     puts @x
#   end
#
#   def izquierda
#     @x -= 4
#     @current_animation = @red_Animation[:run][:izquierda]
#     @direccion = :izquierda
#   end
#
#   def update
#     @image = @current_animation.next!
#     @current_animation = @red_Animation[:stop][@direccion] unless moved?
#   end
# end