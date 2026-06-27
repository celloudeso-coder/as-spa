# Lancement sur terminal Point de Vente SAGA (Windows)

Guide d'installation et de démarrage automatique de la caisse **AS SPA**
([`AS_SPA_Caisse.html`](AS_SPA_Caisse.html)) sur un TPV SAGA All-in-One sous
Windows, avec écran tactile, imprimante thermique 80 mm et tiroir-caisse RJ11.

> L'application est un **fichier HTML unique autonome**. Aucune installation de
> logiciel n'est requise, juste un navigateur **Chrome** ou **Edge** récent.
> La caisse, l'impression et le tiroir fonctionnent **hors-ligne** ; seuls
> l'export PDF et la **synchronisation Supabase** (optionnelle, voir §8) utilisent
> internet — et la sync rattrape automatiquement son retard dès le retour en ligne.

---

## 0. Préparation du fichier

1. Créer le dossier `C:\AsSpa\`.
2. Y copier `AS_SPA_Caisse.html`.
   Chemin final : `C:\AsSpa\AS_SPA_Caisse.html`.

> Les données (ventes, utilisateurs, PIN, réglages) sont stockées localement
> par le navigateur (IndexedDB). **Ne pas changer de navigateur ni vider les
> données du site**, sous peine de perdre l'historique. Faire des sauvegardes
> régulières via *Gestion → Sauvegarder les données*.

---

## 1. Créer un raccourci Chrome en mode kiosque (plein écran)

1. Clic droit sur le Bureau → **Nouveau → Raccourci**.
2. Coller la cible (adapter le chemin de `chrome.exe` si besoin) :

   ```
   "C:\Program Files\Google\Chrome\Application\chrome.exe" --kiosk --app=file:///C:/AsSpa/AS_SPA_Caisse.html --disable-pinch --overscroll-history-navigation=0
   ```

3. Nommer le raccourci **« Caisse AS SPA »** puis **Terminer**.

Explication des flags :

| Flag | Rôle |
|------|------|
| `--kiosk` | Plein écran total, sans barre d'adresse ni onglets |
| `--app=file:///C:/AsSpa/AS_SPA_Caisse.html` | Ouvre directement l'application |
| `--disable-pinch` | Désactive le zoom par pincement (gêne sur tactile) |
| `--overscroll-history-navigation=0` | Empêche le « swipe » de revenir en arrière |

> Avec **Microsoft Edge**, remplacer le chemin par
> `"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"` — les mêmes
> flags sont valables.
>
> Pour **quitter le mode kiosque** : `Alt + F4` (ou `Ctrl + W`).

---

## 2. Démarrage automatique avec Windows

1. Appuyer sur **`Windows + R`**.
2. Taper **`shell:startup`** puis **Entrée** — le dossier *Démarrage* s'ouvre.
3. Y **copier-coller le raccourci** « Caisse AS SPA » créé à l'étape 1
   (clic droit sur le raccourci → Copier, puis Coller dans ce dossier).

À chaque ouverture de session Windows, la caisse se lancera automatiquement en
plein écran.

> Pour ouvrir une session Windows sans mot de passe (caisse dédiée) :
> `Windows + R` → `netplwiz` → décocher *« Les utilisateurs doivent entrer un
> nom… »* → valider avec le compte voulu.

---

## 3. Désactiver veille et économiseur d'écran

Ouvrir l'**Invite de commandes en administrateur** (menu Démarrer → taper `cmd`
→ clic droit → *Exécuter en tant qu'administrateur*) et exécuter :

```bat
:: Jamais de mise en veille (secteur et batterie)
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0

:: Écran toujours allumé
powercfg /change monitor-timeout-ac 0
powercfg /change monitor-timeout-dc 0

:: Pas de mise en veille prolongée
powercfg /change hibernate-timeout-ac 0
powercfg /change hibernate-timeout-dc 0
powercfg /hibernate off
```

Désactiver l'économiseur d'écran : 
**Paramètres → Personnalisation → Écran de verrouillage → Écran de veille →
« (Aucun) »**.

---

## 4. Imprimante thermique par défaut + tiroir-caisse

### 4.1 Imprimante par défaut

