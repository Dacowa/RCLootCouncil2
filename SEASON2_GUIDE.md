# Season 2 Lootverteilungs-System – Anleitung

## 📋 Überblick
Das Season 2 System wurde erfolgreich in dein RCLootCouncil Addon integriert. Es verwaltet automatisch die Loot-Prioritäten basierend auf der Anzahl der Items, die jeder Spieler bereits gewonnen hat.

---

## 🎯 Wie es funktioniert

### Prioritäts-Berechnung
- **Keine Items gewonnen**: Spieler würfelt mit `/rnd 100`
- **1 Item gewonnen**: Spieler würfelt mit `/rnd 99`
- **2 Items gewonnen**: Spieler würfelt mit `/rnd 98`
- **X Items gewonnen**: Spieler würfelt mit `/rnd (100 - X)`

Die Mindest-Roll ist **1** (kann nicht tiefer sinken).

### Auto-Pass System
- **Nur der Loot Master** kann auf Items abstimmen/würfeln
- **Alle anderen Spieler** passen automatisch auf **ALLE** Items
- Spieler müssen keine Aktion durchführen – es ist völlig transparent
- Das System ist so designed, dass die Loot-Vergabe ausschließlich über /rnd erfolgt

### ID-Reset (Raid-Zyklus)
Der "Raid-Zyklus" ist eine ID, die für einen kompletten Raid-Tag gilt. Der Reset kann auf zwei Wegen erfolgen:

#### Option 1: Manueller Reset (empfohlen)
- LootMaster öffnet das VotingFrame
- **Reset Button** klicken, wenn eine neue ID anfängt
- Bestätigung im Dialog akzeptieren
- Alle Spieler-Prioritäten werden zurückgesetzt zu 100

#### Option 2: Automatischer Reset (Mittwoch)
- Aktiviert: Jeden Mittwoch um 19:00 UTC automatisches Reset
- Kann in den Optionen aktiviert/deaktiviert werden
- **Empfehlung**: Nutze lieber den manuellen Button für mehr Kontrolle

---

## 🎮 Benutzer-Interface

### VotingFrame – Priority-Spalte
Im Voting-Frame erscheint eine neue Spalte **"Priority"** die folgende Infos zeigt:
```
1 [/rnd 99]     ← Spieler hat 1 Item, würfelt 99
0 [/rnd 100]    ← Spieler hat 0 Items, würfelt 100
3 [/rnd 97]     ← Spieler hat 3 Items, würfelt 97
```

**Diese Spalte wird automatisch aktualisiert** wenn:
- Ein Item vergeben wird
- Der Raid-Zyklus resettet wird

### Reset Button
Der Reset Button ist nur für den **Loot Master** sichtbar und befindet sich im Voting-Frame.

---

## ⚙️ Einstellungen

Alle Einstellungen findest du in den RCLootCouncil Optionen:

```
Season 2 System
├─ Season 2 Aktivieren ✓
├─ Auto-Pass aktivieren ✓
├─ Prioritäten anzeigen ✓
└─ Automatischer Reset jeden Mittwoch ✓
```

### Empfohlene Einstellungen:
- **Season 2 aktivieren**: JA (Hauptschalter)
- **Auto-Pass aktivieren**: JA (automatisches Passen)
- **Prioritäten anzeigen**: JA (Info für Spieler)
- **Auto-Reset**: JA oder NEIN (nach Vorliebe)

---

## 📊 Beispiel-Szenario

**Boss 1 – Schwert droppt**
- Max: 0 Items → würfelt 100 → gewinnt (z.B. 87)
- Moritz: 0 Items → würfelt 100 → verliert (z.B. 42)
- **Ergebnis**: Max: 1 Item, Moritz: 0 Items

**Boss 2 – Schild droppt**
- Max: 1 Item → würfelt 99
- Moritz: 0 Items → würfelt 100
- **Max würfelt**: 72 (im /rnd 99 range)
- **Moritz würfelt**: 51 (im /rnd 100 range)
- **Ergebnis**: Max gewinnt trotz gleicher Würfelglück-Bedingungen
- **Weil**: Moritz' 100er-Range ist besser als Max' 99er-Range

