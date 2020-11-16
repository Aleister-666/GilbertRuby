class MonedaPlata < Moneda
	trait :bounding_circle, debug: false
	traits :collision_detection
	
	def setup
		@animation = Animation.new(file: "media/Moneda Plateada.png")
		@image = @animation.next
		@collect_coin = Sample.new("media/Songs/mario-coin.mp3")
		self.scale = 0.23
		cache_bounding_circle
  end
	
end