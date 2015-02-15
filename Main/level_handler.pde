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
