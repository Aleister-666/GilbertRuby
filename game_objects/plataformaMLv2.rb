class PlataformaMLv2 < Chingu::GameObject
  traits :collision_detection, :bounding_box
  def setup
    @image = Image['base medianaLv2.png']
  end
end