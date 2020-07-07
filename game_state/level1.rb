class Level1 < Chingu::GameState
  attr_reader :music, :sonido
  traits :viewport, :timer
  GAME_OBJECTS = [Base, Moneda, Plataforma, Plataforma2]
  def initialize(options = {})
    super
    @player_name = options[:player_name].capitalize
    @sonido = options[:sonido]

    # self.input = {e: :edit}
    @background = Image['Level1Bg.png']
    self.viewport.lag = 0
    self.viewport.game_area = [0, 0, 3000, 1000]

    @gilbert = Gilbert.create(x: 50, y: 900, limited: self.viewport.game_area.width)
    setup
    @plataformas = Plataforma2.all

    @music = Song.new("media/Songs/Music Level1.mp3")
    @music.play(true) if @sonido
    @loser_song = Song.new("media/Songs/gameover.ogg")

    randon = ramdon_location
    @boton = Boton.create(x: randon[0], y: randon[1] + 18)
    @plataforma_meta = Meta.create(x: randon[0], y: randon[1] + 45)

    enable_meta(false)

    @marco_name = Image['MarcoName.png']
    @marco_score = Image['MarcoPoint.png']

    @score = 0
    @msjName = Chingu::Text.new("#{@player_name}", x: 85, y: 25, size: 30, color: Gosu::Color::WHITE)
    @msjScore = Chingu::Text.new("#{@score}", x: $window.width - 130, y: 30, size: 35)
    @mensaje = Chingu::Text.new("Has encontrado todas las monedas", x: 320, y: 20, size: 25, color: Gosu::Color::GREEN)
    @mensaje2 = Chingu::Text.new("Encuentra el Boton", x: @msjName.x, y: 45, size: 30, color: Gosu::Color::YELLOW)
  end

  def lose
    meta_random_location
  	@music.pause if @sonido
    @loser_song.play if @sonido
    @gilbert.x = 50
    @gilbert.y = 900
    GAME_OBJECTS.each(&:destroy_all)
    load_game_objects(file: @level)
    push_game_state(Puntajes.new(player_name: @player_name, score: @score))
    @score = 0
  end

  def enable_meta(boolean = true)
    if boolean
      @boton.show!
      @plataforma_meta.show!
    else
      @boton.hide!
      @plataforma_meta.hide!
    end
  end

  def meta_random_location
    randon = ramdon_location
    @boton.x, @boton.y = randon[0], randon[1] + 18
    @plataforma_meta.x, @plataforma_meta.y = randon[0], randon[1] + 45
  end

  def win
    meta_random_location
    GAME_OBJECTS.each(&:destroy_all)
    @music.pause
  	push_game_state(Level2.new(player_name: @player_name, score: @score, sonido: @sonido))
    @score = 0
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

  def setup
    super
    @level = File.join(ROOT, "levels", self.filename + ".yml")
    load_game_objects(file: @level)
    
    @gilbert.swicht = true
    
    @gilbert.x = 50
    @gilbert.y = 900
  end

  # def edit
  #   push_game_state(Chingu::GameStates::Edit.new(except: [Gilbert, PulsatingText, Boton, BaseLv2, PlataformaMLv2, PlataformaSLv2]))
  # end

  def draw
    @background.draw(0, 0, 0)
    @marco_name.draw(0, 0, 0)
    @marco_score.draw($window.width - 170, 0, 0)
    super
    @msjName.draw()
    @msjScore.draw()
    if @score == 15
      Plataforma2.all.select{|e| e.x == @plataforma_meta.x && e.y == @plataforma_meta.y}[0].hide!
      enable_meta
      @msjName.y = 15
      @mensaje.draw
      @mensaje2.draw
    elsif @score < 15
      Plataforma2.all.select{|e| e.x == @plataforma_meta.x && e.y == @plataforma_meta.y}[0].show!
      enable_meta(false)
    end
  end

  def update
    super
    $window.caption = "Gilbert Ruby\tFPS:#{self.fps}\t Objects: #{current_game_state.game_objects.size}"
    @msjScore.text = "#{@score}"
    self.viewport.center_around(@gilbert)

    if @score < 15
    	@gilbert.each_collision(Moneda) do |gilbert, moneda|
	      moneda.play_sound
	      @score += 1
	      moneda.destroy
	      create_coin(ramdon_location)
    	end
    end

    if @score == 15
    	Moneda.destroy_all
    	@gilbert.each_collision(Boton) do |gilbert, boton|
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