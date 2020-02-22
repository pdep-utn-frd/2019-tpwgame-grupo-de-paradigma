import wollok.game.*

class Invader {
	const numero
	var property position
	var previousPosition
	var property vidas = 1
	
	constructor(_numero) {
		numero = _numero
		previousPosition = self.resetPosition()
	}

	method image() = "invader" + numero.toString() + ".png"

	method morir() {
		vidas = vidas - 1
		self.resetPosition()
		game.removeVisual (self)
		game.removeTickEvent("movimiento")
	}

	method acercarseA(personaje) {
		var otroPosicion = personaje.position()
		var newX = position.x() + if (otroPosicion.x() > position.x()) 1 else -1
		var newY = position.y() + if (otroPosicion.y() > position.y()) 1 else -1
	
		newX = newX.max(0).min(game.width() - 1)
		newY = newY.max(1).min(game.height() - 1)
		
		previousPosition = position
		position = game.at(newX, newY)
	}
	
	method resetPosition() {
		position = game.at(numero + 1, 7)
	}
	
	method chocarCon(otro) {
		self.resetPreviousPosition()
		game.sound("RipInvader.mp3")
	}
	
	method resetPreviousPosition() {
		position = previousPosition 
	}
}