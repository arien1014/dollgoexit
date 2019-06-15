PImage[] runDolls = new PImage[8];
PImage[] runHumans = new PImage[3];
PImage bg,dialog,dialogRed,endHuman,blood,bloodDoll,word1,word2,word3;

boolean[] keys = new boolean[2];
Player p1 = new Player( 100, 670 );
PVector location, velocity;
String lastKey;

int humanX,humanY;

int currentFrame;
int numFrames=3;
import processing.video.*;
import ddf.minim.*;
Movie movie;
Movie endMovie;
Minim minim;
AudioPlayer song;
int gameTimer,endTimer;


void setup(){
  imageMode(CENTER);
  size( 1000, 1000 );
  frameRate(10);
  bg = loadImage( "img/bg.png" );
  
  //DIALOG
  dialog = loadImage( "img/dialog.png" );
  dialogRed = loadImage( "img/dialogRed.png" );
  
  //DOLL WALKING
  for (int i=0; i<8; i++){
    runDolls[i] = loadImage("img/runDoll" + (i+1) + ".png");
  }
  blood = loadImage("img/blood.png");
  bloodDoll = loadImage("img/bloodDoll.png");
  keys[0] = false;
  keys[1] = false;
  lastKey = "RIGHT";
  
  //HUMAN WALKING
  currentFrame = 0;
  for (int i=0; i<numFrames; i++){
    runHumans[i] = loadImage("img/runHuman" + (i+1) + ".png");
  }
  endHuman = loadImage( "img/endHuman.png" );
  humanX=900;
  humanY=670;
  
  //MOVIE
  movie = new Movie(this, "hit.mov");
  endMovie = new Movie(this, "end.mov");
  gameTimer = 20;
  endTimer = 20;
  
  //SONG
  minim = new Minim(this);
  song = minim.loadFile("streetSound.mp3");
  song.play();
  
  word1 = loadImage("img/word1.png");
  word2 = loadImage("img/word2.png");
  word3 = loadImage("img/word3.png");

}

void movieEvent(Movie m) {
  m.read();
}

void draw(){
  
  background(0);
  image( bg, width/2, height/2 );
  
  //BLACKLIGHT
  loadPixels();
  for (int x = 0; x < bg.width; x++ ) {
    for (int y = 0; y < bg.height; y++ ) {
      int loc = x + y*bg.width;
      float r = red (bg.pixels[loc]);
      float g = green (bg.pixels[loc]);
      float b = blue (bg.pixels[loc]);
      float distance = dist(x,y,location.x+10,location.y+10);
      float adjustBrightness = map(distance, 0,150,1,0);
      r *= adjustBrightness;
      g *= adjustBrightness;
      b *= adjustBrightness;
      r = constrain(r,0,255);
      g = constrain(g,0,255);
      b = constrain(b,0,255);
      color c = color(r,g,b);
      pixels[loc] = c;
    }
  }
  updatePixels();  
  
  //PLAYER
  p1.drawPlayer();
  p1.loopFrame();
  p1.movePlayer();
  p1.constrainPlayer();
  
  //HUMAN
  int i = (currentFrame ++) % numFrames;
  image(runHumans[i], humanX, humanY);
  
  //MOVIE
  if(location.x+50>=humanX){
  movie.play();
  image(movie, 500, 500,width,height);
  }
  if (movie.time() == movie.duration()) { 
    image(bg,width/2, height/2);
    image(endHuman,humanX,humanY);
    image(blood,800,670);
    image(bloodDoll,800,670);
    gameTimer--;
  }
  if(gameTimer<=0){
    image(dialog,width/2,150);
    text(".........",100,100);
    endTimer--;
  }
  if(endTimer<=0){
    gameTimer=3;
    endMovie.play();
    image(endMovie, 500, 500,width,height);
  }
  
  //DIALOG
  if(location.x>=200 && location.x<=250){
    image(dialog,width/2,150);
    image(word1,350,100);
  }
  
  if(location.x>=500 && location.x<=550){
    image(dialog,width/2,150);
    image(word2,350,100);
  }
  
  if(location.x>=750 && location.x<=800){
    image(dialogRed,width/2,150);
    image(word3,350,100);
  }
}



void keyPressed(){
  if( key == CODED ){
    if( keyCode == LEFT ){
      keys[0] = true;
      lastKey = "LEFT";
    }
    if( keyCode == RIGHT ){
      keys[1] = true;
      lastKey = "RIGHT";
    }
  }
}

void keyReleased(){
  if(key == CODED){
    if(keyCode == LEFT){
      keys[0] = false;
    }
    if(keyCode == RIGHT){
      keys[1] = false;
    }
  }
}
