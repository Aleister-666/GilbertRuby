# Tercer nivel del juego consiste en conseguir monedas usando un Scanner.
# La modalidad es con tiempo, donde se debera de regresar a la "Estacion de recarga"
# para recuperar el tiempo
class Level3 < Chingu::GameState
  attr_reader :music

  traits :viewport, :timer
  GAME_OBJECTS = [Moneda,
                  MonedaPlata,
                  MonedaOro,
                  BaseLv3,
                  PlataformaMLv3,
                  PlataformaSLv3,
                  BaseSpecial,
                  RechargeStation,
                  Scaner,
                  Gilbert].freeze

  PLATAFORMAS = [BaseLv3, PlataformaMLv3, PlataformaSLv3, BaseSpecial].freeze

  def initialize(**options)
    super
    @player_name = options[:player_name].capitalize
    @score = options[:score]
    @sonido = options[:sonido]
    @difficulty = options[:difficulty]
    # self.input = {e: :edit}
  end

  def setup
    super
    @background = Image['Bg level3.png']
    viewport.lag = 0
    viewport.game_area = [0, 0, 1500, 2500]

    @level = File.join(ROOT, 'levels', self.filename + '.yml')
    load_game_objects(file: @level)

    @plataformas = PlataformaSLv3.all

    @music = Song.new('media/Songs/Music Level3.mp3')
    @loser_song = Song.new('media/Songs/gameover.ogg')
    @music.play(true) if @sonido

    @marco_name = Image['MarcoName.png']
    @marco_score = Image['MarcoPoint.png']

    @gilbert = Gilbert.create(x: RechargeStation.all.first.x,
                              y: RechargeStation.all.first.y,
                              limited: viewport.game_area.width)
    
    case @difficulty
    when 'INSANE'
      @life_time = 40
    when 'DIFICIL'
      @life_time = 70
    else
      @life_time = 150
    end

    @time = Chingu::Text.new("Oxigeno: #{@life_time}", x: 350, y: 15, size: 50)
    @danger = Chingu::Text.new('Regresa a la plataforma de recarga',
                                x: @time.x, y: @time.y + 50,
                                size: 20, color: Gosu::Color::YELLOW)
    
    PlataformaSLv3.create(x: 30, y: 850)

    3.times do |n|
      initial_position = ramdon_location
      @moneda_b = Moneda.create(x: initial_position[0], y: initial_position[1]) if n.zero?
      @moneda_p = MonedaPlata.create(x: initial_position[0], y: initial_position[1]) if n == 1
      @moneda_o = MonedaOro.create(x: initial_position[0], y: initial_position[1]) if n == 2
    end
    @moneda_p.hide!
    @moneda_o.hide!

    @msj_name = Chingu::Text.new(@player_name, x: 85, y: 25, size: 30, color: Gosu::Color::WHITE)
    @msj_score = Chingu::Text.new(@score, x: $window.width - 150, y: 30, size: 35)

    if @difficulty == 'NORMAL' || @difficulty == 'DIFICIL'
      @scaner_bronce = Scaner.create(metal: 'bronce', x: 0, y: 0)
      @scaner_plata = Scaner.create(metal: 'plata', x: 0, y: 0)
      @scaner_oro = Scaner.create(metal: 'oro', x: 0, y: 0)
      @scaner_plata.hide!
      @scaner_oro.hide!
    end

    @temp = 0
    @temp_p = 0
    @temp_o = 0
  end


  # def edit
  #   push_game_state(Chingu::GameStates::Edit.new(except: [Gilbert, PulsatingText,
  #                                                         Boton, Base,
  #                                                         Plataforma, Plataforma2,
  #                                                         Meta, Scaner]))
  # end

  def draw
    @background.draw(0, -200, 0)
    @marco_name.draw(0, 0, 0)
    @marco_score.draw($window.width - 170, 0, 0)
    @danger.draw if @life_time < 30
    super
    @time.draw

    @msj_name.draw
    @msj_score.draw
    if @difficulty == 'NORMAL' || @difficulty == 'DIFICIL'
      @scaner_bronce.x = @gilbert.x + 50
      @scaner_bronce.y = @gilbert.y - 140
  
      @moneda_p.visible? ? @scaner_plata.show! : @scaner_plata.hide!
      @scaner_plata.x = @scaner_bronce.x - 100
      @scaner_plata.y = @scaner_bronce.y
  
      @moneda_o.visible? ? @scaner_oro.show! : @scaner_oro.hide!
      @scaner_oro.x = @scaner_bronce.x + 100
      @scaner_oro.y = @scaner_bronce.y
    end

    # Numero de repeticiones para equivaler a segundos
    # 60 para 1 seg
    # 600 para 10 seg
    # 900 para 15 seg
    # 1500 para 25 seg
    # 2400 para 40 seg

    if @temp_p == 50
      @moneda_p.show!
      @temp_p = 0
    elsif @temp_o == 80
      @moneda_o.show!
      @temp_o = 0
    end

    if @moneda_p.visible? && @temp_p == 15
      @moneda_p.hide!
      move_position(ramdon_location, @moneda_p)
    end

    if @moneda_o.visible? && @temp_o == 10
      @moneda_o.hide!
      move_position(ramdon_location, @moneda_o)
    end
  end

  def update
    super
    $window.caption = "Gilbert Ruby\tFPS:#{fps}"
    # $window.caption = "Gilbert Ruby\tFPS:#{fps}\t Objects: #{current_game_state.game_objects.size}"
    @music.volume = 0.3
    viewport.center_around(@gilbert)

    # Conteo para el temporisador
    @temp += 1
    if @temp >= 60 && @temp < 70
      @life_time -= 1 unless hit_by(@gilbert, RechargeStation)
      @time.text = "Oxigeno: #{@life_time}"
      @temp = 0
      @temp_p += 1
      @temp_o += 1
    end

    # Colorea el temporisador para avisar al jugador.
    # Tambien le da Game Over en caso que se acabe el tiempo
    @msj_score.text = @score.to_s
    if @life_time.zero?
      lose
    elsif @life_time < 30
      @time.color = Gosu::Color::RED
    end

    @gilbert.each_collision(Moneda) do |_gilbert, moneda|
      moneda.play_sound
      @score += 1
      move_position(ramdon_location, @moneda_b)
    end

    # Se establece en cuanto tiempo se desaparecen las plataformas dependiendo de la dificultad
    # especificada en la creacion del objeto
    @gilbert.each_collision(*PLATAFORMAS) do |gilbert, superficie|
      case @difficulty
      when 'DIFICIL'
        after(700){}.then{superficie.hide!} unless superficie.class.to_s == 'BaseSpecial'
        after(1000){}.then{superficie.show!}
      when 'INSANE'
        after(450){}.then{superficie.hide!} unless superficie.class.to_s == 'BaseSpecial'
        after(1200){}.then{superficie.show!}
      end
    end

    if @moneda_p.visible?
      @gilbert.each_collision(MonedaPlata) do |_gilbert, moneda_p|
        moneda_p.play_sound
        @score += 5
        @temp_p = 0
        move_position(ramdon_location, @moneda_p)
        moneda_p.hide!
      end
    end

    if @moneda_o.visible?
      @gilbert.each_collision(MonedaOro) do |_gilbert, moneda_o|
        moneda_o.play_sound
        @score += 10
        @temp_o = 0
        move_position(ramdon_location, @moneda_o)
        moneda_o.hide!
      end
    end

    @gilbert.each_collision(RechargeStation) do |_gilbert, _recharge_station|
      @time.color = Gosu::Color::WHITE
      case @difficulty
      when 'NORMAL'
        @life_time = 150
      when 'DIFICIL'
        @life_time = 70
      when 'INSANE'
        @life_time = 40
      end
    end

    # Constantemente se escanea la direccion y altitud de el objetivo
    if @difficulty == 'NORMAL' || @difficulty == 'DIFICIL'
      scanear(@scaner_bronce, @moneda_b)
      scanear(@scaner_plata, @moneda_p)
      scanear(@scaner_oro, @moneda_o)
    end

    if viewport.outside_game_area?(@gilbert)
      lose if @gilbert.y >= viewport.game_area.height
    end
  end

  private

  # Lanza ventana de Game Over. y guarda el puntaje al perder
  def lose
    @music.stop if @sonido
    @loser_song.volume = 0.6
    @loser_song.play if @sonido

    GAME_OBJECTS.each(&:destroy_all)
    pop_game_state
    push_game_state(Puntajes.new(player_name: @player_name, score: @score, difficulty: @difficulty, sonido: @sonido))
  end

  # Devuelve unas cordenadas aleatoria en relacion a las plataformas
  def ramdon_location
    seleccion = @plataformas[rand(@plataformas.length)]
    ubicacion_x = seleccion.x
    ubicacion_y = seleccion.y - 45
    [ubicacion_x, ubicacion_y]
  end

  # Cambia de lugar la ubicacion del tipo de moneda pasada como parametro
  def move_position(array, moneda)
    case moneda.class.to_s
    when 'Moneda'
      @moneda_b.x = array[0]
      @moneda_b.y = array[1]
    when 'MonedaPlata'
      @moneda_p.x = array[0]
      @moneda_p.y = array[1]
    when 'MonedaOro'
      @moneda_o.x = array[0]
      @moneda_o.y = array[1]
    end
  end

  # Cambia la vista del scaner de monedas para indicar donde se encuentra su objetivo
  def scanear(scanner, objetivo)
    if @gilbert.x > objetivo.x && @gilbert.y > objetivo.y
      scanner.abajo_derecha(true)
    elsif @gilbert.x < objetivo.x && @gilbert.y < objetivo.y
      scanner.abajo_derecha
    elsif @gilbert.x > objetivo.x && @gilbert.y < objetivo.y
      scanner.arriba_derecha(true)
    elsif @gilbert.x < objetivo.x && @gilbert.y > objetivo.y
      scanner.arriba_derecha
    end
  end

  # metodo que devuelve true o false dependiendo si el objeto 1 toca al objeto 2
  def hit_by(object, object2)
    object.each_collision(object2) do |_o1, _o2|
      return true
    end
    false
  end


end
