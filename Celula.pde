/**
 The cell class, made for WhiteCell
 Made by @ramayac
 */

class Celula extends FCircle {
  PImage img;
  //PVector p;
  boolean alive = true, encolision = false;
  color miestado = #FFFFFF, micolor = #FFFFFF;
  int transparencia = 220;
  float angulo = 0;
  float rotacion = 0.01;
  final float GRAVEDAD = 40;

  Celula(float x, float y, float r) {
    this(x, y, r, false, false);
    //println(x + ", " + y + ", " + r);
  }

  Celula(float x, float y, float r, boolean sprite) {
    this(x, y, r, sprite, false);
    //println(x + ", " + y + ", " + r + "," + sprite);
  }

  Celula(float x, float y, float r, boolean sprite, boolean player) {
    super(r*2);
    //println(x + ", " + y + ", " + r*2 + "," + sprite + "," + player);
    setPosition(x, y);    

    this.alive = true;
    setGrabbable(player);

    if (sprite) {
      img = celula;
      attachImage(img);

      angulo = random(0, 360);
      rotacion = random(-1, 1);

      if (player) {
        micolor = JUGADOR;
        miestado = JUGADOR;
        setRotatable(false);
        //setStatic(true);
      } 
      else {
        //micolor = color(random(106, 110), random(21, 191), random(204, 255));
        int i = (int)random(0, paleta.length);
        micolor = paleta[i]; //i; 
        //miestado = se queda blanco
      }
    }
  }

  void update(float x, float y) {
    this.setPosition(x, y);
    this.setVelocity(0, 0);
  }

  void draw(processing.core.PGraphics applet) {
    //void draw() {
    if (isAlive() == false) return;
    float o = map(getSize(), 0, 300, 180, 255);
    //float o = map(getSize(), 0, 150, 180, 255);

    if (img != null) {     
      angulo += rotacion;
      if (angulo > 360) {
        angulo = 0;
      } 
      else if (angulo < 0) {
        angulo = 360;
      }

      pushMatrix();
      //imageMode(CENTER);
      //tint(mycolor, o);
      tint(this.micolor, o);
      translate(getX(), getY());
      rotate(radians(angulo));
      image(this.img, 0, 0, this.getSize(), this.getSize());
      popMatrix();
      noTint();

      noFill();
    } 
    else {
      fill(this.micolor, o);
    }

    if (encolision) {
      borde(TOQUE);
    } 
    else {
      borde(this.miestado);
    }
  }

  void borde(color c) {
    stroke(c);
    strokeWeight(2);
    ellipse(getX(), getY(), getSize(), getSize());
  }

  void comparar(Celula o) {
    if (getSize() < o.getSize()) {
      this.miestado = COMESTIBLE;
    } 
    else {
      this.miestado = NOCOMESTIBLE;
    }
  }

  void crece() {
    float s = getSize();
    s += CRECIMIENTO;
    setSize(s);
    setDensity(s/100);

    sndcol.play();
  }

  void disminuye(Celula o) {
    float s = getSize();
    s -= DECRECIMIENTO;
    setSize(s);
    setDensity(s/100);

    if (s < (o.getSize()/3)) {
      setSize(0);
      this.isAlive();
    }
  }

  void setColision(boolean b) {
    this.encolision = b;
  }

  void setAlive(boolean b) {
    this.alive = b;
  }

  boolean isAlive() {
    if (getSize() <= 0 && this.alive) { 
      this.alive = false;
      sndmorir.play(); //Se murio :(
    }
    return this.alive;
  }

  String toString() {
    return "angulo: " + angulo + ", rotacion: " + rotacion + ", size: " + getSize() + ", alive: " + alive
      + ", drawable: " + isDrawable() + ", x: " + getX()  + ", y: " + getY();
  }
} 

void colision(Celula a, Celula o) {
  boolean col = a.isTouchingBody(o);
  //boolean col = circle_collision(a.p.x, a.p.y, a.r, o.p.x, o.p.y, o.r);
  if (col) { 
    if (a.isAlive() && o.isAlive()) {
      if (a.getSize() >= o.getSize()) {
        o.disminuye(a);
        a.crece();
      } 
      else { //a.r < = o.r
        a.disminuye(o);
        o.crece();
      }
      a.setColision(true);
      o.setColision(true);
    }
  } 
  else {
    a.setColision(false);
    o.setColision(false);
  }
}

/* Old school colision
boolean circle_collision(float x_1, float y_1, float radius_1, float x_2, float y_2, float radius_2) {
 //println("distancia: " + dist(x_1, y_1, x_2, y_2) + ", radio: " + (radius_1 + radius_2));
 return dist(x_1, y_1, x_2, y_2) < radius_1 + radius_2;
 }*/
