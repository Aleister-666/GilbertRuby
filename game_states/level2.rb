# Segundo Nivel del juego consiste en alcanzar la cima lo mas rapido posible.
# La forma de juego es contra-relog cuyo tiempo lo define la dificultad
class Level2 < Chingu::GameState
  traits :viewport, :timer

  GAME_OBJECTS = [Base,
                  Plataforma,
                  Plataforma2,
                  Moneda,
                  MonedaPlata,
                  MonedaOro,
                  Meta,
                  BaseSpecial,
                  Gilbert].freeze

  def initialize(**options)
    super
    @player_name = options[:player_name].capitalize
    @score = options[:score]
    @sonido = options[:sonido]
    @difficulty = options[:difficulty]

    # self.input = {e: :edit}
  end

  # def edit
  #   push_game_state(Chingu::GameStates::Edit.new(except: [Gilbert,
  #                                                         PulsatingText,
  #                                                         Boton,
  #                                                         BaseLv3,
  #                                                         PlataformaMLv3,
  #                                                         PlataformaSLv3,
  #                                                         Scaner,
  #                                                         Portal]))
  # end

  def setup
    super
    @background = Image['Bg level2.png']
    viewport.lag = 0
    viewport.game_area = [0, 0, 1500, 3000]

    # Carga del Nivel
    @level = File.join(ROOT, 'levels', self.filename + '.yml')
    load_game_objects(file: @level)

    @music = Song.new('media/Songs/Music Level2.mp3')
    @loser_song = Song.new('media/Songs/gameover.ogg')

    @gilbert = Gilbert.create(x: 100, y: viewport.game_area.height - 150, limited: viewport.game_area.width)

    @marco_name = Image['MarcoName.png']
    @marco_score = Image['MarcoPoint.png']

    @msj_name = Chingu::Text.new(@player_name, x: 85, y: 25, size: 30, color: Gosu::Color::WHITE)
    @msj_score = Chingu::Text.new(@score, x: $window.width - 150, y: 30, size: 35)

    @plataformas = Plataforma2.all
    @plataforma_movil = @plataformas.select {|e| e.x == 24 && e.y == 976}.first
    @tope = false
    @meta = Meta.all.first

    case @difficulty
    when 'NORMAL'
      @life_time = 120
    when 'DIFICIL'
      @life_time = 100
    when 'INSANE'
      @life_time = 80
    end

    @timer = Chingu::Text.new("Tiempo: #{@life_time}", x: 350, y: 15, size: 50)
    @msj_danger = Chingu::Text.new("Se te acaba el tiempo",
                                   x: @timer.x,
                                   y: @timer.y + 45,
                                   size: 30,
                                   color: Gosu::Color::YELLOW)

    every(1000) do
      @life_time -= 1
      @timer.text = "Tiempo: #{@life_time}"
    end
    
    @music.play(true) if @sonido
  end

  def draw
    @background.draw(0, 0, 0)
    @marco_name.draw(0, 0, 0)
    @marco_score.draw($window.width - 170, 0, 0)
    @msj_name.draw
    @msj_score.draw
    super
    @timer.draw
    @msj_score.text = @score
    if @life_time <= 30
      @msj_danger.draw if @life_time
      @timer.color = Gosu::Color::RED
    end
  end

  def update
    super
    $window.caption = "Gilbert Ruby\tFPS:#{fps}"
    # $window.caption = "Gilbert Ruby\tFPS:#{fps}\t Objects: #{current_game_state.game_objects.size}"
    @music.volume = 0.4
    viewport.center_around(@gilbert)

    @gilbert.each_collision(Moneda) do |_gilbert, moneda|
      moneda.play_sound
      @score += 1
      moneda.destroy
      # modena.destroy
    end

    @gilbert.each_collision(MonedaPlata) do |_gilbert, moneda_p|
      moneda_p.play_sound
      @score += 5
      moneda_p.destroy
    end

    @gilbert.each_collision(MonedaOro) do |_gilbert, moneda_o|
      moneda_o.play_sound
      @score += 10
      moneda_o.destroy
    end

    # if hit(@plataforma_movil, @gilbert)
    #   @plataforma_movil.y -= 3 if @plataforma_movil.y > (976 - 300)
    # elsif !hit(@plataforma_movil, @gilbert)
    #   @plataforma_movil.y += 3 if @plataforma_movil.y < 976
    # end

    if @plataforma_movil.y > (976 - 300) && !@tope
    	@plataforma_movil.y -= 3
    	@tope = true if @plataforma_movil.y <= (976 - 300)
    else
    	@plataforma_movil.y += 3
    	@tope = false if @plataforma_movil.y >= 976
    end



    win if @gilbert.y == @meta.bb.top && @gilbert.x <= @meta.bb.center[0]
    lose if @life_time.zero?
  end

  private

  def win
    @music.stop if @sonido

    GAME_OBJECTS.each(&:destroy_all)
    pop_game_state
    push_game_state(Level3.new(player_name: @player_name, score: @score, sonido: @sonido, difficulty: @difficulty))
  end

  def lose
    @music.stop if @sonido
    @loser_song.volume = 0.6
    @loser_song.play if @sonido

    GAME_OBJECTS.each(&:destroy_all)
    pop_game_state
    push_game_state(Puntajes.new(player_name: @player_name, score: @score, difficulty: @difficulty, sonido: @sonido))
  end

  # def hit(object1, object2)
  #   object1.each_collision(object2) do |e1, e2|
  #     return true
  #   end
  #   false
  # end

end
