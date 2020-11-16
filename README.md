# GilbertRuby v0.6.8
Practica de juego con Gosu y Chingu en Ruby

# Meta
El juego consiste en agarrar el mayor numero de monedas posibles, cada vez que se coja una moneda aparecera otra en un lugar diferente, SOLO UNA A LA VEZ, y tu labor sera recolectarlas. Tu puntaje se guardara cuando pierdas(solamente se guardaran los puntajes mas altos).

Recomendacion: "Si siempre atento estas, el game over no conoceras"

# Novedades v0.6.8
* Correciones menores a la jugabilidad
* Implementacion de Cheats
# Requisitos:
* Resolucion Minima: 900 x 600
* Linux o Windows(Para la version de windows, esta un ejecutable y no es nesesario tener los demas requisitos)
* Ruby 2.7 || 1.8.3+
* Gosu (Si la gema no esta instalada, correr en la terminal el comando "bundle install" para instalar las gemas necesarias)
* Chingu (Si la gema no esta instalada, correr en la terminal el comando "bundle install" para instalar las gemas necesarias)

# Controles
Controles del juego do
 * Flecha-Arriba: Saltar.
 * Flecha-Derecha: Mover a la derecha.
 * Flecha-Izquierda: Movera la izquierda.
 * Z: Moverte mas rapido y saltar mas alto(mientras la tecla esta presionada)
 * esc: Salir del Juego en cualquier momento(No se guarda el puntaje).
end

Menu do
 * Utiliza las flechas para mover el señalador
 * Enter: Para seleccionar
end

Pantalla de introduccion de nombre do
 * Utiliza las flechas para mover el señalador
 * Enter: Para seleccionar caracter
 * Q: Regresar al menu
end

Pantalla de creditos do
 * Q: Regresar al menu
end
