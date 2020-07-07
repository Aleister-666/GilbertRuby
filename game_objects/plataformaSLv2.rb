class PlataformaSLv2 < Chingu::GameObject
    traits :collision_detection, :bounding_box
    def setup
      @image = Image['base cortaLv2.png']
      self.width = 64
    end
end