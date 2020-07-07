class BaseP < Chingu::GameObject
  traits :collision_detection, :bounding_box
  def setup
    @image = Image['Base Portal.png']
  end
end