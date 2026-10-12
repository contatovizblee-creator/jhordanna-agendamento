PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS services (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  description TEXT DEFAULT '',
  price_cents INTEGER NOT NULL,
  duration_minutes INTEGER NOT NULL,
  active INTEGER NOT NULL DEFAULT 1,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bookings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  public_token TEXT NOT NULL UNIQUE,
  service_id INTEGER NOT NULL,
  service_name_snapshot TEXT NOT NULL,
  price_cents_snapshot INTEGER NOT NULL,
  duration_minutes_snapshot INTEGER NOT NULL,
  customer_name TEXT NOT NULL,
  customer_whatsapp TEXT NOT NULL,
  customer_email TEXT NOT NULL,
  start_at TEXT NOT NULL,
  end_at TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK(status IN ('pending','confirmed','refused','cancelled','expired','completed','no_show')),
  financial_status TEXT NOT NULL DEFAULT 'unpaid' CHECK(financial_status IN ('unpaid','paid')),
  source TEXT DEFAULT 'direct',
  utm_source TEXT,
  utm_medium TEXT,
  utm_campaign TEXT,
  refusal_reason TEXT,
  internal_notes TEXT,
  pending_expires_at TEXT NOT NULL,
  reminder_sent_at TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(service_id) REFERENCES services(id)
);

CREATE INDEX IF NOT EXISTS idx_bookings_start_at ON bookings(start_at);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);
CREATE INDEX IF NOT EXISTS idx_bookings_email ON bookings(customer_email);

CREATE TABLE IF NOT EXISTS booking_slots (
  booking_id INTEGER NOT NULL,
  slot_start TEXT NOT NULL UNIQUE,
  PRIMARY KEY (booking_id, slot_start),
  FOREIGN KEY(booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS schedule_blocks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  start_at TEXT NOT NULL,
  end_at TEXT NOT NULL,
  reason TEXT DEFAULT '',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_schedule_blocks_start ON schedule_blocks(start_at);

CREATE TABLE IF NOT EXISTS email_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  booking_id INTEGER,
  event_type TEXT NOT NULL,
  recipient TEXT NOT NULL,
  status TEXT NOT NULL,
  provider_id TEXT,
  error_message TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(booking_id) REFERENCES bookings(id) ON DELETE SET NULL
);

INSERT OR IGNORE INTO services (id, name, slug, description, price_cents, duration_minutes, active, sort_order) VALUES
  (1, 'Alongamento Molde F1', 'alongamento-molde-f1', 'Alongamento com Molde F1.', 11000, 120, 1, 1),
  (2, 'Banho em gel', 'banho-em-gel', 'Banho em gel para reforço e acabamento.', 7500, 90, 1, 2),
  (3, 'Blindagem', 'blindagem', 'Blindagem com acabamento delicado.', 7000, 90, 1, 3),
  (4, 'Esmaltação em gel', 'esmaltacao-em-gel', 'Esmaltação em gel.', 6500, 60, 1, 4),
  (5, 'Esmaltação normal', 'esmaltacao-normal', 'Esmaltação tradicional.', 3500, 40, 1, 5),
  (6, 'Manutenção até 15 dias', 'manutencao-ate-15-dias', 'Manutenção até 15 dias.', 8500, 120, 1, 6),
  (7, 'Manutenção após 15 dias', 'manutencao-apos-15-dias', 'Manutenção após 15 dias.', 9500, 120, 1, 7);
