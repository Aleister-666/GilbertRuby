class MonedaOro < Moneda
	trait :bounding_circle, debug: false
	traits :collision_detection
	  
	def setup
	  @animation = Animation.new(file: 'media/Moneda Dorada.png')
	  @image = @animation.next
	  @collect_coin = Sample.new('media/Songs/Coin Collect.ogg')
	  self.scale = 0.28
	  cache_bounding_circle
  end
end