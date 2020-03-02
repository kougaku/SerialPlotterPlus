boolean isStop = false;
Graph graph;

JTextArea area;
ArrayList<String> textBuf =  new ArrayList<String>();
String SETTING_FILE_NAME = "settings.txt";
SerialSetting ss;
int textBufLines = 200;

void setup() {  
  size(800, 404);

  graph = new Graph(800, 280);
  surface.setTitle("Serial Plotter Plus");
  textFont(loadFont("Fabiolo-SmallCap-Semibold-48.vlw"));

  // load setting file
  String[] stg = loadStrings(SETTING_FILE_NAME);
  if ( stg == null ) {
    stg = new String [2];
    stg[0] = "";
    stg[1] = "9600";
  }
  ss = new SerialSetting( this, 580, 302, stg[0], int(stg[1]) );

  // log text area
  Canvas canvas =(Canvas)surface.getNative();
  JLayeredPane pane =(JLayeredPane)canvas.getParent().getParent();
  area = new JTextArea();
  area.setMargin(new Insets(5, 5, 5, 5));
  area.setBackground(Color.BLACK);
  area.setForeground(Color.WHITE);
  area.setEditable(false);
  area.setLineWrap(true);
  area.setWrapStyleWord(true);  
  JScrollPane scrollPane = new JScrollPane(area);
  scrollPane.setBounds(10, 302, 550, 90);
  pane.add(scrollPane);
}

synchronized void draw() {
  background(220);

  // draw graph
  pushMatrix();
  translate( 0, 10 );
  graph.draw();
  if (isStop) {
    fill(0);
    textSize(20);
    text("STOP", 755, 385 );
  }
  popMatrix();

  // update textarea
  if ( !isStop ) {
    String out = "";
    for ( String s : textBuf ) {
      out += s;
    }
    area.setText(out);
  }
}

void dispose() {  
  // save setting file
  String[] stg = { ss.current_port, "" + ss.current_rate };
  saveStrings( SETTING_FILE_NAME, stg );
  exit();
}

synchronized void serialEvent(Serial port) {
  if ( port.available() > 0 ) {
    String recv = port.readStringUntil('\n');
    if ( recv != null && !isStop ) {
      textBuf.add(recv);
      if ( textBuf.size() > textBufLines ) {
        textBuf.remove(0);
      }
      String[] strs = split(recv, ",");
      int n = strs.length;

      if ( n > 0 ) {
        int[] values = new int [n];
        for ( int i=0; i<n; i++ ) {
          values[i] = int(trim(strs[i]));
        }
        graph.setValue(values);
      }
    }
  }
}

void mousePressed() {
  if ( mouseButton == LEFT && graph.isMouseOver() ) {
    isStop = !isStop;
  }
}

void mouseDragged() {
  if ( mouseButton == RIGHT ) {
    graph.slide(pmouseX - mouseX);
  }
}

void mouseWheel(MouseEvent event) {
  float c = event.getCount();
  if ( c < 0 ) graph.scale( 1.5 );
  if ( c > 0 ) graph.scale( 0.7 );
}
