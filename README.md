ROLL & UPPDRAG

Du är lead Flutter-utvecklare + tech writer. Bygg och leverera en mobil-först Flutter-app (Android, iOS, Flutter Web PWA) som visar hjälpguider om svenska myndighetstjänster på enkel svenska + hemspråket med uppläsning (TTS) av hemspråksraden.
Målgrupp: vuxna med låg digital vana och svenska på A1–A2.
Krav på språk i UI: varje steg visas i två rader: Rad A = enkel svenska, Rad B = hemspråket (TTS läser Rad B).

PRODUKTENS SYFTE

Hjälpa användaren att fullfölja vanliga e-tjänst-uppgifter (1177, Kivra, AF m.fl.) utan handledare.

Minimera stress: korta, tydliga steg; konsekvent språk; uppläsning.

Fungerar offline efter första visning av en guide.

ICKE-MÅL (MVP)

Ingen inloggning, inga konton, ingen spårning.

Inget autofyll i myndighetsformulär.

Inga skärmbilder i MVP (text först).

Inget GPT-chatläge i appen (detta är en instruktionsbok).

PERSONOR (för designbeslut)

A: Ny i Sverige, låg digital vana, saknar ibland BankID.

B: Har BankID, låg svenska, rädd att göra fel.

C: Klarar grunderna men fastnar på “ladda upp/foto/PDF”.

GLOBALA ACCEPTANSKRITERIER

Vid start måste appen fråga: “Vilket språk vill du använda?” (varje appstart).

Varje guide har Förberedelser, Steg 1–6 (två rader/ steg), Om det strular.

TTS spelar upp endast hemspråksraden; paus (~600 ms) mellan steg.

Offline: En guide som visats online ska gå att läsa offline.

Tillgänglighet: stora tryckytor (min 48×48 dp), hög kontrast, skärmläsarstöd (Semantics).

Integritet: inga personuppgifter lagras; inga tredjeparts-trackers.

SAMARBETE MED AI-ASSISTENT

Det här repo:t är kopplat till en AI-assistent som kan läsa och ändra filer lokalt i den här utvecklingsmiljön. Assistenten kan hjälpa till att ta fram kod, översättningar och dokumentation, men det finns ett par viktiga begränsningar att känna till:

* Ingen nätverksåtkomst – assistenten kan inte nå externa API:er, webbplatser eller din Git-fjärr.
* Ingen autentisering – kommandon som kräver inloggning (t.ex. `git push`, `firebase deploy`) måste köras manuellt av en människa.
* Manuell granskning – behandla förslag från assistenten som utkast; granska och testa innan de checkas in eller pushas vidare.

Vill du föra över ändringar till ditt eget repo gör du det själv via terminalen, t.ex. `git remote add`, `git push`, osv. Assistenten kan däremot hjälpa dig med steg-för-steg-instruktioner om du behöver.

FUNKTIONALITET (MVP)
1) Språkflöde

Startskärm varje appstart: 8–12 språkknappar med endonym (t.ex. العربية) + svensk benämning + flagg-ikon (hjälpmedel).

Glob-ikon i app-baren för språkbyte när som helst (gäller tills appen stängs).

Språklista v1: ar (arabiska), so (somaliska), ti (tigrinska), fa (persiska/farsi), prs (dari), uk, ru, tr, en, sv.

2) Hemskärm (kakel / GridView)

Ordning efter frekvens × smärta:

BankID – Logga in (samma/annan enhet), Byta kod, Låst (översikt)

1177 – Logga in (samma/annan), Läsa meddelande, Boka tid (light)

Kivra – Aktivera & logga in, Läsa nytt brev / Öppna PDF

Arbetsförmedlingen – Logga in, Ladda upp dokument/foto

Skatteverket – Logga in, Hämta personbevis (PDF)

Försäkringskassan – Logga in, Ladda upp intyg (orientering)

E-post & meddelanden – Logga in, Öppna bilaga, Skicka bild/fil

Mobilens grunder – Wi-Fi, Öppna länk/QR, Skärmdump

Översättning & AI – Google Översätt (kamera/röst), enkel fråga-guide

Kommun & skola – Hitta e-tjänst, Logga in (generiskt)

Trygghet & “visa-upp” – korta fraser (kommunikationstöd)

3) Guidevy

