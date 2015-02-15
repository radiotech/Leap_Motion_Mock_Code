float lastBlock = 0;
float levelChange = 0;

int space = 5;

float rot = 0;

float hSpeed = 3;
float lastVSpeed = -1;
float vSpeed = -1;
float vShift = 0;

float acceleration = .001;
float gravity = .5;

int pX;
int pY;
float pain = 0;

int blockSize;

void setup(){
  size(1000,600);
  blockSize = height/10;
  blocks.add(new Block(0,height,blockSize,blockSize,false));
  
  levels[0] = new Level(height/4*3);
  levels[1] = new Level(height/2);
  levels[2] = new Level(height/4);
  
  
  pX = height/2-blockSize/2;
  pY = width/4;
}

void draw(){
  background(0,255,0);
  
  rot = (float(mouseY)/height)*HALF_PI-QUARTER_PI;
  
  if(keyPressed){
    if(key == '1'){
      rot = -QUARTER_PI/2;
    }
    if(key == '2'){
      rot = 0;
    }
  }
  
  vShift = 0;
  hSpeed += acceleration;
  vSpeed -= gravity;
  
  pain+=abs(vSpeed-lastVSpeed)-gravity*2;
  if(pain < 0){
    pain = 0;
  }
  
  for (int i = 0; i < blocks.size(); i++) {
    if(blocks.get(i).x<pX+blockSize && blocks.get(i).x>pX-blockSize){
      if(blocks.get(i).y<pY+blockSize && blocks.get(i).y>pY-blockSize){
        vSpeed = 0;
        if(blocks.get(i).y<pY){
          vShift = pY-(blocks.get(i).y+blockSize);
        } else {
          vShift = pY-(blocks.get(i).y-blockSize);
        }
      }
    }
  }
  
  for (int i = 0; i < bridges.size(); i++) {
    if(rot<=0){
      if(pX+blockSize>bridges.get(i).x-blockSize/2 && pX<bridges.get(i).x+(bridges.get(i).w*cos(rot))){
        blocks.get(0).move(pX,bridges.get(i).y+  (bridges.get(i).w*sin(rot)) * (pX-bridges.get(i).x)  /  (bridges.get(i).w*cos(rot))  );
      }
    }
  }
  
  
  for (int i = 0; i < levels.length-1; i++) {
    levels[i].move(i);
  }
  for (int i = 0; i < bridges.size(); i++) {
    bridges.get(i).move(i);
  }
  for (int i = 0; i < blocks.size(); i++) {
    blocks.get(i).move(i);
  }
  for (int i = 0; i < enemies.size(); i++) {
    enemies.get(i).move(i);
  }
  for (int i = 0; i < items.size(); i++) {
    items.get(i).move(i);
  }
  lastBlock -= hSpeed;
  
  if(lastBlock+blockSize<width){
    updateLevels();
    for (int i = 0; i < levels.length-1; i++) {
      levels[i].update(i);
    }
    lastBlock = lastBlock+blockSize;
  }
  
  for (int i = 0; i < bridges.size(); i++) {
    bridges.get(i).render();
  }
  for (int i = 0; i < blocks.size(); i++) {
    blocks.get(i).render();
  }
  for (int i = 0; i < enemies.size(); i++) {
    enemies.get(i).render();
  }
  for (int i = 0; i < items.size(); i++) {
    items.get(i).render();
  }
  
  if(pain*3>255){
    fill(pain*3,0,0);
  } else {
    fill(pain*3,0,255);
  }
  noStroke();
  ellipseMode(CORNER);
  ellipse(pX,pY,blockSize*1.25,blockSize*1.25);
}

void mousePressed(){
  if(mouseY>height/2){
    for (int i = 0; i < enemies.size(); i++) {
      if(enemies.get(i).x>pX){
        enemies.get(i).type -= 1;
      }
    }
  }
}

void keyPressed(){
  if(key == '3'){
    for (int i = 0; i < enemies.size(); i++) {
      if(enemies.get(i).x>pX){
        enemies.get(i).type -= 1;
      }
    }
  }
  
}
