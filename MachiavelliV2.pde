import ddf.minim.*;
import ddf.minim.analysis.*;


int h = 1000, w = 1000;
int boxDiameter =40;
int row = w/boxDiameter, col = h/boxDiameter;
float animate = 0;
float[][] z;

Minim minim;
AudioPlayer player;
BeatDetect beat;

float l = 0;

PImage img;
float eRadius = 20;

FFT fftLin;
FFT fftLog;

float height3;
float height23;
float spectrumScale = 4;


void setup(){
  size(800,800,P3D);
  z = new float[row][col];
  float yoffSet = 0;
  
  
  height3 = height/3;
  height23 = 2*height/3;
  


  //background(0);
  minim = new Minim(this);
  //player = minim.loadFile("01 - Open.mp3", 2048);
  //player = minim.loadFile("Red_new.mp3");
  player = minim.loadFile("02 - I Don't Trust Myself ( With Loving You ) (2).mp3");

 
  player.play();
  img = loadImage("1362065252_cover.jpg");
  beat = new BeatDetect();
  
   fftLin = new FFT( player.bufferSize(), player.sampleRate() );
  
  // calculate the averages by grouping frequency bands linearly. use 30 averages.
  fftLin.linAverages( 30 );

  
  
   for (int i = 0; i<row;i++){
     float xoffSet = 0;
    for(int j = 0; j<col; j++){
   z [j][i] = map(noise(xoffSet,yoffSet),0,1,-100,100);
    xoffSet +=0.1;
     
    
  } yoffSet +=0.1;
   }
}

void draw(){ 
  
  animate -= 0.01;
 
  float yoffSet = animate;
   for (int i = 0; i<row;i++){
     float xoffSet = 0;
    for(int j = 0; j<col; j++){
    z [j][i] = map(noise(xoffSet,yoffSet),0,1,-100,player.left.get(1));
    xoffSet +=0.1;
     
    
  } yoffSet +=0.1;
   }
  background(41,48,57);
  translate(w/2,w/2);
  rotateX(PI/3);
 translate(-w/2,-h/2);

  
  for (int i = 0; i<row-1;i++){
    strokeWeight(1);
    stroke(219,112,147);
    fill(41,48,57);
    beginShape(TRIANGLE_STRIP);
    for(int j = 0; j<col; j++){
      vertex(i*boxDiameter,j*boxDiameter,z[i][j]);
      vertex((i+1)*boxDiameter,j*boxDiameter,z[i+1][j]);
    }endShape();
  }
  
  
    frameRate(30);
 /*  if(key == 'a'){
   player.play();
 }*/
    println(frameRate);
  //background(47,79,79);
  stroke(47,79,79);
  stroke(255);
    textSize(20);
//text("Machiavelli", 100 + player.left.get(1)*8, 0+ player.left.get(1)*8); 
fill(255);
strokeWeight(3);  // Beastly
//image(img, width-100, height-100, 100, 100);

beat.detect(player.mix);

  
  // perform a forward FFT on the samples in jingle's mix buffer
  // note that if jingle were a MONO file, this would be the same as using jingle.left or jingle.right
  fftLin.forward( player.mix );


pointCircle();
stroke(0,255,200);
 translate(width/2, height/2);
 
  //point(x(l),y(l));
  for(int i = 0; i<10; i++){
  line(x1(l+i),y1(l+i),x2(l+i),y2(l+i));

  }
  l = l+ 0.2;
   stroke(219,112,147);
     for(int i = 0; i<10; i++){
  line(x1(l-i),y1(l-i),x2(l-i),y2(l-i));

  }
   translate(-width/2, -height/2);
   pointCircle3();
   stroke(255);
//scale(player.left.get(1)*10,player.left.get(1)*10);
pointCircle2();

 {
    noFill();
    for(int i = 0; i < fftLin.specSize(); i++)
    {
          stroke(219,112,147);
      translate(2,0);
      line(i, player.left.get(i)*8, i, player.right.get(i) * 8 + fftLin.getBand(i)*spectrumScale);
    }
        
    fill(255, 128);
   
  }

       //    saveFrame("####.tga");
      

    stroke(255);
    textSize(120);
//text("Machiavelli", - 900 + player.left.get(1)*8,  -300 + player.left.get(1)*8); 
fill(255);
strokeWeight(3);  // Beastly
}


void pointCircle()
{
   float x, y;
    int length = 150;
    float angle = 0.0;
    float angle_stepsize = 0.1;
    // go through all angles from 0 to 2 * PI radians
    while (angle < 2 * PI)
    {
        // calculate x, y from a vector with known length and angle
        x = length * cos (angle);
        y = length * sin (angle);
        
        point((x + width / 2) + player.left.get(1)*-3, (y + height / 2) + player.right.get(1)*-3);
        angle += angle_stepsize;

    }
  
    
}

void pointCircle2()
{
   float x, y;
    int length = 170;
    float angle = 0.0;
    float angle_stepsize = 0.1;
    // go through all angles from 0 to 2 * PI radians
    while (angle < 2 * PI)
    {
        // calculate x, y from a vector with known length and angle
        x = length * cos (angle);
        y = length * sin (angle);
        
        point((x + width / 2) + player.left.get(1)*10, (y + height / 2) + player.right.get(1)*10);
        angle += angle_stepsize;
 
    }
}

void pointCircle3()
{
   float x, y;
    int length = 170;
    float angle = 0.0;
    float angle_stepsize = 0.1;
    // go through all angles from 0 to 2 * PI radians
    while (angle < 2 * PI)
    {
        // calculate x, y from a vector with known length and angle
        x = length * cos (angle);
        y = length * sin (angle);
        
         point((x + width / 2) - player.left.get(1)*10, (y + height / 2) - player.left.get(1)*10);
        angle += angle_stepsize;
 
    }
}

float x1(float l){
  
  return sin(l/10)*100 + player.left.get(1)*10;
}

float y1(float l){
  return cos(l/2)*100 + sin(l/2)*3 + player.left.get(1)*10;
}

float x2(float l){
  
  return sin(l/3)*100 + player.right.get(1)*10;
}

float y2(float l){
  return sin(l/5)*75 + sin(l/2)*50 + player.right.get(1)*10;
}
