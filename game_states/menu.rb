class Menu < Chingu::GameState

  def initialize(**options)
    super
    self.input = { holding_up: :arriba, holding_down: :abajo, return: :seleccion }
    @background = Image['Menu.png']
    play = 'JUGAR'

    @difficulty = %w[NORMAL DIFICIL INSANE]
    @token_difficulty = 0

    @sound_tracks_list = []
    @select_sound = 0
    music = 'Musica: ON'
    sound_track = Song.new('media/Songs/menuSound.mp3')
    sound_track_insane = Song.new('media/Songs/menuSong Insane.mp3')
    @sound_tracks_list << sound_track
    @sound_tracks_list << sound_track_insane
    @sound_tracks_list[@select_sound].play
    @music_playing = true

    acerca = 'ACERCA...'
    salir = 'SALIR'

    @select_song = Sample.new('media/Songs/menuselect.ogg')
    @select_song.volume = 0.3

    @font_color = Gosu::Color::WHITE
    @font_selection = Gosu::Color::RED
    font = 'Days One'

    @play_message = Chingu::Text.create(play, x: $window.width / 2 - 70, y: 250, font: font, size: 50, color: @font_selection)
    @difficulty_message = Chingu::Text.create("Dificultad: #{@difficulty[0]}", x: @play_message.x - 110, y: @play_message.y + 60, font: font, size: 50, color: @font_color)
    @music_message = Chingu::Text.create(music, x: @play_message.x, y: @difficulty_message.y + 60, font: font, size: 50, color: @font_color)
    @about_message = Chingu::Text.create(acerca, x: @play_message.x, y: @music_message.y + 60, font: font, size: 50, color: @font_color)
    @exit_message = Chingu::Text.create(salir, x: @play_message.x, y: @about_message.y + 60, font: font, size: 50, color: @font_color)

    @mensajes = [@play_message, @difficulty_message, @music_message, @about_message, @exit_message]
    @selection = 1
  end

  # Pinta de rojo el texto del mensaje pasado como argumento
  def mesaje_select(message)
    @mensajes.each do |e|
      if message.text == e.text
        e.color = @font_selection
      else
        e.color = @font_color
      end
     
    end
  end


  # Mueve el puntero hacia arriba
  def arriba
    case @selection
    when 2
      mesaje_select(@play_message)
      @selection = 1
      @select_song.play
    when 3
      mesaje_select(@difficulty_message)
      @selection = 2
      @select_song.play
    when 4
      mesaje_select(@music_message)
      @selection = 3
      @select_song.play
    when 5
      mesaje_select(@about_message)
      @selection = 4
      @select_song.play
    end
    sleep(0.15)
  end

  # Mueve el puntero hacia abajo
  def abajo
    case @selection
    when 1
      mesaje_select(@difficulty_message)
      @selection = 2
      @select_song.play
    when 2
      mesaje_select(@music_message)
      @selection = 3
      @select_song.play
    when 3
      mesaje_select(@about_message)
      @selection = 4
      @select_song.play
    when 4
      mesaje_select(@exit_message)
      @selection = 5
      @select_song.play
    end
    sleep(0.15)
  end

  # Instruciones a seguir al seleccionar una opcion
  def seleccion
    case @selection
    when 1
      push_game_state(EnterName.new(callback: method(:enter_name)))
    when 2
      if @token_difficulty.zero?
        @difficulty_message.text = "Dificultad: #{@difficulty[1]}"
        @token_difficulty = 1
        @select_sound = 0
      elsif @token_difficulty == 1
        @difficulty_message.text = "Dificultad: #{@difficulty[2]}"
        @token_difficulty = 2
        @select_sound = 1
        @sound_tracks_list[@select_sound].play if @music_playing
      else
        @difficulty_message.text = "Dificultad: #{@difficulty[0]}"
        @token_difficulty = 0
        @select_sound = 0
        @sound_tracks_list[@select_sound].play if @music_playing
      end
    when 3
      if @music_playing
        @music_message.text = 'Musica: OFF'
        @music_playing = false
        @sound_tracks_list[@select_sound].pause
      else
        @music_message.text = 'Musica: ON'
        @music_playing = true
        @sound_tracks_list[@select_sound].play
      end
    when 4
      push_game_state(Acerca)
    when 5
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
    if @player_name
      push_game_state(Level1.new(player_name: @player_name,
                                 sonido: @music_playing,
                                 difficulty: @difficulty[@token_difficulty]))
    end
  end

end
