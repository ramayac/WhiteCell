import fisica.util.nonconvex.*;
import fisica.*;

/*
WhiteCell, a small Osmos "clone" made in Processing.
 The purpose of this game is to get rid of the disease you have.
 
 This is the first Draft Project made for the Creative 
 Programming for Digital Media & Mobile Apps course,
 in Coursera (https://class.coursera.org/digitalmedia-001/class/index)
 
 Made by Rodrigo Amaya, follow me on twitter: @ramayac
 
 TODO:
 * Behaviour for bad cells
 * Add red cells
 
 */

//General configurations
final int CANTIDAD = 12;
float CRECIMIENTO = 0.20, DECRECIMIENTO = 0.35;
float MINRADIO = 25, MAXRADIO = 50;
//float LIMRADIO = 7.5;
final float PLAYERRADIO = 30;
float ANGULO = 0;

PImage fondo, escombro;
PImage celula, celulaAzul, celulaRoja, celulaVerde;

Celula jugador;
Celula[] celulas = new Celula[CANTIDAD];

Maxim maxim;
AudioPlayer sndcol, sndtoque, sndmorir;

Escena escena = new Escena();

FWorld world;
boolean DEBUG = false;
PFont fuenteChiller, fuenteArial;

void setup() {
  size(600, 600);
  frameRate(60);
  //smooth();

  maxim = new Maxim(this);

  sndcol = maxim.loadFile("colision.wav");
  sndtoque = maxim.loadFile("toque.wav");
  sndmorir = maxim.loadFile("morir.wav");

  sndcol.setLooping(false);
  sndtoque.setLooping(false);
  sndmorir.setLooping(false);

  fondo = loadImage("fondo.jpg");
  escombro = loadImage("noise.png");
  celula = loadImage("cell.png");

  fuenteChiller = loadFont("Chiller-Regular-48.vlw");
  fuenteArial = loadFont("Arial-BoldMT-10.vlw");
  textFont(fuenteChiller, 32);

  //Fisica
  Fisica.init(this);
  world = new FWorld();
  iniciar();
}

void iniciar() {
  world.clear();
  
  world.setEdges();
  world.setGravity(0, 0); //sin gravedad
  
  jugador = new Celula(width/2, height/2, PLAYERRADIO, true, true);

  world.add(jugador);

  //println(escena.estado + ", " + jugador.isAlive());
  for (int i = 0; i < celulas.length; i++) {
    float x = random(0+MAXRADIO, width-MAXRADIO);
    float y = random(0+MAXRADIO, height-MAXRADIO);
    float r = random(MINRADIO, MAXRADIO);
    celulas[i] = new Celula(x, y, r, true);
    world.add(celulas[i]);
  }
}

void draw() {
  checkGamestate();

  if (escena.draw()) {
    //Background layer
    imageMode(CORNER);
    image(fondo, 0, 0, width, height);

    //Let's check for collision
    imageMode(CENTER);
    for (int i = 0; i < celulas.length; i++) {
      //Tint the cells relative to player size
      celulas[i].comparar(jugador);

      //General collision with other cells
      for (int j = 0; j < celulas.length; j++) {
        if (i != j) { //we wont check a cell with it self! 
          colision(celulas[j], celulas[i]);
        }
      }

      //General collision with the player
      colision(jugador, celulas[i]);
    }

    //Some stuff (transparent noise) floating arround
    pushMatrix();
    imageMode(CENTER);
    translate(width/2, height/2);
    //rotate(cos(ANGULO));
    image(escombro, 0, 0, height, height);
    popMatrix();
    
    imageMode(CENTER);
    ANGULO += 0.001;

    if (DEBUG) {
      textFont(fuenteArial, 10);
      world.drawDebug();      
      textFont(fuenteChiller, 32);
    }
    world.draw();
    world.step();
  }
}

void checkGamestate() {
  if (escena.estado == JUGANDO) {
    if (!jugador.isAlive()) {

      escena.estado =  PERDIO;
    } 
    else if (jugador.isAlive()) {

      boolean sincelulas = true;
      for (int i = 0; i < celulas.length; i++) {
        if (celulas[i].isAlive()) {
          sincelulas = false;
          break;
        }
      }

      if (sincelulas && escena.estado == JUGANDO && jugador.isAlive()) {
        escena.estado = GANO;
      }
    }
  }
}

void mousePressed() {
  if (escena.estado == INTRO) {
    escena.estado = JUGANDO;
  } 
  else if (escena.estado == PERDIO || escena.estado == GANO) {
    escena.estado = INTRO;
    iniciar();
  } 
  else {
    if (jugador.isAlive()) {
      sndtoque.play();
      //println("radio: " + jugador.r);
    }
  }
}

void mouseDragged() {
  if (jugador.isAlive()) {
    jugador.update(mouseX, mouseY);
  }
}

void keyPressed() {
  if (key == 'r') { //reset
    iniciar();
  }

  if (key == 'g') { //god mode
    jugador.setSize(156);
    jugador.alive = true;
  }

  if (key == 's') { //screenshot
    saveFrame("captura.png");
  }

  if (key == 'd') {
    DEBUG = !DEBUG;
    println("debug: " +  DEBUG);
    println("jugador: " + jugador.toString());
  }
}

