import 'dart:io';

class NetworkHelper {
  static Future<String> getServerIP() async {
    // Try common IP ranges for local network
    List<String> commonIPs = [
      '192.168.1.100',
      '192.168.1.101', 
      '192.168.1.102',
      '192.168.0.100',
      '192.168.0.101',
      '10.0.0.100',
      '10.0.0.101',
    ];
    
    for (String ip in commonIPs) {
      try {
        final result = await InternetAddress.lookup(ip);
        if (result.isNotEmpty) {
          return 'http://$ip';
        }
      } catch (e) {
        continue;
      }
    }
    
    // Fallback to default
    return 'http://192.168.1.100';
  }
  
  static String getManualIP() {
    // You need to manually set your computer's IP here
    // To find your IP:
    // Windows: Open cmd, type 'ipconfig', look for IPv4 Address
    // Mac/Linux: Open terminal, type 'ifconfig', look for inet address
    return 'http://192.168.1.100'; // Replace with your actual IP
  }
}