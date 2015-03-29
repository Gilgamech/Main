#define XBEE_RESET 20
#define XBEE_ATN 2
#define XBEE_SELECT SS
#define XBEE_DOUT 23

XbeeWifi xbee;



void setup() {
  // put your setup code here, to run once:
if (!xbee.init(XBEE_SELECT, XBEE_ATN, XBEE_RESET, XBEE_DOUT)) {
      // Failed to initialize
}

    xbee.at_cmd_byte(XBEE_AT_NET_TYPE, XBEE_NET_TYPE_IBSS_INFRASTRUCTURE);
    xbee.at_cmd_byte(XBEE_AT_NET_IPPROTO, XBEE_NET_IPPROTO_TCP);
    xbee.at_cmd_str(XBEE_AT_NET_SSID, "my_network");
    xbee.at_cmd_byte(XBEE_AT_NET_ADDRMODE, XBEE_NET_ADDRMODE_DHCP);
    xbee.at_cmd_short(XBEE_AT_ADDR_SERIAL_COM_SERVICE_PORT, 12345);
    xbee.at_cmd_byte(XBEE_AT_SEC_ENCTYPE, XBEE_SEC_ENCTYPE_WPA2);
    xbee.at_cmd_str(XBEE_AT_SEC_KEY, "MyVerySecretPassphrase");

}

void loop() {
  // put your main code here, to run repeatedly: 
  
}

//Callbacks:
//IP Data Reception
//To register a function to receive inbound IP data register a function of the following prototype:
//  void my_ip_inbound_function(uint8_t *data, int len, s_rxinfo *info);
//Using the register_ip_data_callback method:
//  xbee.register_ip_data_callback(my_ip_inbound_function);
//
//Modem Status Reception
//To register for modem status updates, register a function of the following prototype:
//  void my_modem_status_function(uint8_t status);
//Using the register_status_callback method
//  xbee.register_status_callback(my_modem_status_function);
//    
//Remote Data Sample callback
//To register for sample callback, register a function of the following prototype:
//  void my_sample_callback(s_sample *sample);
//Using the register_sample_callback method
//  xbee.register_sample_callback(sample);
//  
//Network Scan callback
//To register for scan callback, register a function of the following prototype:
//  void my_callback(uint8_t encryption_mode, int rssi, char *ssid);
//Using the register_scan_callback method
//  xbee.register_scan_callback(my_scan_callback);
//To scan for networks you must then call initiateScan()
//  xbee.initiateScan()
//  

