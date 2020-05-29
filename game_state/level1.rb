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
