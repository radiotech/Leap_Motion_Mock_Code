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
