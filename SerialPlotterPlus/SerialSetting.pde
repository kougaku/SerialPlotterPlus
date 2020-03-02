import processing.awt.*;
import java.awt.*;
import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import processing.serial.*;

class SerialSetting {
  final int COMBO_PORT_WIDTH  = 100;
  final int COMBO_PORT_HEIGHT = 20;
  final int COMBO_RATE_WIDTH  = 80;
  final int COMBO_RATE_HEIGHT = 20;  
  final Integer[] list_rate = {300, 1200, 2400, 4800, 9600, 14400, 19200, 28800, 38400, 57600, 115200, 230400, 250000, 500000, 1000000, 2000000};  
  String[] list_port = null;

  JComboBox combo_port;
  JComboBox combo_rate;
  String current_port = null;
  int    current_rate = 0;

  Serial serial = null;
  PApplet parent = null;

  SerialSetting(PApplet app, int x, int y, String default_port, int default_rate) {
    parent = app;
    String[] list_port = Serial.list();

    Canvas canvas =(Canvas)surface.getNative();
    JLayeredPane pane =(JLayeredPane)canvas.getParent().getParent();

    // combobox(port)
    combo_port = new JComboBox(list_port);
    combo_port.addActionListener( new SelectActionListener() );
    combo_port.setBounds( x, y, COMBO_PORT_WIDTH, COMBO_PORT_HEIGHT);
    pane.add(combo_port);

    // combobox(rate)
    combo_rate = new JComboBox(list_rate);
    combo_rate.addActionListener( new SelectActionListener() );
    combo_rate.setBounds(x + COMBO_PORT_WIDTH + 15, y, COMBO_RATE_WIDTH, COMBO_RATE_HEIGHT);
    pane.add(combo_rate);

    // select items
    combo_port.setSelectedItem(default_port);
    combo_rate.setSelectedItem(default_rate);    
    combo_port.updateUI();
    combo_rate.updateUI();
  }
  
  class SelectActionListener implements ActionListener {
    @Override
      public void actionPerformed(ActionEvent e) {

      // update params
      current_port = (String)combo_port.getItemAt(combo_port.getSelectedIndex());
      current_rate = (int)combo_rate.getItemAt(combo_rate.getSelectedIndex());      

      // connect
      if ( serial != null ) {
        serial.stop();
      }
      if ( current_port != null ) {
        serial = new Serial(parent, current_port, current_rate );
      }
    }
  }
}
