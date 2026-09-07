# NX Penalty Kick

## Nasil acilir
1. Godot 4.3 veya uzeri bir surumu indir (godotengine.org).
2. Godot editorunu ac, "Import" ile bu klasordeki project.godot dosyasini sec.
3. F5 ile calistir, ilk sahne Main.tscn otomatik acilir.

## Oyun akisi
- Ana menu -> Takim Sec -> Mac (penalti serisi)
- Yon cubugunu (sol alt) surukleyip birak: hedef aci ve yukseklik belirlenir
- Guc cubugu (sag alt) otomatik dolup bosalir, ekrana dokunarak gucu kilitle ve sut cek
- 5 atistan en az 3 gol atarsan bir sonraki tura gecersin, kaleci her turda biraz daha iyi olur
- 5 turu da gecersen turnuvayi kazanirsin

## Yapi
- scripts/autoload: GameManager (tur/skor durumu) ve TeamData (8 takim, tamamen ozgun isim ve renkler)
- scripts/gameplay: Match (ana oyun akisi), Ball, Goalkeeper
- scripts/ui: MainMenu, TeamSelect, Joystick, PowerBar
- Gorsel varliklarin hepsi kod icinde ColorRect/Polygon2D ile ciziliyor, hazir sanat dosyasi gerekmiyor; istersen kaleci/top/forma icin kendi sprite'larinla degistirebilirsin.

## APK olarak derleme
Bu ortamda Godot motoru veya Android SDK bulunmadigi icin APK derlemesi yapilamiyor. Kendi bilgisayarinda Godot editor uzerinden Project > Export ile Android export template'i kurup APK alabilirsin, ya da GitHub Actions ile otomatik derleme kurulmasini istersen bir sonraki adimda onu hazirlayabilirim.
