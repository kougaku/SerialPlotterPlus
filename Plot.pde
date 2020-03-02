public class Plot {
  final int BUF_SIZE = 800;

  int minValue;
  int maxValue;  
  float width;
  float height;
  float scaleX = 1.0;

  int[] ringBuf = new int [BUF_SIZE];
  int head;
  int tail;

  Plot(int min, int max, float w, float h) {
    minValue = min;
    maxValue = max;
    this.width = w;
    this.height = h;
    head = 0;
    tail = ringBuf.length - 1;
  }

  void setRange(int min, int max) {
    minValue = min;
    maxValue = max;
  }

  void setScaleX(float sx) {
    scaleX  = sx;
  }

  void setValue(int value) {   
    head = ( head + 1 ) % ringBuf.length;
    tail = ( tail + 1 ) % ringBuf.length;    
    ringBuf[tail] = value;
  }

  void draw() {
    PVector prev = calcPoint(0);
    for (int i=1; i<ringBuf.length; i++) {
      PVector pos = calcPoint(i);
      line(prev.x, prev.y, pos.x, pos.y);
      if ( scaleX > 10 ) {
        pushStyle();
        fill(255);
        noStroke();
        ellipse( prev.x, prev.y, 5, 5 );
        if ( scaleX > 25.0 ) {
          if ( pos.y > 20 ) {
            text( int(getValue(i)), pos.x-2, pos.y-7 );
          } else {
            text( int(getValue(i)), pos.x-2, pos.y+22 );
          }
        }
        popStyle();
      }
      prev = pos;
    }
  }

  int getValue(int i) {
    int k = (head + i) % ringBuf.length;
    return ringBuf[k];
  }

  PVector calcPoint(int i) {
    float sx = map( i, 0, ringBuf.length-1, 0, scaleX * this.width );
    float sy = map( getValue(i), minValue, maxValue, this.height, 0.0 );
    return new PVector(sx, sy);
  }
}
