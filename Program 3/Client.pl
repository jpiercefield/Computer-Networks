#James Logan Piercefield
#CSC 4200 - Computer Networks
#Program 3

#!/usr/bin/perl

use strict;
use warnings;
use IO::Socket::INET;
use threads;
use IO::Select;
$| = 1;

my $socket = IO::Socket::INET->new("10.105.135.191:5000");
$socket or die "$!";
my $sel = IO::Select->new($socket);

print "Connected on Port". ":" . $socket->peerport() . "\n";

#Creates a thread that takes data from STDIN and send it out
#through the socket.

threads->create(
    sub {
        while(1){
            my $input = <>;
            chomp($input);
            for my $out (my @ready = $sel->can_write(0))
            {
                print $out $input;
            }
        }   
    }
);

while(1)
{
    if(my @ready = $sel->can_read(0))
    {
        for my $socket(@ready)
        {
            my $data = "";
            $socket->recv($data, 1024) ;#or die $!;
            if($data eq " ")
            {
               exit;
            }
            print "$data\n" if $data;
        }
    }
}