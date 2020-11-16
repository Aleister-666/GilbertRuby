class Menu < Chingu::GameState
  def initialize(options = {})
    super
    self.input = { holding_up: :arriba, holding_down: :abajo, return: :seleccion }
    @background = Image['Menu.png']

    play = 'JUGAR'

    music = 'Musica: ON'
    @music_playing = true
    @soundTrack = Song.new('media/Songs/menuSound.mp3')
    @soundTrack.play

    acerca = 'ACERCA...'
    salir = 'SALIR'

    @select_music = Sample.new('media/Songs/menuselect.ogg')

    @font_color = Gosu::Color::WHITE
    @font_selection = Gosu::Color::RED
    font = 'Days One'

    @msjP = Chingu::Text.create(play, x: $window.width / 2 - 70, y: 250, font: font, size: 65, color: @font_selection)
    @msjM = Chingu::Text.create(music, x: @msjP.x, y: @msjP.y + 75, font: font, size: 65, color: @font_color)
    @msjA = Chingu::Text.create(acerca, x: @msjP.x, y: @msjM.y + 75, font: font, size: 65, color: @font_color)
    @msjS = Chingu::Text.create(salir, x: @msjP.x, y: @msjA.y + 75, font: font, size: 65, color: @font_color)
    @selection = 1
  end

  # Mueve el puntero hacia arriba
  def arriba
    case @selection
    when 2
      @msjP.color = @font_selection
      @msjM.color = @font_color
      @selection = 1
      @select_music.play
    when 3
      @msjM.color = @font_selection
      @msjA.color = @font_color
      @selection = 2
      @select_music.play
    when 4
      @msjA.color = @font_selection
      @msjS.color = @font_color
      @selection = 3
      @select_music.play
    end
    sleep(0.15)
  end

  # Mueve el puntero hacia abajo
  def abajo
    case @selection
    when 1
      @msjM.color = @font_selection
      @msjP.color = @font_color
      @selection = 2
      @select_music.play
    when 2
      @msjA.color = @font_selection
      @msjM.color = @font_color
      @selection = 3
      @select_music.play

    when 3
      @msjS.color = @font_selection
      @msjA.color = @font_color
      @selection = 4
      @select_music.play
    end
    sleep(0.15)
  end

  # Instruciones a seguir al seleccionar una opcion
  def seleccion
    case @selection
    when 1
      push_game_state(EnterName.new(callback: method(:enter_name)))
    when 2
      if @music_playing
        @msjM.text = 'Musica: OFF'
        @music_playing = false
        @soundTrack.pause
      else
        @msjM.text = 'Musica: ON'
        @music_playing = true
        @soundTrack.play
      end
    when 3
      push_game_state(Acerca)
    when 4
      exit
    end
  end

  # Callback para el almacenamiento del nombre de usuario
  def enter_name(name)
    return @player_name = 'Anonymus' if name.empty?
    
    @player_name = name[0...18]
  end

  def draw
    @background.draw(0, 0, 0)
    super
  end

  def update
    super
    push_game_state(Level1.new(player_name: @player_name, sonido: @music_playing)) if @player_name
  end

  def finalize
    @soundTrack.stop unless @music_playing
  end
end
