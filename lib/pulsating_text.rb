class PulsatingText < Text
  traits :timer, :effect
  
  def initialize(text, options = {})
    super(text, options)
    options = text  if text.is_a? Hash
    @pulse = options[:pulse] || false
    rotation_center(:center_center)
    every(20) { create_pulse } if @pulse == false
  end
  
  def create_pulse
    pulse = PulsatingText.create(@text,
                                 x: @x,
                                 y: @y,
                                 height: @height,
                                 pulse: true,
                                 image: @image,
                                 zorder: @zorder+1)
    colors = [Color::RED, Color::GREEN, Color::BLUE]
    pulse.color = colors[rand(colors.size)].dup
    pulse.mode = :additive
    pulse.alpha -= 150
    pulse.scale_rate = 0.002
    pulse.fade_rate = -3 + rand(2)
    pulse.rotation_rate = rand(2).zero? ? 0.05 : -0.05
  end
    
  def update
    destroy if self.alpha.zero?
  end
end