Titel + Förberedelser (2–4 punkter).

Stegkort 1–6: två rader text per steg:

sv_enkel (max 9–12 ord, verb först)

hs (hemspråk – TTS läser denna rad)

Lyssna-knapp per steg: TTS av hs.

Om det strular: 2–4 fel→åtgärd, gärna med stepIndex.

Info-ikon (“i”): Källor (etikett + URL) och Senast verifierad: YYYY-MM-DD.

INNEHÅLL (MVP-GUIDER) Uppdatering finns längre ner!!!!

Följande fem ska finnas färdiga:

1177 – Logga in (samma enhet)

1177 – Logga in (annan enhet)

Kivra – Aktivera & logga in

Kivra – Läsa nytt brev

Arbetsförmedlingen – Ladda upp dokument/foto

Varje guide är skriven i A1-svenska, två rader/ steg, och har “Om det strular”. Texterna bygger på officiella, publika källor, omformulerade till enkel svenska och försedda med källa + datum.


fortsättning ökad kravställning samt plan


📋 Del 1: Inventering av vad som finns vs. vad som ska finnas
Nuvarande status (5 guider finns):
✅ 1177 - Logga in (samma enhet)
✅ 1177 - Logga in (annan enhet)
✅ Kivra - Aktivera & logga in
✅ Kivra - Läsa nytt brev
✅ AF - Ladda upp dokument/foto
Saknas (11 nya guider):
❌ Mobilens grunder - Wi-Fi anslut
❌ Mobilens grunder - Öppna länk/QR
❌ Mobilens grunder - Skärmdump
❌ Översättning & AI - Google Översätt kamera
❌ Översättning & AI - Google Översätt röst↔text
❌ BankID - Logga in (samma enhet)
❌ BankID - Logga in (annan enhet)
❌ 1177 - Läsa meddelande (saknas, vi har bara "logga in")
❌ Skatteverket - Hämta personbevis
❌ FK - Logga in (orientering)
❌ E-post - Logga in
❌ E-post - Skicka bild/fil
❌ Trygghet - "Visa-upp-kort" (2 st)

🗣️ Del 2: Språk & TTS-problem
Nuvarande språkstöd:

Svenska (sv) ✅
Arabiska (ar) ✅ (översättning finns)
Somaliska (so) ✅ (översättning finns, MEN fel TTS)
Tigrinska (ti) ⚠️ (ingen översättning, ingen TTS)
Persiska/Farsi (fa) ⚠️ (ingen översättning, TTS?)
Dari (prs) ⚠️ (ingen översättning, TTS?)
Ukrainska (uk) ⚠️ (ingen översättning, TTS?)
Ryska (ru) ⚠️ (ingen översättning, TTS?)
Turkiska (tr) ⚠️ (ingen översättning, TTS?)
Engelska (en) ⚠️ (ingen översättning)

TTS-problem att lösa:
Problem 1: Somaliska läses med svensk röst

Flutter's flutter_tts hittar ingen somalisk röst
Läser somalisk text med svensk uttal = oförståeligt

Lösningar:

Moln-TTS (Azure/Google Cloud) - har somaliska röster
Förinspelade MP3 - spela in varje steg
Extern TTS-app - länka till Google Översätt-app

Problem 2: Tigrinska saknar TTS helt

Nästan ingen TTS-tjänst har tigrinska
Lösning: Endast förinspelade MP3-filer

 arbetsgång:
Fas 1: Fixa befintliga 5 guider (snabbast) *klart*

Lägg till översättningar för alla 8 saknade språk 

Fixa somalisk TTS (välj lösning)
Testa att allt fungerar

Fas 2: Lägg till de 11 nya guiderna 

Skapa innehåll på svenska först
Översätt till alla 10 språk
Generera/spela in TTS för problematiska språk

Fas 3: TTS-integration (tekniskt)

Implementera moln-TTS-fallback
Lägg till förinspelade ljud
Cacha allt för offline


Plan framåt:

TTS: Moln-TTS (Azure/Google) - Implementeras senare när guiderna finns
Prioritering: Lägga till nya guider på svenska först
Översättningar: Maskinöversättning + kvalitetskontroll



uppdatering: alla guider skrivan på svenska

översättningar gjorda för arabiska, somaliska, ryska, ukrinska
Arabiska dock trasig