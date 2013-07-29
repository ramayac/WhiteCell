/**
 The Scene selector
 Made by @ramayac
 */
final int INTRO = 0, JUGANDO = 1, GANO = 2, PERDIO = 3;

class Escena{

  int estado = INTRO;
  float angulo = 0, rotacion = 0.1;
  
  String txt_intro = "You have a disease, destroy it.";
  String txt_ganar = "You are healty again!";
  String txt_perder = "The disease is stronger than you are.";
  
  /*void estado(int e){
    estado = e;
  }*/
  
  boolean draw(){
    switch(this.estado){
      case INTRO:
        drawIntro();
        break;
      case JUGANDO:
        return true;
      case GANO:
        drawWin();
        break;
      case PERDIO:
        drawLose();
        break;
      default:
        this.estado = INTRO;
    }
    return false;
  }
  
  void drawIntro(){
    rotacion();
    background(41);
    
    fill(255, 200);
    float t = textWidth(txt_intro);
    text(txt_intro, width/2 - t/2, height/2);

    /*pushMatrix();
      translate(0, 0);
      imageMode(CORNER);
      //rotate(radians(this.angulo));
      image(celula, 0, 0, 160, 160);
    popMatrix();*/

    pushMatrix();
      translate(width/2, 0);
      imageMode(CENTER);
      noTint();
      rotate(radians(this.angulo));
      image(celula, 0, 0);
    popMatrix();

  }
  
  void rotacion(){
    angulo += rotacion;
    if(angulo > 360){
      angulo = 0;
    } else if (angulo < 0){
      angulo = 360;
    }
  }
  
  void drawWin(){
    rotacion();
    background(#227864);
    
    fill(255, 200);
    float t = textWidth(txt_ganar);
    text(txt_ganar, width/2 - t/2, height/2);

    pushMatrix();
      translate(width/2, 0);
      imageMode(CENTER);
      rotate(radians(this.angulo));
      tint(#227864);
      image(celula, 0, 0);
    popMatrix();
  }
  
  void drawLose(){
    rotacion();
    background(61, 0, 0);
    
    fill(255, 200);
    float t = textWidth(txt_perder);
    text(txt_perder, width/2 - t/2, height/2);

    pushMatrix();
      translate(width/2, 0);
      imageMode(CENTER);
      rotate(radians(this.angulo));
      tint(41, 0, 0);
      image(celula, 0, 0);
    popMatrix();
  }
}
