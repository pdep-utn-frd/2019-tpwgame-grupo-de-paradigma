import wollok.game.*
import ship.*
import visuals.*
import invaders.*

object nivel {
	
	method cargar() {
		
//	INVASOR
	const invaders = [new Invader(1), new Invader(2), new Invader(3)]
	
	invaders.forEach { invader => 
		game.addVisual(invader)
		game.whenCollideDo(invader, { personaje =>
			personaje.chocarCon(invader)
			self.eliminarVidas()
		})
		game.whenCollideDo(invader, { municion =>
			municion.chocarCon(invader)})		
		game.onTick(1.randomUpTo(5) * 500, "movimiento", {
			invader.acercarseA(nave)
		})
	}
			
//	NAVE
		game.addVisual(nave)
		game.say(nave,"Solo tenemos " + nave.vidas() + " vidas")
		
		keyboard.any().onPressDo{ self.comprobarSiGano(invaders) }
		
		self.teclado()
		
		self.mostrarVidas()
}

//	TECLADO
		method teclado() {
		keyboard.up().onPressDo{ nave.irArriba() }
		keyboard.down().onPressDo{ nave.irAbajo() }
		keyboard.left().onPressDo{ nave.irIzquierda() }
		keyboard.right().onPressDo{ nave.irDerecha() }
		keyboard.space().onPressDo{ nave.disparar() }

		keyboard.r().onPressDo{ self.restart() }
		keyboard.e().onPressDo{ game.stop() }
		}
		
// PANTALLAD DE DERROTA:
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
		self.teclado()
	}
	
// MOSTRAR VIDASD DEL JUGADOR EN PANTALLA:
	method mostrarVidas() {
		game.addVisual(life1)
		game.addVisual(life2)
		game.addVisual(life3)
	}
	
// ELIMINAR VIDAS DE LA PANTALLA:
	method eliminarVidas() {
		if (nave.vidas() == 2) {
			game.removeVisual(life1)
		}
		if (nave.vidas() == 1) {
			game.removeVisual(life2)
		}
		if (nave.vidas() == 0) {
			game.removeVisual(life3)
			self.gameOver()
		}
	}	
	
// RESTART
	method restart() { //Cree esto porque no me reestablecia la vida
		self.reset()   //de la nave con un solo reset.
		self.reset()
	}

	method reset() {
		game.clear()
		self.cargar()
		nave.resetVidas()
		nave.resetPosition()
	}

// CONDICION PARA GANAR
	method comprobarSiGano(invaders) {
		if (invaders.all{ c => c.vidas() == 0 }) {
			self.win()
		}
    }
    
// PANTALLA DE VICTORIA:
	method win() {
		game.clear()
		game.addVisual(w)
		game.addVisual(i)
		game.addVisual(n)
		self.teclado()
	}
    
}