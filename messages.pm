package messages;

use Exporter qw(import);
 
our @EXPORT_OK = qw(print_options);

sub print_options {
my $pomoc = "
Wybierz '1', aby stworzyc graf\n" .
  "Wybierz '2' aby uruchomic skrypt bash w oknie serwera\n" .
  "Wybierz '3' aby uruchomic skrypt bash w oknie klienta\n" .
  "Wybierz '4' aby urchomic pomoc dla klienta\n" .
  "Wybierz '5' aby zakończyć działanie klienta\n";

return $pomoc;
}
1;