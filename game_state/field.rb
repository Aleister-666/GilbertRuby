class Field < Chingu::GameState
  traits :viewport, :timer
  def initialize(options = {})
    super(options)
    @background = Image['paisaje.png']
    # @music = Song.new('media/Puella.mp3')
    # @music.play()
    # @moneda = Moneda.create(x: $window.width / 2, y: 534)
    # @red = Red.create(x: 40, y: $window.height - 100)

    @piso = Suelo.create(x: $window.width / 2, y: 600)
    Suelo.create(x: $window.width / 2 + 400, y: 500, corta: true)

    @gilbert = Gilbert.create(x: 40, y: 534)
    coin_position = $window.width / 2
    10.times do Moneda.create(x: coin_position, y: 534); coin_position += 50; end

    self.input = {escape: :exit}
  end
  
  def update
    super
    @gilbert.each_collision(Suelo) do |gilbert, suelo|
      gilbert.velocity_y = 0
      gilbert.acceleration_y = 0
      gilbert.subiendo = false
    end

    @gilbert.each_collision(Moneda) do |gilbert, moneda|
      collect_coin = Song.new("media/mario-coin.mp3").play
      moneda.destroy
    end
  end

  def draw
    super
    @background.draw(0, 0, 0)
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