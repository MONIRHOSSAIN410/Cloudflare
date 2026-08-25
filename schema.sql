-- schema.sql

-- 1. Bots table
CREATE TABLE IF NOT EXISTS bots (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  website TEXT,
  system_prompt TEXT NOT NULL,
  monthly_limit INTEGER NOT NULL DEFAULT 1000,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- 2. Knowledge Base
CREATE TABLE IF NOT EXISTS knowledge (
  id TEXT PRIMARY KEY,
  bot_id TEXT NOT NULL,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (bot_id) REFERENCES bots(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_knowledge_bot_id ON knowledge(bot_id);

-- 3. Conversation Messages
CREATE TABLE IF NOT EXISTS messages (
  id TEXT PRIMARY KEY,
  bot_id TEXT NOT NULL,
  session_id TEXT NOT NULL,
  role TEXT NOT NULL CHECK(role IN ('user', 'assistant', 'system')),
  content TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (bot_id) REFERENCES bots(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_messages_bot_session ON messages(bot_id, session_id, created_at DESC);

-- 4. Monthly Usage Metrics (Atomic Aggregations & Reset)
CREATE TABLE IF NOT EXISTS usage_monthly (
  bot_id TEXT NOT NULL,
  year_month TEXT NOT NULL, -- Format: YYYY-MM
  message_count INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (bot_id, year_month),
  FOREIGN KEY (bot_id) REFERENCES bots(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_usage_bot_month ON usage_monthly(bot_id, year_month);