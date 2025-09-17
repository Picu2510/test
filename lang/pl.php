<?php
return [

	'global.dodaj' => 'Dodaj',
	'global.edytuj' => 'Edytuj',
	'global.reset' => 'Reset',
	'global.usun' => 'Usuń',
	'global.zapisz' => 'Zapisz',
	'global.anuluj' => 'Anuluj', 
	
	// login
		'login.tytul' => 'Logowanie',
		'login.zaloguSie' => 'Zaloguj się',
		'login.haslo' => 'Hasło',
		'login.pin' => 'PIN',
		'login.login' => 'Login / Nazwisko Imię',
		'login.zaloguj' => 'Zaloguj',
		'login.kodPin' => 'Kod PIN (6 cyfr)',
		'login.zalogujPinem' => 'Zaloguj PIN-em',
		'login.zmienHaslo' => 'Zmień hasło',
		
	// header
		'header.jezyk' => 'Język',
		'header.wyloguj' => 'Wyloguj',
    
	// sidebar
		'sidebar.cmms' => 'CMMS',
			'sidebar.cmms.zgloszeniaDodaj' => 'Dodaj zgłoszenie',
			'sidebar.cmms.zgloszeniaLista' => 'Lista zgłoszeń',
			'sidebar.cmms.strukturaZakladu' => 'Struktura zakładu',
			'sidebar.cmms.zgloszenia' => 'Zgłoszenia',
			'sidebar.cmms.raporty' => 'Raporty',
			'sidebar.cmms.konfiguracja' => 'Konfiguracja',
			
		'sidebar.mes' => 'MES',
			'sidebar.mes.panelMES' => 'Panel MES',
			'sidebar.mes.panelSIC' => 'Panel SIC',
			
		'sidebar.kompetencje' => 'Kompetencje',
			'sidebar.kompetencje.matryca' => 'Matryca',
			'sidebar.kompetencje.rekomendacje' => 'Rekomendacje',
			'sidebar.kompetencje.raporty' => 'Raporty',
			'sidebar.kompetencje.konfiguracja' => 'Konfiguracja',
		
		'sidebar.administracja' => 'Administracja',
			'sidebar.administracja.uzytkownicy' => 'Użytkownicy',
			'sidebar.administracja.roleUzytkownikow' => 'Role użytkowników',
	
	// cmms
	
		// Struktura
			// drzewo ===================================================================================
				 'cmms.struktura.drzewo.tytul' => 'Struktura zakładu (Drag & Drop)',
				 
				'cmms.struktura.drzewo.exportDoCSV' => 'Eksport do CSV',
				'kcmms.struktura.drzewo.pokaz' => 'Pokaż',
				'cmms.struktura.drzewo.pokaz_wszystko' => 'Wszystko',
				'cmms.struktura.drzewo.pokaz_aktywne' => 'Aktywne',
				'cmms.struktura.drzewo.pokaz_nieAktywne' => 'Nieaktywne',
				'cmms.struktura.drzewo.rozwinWszystko' => 'Rozwiń wszystko',
				'cmms.struktura.drzewo.zwinWszystko' => 'Zwiń wszystko',
				'cmms.struktura.drzewo.kolorowanie' => 'Kolorowanie:',
				'cmms.struktura.drzewo.bezKolorowania' => 'Bez kolorowania',
				'cmms.struktura.drzewo.typ' => 'Typ',
				'cmms.struktura.drzewo.mpk' => 'MPK / Linia',
				'cmms.struktura.drzewo.element' => 'Element',
				'cmms.struktura.drzewo.szukaj' => 'Szukaj w węzłach ...',
				
			// edit ===================================================================================
			
				'cmms.struktura.edit.tytul' => 'Edytuj węzeł struktury',
				'cmms.struktura.add.tytul' => 'Dodaj węzeł struktury',
				
				
				

				'users.add.login' => 'Login',
				'users.add.email' => 'E‑mail',
				'users.add.imie' => 'Imię',
				'users.add.nazwisko' => 'Nazwisko',
				'users.add.jezyk' => 'Język',
				'users.add.rola' => 'Rola',
				'users.add.pin' => 'PIN (opcjonalny, 6 cyfr)',
				'users.add.generujPin' => 'Generuj PIN',
				'users.add.tylkoDlaAdministratorow' => 'Tylko dla administratorów.',
				'users.add.haslo' => 'Hasło',
				'users.add.powtorzHaslo' => 'Powtórz hasło',
				'users.add.jakWyzej' => 'Jak wyżej',
				'users.add.aktywny' => 'Aktywny',
				'users.add.aktywny' => 'Aktywny',
				

		// raporty
			// menu
				'cmms.raporty.urTytu' => 'Raporty UR',
				'cmms.raporty.urToggle' => 'Raporty utrzymania ruchu',
				
				'cmms.raporty.ur.wallboardTytul' => 'Pracuja aktualnie',
				'cmms.raporty.ur.wallboardDesc' => 'Aktualie wykonwyane zadania.',
				'cmms.raporty.ur.wallboardGoTo' => 'Przejdź do raportu',
				
				'cmms.raporty.ur.liveTytul' => 'Zgłoszenia',
				'cmms.raporty.ur.liveDesc' => 'Lista zgłoszeń ze szczegółowymi danymi LIVE',
				'cmms.raporty.ur.liveGoTo' => 'Przejdź do widoku live zgłoszeń',
				
				'cmms.raporty.ur.agingTytul' => 'Czas w statusie',
				'cmms.raporty.ur.agingDesc' => 'Raport „Aging board / SLA” pokazuje zgłoszenia w kubełkach czasu spędzonego w aktualnym statusie',
				'cmms.raporty.ur.agingGoTo' => 'Przejdź do raportu',
				
				'cmms.raporty.ur.heatmapTytul' => 'Heatmap',
				'cmms.raporty.ur.heatmapDesc' => 'Obciążenie zespołu – Heatmapa pracy (worklog). Daje Wam szybki podgląd, w jakie dni i godziny ludzie najwięcej pracują nad zgłoszeniami.',
				'cmms.raporty.ur.heatmapGoTo' => 'Przejdź do raportu ',
				
				'cmms.raporty.ur.workloadTytul' => 'Obciążenie zespołu / Workload',
				'cmms.raporty.ur.workloadDesc' => 'Kto ile pracował w zadanym zakresie + kto pracuje teraz',
				'cmms.raporty.ur.workloadGoTo' => 'Przejdź do raportu',
				
				'cmms.raporty.ur.slaRiskTytul' => 'Aging & SLA',
				'cmms.raporty.ur.slaRiskDesc' => 'Eyzyko przekroczenia terminu',
				'cmms.raporty.ur.slaRiskGoTo' => 'Przejdź do raportu',
				
				'cmms.raporty.ur.flowTytul' => 'Przepływ (Throughput & Lead Time)',
				'cmms.raporty.ur.flowDesc' => 'Dzienny podgląd ilu zgłoszeń utworzono, zamknięto oraz średni lead time (czas od utworzenia do zamknięcia) dla zamkniętych w danym dniu',
				'cmms.raporty.ur.flowGoTo' => 'Przejdź do raportu',
				
				'cmms.raporty.ur.mttrTytul' => 'MTTR/MTBF',
				'cmms.raporty.ur.mttrDesc' => 'Średni czas naprawy i średni czas między awariami) z możliwością grupowania po zasobie albo po grupie odpowiedzialnej.',
				'cmms.raporty.ur.mttrGoTo' => 'Przejdź do raportu',
				
				'cmms.raporty.ur.backlogTytul' => 'Backlog (trend + starzenie)',
				'cmms.raporty.ur.backlogDesc' => 'Liczba otwartych zgłoszeń w kolejnych dniach (trend), zmianę vs początek zakresu i maksimum z okresu, bucket starzenia (ile otwartych jest 0–1d, 2–3d, 4–7d, 8–14d, 15–30d, >30d), listę najstarszych otwartych (TOP 10) z tytułem, statusem, osobą i grupą.',
				'cmms.raporty.ur.backlogGoTo' => 'Przejdź do raportu',
				
				'cmms.raporty.ur.slaComplianceTytul' => 'SLA compliance %',
				'cmms.raporty.ur.slaComplianceDesc' => 'Tygodnie/miesiące; w terminie vs spóźnione + “brak SLA',
				'cmms.raporty.ur.slaComplianceGoTo' => 'Przejdź do raportu',
				
				'cmms.raporty.ur.paretoPrzyczynTytul' => 'Pareto przyczyn',
				'cmms.raporty.ur.paretoPrzyczynDesc' => 'Liczba wystąppień, łączny czas trwania do następnej zmiany statusu',
				'cmms.raporty.ur.paretoPrzyczynGoTo' => 'Przejdź do raportu',
				
				'cmms.raporty.ur.topZasobyTytul' => 'Top zasoby / grup',
				'cmms.raporty.ur.topZasobyDesc' => 'Liczba zgłoszeń, łączny czas pracy, średni czas realizacji',
				'cmms.raporty.ur.topZasobyGoTo' => 'Przejdź do raportu',
				
				'cmms.raporty.ur.frtTytul' => 'First Response Time (FRT)',
				'cmms.raporty.ur.frtDesc' => 'Czas od utworzenia zgłoszenia do pierwszej faktycznej zmiany statusu',
				'cmms.raporty.ur.frtGoTo' => 'Przejdź do raportu',
				
				'cmms.raporty.ur.reopenRateTytul' => 'Ponownie otwarde',
				'cmms.raporty.ur.reopenRateDesc' => 'Ticket miał co najmniej jedno przejście do statusu zamkniętego, a po tym zdarzeniu wystąpił jakikolwiek status otwarty. Licznik to liczba takich powrotów po pierwszym zamknięciu.',
				'cmms.raporty.ur.reopenRateGoTo' => 'Przejdź do raportu',
				 
				
	
	// konfiguracja
		// menu
			// Użytkownicy
			'cmms.konfiguracja.menu.uzytkownicy' => 'Użytkownicy',
			'cmms.konfiguracja.menu.uzytkownicyToggle' => 'konfiguracja użytkownikó i grup',
			
			'cmms.konfiguracja.menu.grupyTytul' => 'Grupy',
			'cmms.konfiguracja.menu.grupyDesc' => ' Konfiguracja grup użytkoników',
			'cmms.konfiguracja.menu.grupyGoTo' => 'Przejdź do konfiguracji grup',
			
			'cmms.konfiguracja.menu.zasadyPrzydzialuTytul' => 'Zasadu przydziału',
			'cmms.konfiguracja.menu.zasadyPrzydzialuDesc' => ' Konfiguracja zasad przydziału zgłoszeń',
			'cmms.konfiguracja.menu.zasadyPrzydzialuGoTo' => 'Przejdź do konfiguracji zasad',
			
			// Zgłoszenia
			'cmms.konfiguracja.menu.zgloszenia' => 'Zgłoszenia',
			'cmms.konfiguracja.menu.zgloszeniaToggle' => 'konfiguracja typów zgłoszeń',
			
			'cmms.konfiguracja.menu.typTytul' => 'Typ zgłoszenia',
			'cmms.konfiguracja.menu.typDesc' => ' Konfiguracja głównych typów zgłoszeń',
			'cmms.konfiguracja.menu.typGoTo' => 'Przejdź do konfiguracji typów',
			
			'cmms.konfiguracja.menu.podtypTytul' => 'Podtyp zgłoszenia',
			'cmms.konfiguracja.menu.podtypDesc' => ' Konfiguracja podtypów zgłoszeń',
			'cmms.konfiguracja.menu.statusyGoTo' => 'Przejdź do konfiguracji statusów zadań',
			
			'cmms.konfiguracja.menu.statusyTytul' => 'Statusy',
			'cmms.konfiguracja.menu.statusyDesc' => 'konfiguracja statusów w systemie',
			'cmms.konfiguracja.menu.statusyGoTo' => 'Przejdź do konfiguracji zadań',
			
			'cmms.konfiguracja.menu.zadaniaTytul' => 'Zadania',
			'cmms.konfiguracja.menu.zadaniaDesc' => 'konfiguracja zadańa',
			'cmms.konfiguracja.menu.zadaniaGoTo' => 'Przejdź do konfiguracji zadań',
			
			'cmms.konfiguracja.menu.przejsciaTytul' => 'Lista przejsc',
			'cmms.konfiguracja.menu.przejsciaDesc' => ' Przeglądaj wszystkie przejscia miedzy statusami',
			'cmms.konfiguracja.menu.przejsciaGoTo' => 'Przejdź do widoku przejsc',
			
			
			// Struktura
			'cmms.konfiguracja.menu.struktura' => 'Struktura',
			'cmms.konfiguracja.menu.strukturaToggle' => 'konfiguracja struktury zakładu',
			
			'cmms.konfiguracja.menu.drzewoTytul' => 'Drzwo struktury',
			'cmms.konfiguracja.menu.drzewoDesc' => ' Zarządzaj strukturą zakładu w widoku hierarchicznym',
			'cmms.konfiguracja.menu.drzewoGoTo' => 'Przejdź do widoku drzewa',
			
			'cmms.konfiguracja.menu.listaTytul' => 'Lista zasobów',
			'cmms.konfiguracja.menu.listaDesc' => ' Przeglądaj wszystkie elementy struktury w formie listy',
			'cmms.konfiguracja.menu.listaGoTo' => 'Przejdź do widoku listy',
			
			// Słowniki
			'cmms.konfiguracja.menu.slowniki' => 'Słowniki',
			'cmms.konfiguracja.menu.slownikiToggle' => 'konfiguracja słowników',
			
			'cmms.konfiguracja.menu.elementTytul' => 'Element struktury',
			'cmms.konfiguracja.menu.elemntDesc' => ' Zarządzaj słownikiem elementów struktury zakładu',
			'cmms.konfiguracja.menu.elementGoTo' => 'Przejdź do widoku listy elementów',
			
			'cmms.konfiguracja.menu.typZasobuTytul' => 'Typ zasobu',
			'cmms.konfiguracja.menu.typZasobuDesc' => ' Zarządzaj słownikiem typów zasobów',
			'cmms.konfiguracja.menu.typZasobuGoTo' => 'Przejdź do widoku listy typów zasobów',
			
			'cmms.konfiguracja.menu.elementStrukturyTytul' => 'Element struktury',
			'cmms.konfiguracja.menu.telementStrukturyDesc' => ' Zarządzaj słownikiem elementów struktury zakładu',
			'cmms.konfiguracja.menu.elementStrukturyGoTo' => 'Przejdź do widoku listy elementów',
			
			'cmms.konfiguracja.menu.plikTypTytul' => 'Typy plików',
			'cmms.konfiguracja.menu.plikTypDesc' => ' Zarządzaj słownikiem typów plikó załączników',
			'cmms.konfiguracja.menu.plikTypGoTo' => 'Przejdź do widoku listy',
			
			
	
		  'cmms.konfiguracja.title' => 'Konfiguracja struktury zakładu',
		  'cmms.konfiguracja.cards.drzewo_title' => 'Drzewo struktury',
		  'cmms.konfiguracja.cards.drzewo_desc' => 'Zarządzaj strukturą zakładu w widoku hierarchicznym.',
		  'cmms.konfiguracja.cards.lista_title' => 'Lista zasobów',
		  'cmms.konfiguracja.cards.lista_desc' => 'Przeglądaj wszystkie elementy struktury w formie listy tabelarycznej.',
		  'cmms.konfiguracja.cards.go_to_tree' => 'Przejdź do widoku drzewa',
		  'cmms.konfiguracja.cards.go_to_list' => 'Przejdź do widoku listy',
		  'cmms.konfiguracja.cards.slowniki_title' => 'Tabele słownikowe',
		  'cmms.konfiguracja.cards.element_link' => 'Element struktury',
		  'cmms.konfiguracja.cards.typ_zasobu_link' => 'Typ zasobu',
		  'cmms.konfiguracja.cards.mpk_linia_link' => 'MPK i linia',
		  'common.admin_tools' => 'Narzędzia admina',
		  'common.read_only' => 'Tylko odczyt',
	
	// Kompetencje ===================================================================================
	
	
	
	
	// Administacja ===================================================================================
		// Użytkownicy ================================================================================
			// list ===================================================================================
				 'uzytkownicy.list.tytul' => 'Użytkownicy',
				 'uzytkownicy.list.szukaj' => 'Szukaj: login, imię, nazwisko, email',
				 'uzytkownicy.list.wszyscy' => 'Wszyscy',
				 'uzytkownicy.list.aktywni' => 'Aktywni',
				 'uzytkownicy.list.nieaktywni' => 'Nieaktywni',
				 'uzytkownicy.list.filtruj' => 'Filtruj',
				 'uzytkownicy.list.add' => 'Dodaj użytkownika',
				 
				 
				 'uzytkownicy.list.tab.nazwiskoImie' => 'Nazwisko i imię',
				 'uzytkownicy.list.tab.login' => 'Login',
				 'uzytkownicy.list.tab.email' => 'E-mail',
				 'uzytkownicy.list.tab.rola' => 'Rola',
				 'uzytkownicy.list.tab.jezyk' => 'Język',
				 'uzytkownicy.list.tab.aktywny' => 'Aktywny',
				 'uzytkownicy.list.tab.akcje' => 'Akcje',
				 
				 'uzytkownicy.list.tab.edytujUprawnienia' => 'Uprawnienia',
				 
			// edit ===================================================================================
				'uzytkownicy.add.tytul' => 'Dodaj użytkownika',
				'uzytkownicy.edit.tytul' => 'Edytuj użytkownika',
				
				'uzytkownicy.add.login' => 'Login',
				'uzytkownicy.add.email' => 'E‑mail',
				'uzytkownicy.add.imie' => 'Imię',
				'uzytkownicy.add.nazwisko' => 'Nazwisko',
				'uzytkownicy.add.jezyk' => 'Język',
				'uzytkownicy.add.rola' => 'Rola',
				'uzytkownicy.add.pin' => 'PIN (opcjonalny, 6 cyfr)',
				'uzytkownicy.add.generujPin' => 'Generuj PIN',
				'uzytkownicy.add.tylkoDlaAdministratorow' => 'Tylko dla administratorów.',
				'uzytkownicy.add.haslo' => 'Hasło',
				'uzytkownicy.add.powtorzHaslo' => 'Powtórz hasło',
				'uzytkownicy.add.jakWyzej' => 'Jak wyżej',
				'uzytkownicy.add.aktywny' => 'Aktywny',
				'uzytkownicy.add.aktywny' => 'Aktywny',
				
			// edit ===================================================================================
				'uzytkownicy.edit.noweHaslo' => 'Nowe hasło (opcjonalnie)',
				'uzytkownicy.edit.pozostawPusteZebyNieZmieniac' => 'pozostaw puste żeby nie zmieniać',
	
		// Role ================================================================================
			// lista
				'uzytkownicy.role.list.tytul' => 'Role – lista',
				'uzytkownicy.role.list.dodaj' => 'Nowa rola',
				'uzytkownicy.role.list.nazwa' => 'Nazwa',
				'uzytkownicy.role.list.uzytkownicy' => 'Użytkownicy',
				'uzytkownicy.role.list.uprawnienia' => 'Uprawnienia',
				'uzytkownicy.role.list.systemowa' => 'Systemowa',
				'uzytkownicy.role.list.akcje' => 'Akcje',
				'uzytkownicy.role.list.edytuj' => 'Edytuj',
				'uzytkownicy.role.list.usun' => 'Usuń',
				'uzytkownicy.role.list.chroniona' => 'chroniona',
				
			// lista
				'uzytkownicy.role.edit.nowaRola' => 'Nowa rola',
				'uzytkownicy.role.edit.rola' => 'Rola',
				'uzytkownicy.role.list.daneRoli' => 'Dane roli',
				'uzytkownicy.role.list.nazwa' => 'Nazwa',
				'uzytkownicy.role.list.systemowa' => 'Systemowa',
				'uzytkownicy.role.list.nieMoznaUsuwac' => 'Ról systemowych nie można usuwać.',
				'uzytkownicy.role.list.uprawnieniaRoli' => 'Uprawnienia roli',
				'uzytkownicy.role.list.szukajUprawnienia' => 'Szukaj uprawnienia',
				'uzytkownicy.role.list.zaznaczModul' => 'Zaznacz moduł',
				'uzytkownicy.role.list.odznaczModul' => 'Odznacz moduł',
				'uzytkownicy.role.list.wybor' => 'Wybór',
				'uzytkownicy.role.list.uprawnienia' => 'Uprawnienia',
				'uzytkownicy.role.list.wlacz' => 'Włącz',
				'uzytkownicy.role.list.powrot' => 'Powrót',
				'uzytkownicy.role.list.zapiszRole' => 'Zapisz Rolę',
				
				'uzytkownicy.role.list.' => '',
				
//=====================================================================================================


 // ===== CMMS / Konfiguracja – Element struktury =====
    'cmms.konfiguracja.title'                  => 'Konfiguracja struktury zakładu',

    'cmms.konfiguracja.element.list_title'     => 'Elementy struktury',
    'cmms.konfiguracja.element.add_title'      => 'Dodaj element struktury',
    'cmms.konfiguracja.element.edit_title'     => 'Edytuj element struktury',
    'cmms.konfiguracja.element.delete_title'   => 'Usuń element struktury',

    // (jeśli używasz kart menu z wcześniejszych ekranów — opcjonalnie)
    'cmms.konfiguracja.cards.drzewo_title'     => 'Drzewo struktury',
    'cmms.konfiguracja.cards.drzewo_desc'      => 'Zarządzaj strukturą zakładu w widoku hierarchicznym.',
    'cmms.konfiguracja.cards.lista_title'      => 'Lista zasobów',
    'cmms.konfiguracja.cards.lista_desc'       => 'Przeglądaj wszystkie elementy struktury w formie listy.',
    'cmms.konfiguracja.cards.go_to_tree'       => 'Przejdź do widoku drzewa',
    'cmms.konfiguracja.cards.go_to_list'       => 'Przejdź do widoku listy',
    'cmms.konfiguracja.cards.slowniki_title'   => 'Tabele słownikowe',
    'cmms.konfiguracja.cards.element_link'     => 'Element struktury',
    'cmms.konfiguracja.cards.typ_zasobu_link'  => 'Typ zasobu',
    'cmms.konfiguracja.cards.mpk_linia_link'   => 'MPK i linia',

    // ===== Common (UI) =====
    'common.dashboard'         => 'Pulpit',
    'common.name'              => 'Nazwa',
    'common.description'       => 'Opis',
    'common.icon'              => 'Ikona',
    'common.color'             => 'Kolor',
    'common.sort'              => 'Sortowanie',
    'common.active'            => 'Aktywny',
    'common.system'            => 'System',
    'common.actions'           => 'Akcje',

    'common.add'               => 'Dodaj',
    'common.edit'              => 'Edytuj',
    'common.delete'            => 'Usuń',
    'common.delete_confirm'    => 'Potwierdź usunięcie',
    'common.cancel'            => 'Anuluj',
    'common.back'              => 'Powrót',
    'common.create'            => 'Utwórz',
    'common.save_changes'      => 'Zapisz zmiany',

    'common.search'            => 'Szukaj',
    'common.search_placeholder'=> 'Wpisz frazę…',
    'common.only_active'       => 'Tylko aktywne',
    'common.filter'            => 'Filtruj',
    'common.clear'             => 'Wyczyść',

    'common.admin_tools'       => 'Narzędzia admina',
    'common.read_only'         => 'Tylko odczyt',

    'common.not_found'         => 'Nie znaleziono danych.',
    'common.created'           => 'Utworzono.',
    'common.saved'             => 'Zapisano.',
    'common.deleted'           => 'Usunięto.',
    'common.error_generic'     => 'Wystąpił błąd. Spróbuj ponownie.',

    'common.in_use_count'      => 'Ilość powiązań',
    'common.is_system_item'    => 'Pozycja systemowa (zablokowana)',
    'common.cannot_delete_in_use'   => 'Nie można usunąć — pozycja jest używana.',
    'common.cannot_delete_system'   => 'Nie można usunąć pozycji systemowej.',
	
	'common.advanced' => 'Zaawansowane',
	
    // ===== Walidacja =====
    'validation.required'      => 'Pole jest wymagane.',
    'validation.invalid_format'=> 'Nieprawidłowy format.',
    'validation.invalid_color' => 'Nieprawidłowy kolor (#RRGGBB).',
    'validation.unique'        => 'Wartość musi być unikalna.',
	


	'app.title' => 'CMMS / MES / Kompetencje',
    'menu.dashboard' => 'Dashboard',
    'menu.cmms' => 'CMMS',
    'menu.kompetencje' => 'Kompetencje',
    'menu.szkolenia' => 'Szkolenia',

    // Przykładowe komunikaty
    'form.save' => '💾 Zapisz zmiany',
    'form.add'  => '➕ Dodaj',
    'form.cancel' => 'Anuluj',
    'msg.saved' => 'Zapisano pomyślnie.',
    'msg.deleted' => 'Usunięto.',
	
// Tytuł strony drzewa
    'cmms.struct.tree.title' => 'Struktura zakładu (Drag & Drop)',

    // Breadcrumb / linki nawigacyjne
    'global.link_dashboard'            => 'Pulpit',
    'konfiguracja.link_struktura'      => 'Struktura',
    // (celowo także z literówką spotykaną wcześniej)
    'konfiguraca.drzewoStruktury_link' => 'Drzewo struktury',

    // Toolbar / przyciski
    'global.btn_dodaj'                             => 'Dodaj',
    'konfiguraca.drzewoStruktury_exportDoCSV'     => 'Eksport do CSV',
    'konfiguraca.drzewoStruktury_pokaz'           => 'Pokaż',
    'konfiguraca.drzewoStruktury_pokaz_wszystko'  => 'Wszystko',
    'konfiguraca.drzewoStruktury_pokaz_aktywne'   => 'Aktywne',
    'konfiguraca.drzewoStruktury_pokaz_nieAktywne'=> 'Nieaktywne',

    // Modal / potwierdzenia
    'structure.confirm' => 'Potwierdź',
    'structure.cancel'  => 'Anuluj',

    // Komunikaty walidacyjne / alerty (używane w AJAX + DnD)
    'konfiguraca.drzewoStruktury_alert_NieUdaloSieWczytacDrzewa'      => 'Nie udało się wczytać drzewa.',
    'konfiguraca.drzewoStruktury_alert_BladZapisuStruktury'           => 'Błąd zapisu struktury.',
    'konfiguraca.drzewoStruktury_alert_NieprawidlowaOdpowiedzSerwera' => 'Nieprawidłowa odpowiedź serwera.',
    'konfiguraca.drzewoStruktury_alert_BladKomunikacjiZSerwerem'      => 'Błąd komunikacji z serwerem.',

    // Usuwanie węzła (gdy ma dzieci)
    'konfiguraca.lista_nieMoznaUsunacWezla' => 'Nie można usunąć węzła, który posiada elementy podrzędne.',
    'global.usuniecie_pytanie'              => 'Czy na pewno chcesz usunąć ten element?',

    // Dodatkowe etykiety UI (jeśli potrzebujesz w renderze drzewa)
    'structure.add'    => 'Dodaj',
    'structure.edit'   => 'Edytuj',
    'structure.delete' => 'Usuń',
    'structure.active' => 'Aktywny',
    'structure.inactive' => 'Nieaktywny',

    // Komunikaty JS (jeśli w skryptach korzystasz z i18n)
    'js.structure.save_ok'        => 'Zapisano nową kolejność.',
    'js.structure.save_error'     => 'Nie udało się zapisać zmian.',
    'js.structure.reload_error'   => 'Nie udało się przeładować drzewa.',
    'js.structure.server_invalid' => 'Serwer zwrócił nieprawidłową odpowiedź.',
    'js.structure.no_plugin'      => 'Błąd: brak pluginu nestedSortable.',
	
];
