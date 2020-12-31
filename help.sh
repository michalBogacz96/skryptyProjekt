function help(){
  printf "

------------------------  POMOC ------------------------

Witaj w pomocy dla tego skryptu! :)
Skrypt ten służy do podstawowych działań na plikach.
Skrypt za każdym razem wykonuję podstawowe operacje takie jak,
katalogowanie plików o takich samych rozszerzeniach do tych samych nowo utworzonych
katalogów oraz usuwanie pustych plików.
Pierwszym argumentem, który przyjmuje skrypt jest ścieżka do folderu dla którego chcemy dokonać
podstawowych operacji. Jesli jako pierwszy argument nie zostanie podana ścieżka, skrypt wykona
podstawowe operacje dla katalogu w którym się znajduję.

Opcje, które można wywołać to:

 -h lub --help - służy do wyświetlenia pomocy dla tego skryptu. W przypadku w którym zostanie zastosowana
                ta flaga z innymi to zostanie wyświetlona pomoc, a pozostałe argumenty podane podczas
                uruchomienia skryptu zostaną pominięte.
 -z ścieżka lub --zip ścieżka - sluzy do zipowania pliku lub calego katalogu podanego w ścieżce.
                              W przypadku nie podania ścieżki zostanie zipowany katalog podany
                              jako pierwszy argument do programu. W przypadku gdy ten argument nie został
                              podany, zipowany będzie katalog w którym znajduję się skrypt. Przed użyciem flagi
                              upewnij się, że na Twoim komputerze jest zainstalowana opcja zip używając polecenia:
                              'zip -v' lub 'zip --version'. Jeśli nie posiadasz programu zip to zainstaluj go używając
                              komendy 'sudo apt install zip'.

 -uz ścieżka lub --unzip ścieżka - sluzy do rozpakowania pliku lub calego katalogu podanego w ścieżce.
                              W przypadku nie podania ścieżki zostanie sprawdzony katalog, który został podany
                              jako pierwszy argument do programu czy zawiera pliki z rozszerzeniem '.zip'. W przypadku
                              gdy katalog nie został podany, przeszukany zostanie katalog w którym znajduję
                              się skrypt, w celu znalezenia plików z rozszerzenim '.zip' i rozpakowaniu ich.
                              Przed użyciem flagi upewnij się, że na Twoim komputerze jest zainstalowana
                              opcja unzip używając polecenia:
                              'unzip -v' lub 'unzip --version'. Jeśli nie posiadasz programu unzip to zainstaluj go użyj
                              komendy 'sudo apt install unzip'.

  -rm ścieżka - służy do usuwania pliku o podanej ścieżce. W przypadku nie podania ścieżki zostanie wyświetlona pomoc.
"
}