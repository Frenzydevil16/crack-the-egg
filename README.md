# Crack the egg – 10.000 Klicks (YouTube Playable – Epic Drop & Shop Edition)

> 🎮 **Direkt im Browser spielen:** [https://frenzydevil16.github.io/crack-the-egg/](https://frenzydevil16.github.io/crack-the-egg/)

## 1. Spiel in einem Satz, Godot-Version, Exportziel
**Crack the egg – 10.000 Clicks** ist ein cartoonhaftes Clicker- und Sammelspiel, bei dem Spieler ein zentrales Ei durch genau 10.000 effektive Klicks und 14 progressive Riss-Stufen aufbrechen, um in einem epischen Drop-Menü Slimes aus sechs Seltenheitsstufen (Common bis Mythic) zu sammeln und im Shop Klick-Upgrades, zeitbasierte Booster, Glücks-Upgrades und Kosmetik freizuschalten.
* **Godot-Version:** Godot 4.7.2 (`4.7.2.stable.official.ed1daf0bf`)
* **Exportziel:** Web (HTML5 / WebGL2 via GL Compatibility Renderer, Threads: OFF)

---

## 2. Layout & Zentrierungsgarantie (9:16, 16:9 und alle Seitenverhältnisse)
Das Spiel passt sich dynamisch an jedes vom Viewport vorgegebene Seitenverhältnis an (`9:32`, `9:21`, `9:16`, `3:4`, `1:1`, `4:3`, `16:9`, `21:9`, `32:9`).

* **Stretch-Modus in Godot:** `mode = "canvas_items"`, `aspect = "expand"`. Verhindert jegliche Streckung, Unschärfe oder Verzerrung von UI, Texturen und Vektor-Rissen.
* **Garantierte Ei-Zentrierung (`EggCenterAnchor` -> `EggContainer` -> `EggVisual`):**
  * `EggCenterAnchor` liegt mit Ankern `(0.5, 0.5)` exakt im Zentrum des verfügbaren Spielbereichs.
  * `EggContainer` hält die feste logische Position und die Klick-Hitbox (`TouchArea`), sodass das Ei bei Klicks, Rissen, Bildschirmgrößenänderungen oder geöffneten Menüs niemals verrutscht.
  * Alle Squash-, Bounce- und Schüttelanimationen laufen ausschließlich auf dem inneren visuellen Container `EggVisual` und kehren nach jedem Tween exakt auf `Vector2.ZERO` zurück.
* **Viewport-Höhe 0 beim Start (Certification FAQ Defense):**
  * In `scripts/main.gd` fängt `_update_responsive_layout()` Fälle mit `vp_size.x <= 0 or vp_size.y <= 0` sauber ab, verhindert Division durch Null und wartet auf ein valides `size_changed`-Event.
* **Keine Orientierungssperre:** `window/handheld/orientation = 0` (Sensor/Unlocked).

---

## 3. Steuerung: Maus, Touch, Tastatur, Safe Areas
* **Touch & Maus:** Jeder Klick mit der linken Maustaste oder Fingertipp auf Touchscreens löst sofort die aktuelle effektive Klickkraft (`get_effective_click_power()`) aus. Animationen blockieren die Eingabe zu keinem Zeitpunkt.
* **Klick-Feedback:**
  * Federnde Links-/Rechts-Neigung und Squash-&-Bounce-Animation auf `EggVisual` (intensiver bei 25 %, 50 %, 75 %, 90 %, ab 9.000 Klicks und bei 9.999 Klicks).
  * Aufsteigende `+X`-Textanzeigen und anpassbare Klick-Partikel am Klickpunkt.
  * Natürlicher Tap-, Riss-, Kauf- und Aufbrech-Sound (`tap.wav`, `crack.wav`, `buy.wav`, `shatter.wav`).
* **Tastatur:** `ui_cancel` (`Esc`-Taste) schließt geöffnete Menüs (Shop, Slime-Sammlung) ohne `preventDefault()`.
* **Safe Areas:**
  * Mindestens 72 px Sicherheitsabstand am oberen Rand für YouTube-Chrome (Schließen, Stumm, Menü).
  * Mindestens 32 px Abstand an den Seiten und unten. Keine eigenen globalen Mute- oder Exit-Buttons.

---

## 4. Playables-Checkliste (MUST & SHOULD)

| Anforderung | Typ | Status | Datum | Doku-Referenz |
| :--- | :--- | :--- | :--- | :--- |
| **SDK vor Spielcode laden** | MUST | Erledigt | 2026-10-29 | [requirements_integration #1](https://developers.google.com/youtube/gaming/playables/certification/requirements_integration#1-load-playables-sdk) |
| **firstFrameReady Aufruf** | MUST | Erledigt | 2026-10-29 | [requirements_integration #2](https://developers.google.com/youtube/gaming/playables/certification/requirements_integration#2-game-ready-notification) |
| **gameReady Aufruf erst bei Interaktivität** | MUST | Erledigt | 2026-10-29 | [requirements_integration #2](https://developers.google.com/youtube/gaming/playables/certification/requirements_integration#2-game-ready-notification) |
| **Load time < 5 Sekunden** | SHOULD | Offen (Suite-Messung) | 2026-10-29 | [requirements_stability #5](https://developers.google.com/youtube/gaming/playables/certification/requirements_stability#5-load-time) |
| **Initial Bundle < 30 MiB (SHOULD < 15 MiB)** | MUST/SHOULD | Erledigt (11,76 MiB gzip) | 2026-10-29 | [requirements_stability #1](https://developers.google.com/youtube/gaming/playables/certification/requirements_stability#1-initial-bundle-size) |
| **Total Bundle < 250 MiB** | MUST | Erledigt (40,07 MiB raw) | 2026-10-29 | [requirements_stability #2](https://developers.google.com/youtube/gaming/playables/certification/requirements_stability#2-total-bundle-size) |
| **Individual File < 30 MiB (SHOULD < 512 KiB)** | MUST/SHOULD | Bewusst offen (Risiko wasm) | 2026-10-29 | [requirements_stability #3](https://developers.google.com/youtube/gaming/playables/certification/requirements_stability#3-individual-file-size) |
| **Cloud Save: saveData nach Progress** | MUST | Erledigt | 2026-10-29 | [requirements_integration #4](https://developers.google.com/youtube/gaming/playables/certification/requirements_integration#4-cloud-saves) |
| **Cloud Save: loadData vor saveData abwarten** | MUST | Erledigt | 2026-10-29 | [requirements_integration #4](https://developers.google.com/youtube/gaming/playables/certification/requirements_integration#4-cloud-saves) |
| **Save Data Größe < 3 MiB (SHOULD < 500 KiB)** | MUST/SHOULD | Erledigt (< 1 KiB) | 2026-10-29 | [requirements_stability #4](https://developers.google.com/youtube/gaming/playables/certification/requirements_stability#4-saved-game-size) |
| **User Scores: sendScore nur mit Integer** | MUST | Erledigt | 2026-10-29 | [requirements_integration #3](https://developers.google.com/youtube/gaming/playables/certification/requirements_integration#3-user-scores) |
| **Audio: isAudioEnabled & onAudioEnabledChange** | MUST | Erledigt | 2026-10-29 | [requirements_integration #5](https://developers.google.com/youtube/gaming/playables/certification/requirements_integration#5-mute-toggle) |
| **Kein eigener globaler Mute-Button** | SHOULD | Erledigt | 2026-10-29 | [requirements_integration #5](https://developers.google.com/youtube/gaming/playables/certification/requirements_integration#5-mute-toggle) |
| **Pause: onPause stoppt Spielloop, Audio, Render**| MUST | Erledigt | 2026-10-29 | [requirements_integration #6](https://developers.google.com/youtube/gaming/playables/certification/requirements_integration#6-pause-and-resume) |
| **Keine Page Visibility API für Pause/Resume** | MUST | Erledigt | 2026-10-29 | [requirements_integration #6](https://developers.google.com/youtube/gaming/playables/certification/requirements_integration#6-pause-and-resume) |
| **Responsive in allen Seitenverhältnissen** | MUST | Erledigt | 2026-10-29 | [requirements_design #1](https://developers.google.com/youtube/gaming/playables/certification/requirements_design#1-aspect-ratio-and-orientation) |
| **Kein Portrait/Landscape-Lock** | MUST | Erledigt | 2026-10-29 | [requirements_design #1](https://developers.google.com/youtube/gaming/playables/certification/requirements_design#1-aspect-ratio-and-orientation) |
| **Touch & Maus für jede Aktion** | MUST | Erledigt | 2026-10-29 | [requirements_design #2](https://developers.google.com/youtube/gaming/playables/certification/requirements_design#2-interaction-methods) |
| **Esc schließt Modals ohne preventDefault** | SHOULD/MUST | Erledigt | 2026-10-29 | [requirements_design #2](https://developers.google.com/youtube/gaming/playables/certification/requirements_design#2-interaction-methods) |
| **Keine Verwechslung / Exits / externe Links** | MUST | Erledigt | 2026-10-29 | [requirements_design #6](https://developers.google.com/youtube/gaming/playables/certification/requirements_design#6-disallowed-elements) |
| **Relative Pfade, gültige Dateinamen, <8000 Files** | MUST | Erledigt (11 Dateien) | 2026-10-29 | [requirements_stability #8-#10](https://developers.google.com/youtube/gaming/playables/certification/requirements_stability#8-file-references) |
| **JS Heap Peak < 512 MB** | MUST | Erledigt (~55 MB) | 2026-10-29 | [requirements_stability #6](https://developers.google.com/youtube/gaming/playables/certification/requirements_stability#6-crashes) |

---

## 5. Episches Drop-System, Shop & Slime-Sammlung

### 5.1 Drop-Wahrscheinlichkeiten (exakt 100,0 % Summe)
Die Drop-Berechnung (`_roll_slime_rarity()` in `scripts/main.gd`) erfolgt mathematisch exakt vor und unabhängig von der Enthüllungsanimation:

| Glücks-Stufe | Common | Uncommon | Rare | Epic | Legendary | Mythic | Summe |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Standard-Glück (Basis)** | 70,0 % | 20,0 % | 7,0 % | 2,0 % | 0,8 % | 0,2 % | **100,0 %** |
| **Lucky Charm** (2.500 M.) | 55,0 % | 25,0 % | 14,0 % | 4,2 % | 1,4 % | 0,4 % | **100,0 %** |
| **Epic Luck** (10.000 M.) | 40,0 % | 25,0 % | 20,0 % | 10,0 % | 4,0 % | 1,0 % | **100,0 %** |
| **Mythic Luck** (50.000 M.) | 25,0 % | 22,0 % | 25,0 % | 16,0 % | 8,5 % | 3,5 % | **100,0 %** |

### 5.2 Visuelle Seltenheitseffekte (`scripts/drop_reveal_effect.gd`)
* **Common:** Silber-Weiß, sanfte Strahlen und dezente Partikel (+1.500 Münzen).
* **Uncommon:** Natur-Grün, schwebende Blätter-Partikel (+2.000 Münzen).
* **Rare:** Kristall-Blau, leuchtende Eiskristalle und Schockwelle (+3.500 Münzen).
* **Epic:** Astral-Violett, 4-zackige magische Funken und violetter Schein (+7.000 Münzen).
* **Legendary:** Sonnen-Gold, strahlende goldene Lichtstrahlen und Doppel-Schockwelle (+16.000 Münzen).
* **Mythic:** Kosmisch (Violett & Cyan), gegenläufige Galaxie-Strahlen, schwebende Kristalle und Dreifach-Schockwelle (+51.000 Münzen).

### 5.3 Shop-System (4 Kategorien)
* **Klick-Kraft:** Doppelklick (2x, 250 M.), Dreifachklick (3x, 1.000 M.), Superklick (5x, 5.000 M.) – höchste aktive Stufe gilt ohne unkontrolliertes Stapeln.
* **Zeitbasierte Booster:** Klick-Booster (2x für 30s, 500 M.), Auto-Klicker (1 Klick/s für 60s, 1.500 M.), Turbo-Booster (5x für 15s, 2.000 M.) mit Live-Countdown-Anzeige.
* **Glücks-Upgrades:** Lucky Charm, Epic Luck, Mythic Luck mit transparenter 100%-Chancen-Vorschau im Shop.
* **Kosmetik (rein optisch):** Ei-Farben (`egg.svg` + `egg_overlay.svg`), Riss-Stile (Natur, Gold-Kintsugi, Magma-Glut, Frost-Kristall), Klick-Partikel, Hintergrund-Stimmungen und Supernova-Aura.

### 5.4 Slime-Sammlung (Inventar)
* Speichert alle gefundenen Slimes dauerhaft inkl. Anzahl (`Gefunden: Xx`), Seltenheitsfarbe, Beschreibung und `NEU!`-Badge für neu entdeckte Slimes.

---

## 6. SDK-Einbindung & Speichersystem
* **Wrapper:** `scripts/yt_game_sdk/YTGameWrapper.gd` als Autoload `YTGameWrapper`.
* **Konnektor:** `YTGameSDK.js` im Projektverzeichnis und im Build-Ordner.
* **Doppeltes Speichersystem (Schema v2):**
  * **Lokal:** `user://egg_save.json` speichert Klicks, Münzen, Upgrades, aktive Booster-Restzeiten, Kosmetik und Slime-Inventar.
  * **Cloud:** Synchronisation über `YTGameWrapper.save_data()` (erst nachdem `load_data()` abgeschlossen ist).
  * `YTGameWrapper.send_score()` sendet ausschließlich Integer-Werte.

---

## 7. Export & Gemessene Bundle-Größen
* **Preset:** `Web` (Single-Threaded, `variant/thread_support=false`)
* **Gemessene Dateigrößen (Stand 2026-10-29):**

| Datei | Raw (Bytes) | Raw (KiB/MiB) | Gzip (Bytes) | Gzip (KiB/MiB) | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `index.html` | 5.541 | 5,41 KiB | 2.236 | 2,18 KiB | OK (< 512 KiB) |
| `index.js` | 279.815 | 273,26 KiB | 68.740 | 67,13 KiB | OK (< 512 KiB) |
| `index.pck` | 2.161.228 | 2,06 MiB | 2.103.075 | 2,01 MiB | OK |
| `index.wasm` | 39.514.754 | 37,68 MiB | 10.114.291 | 9,65 MiB | Raw > 30 MiB (Gzip 9,65 MiB) |
| `YTGameSDK.js` | 5.655 | 5,52 KiB | 1.248 | 1,22 KiB | OK (< 512 KiB) |
| Icons & Worklets | ~46.507 | ~45,4 KiB | ~37.539 | ~36,7 KiB | OK (< 512 KiB) |
| **Initial Bundle (Gzip)** | — | — | **12.327.189** | **11,76 MiB** | **SHOULD < 15 MiB erreicht** |
| **Gesamtbundle (Raw)** | **42.013.543** | **40,07 MiB** | — | — | **MUST < 250 MiB erreicht** |

---

## 8. Testprotokoll der Doku-Test-Suite
* **Status:** Noch nicht in der gehosteten Suite getestet (erfordert Google-Account-Anmeldung im Entwickler-Browser).
* **Lokaler Testserver:** `serve.ps1` läuft aktiv auf Port 8085 mit Gzip-Kompression und offiziellen YouTube-CSP-Headern.
  * Startbefehl: `powershell -ExecutionPolicy Bypass -File .\serve.ps1 -Port 8085`
  * Lokale URL: `http://localhost:8085/index.html`

---

## 9. Bekannte Risiken
1. **Viewport-Höhe 0 bei WebView-Start:** Durch defensive Überprüfung `vp_size.y > 0` in `scripts/main.gd` neutralisiert.
2. **`index.wasm` Raw-Größe (37,68 MiB):** Unkomprimiert über 30 MiB, gzipped 9,65 MiB.
3. **Klick-Spamming & Überlauf:** Klicks werden durch `min(MAX_CLICKS, current_clicks + gain)` exakt bei `10.000` gekappt; Mehrfachauslösungen des Finales sind durch `is_hatched` und `is_revealing_drop` ausgeschlossen.

---

## 10. Änderungslog
* **2026-10-29 (Session 4 – Complete Visual Overhaul & UI Improvement):**
  * **Komplett überarbeitetes Hauptmenü (`MainMenuOverlay`):** Hero-Showcase mit animiertem Ei & Mythic-Slime, großem Start-/Weiterspielen-Button und Kachel-Buttons für Shop, Slime-Sammlung, Upgrades und Einstellungen inkl. Übergangsanimationen (`scripts/ui_kit.gd`).
  * **Eigenständige KI-generierte Slimes (`assets/slimes/slime_*_alpha.png`):** 6 individuell mit dem KI-Bildgenerator erstellte und mit Alpha-Matting freigestellte Slimes mit eigener Silhouette und Persönlichkeit für Common, Uncommon, Rare, Epic, Legendary und Mythic.
  * **Neuer Märchen-Slime-Welt-Hintergrund:** KI-generierte Slime-Landschaft (`assets/background.png`) kombiniert mit dem mehrschichtigen Atmosphären-System `scripts/world_backdrop.gd` (Sonnenstrahlen, schwebende Glühwürmchen/Kristallpartikel und wiegende Leuchtpflanzen).
  * **Zufällige Links/Rechts-Klickeffekte (`scripts/side_click_fx.gd`):** 6 Effektvarianten (Comic-Blitze, Lichtpartikel, Sterne/Funken, Energieimpulse, Kristallpartikel, Glitzerexplosionen) mit Klickserien-Skalierung (Combo-Streak) und Meilenstein-Bursts bei 1.000, 5.000, 9.000 und 9.999 Klicks.
  * **Neue Sammlerspiel-Fortschrittsanzeige (`scripts/fancy_progress_bar.gd`):** Abgerundeter Mehrfarb-Verlauf, weiche Interpolation, wandernder Shimmer-Glanz, Meilenstein-Diamanten und kombinierte Klick- & Prozentanzeige (`4.250 / 10.000  (42,5 %)`).
* **2026-10-29 (Session 3 – Epic Drop System & Shop Update):**
  * **Grafik & Texturen:** Zweischichtiges glänzendes Vektor-Ei (`assets/egg.svg` + `assets/egg_overlay.svg`), nahtloser 1024×1024 Cartoon-Hintergrund (`assets/background.png`) und 4 Riss-Stile in `scripts/crack_overlay.gd` implementiert.
  * **Zentrierungsgarantie:** Separater `EggVisual`-Container in `scenes/main.tscn`, damit `EggContainer` bei allen Klick- und Schüttelanimationen exakt zentriert bleibt.
  * **Episches Drop-Menü:** `scripts/drop_reveal_effect.gd` mit Seltenheits-Lichtstrahlen, Schockwellen und Partikeln für Common (70 %), Uncommon (20 %), Rare (7 %), Epic (2 %), Legendary (0,8 %) und Mythic (0,2 %).
  * **Shop & Währungssystem:** Shop-Icon oben rechts mit 4 Kategorien (Klick-Kraft 2x/3x/5x, Zeit-Booster mit Live-Timer, Glücks-Upgrades mit 100%-Tabellen, Kosmetik).
  * **Slime-Sammlung:** Inventar-Menü mit Fundzähler, Seltenheitsfarben und `NEU!`-Markierung.
  * **Web-Build & Tests:** Alle automatisierten Tests bestanden; Web-Export aktualisiert (`10,79 MiB` gzipped).
