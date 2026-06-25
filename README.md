# AS SPA — Caisse

Application de caisse **PWA** (Progressive Web App) pour l'institut de beauté
**AS SPA** à Conakry (RATOMA, Carrefour Hôtel MARIADOR PALACE — Tél : 623 606 098).

La caisse tient dans un **unique fichier HTML autonome** : [`AS_SPA_Caisse.html`](AS_SPA_Caisse.html)
(HTML + CSS + JavaScript, sans dépendance à installer). Elle fonctionne hors-ligne
et stocke ses données localement dans le navigateur via **IndexedDB**. Un dashboard
propriétaire et une synchronisation Supabase sont disponibles en option.

## Contenu du dépôt

- [`index.html`](index.html) — page d'accueil (liens Dashboard / Caisse), servie à la racine du site Vercel.
- [`AS_SPA_Caisse.html`](AS_SPA_Caisse.html) — caisse PWA autonome, 100% hors ligne (IndexedDB).
- [`AS_SPA_Dashboard.html`](AS_SPA_Dashboard.html) — dashboard propriétaire (lecture Supabase), déployable Vercel / GitHub Pages.
- [`supabase/migration_asspa.sql`](supabase/migration_asspa.sql) — schéma Supabase (table, index, RLS) + guide de création du projet.
- [`LANCEMENT_SAGA.md`](LANCEMENT_SAGA.md) — installation & démarrage automatique sur TPV SAGA (Windows).

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

## Synchronisation Supabase (optionnelle)

La caisse fonctionne **100% hors ligne** : IndexedDB reste la source de vérité.
Supabase est une couche de synchronisation **facultative** — si les champs de
config sont vides, rien ne sort de l'appareil.

- Chaque transaction porte un champ `synced` ; un service pousse en arrière-plan
  (toutes les 30 s, après chaque vente et au retour en ligne) les transactions
  non synchronisées via `upsert` sur `local_id` (déduplication).
- Configuration dans **Gestion → Paramètres → Connexion Supabase** (URL + clé
  anon). Un badge header indique l'état : `● N non sync.` ou `✓ Sync`.
- **Dashboard propriétaire** séparé : [`AS_SPA_Dashboard.html`](AS_SPA_Dashboard.html)
  (déployable sur Vercel / GitHub Pages) — accès par mot de passe (SHA-256),
  KPIs, top 7 services, 50 dernières transactions, export CSV, et actualisation
  temps réel (Supabase Realtime + rafraîchissement 60 s).
- Schéma de base de données : [`supabase/migration_asspa.sql`](supabase/migration_asspa.sql)
  (table `transactions`, index, politiques RLS, instructions de création du projet).

### Mise en route (testé)

1. **Base** : exécuter [`supabase/migration_asspa.sql`](supabase/migration_asspa.sql)
   dans le SQL Editor du projet Supabase (*Run* → « Success. No rows returned »).
2. **Caisse** : Gestion → Paramètres → Connexion Supabase → saisir l'URL du projet
   et la clé publishable (`sb_publishable_…`, joue le rôle de clé anon), puis
   *Tester & Enregistrer*. Le badge du header passe à `✓ Sync`.
3. **Dashboard** : ouvrir `AS_SPA_Dashboard.html`, définir le mot de passe, saisir
   la même URL + clé → les ventes de la caisse s'affichent en direct.

> Les identifiants se saisissent dans l'interface (jamais en dur dans les fichiers
> ni dans Git). La clé `service_role` / secret et le mot de passe Postgres ne sont
> **pas** utilisés par les applications.

## Utilisation

Ouvrir [`AS_SPA_Caisse.html`](AS_SPA_Caisse.html) dans un navigateur récent
(mobile ou desktop), puis se connecter avec un profil et son PIN.

> **Note** : l'export **PDF** charge dynamiquement les librairies
> [jsPDF](https://cdnjs.com/libraries/jspdf) (2.5.1) et
> [jspdf-autotable](https://cdnjs.com/libraries/jspdf-autotable) (3.8.2) depuis
> le CDN cdnjs ; une connexion internet est nécessaire **uniquement** pour cet
> export. Tout le reste fonctionne hors-ligne.

## Déploiement (Vercel)

Le dépôt est un **site statique** (aucune étape de build) déployé sur Vercel,
branché sur la branche `main` (chaque `git push` redéploie automatiquement).

- **En ligne** : <https://as-spa-flax.vercel.app>
  - `/` → page d'accueil ([`index.html`](index.html))
  - `/AS_SPA_Dashboard.html` → dashboard propriétaire
  - `/AS_SPA_Caisse.html` → caisse (instance en ligne, données séparées du TPV)
- **Réglages d'import Vercel** : preset `Other`, *Root Directory* `./`, **aucune**
  commande de build, **aucune** variable d'environnement (l'URL + la clé
  Supabase se saisissent dans l'interface, jamais dans Vercel ni dans Git).
- La page d'accueil est servie via une vraie `index.html` (pas de `vercel.json` :
  un rewrite `/` + `cleanUrls` provoquait un 404 à la racine).
- Le **dashboard** a besoin du **HTTPS** (Vercel) pour le hachage SHA-256 du mot
  de passe ; la **caisse du TPV** reste en local (`file://`, voir
  [`LANCEMENT_SAGA.md`](LANCEMENT_SAGA.md)).

## Données

- Stockage local **IndexedDB** (`AsSpaDB`, v3) : `transactions` (avec champ
  `synced`), `users`, `meta` (compteur de reçus, `tiroir_auto`, `supabase_config`)
  et `sync_queue`.
- **Sauvegarde** : export JSON (`ASSPA_backup_AAAA-MM-JJ.json`).
- **Exports** : `ASSPA_AAAA-MM-JJ.csv`, `ASSPA_rapport_AAAA-MM-JJ.pdf` et
  `ASSPA_dashboard_AAAA-MM-JJ.csv` (depuis le dashboard).

## Technique

- Fichiers HTML/CSS/JS autonomes, sans étape de build.
- Dépendances chargées à la demande depuis un CDN (connexion requise seulement
  à ce moment) : jsPDF + jspdf-autotable (export PDF), supabase-js (sync optionnelle).
- Palette or/champagne, police serif Georgia pour les titres.
- Devise : Franc guinéen (**GNF**).
