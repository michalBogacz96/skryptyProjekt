#!/usr/bin/perl -w
# read from STDIN and write to a server
use strict;
use IO::Socket;
use Cwd;

use Scalar::Util qw(looks_like_number);
use FindBin;
use lib "$FindBin::Bin/";
use messages qw(print_options);
use Getopt::Long;


if( defined($ARGV[0]) && ($ARGV[0] eq '-h' || $ARGV[0] eq '-help'))
{
help();
exit;
}

if(!(defined($ARGV[0]) && defined($ARGV[1]))){
print "Niepoprawnie podane argumenty. Wyswietlam pomoc.\n";
help();
exit();
}

sub help { print "

        ------------------------  POMOC ------------------------

Witaj w pomocy dla skryptu client.pl.
jest to implementacja klienta w programie klient-serwer,
za pomocą którego możemy uruchamiać programy z basha i pythona.
Ten program czyli 'client.pl' uruchamiamy jako drugi. Należy pamiętać,
aby jako pierwszy uruchomić serwer z pliku o nazwie server.pl (aby
dowiedzieć się więcej uruchom 'server.pl -h') następnie uruchomić plik
'client.pl' za pomocą którego połączymy się z serwerem.
Program 'client.pl' przyjmuje dwa argumenty:
- adres serwera do ktorego chcemy sie polaczyc.
- port na ktorym dziala serwer.
Następnie będziemy mogli skorzystać z kilku opcji:
- uruchomienie generatora grafu wraz z demonstracją jego zaimplementowanych funkcji,
- uruchomienie skryptu bash w oknie klienta,
- uruchomienie skryptu bash w oknie serwera
Więcej wskazówek pokaże się podczas działania programu.
";
}


my $sock = new IO::Socket::INET(
                   PeerAddr => $ARGV[0],
                   PeerPort => $ARGV[1],
                   Proto    => 'tcp');
$sock or die "Nastapil problem z gniazdkiem. Polaczenie z serwerem nie udalo sie\n";
my $current_path = getcwd;

sub send_to_server {
    $sock->autoflush(1);
my $in = $_[0];
my ($buf, $kid);
die "fork fail: $!" unless defined($kid = fork);
    if ($kid) {
    while ($in) {
   print $sock $in;
    choose_option();
    }
    kill(TERM => $kid);
} else {
    while (defined($buf = <$sock>)) {
   print $buf;
    }
    print "Serwer został rozłączony, a więc kończę działanie...\n";
    close $sock;
    kill(TERM => $kid);
}
}

sub choose_option {
   print print_options() ;
my $option = <STDIN>;
   if ($option == "1") {
                print "Podaj liczbę wieksza od 3.Ta liczba bedzie rozmiarem grafu.\nAby wlaczyc pomoc nacisnij '-h'\n";
                my $graph_size = <STDIN>;
                my $message_to_server = "1 ${graph_size}";
                send_to_server($message_to_server);
                print print_options();
                last;
   } elsif($option == "2") {
                print "Podaj argumenty do skryptu bash lub '-h', aby otrzymać pomoc na temat działania skryptu\n";
                my $bash_param = <STDIN>;
                my $message_to_server = "${bash_param}";
                print "Przejdź do okna serwera\n";
                send_to_server($message_to_server);
   } elsif ($option == "3") {
                print "Podaj argumenty do skryptu bash lub '-h', '--help' aby otrzymać pomoc na temat działania skryptu\n";
                my $local_bash_param = <STDIN>;
                system("/bin/bash ${current_path}/bashScript.sh ${local_bash_param}");
                print_options();
                choose_option();
   }elsif($option == "4") {
                help();
                choose_option();
   } elsif($option == "5") {
                exit;
   }else{
                print "Klawisz nieobslugiwany. Wyswietlam opcje programu.";
                choose_option();
   }
}

choose_option();

