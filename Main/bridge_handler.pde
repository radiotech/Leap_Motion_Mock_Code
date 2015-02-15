
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
