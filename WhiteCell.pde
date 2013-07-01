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
 * Add physics
 
 */

//General configurations
int CANTIDAD = 12;
float CRECIMIENTO = 0.20, DECRECIMIENTO = 0.35;
float MINRADIO = 25, MAXRADIO = 50;
//float LIMRADIO = 7.5;
float PLAYERRADIO = 30;
float ANGULO = 0;

PImage fondo, escombro;
PImage celula, celulaAzul, celulaRoja, celulaVerde;

Celula jugador;
Celula[] celulas = new Celula[CANTIDAD];

Maxim maxim;
AudioPlayer sndcol, sndtoque, sndmusica, sndmorir;

Escena escena = new Escena();

void setup() {
  size(600, 600);
  frameRate(25);
  smooth();

  maxim = new Maxim(this);

  //musica = maxim.loadFile("musica.wav");
  sndcol = maxim.loadFile("colision.wav");

  sndtoque = maxim.loadFile("toque.wav");
  sndmorir = maxim.loadFile("morir.wav");

  sndcol.setLooping(false);
  sndtoque.setLooping(false);
  sndmorir.setLooping(false);

  sndcol.volume(2);
  sndmorir.volume(2.5);

  fondo = loadImage("fondo.jpg");

  escombro = loadImage("noise.png");
  escombro.resize(height*2, height*2);
  escombro.filter(BLUR, 3);

  celula = loadImage("cell.png");
  celula.filter(DILATE);
  //celula.filter(DILATE);

  iniciar();
}

void iniciar() {
  //TODO: que no choquen las celulas al ponerlas en la escena
  jugador = new Celula(width/2, height/2, PLAYERRADIO, true, true);
  //println(escena.estado + ", " + jugador.isAlive());
  for (int i = 0; i < celulas.length; i++) {
    celulas[i] = new Celula(random(0+MAXRADIO, width-MAXRADIO), random(0+MAXRADIO, height-MAXRADIO), random(MINRADIO, MAXRADIO), true, false);
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
      //Draw the cells
      celulas[i].draw();
    }

    //Some stuff (transparent noise) floating arround
    pushMatrix();
    imageMode(CENTER);
    translate(width/2, height/2);
    rotate(cos(ANGULO));
    image(escombro, 0, 0);
    popMatrix();  

    jugador.draw();
    ANGULO += 0.0007;
  }
}

void checkGamestate() {
  if (escena.estado == JUGANDO) {
    if (!jugador.isAlive()) {

      escena.estado =  PERDIO;
    } else if (jugador.isAlive()) {

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
  } else if (escena.estado == PERDIO || escena.estado == GANO) {
    escena.estado = INTRO;
    iniciar();
  } else {
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
    jugador.r = 70;
    jugador.alive = true;
  }

  if (key == 's') { //screenshot
    saveFrame("captura.png");
  }
}

