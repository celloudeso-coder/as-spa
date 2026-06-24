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
- **Gestion** : utilisateurs et codes PIN, sauvegarde/restauration des données
  (JSON) et réinitialisation.
- **Exports** : **CSV** et **PDF** des transactions de la période filtrée.

## Profils & accès

L'accès se fait par profil + code PIN. Trois rôles, avec des droits croissants :

| Rôle         | Badge  | Caisse | Dashboard | Gestion | Export CSV/PDF | Réinitialisation |
| ------------ | ------ | ------ | --------- | ------- | -------------- | ---------------- |
| Propriétaire | `PROP` | ✓      | ✓         | ✓       | ✓              | ✓                |
| Adjoint      | `ADJ`  | ✓      | ✓         | —       | ✓              | —                |
| Caissier     | `CAIS` | ✓      | —         | —       | —              | —                |

Profils par défaut (à modifier après la première connexion) :

| Profil | PIN |
|--------|-----|
| Propriétaire | `1234` |
| Adjoint | `5678` |
| Caissier | `0000` |

## Utilisation

Ouvrir [`AS_SPA_Caisse.html`](AS_SPA_Caisse.html) dans un navigateur récent
(mobile ou desktop), puis se connecter avec un profil et son PIN.

> **Note** : l'export **PDF** charge dynamiquement les librairies
> [jsPDF](https://cdnjs.com/libraries/jspdf) (2.5.1) et
> [jspdf-autotable](https://cdnjs.com/libraries/jspdf-autotable) (3.8.2) depuis
> le CDN cdnjs ; une connexion internet est nécessaire **uniquement** pour cet
> export. Tout le reste fonctionne hors-ligne.

## Données

- Stockage local **IndexedDB** (`AsSpaDB`) : transactions, utilisateurs, compteur de reçus.
- **Sauvegarde** : export JSON (`ASSPA_backup_AAAA-MM-JJ.json`).
- **Exports** : `ASSPA_AAAA-MM-JJ.csv` et `ASSPA_rapport_AAAA-MM-JJ.pdf`.

## Technique

- Fichier unique HTML/CSS/JS, sans étape de build.
- Palette or/champagne, police serif Georgia pour les titres.
- Devise : Franc guinéen (**GNF**).
