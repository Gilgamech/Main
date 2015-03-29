// ** MOSI - pin 11
// ** MISO - pin 12
// ** CLK - pin 13

#include <LiquidCrystal.h>
#include <SD.h>

// set up variables using the SD utility library functions:
Sd2Card card;
SdVolume volume;
SdFile root;
File myFile;

// change this to match your SD shield or module;
// Arduino Ethernet shield: pin 4
const int chipSelect = 4;
LiquidCrystal lcd(1, 6, 5, 0, 3, 2); // LCD input pins 4, 6, 11, 12, 13, 14

void setup() {
  // set up the LCD's number of columns and rows: 
  lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.setCursor(0, 0);
  lcd.print("Type  Vol   MB");
//  lcd.setCursor(0, 1);
//  lcd.print("volumesize");
  

  // Open serial communications and wait for port to open:
//  Serial.begin(9600);
//  Serial.print("\nInitializing SD card...");
//  lcd.setCursor(0, 0);
//  lcd.print("Initializing SD card...");
  // On the Ethernet Shield, CS is pin 4. It's set as an output by default.
  // Note that even if it's not used as the CS pin, the hardware SS pin 
  // (10 on most Arduino boards, 53 on the Mega) must be left as an output 
  // or the SD library functions will not work. 
  pinMode(10, OUTPUT);     // change this to 53 on a mega


  // we'll use the initialization code from the utility libraries
  // since we're just testing if the card is working!

  if (!card.init(SPI_HALF_SPEED, chipSelect)) {
  lcd.setCursor(0, 1);
  lcd.print("initialization failed.");
//    Serial.println("initialization failed. Things to check:");
//    Serial.println("* is a card is inserted?");
//    Serial.println("* Is your wiring correct?");
//    Serial.println("* did you change the chipSelect pin to match your shield or module?");
    return;
  } else {
      lcd.setCursor(0, 1);
  lcd.print("OK");
//   Serial.println("Wiring is correct and a card is present."); 
delay(500);
  }

  // print the type of card
//  Serial.print("\nCard type: ");
  switch(card.type()) {
    case SD_CARD_TYPE_SD1:
  lcd.setCursor(0, 1);
  lcd.print("SD1");
//      Serial.println("SD1");
      break;
    case SD_CARD_TYPE_SD2:
      lcd.setCursor(0, 1);
  lcd.print("SD2");
//      Serial.println("SD2");
      break;
    case SD_CARD_TYPE_SDHC:
      lcd.setCursor(0, 1);
  lcd.print("SDHC");
//      Serial.println("SDHC");
      break;
    default:
      lcd.setCursor(0, 1);
  lcd.print("UNK");
//      Serial.println("Unknown");
  }

  // Now we will try to open the 'volume'/'partition' - it should be FAT16 or FAT32
  if (!volume.init(card)) {
  lcd.setCursor(0, 1);
  lcd.print("No Card");
//    Serial.println("Could not find FAT16/FAT32 partition.\nMake sure you've formatted the card");
    return;
  }


  // print the type and size of the first FAT-type volume
  uint32_t volumesize;
  lcd.setCursor(5, 1);
  lcd.print("FAT");
  lcd.print(volume.fatType(), DEC);
//  Serial.print("\nVolume type is FAT");
//  Serial.println(volume.fatType(), DEC);
//  Serial.println();
  
  volumesize = volume.blocksPerCluster();    // clusters are collections of blocks
  volumesize *= volume.clusterCount();       // we'll have a lot of clusters
  volumesize *= 512;                            // SD card blocks are always 512 bytes
//  Serial.print("Volume size (bytes): ");
//  Serial.println(volumesize);
//  Serial.print("Volume size (Kbytes): ");
  volumesize /= 1024;
//  Serial.println(volumesize);
//  Serial.print("Volume size (Mbytes): ");
  volumesize /= 1024;
    lcd.setCursor(12, 1);
  lcd.print(volumesize);
//  Serial.println(volumesize);

delay(5000);
//  Serial.println("\nFiles found on the card (name, date and size in bytes): ");
  lcd.setCursor(0, 0);
  lcd.print("               ");
  lcd.setCursor(0, 0);
  lcd.print("Files found:");
  lcd.setCursor(0, 1);
  lcd.print("               ");
  lcd.setCursor(0, 1);
  lcd.print(root.openRoot(volume));
  
  
  myFile = SD.open("BACON.TXT");
  if (myFile) {
      lcd.setCursor(0, 0);
  lcd.print("               ");
  lcd.setCursor(0, 0);
  lcd.print("BACON.TXT:");
  lcd.setCursor(0, 1);
  lcd.print("               ");
  lcd.setCursor(0, 1);
      
    // read from the file until there's nothing else in it:
    while (myFile.available()) {
        lcd.print(myFile.read());
    }
    // close the file:
    myFile.close();
  } else {
    // if the file didn't open, print an error:
      lcd.setCursor(0, 0);
  lcd.print("               ");
  lcd.setCursor(0, 0);
  lcd.print("error opening BACON.TXT");
  lcd.setCursor(0, 1);
  lcd.print("               ");
  lcd.setCursor(0, 1);
  }

  

  
  
}


void loop() {
  
}
