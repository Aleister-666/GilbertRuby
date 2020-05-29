class Lose < Chingu::GameState
    traits :viewport, :timer
    def initialize
        super
        @seg = 3
        msj = Chingu::Text.create("Has Perdido Pendejo. VUELVE A EMPEZAR", x: 150, y: 150, size: 30)
        msj2 = Chingu::Text.create(decrement, x: 150, y: 200, size: 30)
        after(800){@seg -= 1; msj2.text = decrement}
        after(1600){@seg -= 1; msj2.text = decrement}
        after(2400){game_states[2].play_song; pop_game_state; game_states[1].pop_game_state;}
    end

    def decrement
    	return "Espera #{@seg} segundos para comenzar de nuevo"
    end

    def draw
        game_states[2].draw
        super
    end
end