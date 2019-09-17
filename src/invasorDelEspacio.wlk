import wollok.game.*
import visuales.*

object invasorDelEspacio {
	var property invaders = [new Invader(1), new Invader(2),new Invader(3), new Invader(4), new Invader(5)]
	
	//GENERAR JUGADOR:
	method iniciarNave() {
			game.addVisual(nave)
			game.say(nave, "Ah shit, here we go again")
	}
	
	//GENERAR ENEMIGOS:
	method inicarInvasores() {
		invaders.forEach { invader => 
			game.addVisual(invader)
			game.whenCollideDo(invader, { personaje =>
			personaje.chocarCon(invader)
			})
			game.whenCollideDo(invader, { proyectil =>
				proyectil.chocarCon(invader)
			})
		
			game.onTick(1.randomUpTo(5) * 500,"moverse", {
				invader.acercarseA(nave)
			})
		}
	}	
	
	//PANTALLA DE VICTORIA:
	method win() {
		game.removeVisual(nave)
		game.addVisual(w)
		game.addVisual(i)
		game.addVisual(n)
	}
	
	//PANTALLAD DE DERROTA:
	method gameOver() {
		game.clear()
		game.addVisual(g)
		game.addVisual(a)
		game.addVisual(m)
		game.addVisual(new E(position = game.at(3,4)))
		game.addVisual(o)
		game.addVisual(v)
		game.addVisual(new E(position = game.at(7,4)))
		game.addVisual(r)
	}
	
	//MOSTRAR VIDASD DEL JUGADOR EN PANTALLA:
	method mostrarVidas() {
		game.addVisual(life1)
		game.addVisual(life2)
		game.addVisual(life3)
	}
	
	//ELIMINAR VIDAS DE LA PANTALLA:
	method eliminarVidas() {
		if (nave.vidas() == 2) {
			game.removeVisual(life1)
		}
		if (nave.vidas() == 1) {
			game.removeVisual(life2)
		}
		if (nave.vidas() == 0) {
			game.removeVisual(life3)
		}
	}	
	
	//COMANDO PARA CERRAR JUEGO:
	method cerrarJuego() {
		game.stop()
	}
	
	//COMANDO PARA RESET DEL JUEGO:
	method reset() {
		invaders.forEach{invader => invader.resetPosition()}
		self.inicarInvasores()
		nave.resetPosition()
	}
}

//OBJETO JUGADOR:
object nave {
	var property image = "nave.png"
	var property vidas = 3
	var property position = game.at(4,1)
	
	method juegoTerminado() = vidas == 0
		
	method resetPosition() {
		position = game.at(4,1)
	}
	
	method moverIzq() {
		if (self.position().x() > 0) {
		position = position.left(1)			
		}
	}
	
	method moverDer() {
		if (self.position().x() < 8) {
		position = position.right(1)			
		}
	}	
	
	method chocarCon(invader) {

		vidas = vidas -1
		
		invasorDelEspacio.eliminarVidas()
		
		self.resetPosition()
		invader.resetPosition()
		game.sound("RipNave.mp3")

		if (self.juegoTerminado()) {
			invasorDelEspacio.gameOver()
		}
	}
	
}

//CLASE ENEMIGOS:
class Invader {	
	const numero
	var property position
	var previousPosition
	var property vidas = 1
	
	constructor(_numero) {
		numero = _numero
		previousPosition = self.resetPosition()
	}	
	
	method muerte() {
			vidas = vidas - 1
			game.removeVisual(self)
			game.removeTickEvent("moverse")
			game.sound("RipInvader.mp3")
	}
	
	method image() = "invader" + numero.toString() + ".png"

//	method movimiento() {
//		game.onTick(2000, "mov", {position.x(1) position.x(-1) position.y(-1)})
//	}

	method acercarseA(personaje) {
		var otroPosicion = personaje.position()
		var newX = position.x() + if (otroPosicion.x() > position.x()) 1 else -1
		var newY = position.y() + if (otroPosicion.y() > position.y()) 1 else -1

		newX = newX.max(0).min(game.width() - 1)
		newY = newY.max(0).min(game.height() - 1)
		previousPosition = position
		position = game.at(newX, newY)
	}

	method resetPosition() {
		position = game.at(numero + 1, 7)
	}
	
	method chocarCon(otro) {
		if (self.position() == bala.position()) {
			game.removeVisual(self) 
			game.removeTickEvent("disparar") 
		}
		
		if (self.position() == nave.position()) {
			self.resetPreviousPosition()
		}
		self.resetPreviousPosition()
	}
	
	method resetPreviousPosition() {
		position = previousPosition 
	}
}

//OBJETO MUNICION DEL JUGADOR:
object bala {
	var property image = "disparo.png"
	var property position = nave.position().up(1)
	
	method disparar() {
		self.resetPosition()
		game.onTick(100, "disparar", {position = position.up(1)})
		if (position.y() == 8) {
			game.removeVisual (self)
			game.removeTickEvent("disparar")
		}
	}
	
	method resetPosition() {
		position = nave.position().up(1)
	}
	
	method chocarCon(invader) {
		game.removeVisual(self)
		invader.muerte()
	}
}
