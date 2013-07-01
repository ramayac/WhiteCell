/**
  The cell class, made for WhiteCell
  Made by @ramayac
*/
//Colors came from > https://kuler.adobe.com/explore/most-favorite/?time=month

//color COMESTIBLE = #B3FF00, NOCOMESTIBLE = #FD012A, JUGADOR = #007BFD, TOQUE = #6EBFFF;
color 
COMESTIBLE = #FFC9C1, 
NOCOMESTIBLE = #CC535A, 
JUGADOR = #FFFFFF, 
TOQUE = #9CFFFE;

color[] paleta = {
  //Paleta "cancer"
  #4D4361, #423A38, #806B53, #8C745E, #7F9179, #7F9179
  //Paleta "normal"
  //#35203B, #AB1452, #CF3B26, #F7B522, #8CF226
};

class Celula {
  PImage img;
  PVector p;
  float r;
  boolean alive = true, encolision = false;
  color miestado = #FFFFFF, micolor = #FFFFFF;
  int transparencia = 220;
  float angulo = 0;
  float rotacion = 0.01;

  Celula(float x, float y, float r, boolean sprite, boolean player) {
    p = new PVector(x, y);
    this.r = r;
    this.alive = true;
    
    if(sprite){
      //img = new PImage();
      //img.copy(celula, 0, 0, celula.width, celula.height, 0, 0, celula.width, celula.height);
      img = celula;
      angulo = random(0, 360);
      rotacion = random(-1, 1);
      
      if(player){
        micolor = JUGADOR;
        miestado = JUGADOR;
      } else {
        //micolor = color(random(106, 110), random(21, 191), random(204, 255));
        int i = (int)random(0, paleta.length);
        micolor = paleta[i]; //i; 
        //miestado = se queda blanco
      }
    }
  }

  Celula(float x, float y, float r) {
    p = new PVector(x, y);
    this.r = r;
  }

  void update(float x, float y) {
    p.x = x;
    p.y = y;
  }

  void draw() {
    if (isAlive() == false) return;
    float o = map(r, 0, 150, 180, 255);
    
    if(img != null){     
      angulo += rotacion;
      if(angulo > 360){
        angulo = 0;
      } else if (angulo < 0){
        angulo = 360;
      }
      
      //translate(p.x, p.y);
      pushMatrix();
        //imageMode(CENTER);
        //tint(mycolor, o);
        tint(this.micolor, o);
        translate(p.x, p.y);
        rotate(radians(angulo));
        //image(this.img, p.x, p.y, r*2, r*2);
        image(this.img, 0, 0, r*2, r*2);
      popMatrix();
      noTint();
      
      noFill();
    } else {
      fill(this.micolor, o);
    }
    
    if(encolision){
      borde(TOQUE);
    } else {
      borde(this.miestado);
    }
  }
  
  void borde(color c){
    stroke(c);
    strokeWeight(2);
    ellipse(p.x, p.y, r*2, r*2);
  }

  void comparar(Celula o) {
    if (this.r < o.r) {
      this.miestado = COMESTIBLE;
    } 
    else {
      this.miestado = NOCOMESTIBLE;
    }
  }

  void crece() {
    this.r += CRECIMIENTO;
    sndcol.play();
  }

  void disminuye(Celula o) {
    this.r -= DECRECIMIENTO;
    if (r < (o.r/3)) {
      this.r=0;
      //this.alive = false;
      this.isAlive();
    }
  }

  void setColision(boolean b){
    this.encolision = b;
  }

  void setAlive(boolean b){
   this.alive = b; 
  }

  boolean isAlive() {
    if(this.r <= 0 && this.alive) { 
      this.alive = false;
      //println("Se murio :(");
      sndmorir.play();
    }
    return this.alive;
  }
} 

void colision(Celula a, Celula o) {
  boolean col = circle_collision(a.p.x, a.p.y, a.r, o.p.x, o.p.y, o.r);
  if (col) { 
    if(a.isAlive() && o.isAlive()){
      if (a.r >= o.r) {
          o.disminuye(a);
          a.crece();
      } else { //a.r < = o.r
          a.disminuye(o);
          o.crece();
      }
      a.setColision(true);
      o.setColision(true);
    }
  } else {
    a.setColision(false);
    o.setColision(false);
  }
  
}

boolean circle_collision(float x_1, float y_1, float radius_1, float x_2, float y_2, float radius_2) {
  //println("distancia: " + dist(x_1, y_1, x_2, y_2) + ", radio: " + (radius_1 + radius_2));
  return dist(x_1, y_1, x_2, y_2) < radius_1 + radius_2;
}