1. **Paramètres → Bluetooth et appareils → Imprimantes et scanners**.
2. Sélectionner l'imprimante thermique 80 mm (port **USB** ou **série COM**).
3. Cliquer **« Définir par défaut »**.
4. Désactiver *« Laisser Windows gérer mon imprimante par défaut »* pour qu'elle
   le reste.

### 4.2 Réglages d'impression (format ticket)

Dans **Propriétés de l'imprimante → Préférences** :

- Largeur papier : **80 mm** (zone imprimable ~72 mm).
- Marges : **0** partout.
- Vitesse / densité : valeurs par défaut du constructeur.

> Dans la boîte d'impression de Chrome (si elle apparaît), choisir l'imprimante
> thermique, **Marges : Aucune**, et décocher *En-têtes et pieds de page*.
> Pour éviter cette boîte à chaque ticket, activer l'impression silencieuse via
> le flag `--kiosk-printing` ajouté à la cible du raccourci (étape 1).

### 4.3 Tiroir-caisse (RJ11 sur l'imprimante)

Le tiroir est relié à l'imprimante par le câble **RJ11**. Il s'ouvre quand
l'imprimante reçoit la commande **ESC/POS « drawer kick »** (`ESC p 0 25 250`),
que l'application envoie automatiquement :

- **Automatiquement** à chaque ticket, si l'option
  *Gestion → Paramètres → « Ouverture tiroir automatique à chaque impression »*
  est cochée (activée par défaut).
- **Manuellement** via le bouton **« Ouvrir tiroir »** (vue Caisse) ou la
  touche **F4** — réservé au Propriétaire et à l'Adjoint.

> Si le tiroir ne s'ouvre pas : vérifier dans les **préférences du pilote** de
> l'imprimante l'option *« Ouvrir le tiroir avant/après impression »* (selon le
> modèle SAGA/EPSON/XPrinter), et le branchement RJ11.

---

## 5. Raccourcis clavier (clavier AZERTY externe)

| Touche | Action |
|--------|--------|
| `F1` | Curseur sur le champ *Nom cliente* |
| `F2` | Enregistrer la vente |
| `F3` | Vider le panier (avec confirmation) |
| `F4` | Ouvrir le tiroir-caisse |
| `F5` | Basculer le plein écran |
| `Échap` | Fermer le reçu affiché |
| `Entrée` | Terminer (fermer le reçu) |
| `F12` | Afficher / masquer le panneau d'aide des raccourcis |

---

## 6. Mise à jour du fichier HTML

1. Fermer la caisse : `Alt + F4`.
2. **Sauvegarder les données** au préalable depuis une session :
   *Gestion → Sauvegarder les données* (fichier `ASSPA_backup_AAAA-MM-JJ.json`).
3. Remplacer `C:\AsSpa\AS_SPA_Caisse.html` par la nouvelle version
   (**même nom, même dossier** — sinon les données IndexedDB ne seront pas
   retrouvées, car elles sont liées à l'URL du fichier).
4. Relancer le raccourci « Caisse AS SPA ».
5. Vérifier que l'historique des ventes est bien présent (sinon, restaurer la
   sauvegarde via *Gestion → Restaurer une sauvegarde*).

> ⚠ Conserver impérativement le **même chemin de fichier** d'une version à
> l'autre : IndexedDB est isolé par origine (`file:///C:/AsSpa/...`). Changer le
> dossier ou le nom = nouvel espace de données vide.

---

## 7. Dépannage rapide

| Problème | Solution |
|----------|----------|
| L'écran se met en veille | Refaire l'étape 3 (`powercfg`) |
| Le ticket ne s'imprime pas | Imprimante par défaut ? (4.1) Marges à 0 ? (4.2) |
| Marges/coupures bizarres sur le ticket | Mettre **Marges : Aucune** et largeur 80 mm |
| Le tiroir ne s'ouvre pas | Option pilote (4.3) + câble RJ11 + réglage *tiroir auto* |
| Données disparues après mise à jour | Le fichier a changé de nom/dossier → revenir au chemin d'origine, puis restaurer la sauvegarde |
| Sortir du plein écran | `Alt + F4` ou `Ctrl + W` |
| Badge `● N non sync.` qui persiste | Vérifier la connexion internet + la config Supabase (§8) |
| Dashboard en ligne vide | Même URL + clé publishable que la caisse ? Migration SQL exécutée ? |
| Afficheur client muet | Reconnecter via §9 ; vérifier le port COM et le câble |
| 2ᵉ ligne de l'afficheur décalée | Modèle utilisant un autre code de saut de ligne → voir note §9 |

