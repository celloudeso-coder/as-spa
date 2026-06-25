# AS SPA — Caisse

Application de caisse **PWA** (Progressive Web App) pour l'institut de beauté
**AS SPA** à Conakry (RATOMA, Carrefour Hôtel MARIADOR PALACE — Tél : 623 606 098).

Le tout tient dans un **unique fichier HTML autonome** : [`AS_SPA_Caisse.html`](AS_SPA_Caisse.html)
(HTML + CSS + JavaScript, sans dépendance à installer). Il fonctionne hors-ligne
et stocke ses données localement dans le navigateur via **IndexedDB**.

## Fonctionnalités

- **Caisse** : sélection des prestations par catégorie (Pédicure & Manucure,
  Onglerie, Épilation, Soins visage, Cils, Massage, Hammam & Sauna), panier,
  choix du mode de paiement (Espèces, Orange Money, Wave, Carte), génération
  et impression d'un reçu.
- **Dashboard** : chiffre d'affaires, nombre de transactions, panier moyen,
  prestations vendues, CA par caissier, top 7 des services et liste des
  transactions, avec filtres (Aujourd'hui / Cette semaine / Ce mois / Tout).
- **Gestion** : utilisateurs et codes PIN, paramètres, sauvegarde/restauration
  des données (JSON) et réinitialisation.
- **Exports** : **CSV** et **PDF** des transactions de la période filtrée.
- **Impression thermique** : ticket texte 48 colonnes (rouleau 80 mm) envoyé à
  l'imprimante via une iframe `@media print` ; impression A4 classique en repli.
- **Tiroir-caisse** : ouverture automatique à l'impression (commande ESC/POS) ou
  manuelle (bouton « Ouvrir tiroir » / touche F4), réservée Propriétaire & Adjoint.

## Profils & accès

L'accès se fait par profil + code PIN. Trois rôles, avec des droits croissants :

| Rôle         | Badge | Caisse | Dashboard | Gestion | Export CSV/PDF | Réinitialisation |
| ------------ | ----- | ------ | --------- | ------- | -------------- | ---------------- |
| Propriétaire | 👑    | ✓      | ✓         | ✓       | ✓              | ✓                |
| Adjoint      | 🔑    | ✓      | ✓         | —       | ✓              | —                |
| Caissier     | 💼    | ✓      | —         | —       | —              | —                |

Profils par défaut (à modifier après la première connexion) :

| Profil       | PIN    |
| ------------ | ------ |
| Propriétaire | `1234` |
| Adjoint      | `5678` |
| Caissier     | `0000` |

## Terminal Point de Vente (TPV SAGA)

L'application est optimisée pour un TPV **SAGA All-in-One** sous Windows (écran
tactile 1024×768, imprimante thermique, tiroir-caisse RJ11) :

- Interface tactile : cibles ≥ 48 px, services ≥ 80 px, polices ≥ 14 px,
  défilement interne fluide, bouton **Plein écran**.
- Impression thermique ESC/POS + ouverture automatique du tiroir.
- **Raccourcis clavier** (clavier AZERTY externe) : `F1` nom cliente ·
  `F2` enregistrer la vente · `F3` vider le panier · `F4` ouvrir le tiroir ·
  `F5` plein écran · `F12` panneau d'aide · `Échap` fermer le reçu ·
  `Entrée` terminer le reçu.

Procédure complète d'installation et de démarrage automatique :
voir [`LANCEMENT_SAGA.md`](LANCEMENT_SAGA.md).

## Utilisation

Ouvrir [`AS_SPA_Caisse.html`](AS_SPA_Caisse.html) dans un navigateur récent
(mobile ou desktop), puis se connecter avec un profil et son PIN.

> **Note** : l'export **PDF** charge dynamiquement les librairies
> [jsPDF](https://cdnjs.com/libraries/jspdf) (2.5.1) et
> [jspdf-autotable](https://cdnjs.com/libraries/jspdf-autotable) (3.8.2) depuis
> le CDN cdnjs ; une connexion internet est nécessaire **uniquement** pour cet
> export. Tout le reste fonctionne hors-ligne.

## Données

- Stockage local **IndexedDB** (`AsSpaDB`) : transactions, utilisateurs, compteur
  de reçus et paramètres (ex. `tiroir_auto` pour l'ouverture automatique du tiroir).
- **Sauvegarde** : export JSON (`ASSPA_backup_AAAA-MM-JJ.json`).
- **Exports** : `ASSPA_AAAA-MM-JJ.csv` et `ASSPA_rapport_AAAA-MM-JJ.pdf`.

## Technique

- Fichier unique HTML/CSS/JS, sans étape de build.
- Palette or/champagne, police serif Georgia pour les titres.
- Devise : Franc guinéen (**GNF**).
