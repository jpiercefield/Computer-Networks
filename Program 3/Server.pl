#James Logan Piercefield
#CSC 4200 - Computer Networks
#Program 3

#!/usr/bin/perl

use strict;
use warnings;
use IO::Socket::INET;
use IO::Select;
no warnings 'all'; #disable warnings
$| = 1;
my $serv = IO::Socket::INET->new(
    LocalAddr => '127.0.0.1',
    LocalPort => '5000',
    Reuse => 1,
    Listen => 1,
);


print 'Server up...';
my $sel = IO::Select->new($serv); #initializing IO::Select with a IO::Handle/Socket

print "\nAwaiting Connections...\n";


my $dataTwo = "";
my $clientSender = 0;
my $totalClientCount = 0;
our @cIPandPort;
while(1){
    if(my @ready = $sel->can_read(0)){ #polls the IO::Select object for IO::Handles / Sockets that can be read from
         while(my $sock = shift(@ready)){
            if($sock == $serv){
                my $client = $sock->accept();
                my $paddr = $client->peeraddr();
                my $pport = $client->peerport();
                
                $cIPandPort[$totalClientCount] = $paddr . ":" . $pport;
                $totalClientCount++; 
                
                print "New connection from $paddr on $pport \n";

                $sel->add($client); 
                #Adds new IO::Handle /Socket to IO::Select, so that it can be polled 
                #for readability/writability with can_read and can_write
            }
            else {
                my $paddr = $sock->peeraddr();
                my $pport = $sock->peerport();
                my $cIPandPortCheck = $paddr . ":" . $pport;
                
                my $data = "";
                $sock->recv($data, 1024) ;
                $dataTwo = $data;
                
                my $char = substr( $data, 0 , 1 );
                my $charTwo = substr( $data, 1 , 1 );
                if($charTwo eq "d")
                {
                     my $i = 1;
                     my $nothing = " ";
                     for my $clients ($sel->can_write(0))
                     {  
                           if($clients == $serv){next}
                           if($i == $char)
                           {
                              print $clients $nothing;
                              @ready = grep { $_ ne $sel } @ready;   
                           }
                           $i++;
                     } 
                } else {
                  if($data eq "")
                  {
                  
                  } else {
                     if($charTwo ne ":")
                     {
                        $char = $char . $charTwo;
                     }
             
                     if($data){                  
                        my $i = 1;
                        for my $clients ($sel->can_write(0))
                        {  
                              if($clients == $serv){next}
                              if($i == $char)
                              {
                                 print $clients $data;
                              }
                              $i++;
                        }
                     }
                     my $clientSenderIndex = 0;
                     for(my $i = 0; $i <= $totalClientCount; $i++)
                     {
                        if($cIPandPort[$i] eq $cIPandPortCheck)
                        {
                            $clientSender = $i + 1;
                        }
                     } 
                
                     print "c" . $clientSender . ": " . $dataTwo . "\n";
                  }
               }  
            }
        }
    }
}