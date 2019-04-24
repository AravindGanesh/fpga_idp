int i=0, j=0;
void setup(){
  Serial.begin(9600);
  pinMode(12, OUTPUT);
  for(i=2; i<=9; i++){
    pinMode(i, INPUT);
  }
 
}

int d, digit=0, k;
int clk=HIGH;
int counter=0;
void loop(){
  digitalWrite(12, clk);
  clk=!clk;
  
  if(clk==HIGH){
    k=128;
    for(j=9; j>=2; j--){
      d=digitalRead(j);
      if(d==1){
        digit=digit+k;
      }
      k = k/2;
      //Serial.print(digit);
    }Serial.println(digit);
  }
  digit=0;
  delay(250);
}
