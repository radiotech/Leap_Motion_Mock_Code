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
ArrayList<Block> blocks = new ArrayList<Block>();

class Block {
  float x;
  float y;
  int w;
  int h;
  boolean visible = true;
  
  Block(float tx, float ty, int tw, int th){
    x = tx;
    y = ty;
    w = tw;
    h = th;
  }
  
  Block(float tx, float ty, int tw, int th, boolean a){
    x = tx;
    y = ty;
    w = tw;
    h = th;
    visible = a;
  }
  
  void move(int self){
    x-=hSpeed;
    y+=vSpeed+vShift;
    if(visible){
      if(ceil(x+blockSize*2)<0){
        blocks.remove(self);
      }
    }
  }
  
  void move(float tx, float ty){
    x=tx;
    y=ty;
  }
  
  void render(){
    if(visible){
      noStroke();
      fill(0);
      rect(x,y,w+hSpeed,h);
    }
  }
}

ArrayList<Bridge> bridges = new ArrayList<Bridge>();

class Bridge {
  float x;
  float y;
  int w;
  int h;
  
  Bridge(float tx, float ty, int tw, int th){
    x = tx;
    y = ty;
    w = tw;
    h = th;
  }
  
  void move(int self){
    x-=hSpeed;
    y+=vSpeed+vShift;
    if(x+w<0){
      bridges.remove(self);
      
      for (int i = 0; i < levels.length-1; i++) {
        if(abs(levels[i].y-(pY+blockSize))<blockSize*2){
          changeLevel(i);
        }
      }
      
      
    }
  }
  
  void render(){
    stroke(100);
    strokeWeight(h);
    if(rot<=0){
      line(x,y+h/2,x+w*cos(rot),y+h/2+w*sin(rot));
    }
  }
}
ArrayList<Enemy> enemies = new ArrayList<Enemy>();

class Enemy {
  float x;
  float y;
  int type;
  
  Enemy(float tx, float ty, int t){
    x = tx;
    y = ty;
    type = t;
  }
  
  void move(int self){
    x-=hSpeed;
    y+=vSpeed+vShift;
    if(x+blockSize < 0 || type < 0){
      enemies.remove(self);
      items.add(new Item(x+blockSize/4,y,1));
    }
  }
  
  void render(){
    noStroke();
    fill(255,0,0);
    ellipseMode(CORNER);
    ellipse(x,y-blockSize*(1+float(type)/2),blockSize,blockSize*(1+float(type)/2));
  }
}
ArrayList<Item> items = new ArrayList<Item>();

class Item {
  float x;
  float y;
  int type;
  
  Item(float tx, float ty, int t){
    x = tx;
    y = ty;
    type = t;
  }
  
  void move(int self){
    x-=hSpeed;
    y+=vSpeed+vShift;
    if(x+blockSize<0){
      items.remove(self);
    }
    
    if(abs(x-pX)<blockSize){
      if(abs((y-blockSize)-pY)<blockSize){
        items.remove(self);
      }
    }
  }
  
  void render(){
    noStroke();
    fill(255,255,0);
    ellipseMode(CORNER);
    ellipse(x,y-blockSize/2,blockSize/2,blockSize/2);
  }
}
//ArrayList<Level> levels = new ArrayList<Level>();
Level[] levels = new Level[4]; 

int obstacle = 1;
int pauseLength = -1;
int nextPause = 10;

class Level {
  
  boolean active = true;
  float y;
  
  Level(float ty){
    y = ty;
  }
  
  void move(int self){
    y+=vSpeed+vShift;
  }
  
  void update(int self){
    if(pauseLength < 0 || self == 0){
      if(active){
        blocks.add(new Block(floor(lastBlock+blockSize),y,blockSize,blockSize));
        
        if(random(100)<2){
          enemies.add(new Enemy(floor(lastBlock+blockSize),y,floor(random(5))));
        }
      }
      
      if(nextPause == 0){
        if(self == 1){
          bridges.add(new Bridge(floor(lastBlock+blockSize*2),y,blockSize*8,blockSize));
        }
        active = true;
        if(self == 1 && obstacle == 1){
          active = false;
        }
        if(self == 2 && obstacle == 2){
          active = false;
        }
      }
    }
  }
  
}

void updateLevels(){
  if(pauseLength < 0){
    if(bridges.size()>0 && nextPause > 0){
      nextPause++;
    }
    nextPause--;
    if(nextPause < 0){
      obstacle = floor(random(3));
      pauseLength = 6;
      //bridges.add(new Bridge(floor(lastBlock+blockSize*2),y,blockSize*8,blockSize));
      nextPause = 1+floor(random(30));
    }
  } else {
    pauseLength--;
  }
  
}

void changeLevel(int tLevel){
  
  switch(tLevel){
    case 2:
    //move down one
    
    levels[0].y = height/4;
    levels[0].active = false;
    
    levels[3] = levels[0];
    levels[0] = levels[1];
    levels[1] = levels[2];
    levels[2] = levels[3];
    
    
    break;
    case 1:
    //stay
    break;
    case 0:
    //move up one
    
    levels[2].y = height/4*3;
    levels[2].active = false;
    
    levels[3] = levels[2];
    levels[2] = levels[1];
    levels[1] = levels[0];
    levels[0] = levels[3];
    
    
    
    break;
  }
  
  
  
}

