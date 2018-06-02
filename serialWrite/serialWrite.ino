void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
}

// the loop routine runs over and over again forever:
void loop() {
  // read the input on analog pin 0:
  int sensorValue = analogRead(A0);
  //8 byte can only store up to 255 worth of data
  sensorValue = map(sensorValue, 0, 1024, 0, 255);
  // print out the value you read:
  Serial.write(sensorValue);
  //Convert binary data into Ascii. 
  //Debugging only! Don't use on actual code!
  //Serial.println(sensorValue);
  delay(1000); // delay in between reads for stability
}
