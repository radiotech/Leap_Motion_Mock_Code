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
