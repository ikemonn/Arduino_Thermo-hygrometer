
#include <DHT.h>
#include <SPI.h>
#include <Ethernet2.h>

#define DHTTYPE DHT22
#define DHT22_PIN 7
DHT dht(DHT22_PIN, DHTTYPE);
// Ethernetシールドのmacアドレス
byte mac[] = { 0x90,0xA2,0xDA,0x10,0x67,0xBA };
// MacのローカルIP
char server[] = "192.168.1.9";    
// 自身のネットワークによって変更する
IPAddress ip(192, 168, 1, 2);
EthernetClient client;

unsigned long lastConnectionTime = 0;             
const unsigned long postingInterval = 30L * 1000L; 


void setup() {
  pinMode(DHT22_PIN, INPUT);
  Serial.begin(9600);
  
  delay(1000);
  Ethernet.begin(mac, ip);
  Serial.print("My IP address: ");
  Serial.println(Ethernet.localIP());
}

char ch[10];
char ct[10];

void loop()
{
  if (client.available()) {
    char c = client.read();
    Serial.write(c);
  }
  
  if (millis() - lastConnectionTime > postingInterval) {
    float h  = dht.readHumidity() ;
    float t  = dht.readTemperature();
    httpRequest(h, t);
  }
}


void httpRequest(float humid, float temp) {

  client.stop();

  if (client.connect(server, 3000)) {
    Serial.println("connecting...");
    Serial.println("humid is ");
    Serial.println(humid);
    Serial.println("temp is ");
    Serial.println(temp);

    client.print("GET ");
    client.print("/?h=");
    client.print(humid);
    client.print("&t=");
    client.print(temp);
    client.println(" HTTP/1.1");
    client.println("Host: 192.168.1.9");
    client.println("Connection: close");
    client.println();

    lastConnectionTime = millis();
  }
  else {
    Serial.println("connection failed");
  }
}
