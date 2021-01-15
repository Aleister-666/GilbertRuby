class BaseLv3 < Chingu::GameObject
  traits :collision_detection, :bounding_box
  
  def setup
    @image = Image['baseLv3.png']
  end
end