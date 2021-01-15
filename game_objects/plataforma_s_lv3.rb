class PlataformaSLv3 < Chingu::GameObject
  traits :collision_detection, :bounding_box
  
  def setup
    @image = Image['base cortaLv3.png']
    self.width = 64
  end
end