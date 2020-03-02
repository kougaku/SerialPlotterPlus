void setup() {
  Serial.begin(115200);
}

int t = 0;
void loop() {
  t++;
  int v1 = (int)(100 * sin(t * 0.02) + 512);
  int v2 = (int)(250 * sin(t * 0.02) + 512);
  int v3 = (int)(450 * sin(t * 0.02) + 512);  
  Serial.print(v1);  
  Serial.print(", ");
  Serial.print(v2);
  Serial.print(", ");
  Serial.print(v3);
  Serial.println();
}
