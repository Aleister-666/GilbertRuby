class Level2 < Chingu::GameState
	attr_reader :music
	traits :viewport, :timer
	GAME_OBJECTS = [Moneda, MonedaPlata, MonedaOro, BaseLv2, PlataformaMLv2, PlataformaSLv2, BaseP, Portal]
	def initialize(options = {})
		super
		@player_name = options[:player_name].capitalize
		@score = options[:score]
		@sonido = options[:sonido]

		# self.input = {e: :edit}
	  @background = Image['Level2Bg.png']
	  self.viewport.lag = 0
		self.viewport.game_area = [0, 0, 1500, 2500]
		@level = File.join(ROOT, "levels", self.filename + ".yml")
    	load_game_objects(file: @level)
		@plataformas = PlataformaSLv2.all
	   
	  @music = Song.new("media/Songs/Music Level2.mp3")
	  @loser_song = Song.new("media/Songs/gameover.ogg")
	  @music.play(true) if @sonido

	  @marco_name = Image['MarcoName.png']
    @marco_score = Image['MarcoPoint.png']

		@gilbert = Gilbert.create(x: Portal.all.first.x, y: Portal.all.first.y, limited: self.viewport.game_area.width)

		@life_time = 150
		@time = Chingu::Text.new("Oxigeno: #{@life_time}", x: 350, y: 15, size: 50)
		@danger = Chingu::Text.new("Regresa a la plataforma de recarga", x: @time.x, y: @time.y + 50, size: 20, color: Gosu::Color::YELLOW)
		
		PlataformaSLv2.create(x: 30, y: 850)

		3.times do |n|
			initial_position = ramdon_location
			@moneda_B = Moneda.create(x: initial_position[0], y: initial_position[1]) if n == 0
			@moneda_P = MonedaPlata.create(x: initial_position[0], y: initial_position[1]) if n == 1
			@moneda_O = MonedaOro.create(x: initial_position[0], y: initial_position[1]) if n == 2
		end

		@moneda_P.hide!
		@moneda_O.hide!

	  @msjName = Chingu::Text.new("#{@player_name}", x: 85, y: 25, size: 30, color: Gosu::Color::WHITE)
		@msjScore = Chingu::Text.new("#{@score}", x: $window.width - 130, y: 30, size: 35)

		@scaner_bronce = Scaner.create(metal: "bronce", x: 0, y: 0)
		@scaner_plata = Scaner.create(metal: "plata", x: 0, y: 0)
		@scaner_oro = Scaner.create(metal: "oro", x: 0, y: 0)

		@scaner_plata.hide!
		@scaner_oro.hide!

		@temp_P = 0
		@temp_O = 0
		@temp_G = 0
	end

	def lose
	  	@music.pause if @sonido
	    @loser_song.play if @sonido
	    @gilbert.x = 50
	    @gilbert.y = 900
	    GAME_OBJECTS.each(&:destroy_all)
	    push_game_state(Puntajes.new(player_name: @player_name, score: @score))
	end

		def ramdon_location
	  	seleccion = @plataformas[rand(@plataformas.length)]
	  	ubicacion_x = seleccion.x
	  	ubicacion_y = seleccion.y - 45
	  	return [ubicacion_x, ubicacion_y]
		end

  	def move_position(array, moneda)
  		if moneda.class.to_s == "Moneda"
  			@moneda_B.x = array[0]
  			@moneda_B.y = array[1]
  		elsif moneda.class.to_s == "MonedaPlata"
  			@moneda_P.x = array[0]
  			@moneda_P.y = array[1]
  		elsif moneda.class.to_s == "MonedaOro"
  			@moneda_O.x = array[0]
  			@moneda_O.y = array[1]
  		end	
		end

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

		def hit_by(object, object2)
			object.each_collision(object2) do |o1, o2|
				return true
			end
			return false
		end
		

	# def edit
 #     push_game_state(Chingu::GameStates::Edit.new(except: [Gilbert, PulsatingText, Boton, Base, Plataforma, Plataforma2, Meta, Scaner]))
 #  end

		def draw
    	@background.draw(0, 0, 0)
    	@marco_name.draw(0, 0, 0)
			@marco_score.draw($window.width - 170, 0, 0)
			@danger.draw if @life_time < 30
			super
			@temp_P += 1
			@temp_O += 1
			@time.draw()
			
    	@msjName.draw()
			@msjScore.draw()
			@scaner_bronce.x = @gilbert.x + 50
			@scaner_bronce.y = @gilbert.y - 140

			@moneda_P.visible? ? @scaner_plata.show! : @scaner_plata.hide!
			@scaner_plata.x = @scaner_bronce.x - 100
			@scaner_plata.y = @scaner_bronce.y

			@moneda_O.visible? ? @scaner_oro.show! : @scaner_oro.hide!
			@scaner_oro.x = @scaner_bronce.x + 100
			@scaner_oro.y = @scaner_bronce.y

			#60 para 1 seg
			#600 para 10 seg
			#900 para 15 seg
			#1500 para 25 seg
			#2400 para 40 seg

			if @temp_P >= 3000
				@moneda_P.show!
				@temp_P = 0
			elsif @temp_O >= 4800
				@moneda_O.show!
				@temp_O = 0
			end

			if @moneda_P.visible?
				if @temp_P >= 900
					@moneda_P.hide!
					move_position(ramdon_location, @moneda_P)
				end
			end

			if @moneda_O.visible?
				if @temp_O >= 600
					@moneda_O.hide!
					move_position(ramdon_location, @moneda_O)
				end
			end
		end

	def update
		super
		@temp_G += 1
		if @temp_G >= 60 && @temp_G < 70
			@life_time -= 1 unless hit_by(@gilbert, Portal)
			@time.text = "Oxigeno: #{@life_time}"
			@temp_G = 0
		end

		if @life_time == 0
			lose
		elsif @life_time < 30
			@time.color = Gosu::Color::RED
			
		end
		
		$window.caption = "Gilbert Ruby\tFPS:#{self.fps}\t Objects: #{current_game_state.game_objects.size}"
		self.viewport.center_around(@gilbert)
		@msjScore.text = "#{@score}"

		@gilbert.each_collision(Moneda) do |gilbert, moneda|
	      moneda.play_sound
	      @score += 1
	      move_position(ramdon_location, @moneda_B)
		end

		if @moneda_P.visible?
			@gilbert.each_collision(MonedaPlata) do |gilbert, moneda_P|
				moneda_P.play_sound
				@score += 5
				@temp_P = 0
				move_position(ramdon_location, @moneda_P)
				moneda_P.hide!
			end
		end

		if @moneda_O.visible?
			@gilbert.each_collision(MonedaOro) do |gilbert, moneda_O|
				moneda_O.play_sound
				@score += 10
				@temp_O = 0
				move_position(ramdon_location, @moneda_O)
				moneda_O.hide!
			end
		end


		@gilbert.each_collision(Portal) do |gilbert, portal|
			@time.color = Gosu::Color::WHITE
			@life_time = 150
		end

		scanear(@scaner_bronce, @moneda_B)
		scanear(@scaner_plata, @moneda_P)
		scanear(@scaner_oro, @moneda_O)
		
		if self.viewport.outside_game_area?(@gilbert)
			if @gilbert.y >= self.viewport.game_area.height
        lose
			end
		end
	end
end