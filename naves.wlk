class Nave{
  var velocidad
  var direccion
  var combustible

  method acelerar(cuanto){
    velocidad = 100000.min(velocidad + cuanto)
  }
  method desacelerar(cuanto){
    velocidad = 0.max(velocidad + cuanto)
  }

  method velocidad() = velocidad
  method irHaciaElSol(){
    direccion = 10
  }
  method escaparseDelSol(){
    direccion = -10
  }
  method ponerseParaleloAlSol(){
    direccion = 0
  }
  method acercarseUnPocoAlSol(){
    direccion = 10.min(direccion + 1)
  }
  method alejarseUnPocoAlSol(){
    direccion = (-10).max(direccion - 1)
  }
  method prepararViaje()

  method cargarCombustible(unaCantidad){
    combustible += unaCantidad
  }

  method descargarCombustible(unaCantidad){
    combustible = 0.max(combustible - unaCantidad)
  }

  method combustible() = combustible

  method accidonAdicionalAlViaje(){
    self.cargarCombustible(30000)
    self.acelerar(5000)
  }

  method estaTranquila(){
    return self.combustible() >= 4000 and self.velocidad() < 12000
  }
  method escapar()
  method avisar()

  method recibirAmenaza(){
    self.escapar()
    self.avisar()
  }

  method pocaActividad()

  method estaDeRelajo(){
    self.estaTranquila() and self.pocaActividad()
  }
}

class NaveBaliza inherits Nave{
  var colorActual
  var cambioColor = false
  method cambiarColorDeBaliza(unColor){
    if (not ["verde","rojo","azul"].contains(unColor))
      self.error("color no permitido")
    colorActual = unColor
    cambioColor = true
  }
  override method prepararViaje(){
    self.accidonAdicionalAlViaje()
    self.cambiarColorDeBaliza("verde")
    self.ponerseParaleloAlSol()
  }

  method colorActual() = colorActual
  override method estaTranquila(){
    return super() and self.colorActual() != "rojo"
  }

  override method escapar(){
    self.irHaciaElSol()
  }
  override method avisar(){
    self.cambiarColorDeBaliza("rojo")
  }

  override method pocaActividad(){
    not cambioColor
  }
}

class NaveDePasajeros inherits Nave{
  var pasajeros
  var comida
  var bebida
  var cantRacionesDeComidasServidas
  method agregarPasajeros(unaCantidad){
    pasajeros += unaCantidad
  }
  method vaciarNave(){
    pasajeros = 0
  }

  method cargarComida(unaCantidad){
    comida += unaCantidad
  }
  method descargarComida(unaCantidad){
    comida -= unaCantidad
  }
  method cargarBebida(unaCantidad){
    bebida += unaCantidad
  }
  method descargarBebida(unaCantidad){
    bebida -= unaCantidad
  }
  override method prepararViaje(){
    self.accidonAdicionalAlViaje()
    self.cargarComida(4 * pasajeros)
    self.cargarBebida(6 * pasajeros)
    self.acercarseUnPocoAlSol()
  }

  override method escapar(){
    self.acelerar(velocidad)
  }
  override method avisar(){
    comida = 0.max(comida - pasajeros)
    cantRacionesDeComidasServidas = cantRacionesDeComidasServidas + comida
    bebida = 0.max(bebida - pasajeros * 2)
  }

  override method pocaActividad(){
    return cantRacionesDeComidasServidas < 50
  }
}

class NaveDeCombate inherits Nave{
  const mensajes = []
  var invisible = false
  var desplegMisiles = false

  method ponerseVisible(){
    invisible = false
  }
  method ponerseInvisible(){
    invisible = true
  }
  method estaInvisible(){
    return invisible
  }
  method desplegarMisiles(){
    desplegMisiles = true
  }
  method replegarMisiles(){
    desplegMisiles = false
  }
  method misilesDesplegados(){
    return desplegMisiles
  }
  method emitirMensaje(mensaje){
    mensajes.add(mensaje)
  }
  method mensajesEmitidos(){
    mensajes.size()
  }
  method primerMensajeEmitido(){
    return mensajes.first()
  }
  method ultimoMensajeEmitido(){
    mensajes.last()
  }
  method emitioMensaje(mensaje){
    mensaje.contains(mensaje)
  }
  method esEscueta(){
    return not mensajes.any({m => m.size() > 30})
  }
  override method prepararViaje(){
    self.accidonAdicionalAlViaje()
    self.ponerseInvisible()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitioMensaje("Saliendo en mision")
  }

  override method accidonAdicionalAlViaje(){
    super()
    self.acelerar(15000)
  }
  override method estaTranquila(){
    return super() and not desplegMisiles
  }
  
  override method escapar(){
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }
  override method avisar(){
    self.emitirMensaje("Amenaza recibida")
  }
  override method pocaActividad() = true
}

class NaveHostipal inherits NaveDePasajeros{
  var property quirofanoPreparado = true
  
  override method estaTranquila(){
    return super() and self.quirofanoPreparado()
  }
  override method recibirAmenaza(){
    super()
    quirofanoPreparado = true
  }
}

class NaveDeCombateSigilosa inherits NaveDeCombate{
  override method estaTranquila(){
    return super() and not invisible
  }

  override method recibirAmenaza(){
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
}