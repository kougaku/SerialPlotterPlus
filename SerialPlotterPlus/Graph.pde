public class Graph {
  float width;
  float height;  
  int minValue = 0;
  int maxValue = 1023;
  float minScaleX = 1.0;
  float maxScaleX = 50.0;
  float scaleX  = 1.0;
  float offsetX = 0.0;
  PVector mouse;
  Plot[] plots;
  color[] colorTable = {
    #FF0000, #00FF00, #00FFFF
  };

  Graph(float w, float h) {
    this.width = w;
    this.height = h;    
    mouse = new PVector();
    plots = new Plot [1];
    plots[0] = new Plot( minValue, maxValue, this.width, this.height);
  }

  void setRange(int min, int max) {
    minValue = min;
    maxValue = max;
    for (Plot p : plots) {
      p.setRange(min, max);
    }
  }

  void scale(float s) {
    scaleX  = constrain( scaleX * s, minScaleX, maxScaleX );
    offsetX = constrain( offsetX, 0, this.width * scaleX - this.width );    
    for (Plot p : plots) {
      p.setScaleX(scaleX);
    }
  }

  void slide(int d) {
    offsetX = constrain( offsetX + d, 0, this.width * scaleX - this.width );
  }

  void setValue(int[] value) {
    int n = value.length;    
    if ( plots.length != n ) {
      plots = new Plot [n];
      for (int i=0; i<n; i++) {
        plots[i] = new Plot(minValue, maxValue, this.width, this.height);
      }
    }
    for (int i=0; i<value.length; i++) {
      plots[i].setValue(value[i]);
    }
  }

  void setValue(int value) {
    if ( plots.length != 1 ) {
      plots = new Plot [1];
      plots[0] = new Plot(minValue, maxValue, this.width, this.height);
    }
    plots[0].setValue(value);
  }

  void draw() {
    // --------------------------------------------------------------
    // background
    noStroke();
    fill(50);
    rect( 0, 0, this.width, this.height );

    // --------------------------------------------------------------
    // plot
    pushMatrix();
    translate(-offsetX, 0);  // offset
    for (int i=0; i<plots.length; i++) {
      stroke(colorTable[i%colorTable.length]);
      strokeWeight(2);
      plots[i].draw();
    }
    popMatrix();
    
    // ----------------------------------------------------
    // border line    
    mouse = screenToLocal(mouseX, mouseY);
    if ( mouse.y >= 0 && mouse.y < this.height ) {
      int v = (int)map( mouse.y, 0, this.height, maxValue, minValue );
      stroke(255, 255, 0);
      strokeWeight(2);
      line(0, mouse.y, this.width, mouse.y );
      fill(255, 255, 0);
      textSize(20);
      if ( mouse.y > 20 ) {
        text( v, mouse.x + 18, mouse.y - 5 );
      } else {
        text( v, mouse.x + 18, mouse.y + 20 );
      }
    }
  }

  boolean isMouseOver() {
    return ( 0 < mouse.x && mouse.x < this.width && 0 < mouse.y && mouse.y < this.height );
  }

  PVector screenToLocal(float x, float y) {
    PVector in = new PVector(x, y);
    PVector out = new PVector();
    PMatrix2D current_matrix = new PMatrix2D();
    getMatrix(current_matrix);  
    current_matrix.invert();
    current_matrix.mult(in, out);
    return out;
  }
}
