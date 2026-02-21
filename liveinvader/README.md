# 📣 Liveinvader Script - Dokumentation

Willkommen beim **Liveinvader News System**! Mit diesem Script können Spieler Werbeanzeigen auf dem Server schalten, die für alle Spieler sichtbar sind.

---

## 🚀 Nutzung

1. **Standort**: Gehe zum Liveinvader Gebäude (roter Marker).
2. **Öffnen**: Drücke die Taste **[E]**, um das Tablet zu öffnen.
3. **Anzeige schreiben**: Gib deine Nachricht in das Textfeld ein.
4. **Zahlen**: Wähle zwischen **Barzahlung** (Brieftaschen-Icon) oder **Bankzahlung** (Karten-Icon).
5. **Anzeige**: Sobald du bezahlst, wird die Anzeige oben links für alle Spieler eingeblendet und im Newsfeed gespeichert.

---

## ⚙️ Konfiguration (Änderungen vornehmen)

Hier findest du die wichtigsten Stellen, um das Script nach deinen Wünschen anzupassen:

### 1. "Silent" Text & Branding ändern
Wenn du den Text "Silent" im Tablet ändern möchtest:
*   **Datei**: `html/index.html`
*   **Zeile**: 20
*   **Code**: `<div class="title-silent">Silent</div>`

### 2. Preise anpassen
Der Preis wird pro Zeichen berechnet.
*   **Server-seitig** (für die tatsächliche Abbuchung):
    *   **Datei**: `server.lua`
    *   **Zeile**: 9
    *   **Code**: `local cost = #message * 5` (Ändere die `5` in deinen Wunschpreis).
*   **Client-seitig** (für die Anzeige im Tablet):
    *   **Datei**: `html/script.js`
    *   **Zeile**: 10
    *   **Code**: `let costPerChar = 5;` (Muss mit dem Wert in der `server.lua` übereinstimmen).

### 3. Standort / Koordinaten ändern
Um den Punkt zu verschieben, an dem man das Tablet öffnen kann:
*   **Datei**: `client.lua`
*   **Zeile**: 3
*   **Code**: `local lifeinvaderCoords = vector3(-1083.0861, -248.0762, 37.7633)`

### 4. Marker-Aussehen ändern
Wenn du die Farbe oder Größe des roten Kreises am Boden ändern willst:
*   **Datei**: `client.lua`
*   **Zeile**: 71
*   **Parameter**: `DrawMarker(1, ... 209, 33, 39, ...)` (Die Zahlen 209, 33, 39 sind der RGB-Farbcode für Rot).

---

## 🛠️ Installation
1. Ordner `liveinvader` in deinen `resources` Ordner kopieren.
2. In der `server.cfg` mit `ensure liveinvader` eintragen.
3. Server neustarten oder Script starten.

---
*Erstellt für den Server von Silent.*
