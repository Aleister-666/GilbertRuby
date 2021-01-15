class Plataforma2 < Chingu::GameObject
  traits :collision_detection, :bounding_box

  def setup
    @image = Image['base corta.png']
    self.width = 64
  end
  
end