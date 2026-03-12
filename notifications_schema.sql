-- ============================================================
--  Digitale Solution — Table notifications
--  Coller et exécuter dans : Supabase Dashboard → SQL Editor
-- ============================================================

CREATE TABLE IF NOT EXISTS notifications (
  id            text PRIMARY KEY,
  merchant_id   text NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
  type          text NOT NULL DEFAULT 'product_added',
  titre         text NOT NULL,
  message       text NOT NULL,
  data          jsonb,                  -- { nom, prix, stock, product_id }
  lu            boolean DEFAULT false,
  created_at    timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_notifications_merchant ON notifications(merchant_id);
CREATE INDEX IF NOT EXISTS idx_notifications_lu       ON notifications(merchant_id, lu);

-- RLS : seul le service_role (backend) peut lire/écrire
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- ── Push Subscriptions (pour les notifications PWA) ────────
CREATE TABLE IF NOT EXISTS push_subscriptions (
  id            text PRIMARY KEY,
  merchant_id   text NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
  endpoint      text NOT NULL UNIQUE,
  p256dh        text NOT NULL,
  auth          text NOT NULL,
  created_at    timestamptz DEFAULT now()
);

ALTER TABLE push_subscriptions ENABLE ROW LEVEL SECURITY;
