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
