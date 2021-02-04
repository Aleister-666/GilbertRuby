# GilbertRuby
*Practica de videojuego con Gosu y Chingu en Ruby*

## Objetivos
El juego consisten en recolectar el mayor numero de monedas posibles. Los puntajes son guardados al perder y solamente es guardado el puntaje mas alto.

Existen 3 tipos de monedas las cuales poseen valores diferentes:
* Las monedas de **Bronce** son las de menor valor, pero son las que mas aparecen. **1 moneda de bronce = 1pt**
* Las monedas de **Plata** son las de valor intermedio, aparecen de vez en cuando. **1 moneda de plata = 5pt**
* Las monedas de **Oro** son las de mayor valor y aparecen raramente. **1 moneda de oro = 10pt**

Recomendacion al jugar: ***"Si pendiente estas, el game over no conoceras"***
## Caracteristicas V1.0.0
* 3 Niveles de juego diferentes.
* 3 Dificultades Normal, Dificil e Insane
* Mejoras sustanciales en mecanicas respecto a versiones anteriores
* Mejora visual en algunas partes (nuevos fondos y efectos) respecto a versiones anteriores
* Correciones de bugs conocidos.

## Novedades v1.1.1
* Solucion a bugs en niveles 1 y 2
* Solucion a bugs en pantalla de menu
* Mejoras en la mecanica del nivel 2
* Mejoras en la mecanica del nivel 3
* Mejoras leves en la mecanica del nivel 1

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