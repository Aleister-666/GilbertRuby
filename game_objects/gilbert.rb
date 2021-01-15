class Gilbert < Chingu::GameObject
  trait :bounding_box, debug: false, scale: 0.5
  traits :velocity, :timer, :collision_detection

  attr_accessor :jumping
  attr_reader :last_x, :last_y, :direcction

  PLATAFORMAS = [Base,
                 Plataforma,
                 Plataforma2,
                 BaseLv3,
                 PlataformaMLv3,
                 PlataformaSLv3,
                 BaseSpecial,
                 Meta].freeze

  def initialize(options = {})
    super
    @area_x = options[:limited]
    self.input = {holding_left: :izquierda,
                  holding_right: :derecha,
                  %i[space holding_up] => :arriba,
                  z: :corriendo,
                  released_z: :no_corriendo}
    
    @gilbert_animations = {}
    @gilbert_animations[:run_right] = Animation.new(file: 'media/Gilbert_animacion_derecha2.png', size: [66, 103])
    @gilbert_animations[:run_right].frame_names = {stand_right: 15..15}
    @gilbert_animations[:run_left] = Animation.new(file: 'media/Gilbert_animacion_izquierda2.png', size: [66, 103])
    @gilbert_animations[:run_left].frame_names = {stand_left: 15..15}
    @animation = @gilbert_animations[:run_right][:stand_right]

    @song_salto = Sample.new('media/Songs/jump.wav')
    @direcction = :stand_right
    @orientation = :run_right
    @jumping = false
    @corriendo = false
    @speed = 3

    self.scale = 0.9
    self.acceleration_y = 0.5
    self.max_velocity = 15

    #Lo que hace que no se caiga. Super importante. Mega iMPORTANTE
    self.rotation_center = :bottom_center
    update
    cache_bounding_box
  end

  # Mueve a la izquierda al Gilbert
  def izquierda
    move(-@speed, 0)
    @animation = @gilbert_animations[:run_left]
    @orientation = :run_left
    @direcction = :stand_left
  end

  # Mueve a la derecha al Gilbert
  def derecha
    move(@speed, 0)
    @animation = @gilbert_animations[:run_right]
    @orientation = :run_right
    @direcction = :stand_right
  end

  # Hace que Gilbert salte
  def arriba
    return if @jumping
    @song_salto.play
    @jumping = true
    @corriendo ? self.velocity_y = -13 : self.velocity_y = -10
  end

  # Establece la velocidad de Gilbert al correr
  def corriendo
    @speed = 5
    @corriendo = true
  end

  def no_corriendo
    @speed = 3
    @corriendo = false
  end

  # Mueve a Gilbert a las cordenadas (X, Y)
  def move(x, y)
    self.x += x
    each_collision(*PLATAFORMAS) do |gilbert, superficie|
      if gilbert.x >= superficie.bb.right && gilbert.y != superficie.bb.top
        self.x = previous_x
      elsif gilbert.x <= superficie.bb.left && gilbert.y != superficie.bb.top
        self.x = previous_x
      end
    end
    self.y += y
  end

  def update
    @image = @animation.next!
    if @x <= 0
      @x = @last_x
    elsif @x >= @area_x
      @x = @last_x
    end

    # Esto para evitar que se pueda saltar al caerse
    @jumping = true 

    # Aqui esta se establece la logica que le da su estabilidad sobre las plataformas/superficies
    each_collision(*PLATAFORMAS) do |gilbert, superficie|
      if velocity_y.negative?
        # gilbert.y = superficie.bb.bottom + gilbert.image.height * factor_y
        gilbert.y = superficie.bb.bottom + gilbert.image.height
        self.velocity_y = 5
      else
        gilbert.y = superficie.bb.top if superficie.visible
        superficie.visible ? @jumping = false : @jumping = true
      end
    end
    # Mueve los frame de la animacion
    @animation = @gilbert_animations[@orientation][@direcction] unless moved?
    @last_x, @last_y = @x, @y
  end
end