**Nach mehreren Bossen – alle gleich ausgestattet**
- Wenn alle Spieler ≥1 Item haben:
- Alle würfeln mit 99 (oder tiefer, je nach Anzahl)
- Die Chancen sind wieder gleich verteilt

---

## 🔧 Technische Details

### Tracking
- **Datenspeicherung**: SavedVariables → `RCLootCouncilDB.lootPriority`
- **Aktuelle ID**: Wird beim ersten Loot generiert
- **Spieler-Statistiken**: `playerStats[spielername] = anzahl_items`

### Nachrichten (Intern)
Das System sendet folgende Nachrichten für interne Synchronisation:
- `RCLootPriorityIDReset` – ID hat sich resettet
- `RCLootPriorityUpdated` – Spieler hat Item gewonnen
- `RCLootPriorityTrackerReset` – Komplett reset

---

## ❓ Häufig gestellte Fragen

**F: Können Spieler manuell abstimmen?**  
A: Nein. Alle außer dem Loot Master passen automatisch. Das System ist für reine /rnd-Verteilung gedacht.

**F: Was passiert beim Disconnect?**  
A: Die Prioritäts-Daten bleiben erhalten. Nach dem Reconnect wird die aktuelle ID weiterhin verwendet.

**F: Kann ich den Reset rückgängig machen?**  
A: Nein. Der Reset ist final. Falls nötig, manuell in den SavedVariables korrigieren.

**F: Funktioniert das System mit Transmog/BoE Items?**  
A: Ja. Alle Items zählen zum Tracking, ob BoE, BoP oder Transmog.

**F: Was wenn der Loot Master offline ist?**  
A: Der Reset muss von jemandem durchgeführt werden, der als Loot Master konfiguriert ist. Der Reset Button ist nur für ihn sichtbar.

---

## 🔄 Workflow für deine Gilde

### Vorbereitung
1. **Einstellungen checken**: Alle Season 2 Einstellungen auf ✓
2. **Spieler informieren**: "Wir nutzen das neue Prioritäts-System"

### Pro Raid-Abend
1. **Raid startet** → Erster Loot droppt
2. **Loot Master**: Reset Button klicken wenn es losgeht
3. **Während des Raids**: VotingFrame zeigt automatisch Prioritäten
4. **Items werden vergeben**: Auto-Pass passiert im Hintergrund
5. **Nächster Tag/Woche**: Neuer Reset für neue ID

### Monitoring
- Überprüfe regelmäßig die Priority-Spalte im VotingFrame
- Stelle sicher, dass Loot fair verteilt wird
- Bei Fragen nachschauen welcher Spieler wie viele Items hat

---

## 🆘 Troubleshooting

**Problem: Priority-Spalte zeigt nichts**  
→ Sicherstelle, dass `season2Enabled` in Optionen aktiviert ist

**Problem: Auto-Pass funktioniert nicht**  
→ Überprüfe ob du der Loot Master bist (dann funktioniert es nicht)
→ Check ob `season2AutoPass` aktiviert ist

**Problem: Reset Button ist nicht sichtbar**  
→ Du musst der Loot Master sein
→ Das VotingFrame muss offen sein

**Problem: Prioritäten stimmen nicht**  
→ Raid ID noch nicht resettet? Versuche manuell zu resetten
→ Log mit `/rclc debug` prüfen

---

## 📝 Anmerkungen

- **Performance**: Das System ist sehr ressourcenschonend
- **Kompatibilität**: Vollständig kompatibel mit bestehendem RC Loot Council
- **Backup**: Prioritäts-Daten werden in SavedVariables gespeichert (nicht gelöscht auf reload)

---

**Version**: 1.0  
**Letztes Update**: 2026-08-16  
**Autor**: Copilot (Season 2 Implementation)

Viel Erfolg mit der neuen Lootverteilung! 🎉
