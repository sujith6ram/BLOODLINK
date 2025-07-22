#include <WiFi.h>
#include <HTTPClient.h>
#include <SPI.h>
#include <MFRC522.h>
#include <OneWire.h>
#include <DallasTemperature.h>

// WiFi credentials
#define WIFI_SSID "Galaxy M31D07A"
#define WIFI_PASSWORD "nqqd5512"

// Firebase URLs
#define FIREBASE_RFID_URL "https://iot-app-60d05-default-rtdb.firebaseio.com/rfid_data.json"
#define FIREBASE_TEMP_URL "https://iot-app-60d05-default-rtdb.firebaseio.com/TemperatureSensor.json"

// RFID Pinsqq/
#define SS_1  5    // RFID 1 SS pin
#define SS_2  17   // RFID 2 SS pin
#define SS_3  16   // RFID 3 SS pin
#define RST_PIN  22  // Common RST pin

// Temperature Sensor Pin
#define ONE_WIRE_BUS 4

// Initialize RFID readers
MFRC522 rfid1(SS_1, RST_PIN);
MFRC522 rfid2(SS_2, RST_PIN);
MFRC522 rfid3(SS_3, RST_PIN);

// Initialize OneWire & DallasTemperature for DS18B20
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

WiFiClient client;

void setup() {
    Serial.begin(115200);
    
    // Connect to WiFi
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.println("Connecting to WiFi...");
    }
    Serial.println("Connected to WiFi");

    // Initialize SPI for RFID readers
    SPI.begin();
    rfid1.PCD_Init();
    rfid2.PCD_Init();
    rfid3.PCD_Init();
    Serial.println("RFID Readers Initialized");

    // Initialize DS18B20 sensor
    sensors.begin();
}

// Function to check RFID and send data
void checkRFID(MFRC522 &rfid, const char* location) {
    if (!rfid.PICC_IsNewCardPresent() || !rfid.PICC_ReadCardSerial()) {
        return;
    }
    
    String detectedTag = "";
    for (byte i = 0; i < rfid.uid.size; i++) {
        detectedTag += String(rfid.uid.uidByte[i], HEX);
    }
    detectedTag.toUpperCase();

    Serial.print("Tag UID at ");
    Serial.print(location);
    Serial.print(": ");
    Serial.println(detectedTag);

    sendDataToFirebaseRFID(detectedTag, location);

    rfid.PICC_HaltA();
    rfid.PCD_StopCrypto1();
}

// Function to read and send temperature data
void checkTemperature() {
    sensors.requestTemperatures();
    float temperature = sensors.getTempCByIndex(0);

    Serial.print("Temperature: ");
    Serial.println(temperature);

    sendDataToFirebaseTemperature(temperature);
}

// Function to send RFID data to Firebase
void sendDataToFirebaseRFID(String rfidTag, String location) {
    if (WiFi.status() == WL_CONNECTED) {
        HTTPClient http;
        http.begin(FIREBASE_RFID_URL);
        http.addHeader("Content-Type", "application/json");

        String jsonPayload = "{ \"rfidTag\": \"" + rfidTag + "\", \"location\": \"" + location + "\" }";

        int httpResponseCode = http.POST(jsonPayload);
        if (httpResponseCode == 200) {
            Serial.println("RFID Data sent successfully!");
        } else {
            Serial.print("Error sending RFID data: ");
            Serial.println(httpResponseCode);
        }
        http.end();
    }
}

// Function to send temperature data to Firebase
void sendDataToFirebaseTemperature(float temperature) {
    if (WiFi.status() == WL_CONNECTED) {
        HTTPClient http;
        http.begin(FIREBASE_TEMP_URL);
        http.addHeader("Content-Type", "application/json");

        String jsonPayload = "{\"temperature\": " + String(temperature) + "}";

        int httpResponseCode = http.PUT(jsonPayload);
        if (httpResponseCode > 0) {
            Serial.print("Temperature Data sent successfully. Response: ");
            Serial.println(httpResponseCode);
        } else {
            Serial.print("Error sending temperature data: ");
            Serial.println(httpResponseCode);
        }
        http.end();
    }
}

void loop() {
    checkRFID(rfid1, "p");
    checkRFID(rfid2, "s");
    checkRFID(rfid3, "r");

    checkTemperature();

    delay(5000);  // Delay for 5 seconds before next cycle
}
