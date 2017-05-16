#IO Interface to socket communications in AF_INET domain
use IO::Socket::INET;
 
# Auto-flush socket / "Command Buffering"
$| = 1; #Special Perl Variable
 
# creating a listening socket
my $socket = new IO::Socket::INET (
    LocalHost => '127.0.0.1',
    LocalPort => '5000',
    Proto => 'tcp', #Protocol 
    Listen => 5,    #Listen Socket
    ReuseAddr => 1  
);
die "Can't create socket $!\n" unless $socket;
print "Server waiting for client connection on port 5000\n";
 
while(1)
{
    # waiting for a new client connection
    my $client_socket = $socket->accept(); 
 
    # get information about a newly connected client
    my $client_address = $client_socket->peerhost();
    my $client_port = $client_socket->peerport();
    print "Connection from $client_address:$client_port\n";
 
    # read up to 1024 characters from the connected client
    my $data = "";
    $client_socket->recv($data, 1024);
    print "Received: $data\n";
 
    # write response data to the connected client   
    $data = localtime(); # Load Data and Time 
    $client_socket->send($data); # Send to Client
 
    # notify client that response has been sent
    shutdown($client_socket, 1);
}
 
$socket->close();