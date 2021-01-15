class PlataformaMLv3 < Chingu::GameObject
  traits :collision_detection, :bounding_box
  
  def setup
    @image = Image['base medianaLv3.png']
  end
end