class Level1 < Chingu::GameState
  attr_reader :music, :sonido

  traits :viewport, :timer

  GAME_OBJECTS = [Base, Moneda, Plataforma, Plataforma2, Boton, Meta].freeze

  def initialize(options = {})
    super
    @player_name = options[:player_name].capitalize
    @sonido = options[:sonido]

    # self.input = {e: :edit}
    self.input = {w: :cheats}
  end

  # Metodo para establecer por default el estado del juego,
  # se usa para la carga previa del nivel
  def setup
    super
    @background = Image['Level1Bg.png']
    self.viewport.lag = 0
    self.viewport.game_area = [0, 0, 3000, 1000]
    @gilbert = Gilbert.create(x: 50, y: 900, limited: self.viewport.game_area.width)

    # Habilita que al pisar una plataforma esta desaparesca
    @gilbert.solid = false

    @level = File.join(ROOT, "levels", self.filename + ".yml")
    load_game_objects(file: @level)

    @plataformas = Plataforma2.all
    @music = Song.new("media/Songs/Music Level1.mp3")
    @music.play(true) if @sonido
    @loser_song = Song.new("media/Songs/gameover.ogg")

    @moneda = Moneda.all.first

    @meta_on = false

    @marco_name = Image['MarcoName.png']
    @marco_score = Image['MarcoPoint.png']

    @score = 0
    @msjName = Chingu::Text.new("#{@player_name}", x: 85, y: 25, size: 30, color: Gosu::Color::WHITE)
    @msjScore = Chingu::Text.new("#{@score}", x: $window.width - 130, y: 30, size: 35)
    @mensaje = Chingu::Text.new("Has encontrado todas las monedas", x: 320, y: 20, size: 25, color: Gosu::Color::GREEN)
    @mensaje2 = Chingu::Text.new("Encuentra el Boton", x: @msjName.x, y: 45, size: 30, color: Gosu::Color::YELLOW)
  end

  # Metodo que especifica que hacer cuando el jugador pierde
  def lose
  	@music.pause if @sonido
    @loser_song.play if @sonido
    @gilbert.x = 50
    @gilbert.y = 900
    GAME_OBJECTS.each(&:destroy_all)
    load_game_objects(file: @level)
    push_game_state(Puntajes.new(player_name: @player_name, score: @score))
    @score = 0
    @moneda = Moneda.all.first
    @meta_on = false
  end

  def create_meta(array)
    @boton = Boton.create(x: array[0], y: array[1] + 18)
    @plataforma_meta = Meta.create(x: array[0], y: array[1] + 45)
  end

  # Metodo que sirve para cambiar la posicion de la meta de forma "Aleatoria"
  def meta_random_location(array)
    @boton.x, @boton.y = array[0], array[1] + 18
    @plataforma_meta.x, @plataforma_meta.y = array[0], array[1] + 45
  end

  # Metodo a ejecutar cuando el jugador gana o cumple un requisito para ganar
  def win
    meta_random_location(ramdon_location) if @meta_on
    GAME_OBJECTS.each(&:destroy_all)
    @music.pause
    push_game_state(Level2.new(player_name: @player_name, score: @score, sonido: @sonido))
    @score = 0
  end

  # Especificaciones de cheats o trucos para el juego
  def cheats
  	win if @gilbert.x >= 2995 && @gilbert.y == 845.5
  end

  # Metodo para retornar una posicion aleatoria en base a las ubicaciones
  # en este metodo la ubicacion o cordenada y es reducida en 45 que significa
  # que las cordenadas devueltas estaras en el pasicion x de la plataforma y 
  # 45 menos con respecto en y. ESTE METODO FUE MAS PENSADO PARA LA UBICACION DE LAS MONEDAS.
  def ramdon_location
    seleccion = @plataformas[rand(@plataformas.length)]
    ubicacion_x = seleccion.x
    ubicacion_y = seleccion.y - 45
    return [ubicacion_x, ubicacion_y]
  end

  # Crea un objeto de la clase Moneda
  def move_coin(array)
    @moneda.x = array[0]
    @moneda.y = array[1]
  end

  

  # def edit
  #   push_game_state(Chingu::GameStates::Edit.new(except: [Gilbert, PulsatingText, Boton, BaseLv2, PlataformaMLv2, PlataformaSLv2]))
  # end

  def draw
    @background.draw(0, 0, 0)
    @marco_name.draw(0, 0, 0)
    @marco_score.draw($window.width - 170, 0, 0)
    super
    @msjName.draw
    @msjScore.draw

    # condiciones para que aparesca o no la meta del nivel
    if @score == 15
      create_meta(ramdon_location) unless @meta_on
      @meta_on = true
      Plataforma2.all.select{ |e| e.x == @plataforma_meta.x && e.y == @plataforma_meta.y}[0].hide!
      @msjName.y = 15
      @mensaje.draw
      @mensaje2.draw
    end
  end

  def update
    super
    # $window.caption = "Gilbert Ruby\tFPS:#{self.fps}"
    $window.caption = "Gilbert Ruby\tFPS:#{fps}\t Objects: #{current_game_state.game_objects.size}"

    @msjScore.text = "#{@score}"
    self.viewport.center_around(@gilbert)

    @gilbert.each_collision(Moneda) do |_gilbert, moneda|
      moneda.play_sound
      @score += 1
      move_coin(ramdon_location)
    end

    if @meta_on
    	Moneda.destroy_all
      @gilbert.each_collision(Boton) do 
    		win
    	end
    end

    if self.viewport.outside_game_area?(@gilbert)
      if @gilbert.y >= self.viewport.game_area.height
        lose
      end
    end
  end
end
