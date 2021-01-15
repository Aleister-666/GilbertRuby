# GilbertRuby
*Practica de videojuego con Gosu y Chingu en Ruby*

## Meta
El juego consisten en recolectar el mayor numero de monedas posibles. Los puntajes son guardados al perder y solamente es jugardado el puntaje mas alto.

Existen 3 tipos de monedas las cuales poseen valores diferentes:
* Las monedas de **Bronce** son las de menor valor, pero son las que mas aparecen. **1 moneda de bronce = 1pt**
* Las monedas de **Plata** son las de valor intermedio, aparecen de vez en cuando. **1 moneda de plata = 5pt**
* Las monedas de **Oro** son las de mayor valor y aparecen raramente. **1 moneda de oro = 10pt**

Recomendacion al jugar: ***"Si siempre atento estas, el game over no conoceras"***

## Novedades v1.0.0
* Se agrego un nuevo nivel
* Se agregaron 3 modos de dificultad (Normal, Dificil, Insane).
* Correciones a bug descubiertos.
* Mejoras en las mecanicas del juego.
* Se agregaron cheats ocultos para un nivel.
* Se cambiaron los Backgrounds de los niveles por unos nuevos.
* Los puntajes en la ventana de puntaciones se marcan en amarillo para distinguirlos.
* Se agrego fondo por defecto a la pantalla de espera.

## Requisitos:
* Resolucion Minima: 900 x 600
* Linux o Windows(Para la version de windows, esta un ejecutable y no es nesesario tener los siguientes requisitos)
* Ruby 3.0 || 1.8.3+
* Gosu (Si la gema no esta instalada, correr en la terminal el comando "bundle install" para instalar las gemas necesarias)
* Chingu (Si la gema no esta instalada, correr en la terminal el comando "bundle install" para instalar las gemas necesarias)

## Controles
1. Controles del juego
 * Flecha-Arriba: Saltar.
 * Flecha-Derecha: Mover a la derecha.
 * Flecha-Izquierda: Movera la izquierda.
 * Z: Moverte mas rapido y saltar mas alto(mientras la tecla esta presionada)
 * esc: Salir del Juego en cualquier momento(No se guarda el puntaje).

2. Menu
 * Utiliza las flechas para mover el señalador
 * Enter: Para seleccionar

3. Pantalla de introduccion de nombre
 * Utiliza las flechas para mover el señalador
 * Enter: Para seleccionar caracter
 * Q: Regresar al menu

4. Pantalla de creditos
 * Q: Regresar al menu