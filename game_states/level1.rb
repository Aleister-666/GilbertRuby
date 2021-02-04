  # El primer nivel del juego, consiste en saltar y saltar plataformas cojiendo monedas.
  # Despues de alcanzado el puntaje suficiente aparece un boton para ir al siguiente nivel
class Level1 < Chingu::GameState
  attr_reader :music, :sonido

  traits :viewport, :timer

  GAME_OBJECTS = [Base, Moneda, Plataforma, Plataforma2, Meta].freeze
  PLATAFORMAS = [Base, Plataforma, Plataforma2].freeze

  def initialize(**options)
    super
    @player_name = options[:player_name].capitalize
    @sonido = options[:sonido]
    @difficulty = options[:difficulty]

    # self.input = {e: :edit}
    self.input = { w: :cheats }
  end

  # Metodo para establecer por default el estado del juego,
  # se usa para la carga previa del nivel
  def setup
    super
    @background = Image['Bg level1.png']
    viewport.lag = 0
    viewport.game_area = [0, 0, 3000, 1000]
    @gilbert = Gilbert.create(x: 50, y: 900, limited: viewport.game_area.width)
    @level = File.join(ROOT, 'levels', self.filename + '.yml')
    load_game_objects(file: @level)

    @plataformas = Plataforma2.all
    @music = Song.new('media/Songs/Music Level1.mp3')
    @loser_song = Song.new('media/Songs/gameover.ogg')

    @moneda = Moneda.all.first

    @meta_on = false

    @marco_name = Image['MarcoName.png']
    @marco_score = Image['MarcoPoint.png']

    @score = 0
    @msj_name = Chingu::Text.new(@player_name, x: 85, y: 25, size: 30, color: Gosu::Color::WHITE)
    @msj_score = Chingu::Text.new(@score.to_s, x: $window.width - 130, y: 30, size: 35)
    @mensaje = Chingu::Text.new('Has encontrado todas las monedas', x: 320, y: 20, size: 25, color: Gosu::Color::GREEN)
    @mensaje2 = Chingu::Text.new('Encuentra la Meta', x: @msj_name.x, y: 45, size: 30, color: Gosu::Color::YELLOW)

    @music.play(true) if @sonido
  end


  # def edit
  #   push_game_state(Chingu::GameStates::Edit.new(except: [Gilbert,
  #                                                         PulsatingText,
  #                                                         BaseLv3,
  #                                                         PlataformaMLv3,
  #                                                         PlataformaSLv3]))
  # end

  def draw
    @background.draw(0, -200, 0)
    @marco_name.draw(0, 0, 0)
    @marco_score.draw($window.width - 170, 0, 0)
    super
    @msj_name.draw
    @msj_score.draw

    # condiciones para que aparesca o no la meta del nivel
    if @score == 15
      create_meta(ramdon_location) unless @meta_on
      Plataforma2.all.select do |e|
        e.x == @plataforma_meta.x && e.y == @plataforma_meta.y
      end.first.destroy unless @meta_on
      
      @meta_on = true
      @msj_name.y = 15
      @mensaje.draw
      @mensaje2.draw
    end
  end

  def update
    super
    $window.caption = "Gilbert Ruby\tFPS:#{fps}"
    # $window.caption = "Gilbert Ruby\tFPS:#{fps}\t Objects: #{current_game_state.game_objects.size}"

    @music.volume = 0.3
    @msj_score.text = "#{@score}"
    viewport.center_around(@gilbert)

    @gilbert.each_collision(Moneda) do |_gilbert, moneda|
      moneda.play_sound
      @score += 1
      move_coin(ramdon_location)
    end

    if @meta_on
      Moneda.destroy_all
      @gilbert.each_collision(Meta) do |gilbert, meta|
  	    win if gilbert.x <= meta.bb.center[0] && gilbert.y == meta.bb.top
      end
    end
    
    # Se establece en cuanto tiempo se desaparecen las plataformas dependiendo de la dificultad
    # especificada en la creacion del objeto
    @gilbert.each_collision(*PLATAFORMAS) do |gilbert, superficie|
      case @difficulty
      when 'NORMAL'
        after(1500){}.then{superficie.hide!} unless superficie.bb.left.zero?
        after(2200){}.then{superficie.show!}
      when 'DIFICIL'
        after(700){}.then{superficie.hide!} unless superficie.bb.left.zero?
        after(1000){}.then{superficie.show!}
      when 'INSANE'
        after(450){}.then{superficie.hide!} unless superficie.bb.left.zero?
        after(1200){}.then{superficie.show!}
      end
    end

    if self.viewport.outside_game_area?(@gilbert)
      lose if @gilbert.y >= self.viewport.game_area.height
    end
  end

  private

  # Crea la meta y boton
  def create_meta(array)
    @plataforma_meta = Meta.create(x: array[0], y: array[1] + 45)
  end
  
  # Metodo que sirve para cambiar la posicion de la meta de forma "Aleatoria"
  def meta_random_location(array)
    @plataforma_meta.x = array[0]
    @plataforma_meta.y = array[1] + 45
  end

  # Metodo para retornar una posicion aleatoria en base a las ubicaciones
  # en este metodo la ubicacion o cordenada y es reducida en 45 que significa
  # que las cordenadas devueltas estaras en el pasicion x de la plataforma y 
  # 45 menos con respecto en y. ESTE METODO FUE MAS PENSADO PARA LA UBICACION DE LAS MONEDAS.
  def ramdon_location
    seleccion = @plataformas[rand(@plataformas.length)]
    ubicacion_x = seleccion.x
    ubicacion_y = seleccion.y - 45
    [ubicacion_x, ubicacion_y]
  end

  # Crea un objeto de la clase Moneda
  def move_coin(array)
    @moneda.x = array[0]
    @moneda.y = array[1]
  end

  # Metodo que especifica que hacer cuando el jugador pierde
  def lose
    @music.pause if @sonido
    @loser_song.volume = 0.6
    @loser_song.play if @sonido

    GAME_OBJECTS.each(&:destroy_all)
    pop_game_state
    push_game_state(Puntajes.new(player_name: @player_name, score: @score, difficulty: @difficulty, sonido: @sonido))
  end

  # Metodo a ejecutar cuando el jugador gana o cumple un requisito para ganar
  def win
    @music.stop if @sonido
    
    GAME_OBJECTS.each(&:destroy_all)
    pop_game_state
    push_game_state(Level2.new(player_name: @player_name, score: @score, sonido: @sonido, difficulty: @difficulty))
  end

  # Especificaciones de cheats o trucos para el juego
  def cheats
    win if @gilbert.x > 2995 && @gilbert.y == 846.5
  end

end
