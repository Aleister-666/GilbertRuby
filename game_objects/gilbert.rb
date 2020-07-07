class Gilbert < Chingu::GameObject
  trait :bounding_box, debug: false, scale: 0.5
  traits :velocity, :timer, :collision_detection
  attr_accessor :jumping
  attr_writer :swicht
  attr_reader :last_x, :last_y
  def initialize(options)
    super
    @area_x = options[:limited]
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
    @swicht = false


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
    self.each_collision(Base, Plataforma) do
      self.x = previous_x
      break
    end
    self.y += y
  end

  def update
    @image = @animation.next!
    if @x <= 0
      @x = @last_x
      # @y = @last_y
    elsif @x >= @area_x
        @x = @last_x
        # @y = @last_y
    end
    #Esto es Gloria :'''v
    @jumping = true #Esto para evitar que se pueda saltar al caerse.
    self.each_collision(Base, Plataforma, Plataforma2, BaseLv2, PlataformaMLv2, PlataformaSLv2, BaseP) do |gilbert, superficie|
      if self.velocity_y < 0
        gilbert.y = superficie.bb.bottom + gilbert.image.height * self.factor_y
        self.velocity_y = 0
      else
        superficie.visible ? @jumping = false : @jumping = true
        gilbert.y = superficie.bb.top - 1 if superficie.visible?
      end
      if collidable && @swicht == true
	        after(1500){superficie.hide!} unless superficie.x < 40
	        after(2200){superficie.show!}
      end
    end
    @animation = @gilbertAnimations[@orientation][@direcction] unless moved?
    @last_x, @last_y = @x, @y
  end
end