---

## 8. Synchronisation Supabase & dashboard en ligne (optionnel)

La caisse fonctionne parfaitement **sans** cette étape (tout reste local). Activer
la synchronisation permet au **propriétaire de consulter les ventes à distance**
via le dashboard en ligne, en temps réel.

### 8.1 Connecter la caisse

1. Caisse → **Gestion → Paramètres → Connexion Supabase**.
2. Saisir l'**URL du projet** (`https://xxxx.supabase.co`) et la **clé publishable**
   (`sb_publishable_…`).
3. **Tester & Enregistrer** → le badge de l'en-tête passe à **✓ Sync**
   (ou `● N non sync.` s'il reste des ventes à pousser).

> Les ventes sont toujours enregistrées en local d'abord, puis poussées en
> arrière-plan (toutes les 30 s, après chaque vente et au retour en ligne).
> Laisser les champs **vides** = caisse 100% hors-ligne.

### 8.2 Dashboard propriétaire (en ligne)

- Adresse : **<https://as-spa-flax.vercel.app>** → bouton *Dashboard Propriétaire*
  (ou directement `…/AS_SPA_Dashboard.html`).
- **1er lancement** : définir un mot de passe, puis saisir la **même** URL + clé
  publishable que la caisse.
- KPIs, top 7 services, 50 dernières transactions, export CSV, mise à jour en
  direct. Consultable depuis n'importe quel appareil (téléphone, PC).

> ⚠ Ne jamais saisir la clé **secrète** (`sb_secret_…`) ni le mot de passe de la
> base : seules l'URL et la clé **publishable** sont nécessaires.

---

## 9. Afficheur client VFD (écran prix côté cliente) — optionnel

Écran **2 lignes × 20 caractères** orienté vers la cliente, qui affiche les
services et les prix en temps réel. Branché au TPV en **série (COM)** ou **USB**,
piloté via la **Web Serial API** (Chrome / Edge sur Windows uniquement).

### 9.1 Repérer le port

1. Clic droit sur **Démarrer → Gestionnaire de périphériques**.
2. Dérouler **Ports (COM et LPT)** → noter le port de l'afficheur (ex. `COM3`).
   (Un afficheur USB peut apparaître comme « USB Serial Port (COMx) ».)

### 9.2 Connecter l'afficheur

1. Caisse → **Gestion → Paramètres → Afficheur client VFD**.
2. **Connecter l'afficheur** → Chrome affiche une popup de sélection : choisir le
   port noté à l'étape 9.1 (autorisation demandée **une seule fois** par origine).
3. Le badge **🖥 VFD** de l'en-tête passe au **vert**. Les boutons **Test bienvenue
   / Test total / Test défilement** permettent de vérifier l'affichage.

L'afficheur réagit ensuite automatiquement : ajout au panier (service + prix +
total), total à payer, remerciement, puis **mode veille** après 5 min d'inactivité.

> - Réglages port : **9600 bauds, 8 bits, 1 stop, sans parité** (standard VFD SAGA).
> - Si l'afficheur n'est pas connecté, la caisse fonctionne normalement (aucun effet).
> - **2ᵉ ligne décalée ?** Selon le modèle, le saut de ligne n'est pas `CR/LF`.
>   Dans `AS_SPA_Caisse.html`, fonction `vfdSend`, remplacer les octets
>   `[0x0D,0x0A]` par la commande du modèle (ex. `[0x1B,0x6C,0x02]`).
> - La popup de choix du port réapparaît après un changement de port USB ou un
>   nettoyage des autorisations du navigateur.

---

**AS SPA — Institut de beauté**
RATOMA, Carrefour Hôtel MARIADOR PALACE — Tél : 623 606 098
