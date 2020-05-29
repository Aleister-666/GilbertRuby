require 'gosu'
require 'chingu'
include Gosu
include Chingu

class PulsatingText < Text
  traits :timer, :effect
  
  def initialize(text, options = {})
    super(text, options)
    
    options = text  if text.is_a? Hash
    @pulse = options[:pulse] || false
    self.rotation_center(:center_center)
    every(20) { create_pulse }   if @pulse == false
  end
  
  def create_pulse
    pulse = PulsatingText.create(@text, x: @x, y: @y, height: @height, pulse:true, image: @image, zorder: @zorder+1)
    colors = [Color::RED, Color::GREEN, Color::BLUE]
    pulse.color = colors[rand(colors.size)].dup
    pulse.mode = :additive
    pulse.alpha -= 150
    pulse.scale_rate = 0.002
    pulse.fade_rate = -3 + rand(2)
    pulse.rotation_rate = rand(2) == 0 ? 0.05 : -0.05
  end
    
  def update
    destroy if self.alpha == 0
  end
end

class Base < Chingu::GameObject
  traits :collision_detection, :bounding_box
  def setup
    @image = Image['base.png']
  end
end

class Plataforma < Chingu::GameObject
  traits :collision_detection, :bounding_box
  def setup
    @image = Image['base corta.png']
  end
end

class Plataforma2 < Chingu::GameObject
    traits :collision_detection, :bounding_box
    def setup
      @image = Image['base corta.png']
      self.width = 64
    end
end

class Moneda < Chingu::GameObject
  trait :bounding_circle, debug: false
  traits :collision_detection
  def setup
    @animation = Animation.new(file: "media/Moneda.png")
    @image = @animation.next
    @collect_coin = Sample.new("media/Songs/mario-coin.mp3")
    self.scale = 0.5
    cache_bounding_circle
  end

  def update
    @image = @animation.next
  end

  def play_sound
    @collect_coin.play
  end
end

class Gilbert < Chingu::GameObject
  trait :bounding_box, debug: false, scale: 0.5
  traits :velocity, :timer, :collision_detection
  attr_accessor :jumping
  attr_reader :last_x, :last_y
  def initialize(options)
    super
    self.input = {holding_left: :izquierda, holding_right: :derecha, [:space, :holding_up] => :arriba, z: :corriendo, released_z: :no_corriendo}
    @gilbertAnimations = {}
    @gilbertAnimations[:run_right] = Animation.new(file: 'media/Gilbert_animacion_derecha2.png', size: [66, 103])
    @gilbertAnimations[:run_right].frame_names = {stand_right: 15..15}
    @gilbertAnimations[:run_left] = Animation.new(file: 'media/Gilbert_animacion_izquierda2.png', size: [66,103])
    @gilbertAnimations[:run_left].frame_names = {stand_left: 15..15}
    @animation = @gilbertAnimations[:run_right][:stand_right]
    @song_salto = Sample.new("media/Songs/jump.wav")
    @direcction = :stand_right
    @orientation = :run_right
    @jumping = false
    @corriendo = false
    @speed = 3

    self.scale = 0.9
    self.acceleration_y = 0.5
    self.max_velocity = 15
    self.rotation_center = :bottom_center #Lo que hace que no se caiga. Super importante. Mega iMPORTANTE

    update
    cache_bounding_box
  end

  def izquierda
    move(-@speed, 0)
    @animation = @gilbertAnimations[:run_left]
    @orientation = :run_left
    @direcction = :stand_left
  end
  def derecha
    move(@speed, 0)
    @animation = @gilbertAnimations[:run_right]
    @orientation = :run_right
    @direcction = :stand_right
  end
  def arriba
    return if @jumping
    @song_salto.play
    @jumping = true
    @corriendo ? self.velocity_y = -13 : self.velocity_y = -10
  end

  def corriendo
    @speed = 5
    @corriendo = true
  end

  def no_corriendo
    @speed = 3
    @corriendo = false
  end

#Este metodo es la base primordial de todo
  def move(x,y)
    self.x += x
    self.each_collision(Base, Plataforma) do |gilbert, superficie|
      self.x = previous_x
      break
    end
    self.y += y
  end

  def update
    @image = @animation.next!
    if @x <= 0
      @x = @last_x
      @y = @last_y
    elsif @x >= 3000
        @x = @last_x
        @y = @last_y
    end
    
    #Esto es Gloria :'''v
    self.each_collision(Base, Plataforma, Plataforma2) do |gilbert, superficie|
      if self.velocity_y < 0
        gilbert.y = superficie.bb.bottom + gilbert.image.height * self.factor_y
        self.velocity_y = 0
      else
        superficie.visible ? @jumping = false : @jumping = true
        #@jumping = false
        gilbert.y = superficie.bb.top - 1 if superficie.visible?
      end
      if collidable
        after(1500){superficie.hide!}
        after(2200){superficie.show!}
      end
    end

    @animation = @gilbertAnimations[@orientation][@direcction] unless moved?
    @last_x, @last_y = @x, @y
  end
end

