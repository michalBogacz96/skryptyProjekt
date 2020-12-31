#!/usr/bin/perl -w

use strict;
use IO::Socket;
use Sys::Hostname;
use Cwd qw(abs_path);
use POSIX qw(:sys_wait_h);
use File::Basename;
use FindBin;
use lib "$FindBin::Bin/";
use messages qw(print_options);
use Sys::Hostname;
use Socket;


sub REAP {
    1 until (-1 == waitpid(-1, WNOHANG));
    $SIG{CHLD} = \&REAP;
}


if( defined($ARGV[0]) && ($ARGV[0] eq '-h'))
{
help();
exit;
}

sub help {
    print "
        ------------------------  POMOC ------------------------

Witaj w pomocy dla programu server.pl.
Jest to implementacja serwera w programie klient-serwer,
za pomocą którego możemy uruchamiać programy z basha i pythona.
Ten plik uruchamiamy jako pierwszy następnie uruchamiamy plik 
'client.pl'. Pliki server.pl oraz client.pl łączą się ze sobą,
za pomocą protokołu tcp i wymieniają informacjami poprzez sieć.
Serwer dziala na porcie 7890. Serwer w zależności od poleceń
klienta uruchamia pewne programy z różnymi warunkami wykonania.
Aby dowiedzieć się więcej o kliencie
uruchom 'client.pl -h'.
"
}


my $sock = new IO::Socket::INET(
                   LocalPort => 7890,
                   Proto     => 'tcp',
                   Listen    => SOMAXCONN,
                   Reuse     => 1);
$sock or die "Nastapil problem z gniazdkiem. Wylaczam serwer\n";
STDOUT->autoflush(1);
my($new_sock, $buf, $kid);
my $current_path = abs_path($0);
my($filename, $directories) = fileparse($current_path);
my $param;
print "Uruchomiono serwer, naciśnij ctrl + c, aby zakończyć działanie serwera\n";

while ($new_sock = $sock->accept()) {
    print "Połączono z klientem\n";
    next if $kid = fork;
    die "fork: $!" unless defined $kid;
    close $sock;
    while (defined($buf = <$new_sock>)) {
   chop $buf;
   $buf = lc $buf;
   if($buf eq ''){
        print ($new_sock  system("/bin/bash ${directories}/bashScript.sh"));
   }else{
       my @buf_tab = split(' ', $buf);
       print "$directories\n\n";
       if ($buf_tab[0] eq "1") {
               print($new_sock `python3 main.py ${buf_tab[1]}`);
               print $new_sock print_options();
       } else {
               print ($new_sock  system("/bin/bash ${directories}/bashScript.sh ${buf}"));
       }
   }
}
      print "Rozłączono z klientem\n";
    exit;
} 
continue {
    close $new_sock;

}