#IO Interface to socket communications in AF_INET domain
use IO::Socket::INET;

# Auto-flush socket / "Command Buffering"
$| = 1; #Special Perl Variable
 
while(1) {

   print "Enter your message: ";
   my $input = <STDIN>;
   chomp $input;
   if(length($input) > 1000)
   {
      print "Sorry this message is too large. Please use 1000 or less characters.\n";
   }
   if($input ne "") { 

      # Create Connecting Socket
      my $socket = new IO::Socket::INET (
         PeerHost => '10.105.195.217',
         PeerPort => '5000',
         Proto => 'tcp',     #Protocol
      );
      die "Can't connect to server $!\n" unless $socket;
      #print "\nSuccessfully connected to the server!\n";

  
      # Data to send to server
      my $size = $socket->send($input);   #->send($msgVar)
      #print "Sent data of length $size\n";
 

      # Tells server that it is finished sending data / Request Sent
      shutdown($socket, 1);
 
      # Receive a response of up to 1024 characters from server
      my $response = "";
      $socket->recv($response, 1024);   #->recv($StoreVar, maxChars)
      print "Server response: $response\n\n";
   
      #Close Socket 
      $socket->close();
      sleep(0);
   }
}
 
