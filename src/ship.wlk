import wollok.game.*
import direction.*

object nave{
	var property position = game.at(4,1)
	var direccion = arriba
	var property vidas = 3
	
	method disparar() {
		const bala = new Bala()
		game.addVisual(bala)
		bala.mover()	
	}

	method resetPosition() {
		position = game.at(4,1)
	}
	
	method chocarCon(invader) {
		vidas = vidas - 1
		self.resetPosition()
		game.sound("RipNave.mp3")
		invader.resetPosition()
		if (vidas == 0) {
			game.removeVisual (self)
		}
	}

	method irArriba() {
		if (position.y() < 7) {
		direccion = arriba
		self.avanzar()	
		}
	}

	method irAbajo() {
		if (position.y() > 1) {
		direccion = abajo
		self.avanzar()
		}
	}

	method irIzquierda() {
		if (position.x() > 0) {
		direccion = izquierda
		self.avanzar()
		}
	}

	method irDerecha() {
		if (position.x() < 8) {
		direccion = derecha
		self.avanzar()
		}
	}
	
	method avanzar() {
		position = direccion.siguiente(position)
	}
	
	method image() = "nave.png"
	
	method resetVidas() {
		vidas = 3
	}
	
}

class Bala {
	var property image = "disparo.png"
	var property position = nave.position().up(1)
	
	method mover() {
		self.resetPosition()
		game.onTick(120, "disparar", {position = position.up(1)})
		if (position.y() == 8) {
			game.removeVisual (self)
			game.removeTickEvent("disparar")
		}
	}
	
	method resetPosition() {
		position = nave.position().up(1)
	}
	
	method chocarCon(invader) {
		self.resetPosition()
		game.removeVisual (self)
		game.removeTickEvent("disparar")
		invader.morir()
	}
}
