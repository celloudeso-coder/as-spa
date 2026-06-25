-- ═══════════════════════════════════════════════════════════════════════════
--  AS SPA — Schéma Supabase pour la synchronisation de la caisse
-- ═══════════════════════════════════════════════════════════════════════════
--
--  CRÉER LE PROJET SUPABASE ET RÉCUPÉRER L'URL + LA CLÉ ANON
--  ---------------------------------------------------------------------------
--  1. Aller sur https://supabase.com → se connecter → "New project".
--     - Choisir une organisation, un nom (ex. "as-spa"), un mot de passe BDD
--       (à conserver) et la région la plus proche (ex. "West EU (Paris)").
--  2. Attendre ~2 min que le projet soit provisionné.
--  3. Ouvrir le projet → menu "SQL Editor" → "New query" → coller TOUT ce
--     fichier → "Run". (Ou : Supabase CLI → `supabase db push`.)
--  4. Récupérer les identifiants à coller dans la caisse et le dashboard :
--       Settings → API (ou "Project Settings → API / Data API")
--         • Project URL      →  ex. https://abcdefgh.supabase.co
--         • anon public key  →  longue chaîne "eyJhbGciOi..."  (clé ANON)
--     ⚠ Ne jamais utiliser la clé "service_role" côté caisse/dashboard.
--  5. Saisir ces deux valeurs :
--       - Caisse    : Gestion → Paramètres → "Connexion Supabase"
--       - Dashboard : carte "Connexion Supabase" au 1er lancement
--
--  MODÈLE DE SYNC
--  ---------------------------------------------------------------------------
--  La caisse écrit toujours dans IndexedDB (hors ligne), puis pousse vers cette
--  table par `upsert` sur la colonne `local_id` (= id IndexedDB) pour éviter les
--  doublons. Conçu pour UNE caisse source ; le dashboard ne fait que lire.
-- ═══════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS transactions (
  id            BIGSERIAL PRIMARY KEY,
  local_id      INTEGER,           -- id IndexedDB côté caisse
  num           TEXT NOT NULL,     -- REC-0001
  date          TIMESTAMPTZ NOT NULL,
  client_nom    TEXT,
  client_tel    TEXT,
  items         JSONB NOT NULL,    -- [{name, price, qty}]
  total         INTEGER NOT NULL,
  paiement      TEXT,
  caissier      TEXT,
  caissier_role TEXT,
  note          TEXT,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- Déduplication : `local_id` unique => `upsert(onConflict:'local_id')` côté
-- caisse met à jour la ligne existante au lieu de créer un doublon.
CREATE UNIQUE INDEX IF NOT EXISTS idx_tx_local_id ON transactions(local_id);

-- Index pour les requêtes dashboard
CREATE INDEX IF NOT EXISTS idx_tx_date ON transactions(date DESC);
CREATE INDEX IF NOT EXISTS idx_tx_caissier ON transactions(caissier);

-- RLS : lecture publique avec anon key (le dashboard lit)
--       écriture publique avec anon key (la caisse pousse)
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

-- `IF NOT EXISTS` n'est pas supporté pour CREATE POLICY : on nettoie d'abord
-- pour rendre le script ré-exécutable sans erreur.
DROP POLICY IF EXISTS "anon_read"   ON transactions;
DROP POLICY IF EXISTS "anon_insert" ON transactions;
DROP POLICY IF EXISTS "anon_update" ON transactions;

CREATE POLICY "anon_read"   ON transactions FOR SELECT USING (true);
CREATE POLICY "anon_insert" ON transactions FOR INSERT WITH CHECK (true);
CREATE POLICY "anon_update" ON transactions FOR UPDATE USING (true);

-- Realtime : permet l'actualisation en direct du dashboard.
-- (Sans erreur si la table est déjà dans la publication.)
DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE transactions;
EXCEPTION
  WHEN duplicate_object THEN NULL;
  WHEN undefined_object THEN NULL;
END $$;

-- ═══════════════════════════════════════════════════════════════════════════
--  NOTE DE SÉCURITÉ
--  Ces politiques ouvrent lecture/écriture à toute personne disposant de la clé
--  anon (acceptable pour un usage interne mono-établissement). Pour durcir :
--    • restreindre par Supabase Auth (connexion proprio) côté dashboard ;
--    • limiter l'INSERT/UPDATE à un rôle authentifié pour la caisse ;
--    • ne PAS exposer la clé service_role.
-- ═══════════════════════════════════════════════════════════════════════════
