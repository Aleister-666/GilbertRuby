class Meta < Chingu::GameObject
  traits :collision_detection, :bounding_box
  
  def setup
    @image = Image['base final.png']
    self.width = 64
  end
end