class Intro < Chingu::GameState
  def initialize
    super
    Chingu::Text.create("Gilbert Ruby", x:320, y: 0, size: 50, color: Gosu::Color::RED)
    inputs = <<~INPUT 
    Bienvenidos al GIlbert Ruby, tu Objetivo sera agarrar el mayor numero de monedas posibles.
    Tu puntaje sera guardado al perder. PERO SOLO LOS MAYORES PUNTAJES.
    Mover-Derecha: Flecha-Derecha. Mover-Izquierda: Flecha-Izquierda.
    Saltar: Flecha-Arriba, Spacio.
    Correr: Z.
    Escape: Salir del juego en cualquier momento. EL PUNTAJE NO SERA GUARDADO
    INPUT
    Chingu::Text.create(inputs, x: 0, y: 50, size: 30, color: Gosu::Color::GRAY, align: :center, max_width: $window.width)

    Chingu::Text.create("Master Developer---> Junior Rengifo", x: 150, y: 350, size: 40, color: Gosu::Color::FUCHSIA)
    Chingu::Text.create("Desing Gilbert And Level---> Duglas Montoya", x: 145, y: 400, size: 40, color: Gosu::Color::BLUE)
    Chingu::Text.create("Presiona Enter para comenzar", x: 150, y: $window.height - 100, size: 50, color: Gosu::Color::RED)
    self.input = {return: :enter_name_window}
  end

  def enter_name_window
    #push_game_state(EnterName)
    push_game_state(Chingu::GameStates::EnterName.new(callback: method(:enter_name)))
  end

  def enter_name(name)
    return @player_name = "Anonymus" if name.empty?
    @player_name = name
  end

  def player_name
    return @player_name
  end

  def update
    super
    if  @player_name
      push_game_state(Level1, setup: false)
    end
  end
end

class Level1 < Chingu::GameState
  traits :viewport, :timer
  GAME_OBJECTS = [Base, Moneda, Plataforma, Plataforma2]
  def initialize
    super
    @player_name = previous_game_state().player_name.capitalize

    #self.input = {e: :edit}
    @background = Image['paisaje.png']
    self.viewport.lag = 0
    self.viewport.game_area = [0, 0, 3000, 1000]
    load_game_objects
    @sonido = Song.new("media/Songs/SoundTrack.mp3")
    @loser_song = Song.new("media/Songs/gameover.ogg")
    play_song
    @gilbert = Gilbert.create(x: 50, y: 900)
    @contador = 0
    @marcador = Chingu::Text.new("#{@player_name}:  Puntaje: #{@contador}", x: 5, y: 5, size: 35, color: Gosu::Color::BLACK)
    @plataformas = Plataforma2.all
  end

  def lose
    play_song(nil)
    @loser_song.play
    @gilbert.x = 50
    @gilbert.y = 900
    GAME_OBJECTS.each(&:destroy_all)
    load_game_objects
    push_game_state(Puntajes.new(player: @player_name, score: @contador))
    @contador = 0
  end

  def ramdon_location
    seleccion = @plataformas[rand(@plataformas.length)]
    ubicacion_x = seleccion.x
    ubicacion_y = seleccion.y - 45
    return [ubicacion_x, ubicacion_y]
  end

  def create_coin(array)
    Moneda.create(x: array[0], y: array[1])
  end

  def play_song(play = true)
    case play
    when true
      @sonido.play(true)
    when false
      @sonido.pause
    when nil
      @sonido.stop
    end
  end

  # def edit
  #   push_game_state(Chingu::GameStates::Edit.new(except: [Gilbert, PulsatingText]))
  # end

  def draw
    super
    @background.draw(0, 0, 0)
    @marcador.draw()
  end

  def update
    super
    $window.caption = "Gilbert Ruby\tFPS:#{self.fps}"
    @marcador.text = "#{@player_name}:  Puntaje: #{@contador}"
    self.viewport.center_around(@gilbert)
    @gilbert.each_collision(Moneda) do |gilbert, moneda|
      moneda.play_sound
      @contador += 1
      moneda.destroy
      create_coin(ramdon_location)
    end

    if self.viewport.outside_game_area?(@gilbert)
      if @gilbert.y >= self.viewport.game_area.height
        @gilbert.y = self.viewport.game_area.height + 100
        lose
      end
    end
  end
end

class Lose < Chingu::GameState
    traits :viewport, :timer
    def initialize
        super
        @seg = 3
        msj = Chingu::Text.create("Has Perdido Pendejo. VUELVE A EMPEZAR", x: 150, y: 150, size: 30)
        msj2 = Chingu::Text.create(decrement, x: 150, y: 200, size: 30)
        after(800){@seg -= 1; msj2.text = decrement}
        after(1600){@seg -= 1; msj2.text = decrement}
        after(2400){game_states[2].play_song; pop_game_state; game_states[1].pop_game_state;}
    end

    def decrement
      return "Espera #{@seg} segundos para comenzar de nuevo"
    end

    def draw
        game_states[2].draw
        super
    end
end

class Puntajes < Chingu::GameState
  def initialize(options = {})
    super(options)
    self.input = {r: proc{push_game_state(Lose, setup: false)}, q: proc{exit}}
    Chingu::Text.create("R:Iniciar de Juego", x: 0, y: 5, size: 25, color: Gosu::Color::RED)
    Chingu::Text.create("Q:Cerrar Juego", x: $window.width - 150, y: 5, size: 25, color: Gosu::Color::RED)

    @marcador = HighScoreList.load(size: 9)
    @titulo = PulsatingText.create("PUNTAJES", x: $window.width/2, y: 50, size: 70)
    add(options[:player], options[:score])
  end

  def add(name, score)
    data = {:name => name, :score => score, :text => "Gilbert Ruby Puntajes"}
    position = @marcador.add(data)
    create_text
  end
  
  def create_text
    @marcador.each_with_index do |high_score, index|
      y = index * 25 + 100
      Text.create(high_score[:name], :x => @titulo.x - 300, :y => y, :size => 30)
      Text.create(high_score[:score], :x => @titulo.x, :y => y, :size => 30)
    end
  end
end


class Game < Chingu::Window
  def initialize
    super(900, 600, false)
    self.input = {escape: :exit}
    self.caption = "Gilbert Ruby"
    push_game_state(Intro)
  end
end

Game.new.show