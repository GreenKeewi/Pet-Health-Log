-- Users are created via Supabase Auth; however we keep a profile table for extras
CREATE TABLE profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id),
  display_name text,
  email text,
  created_at timestamptz DEFAULT now()
);

-- Pets
CREATE TABLE pets (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  name text NOT NULL,
  species text NOT NULL, -- dog | cat | other
  breed text,
  dob date,
  sex text,
  avatar_url text,
  weight_kg numeric,
  created_at timestamptz DEFAULT now()
);

-- Visits (veterinary visits, grooming etc)
CREATE TABLE visits (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  pet_id uuid REFERENCES pets(id) ON DELETE CASCADE,
  owner_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  clinic_name text,
  visit_date timestamptz,
  visit_type text, -- checkup, vaccine, dental, emergency, grooming, other
  total_cost numeric,
  notes text, -- OCR raw notes
  ai_summary text, -- GPT generated
  ai_tags jsonb, -- e.g. {"medications":["amoxicillin"], "next_steps":["follow-up in 2 weeks"]}
  created_at timestamptz DEFAULT now()
);

-- Attachments (receipts, PDFs, photos)
CREATE TABLE attachments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  visit_id uuid REFERENCES visits(id) ON DELETE CASCADE,
  pet_id uuid REFERENCES pets(id),
  owner_id uuid REFERENCES profiles(id),
  url text,
  mime_type text,
  extracted_text text, -- text recognized by OCR
  created_at timestamptz DEFAULT now()
);

-- Reminders
CREATE TABLE reminders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  pet_id uuid REFERENCES pets(id),
  owner_id uuid REFERENCES profiles(id),
  title text,
  note text,
  remind_at timestamptz,
  recurrence text, -- "none", "yearly", "custom"
  is_done boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Subscriptions (RevenueCat webhooks update user status)
CREATE TABLE subscriptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id uuid REFERENCES profiles(id),
  product_id text,
  status text, -- active, cancelled, expired
  purchase_date timestamptz,
  expires_at timestamptz,
  raw_payload jsonb,
  created_at timestamptz DEFAULT now()
);

-- Create indices for performance
CREATE INDEX idx_pets_owner_id ON pets(owner_id);
CREATE INDEX idx_visits_pet_id ON visits(pet_id);
CREATE INDEX idx_visits_owner_id ON visits(owner_id);
CREATE INDEX idx_reminders_owner_id ON reminders(owner_id);
CREATE INDEX idx_reminders_pet_id ON reminders(pet_id);
CREATE INDEX idx_attachments_visit_id ON attachments(visit_id);
CREATE INDEX idx_subscriptions_owner_id ON subscriptions(owner_id);

-- Enable Row Level Security (RLS)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE pets ENABLE ROW LEVEL SECURITY;
ALTER TABLE visits ENABLE ROW LEVEL SECURITY;
ALTER TABLE attachments ENABLE ROW LEVEL SECURITY;
ALTER TABLE reminders ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

-- RLS Policies for profiles
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- RLS Policies for pets
CREATE POLICY "Users can view own pets" ON pets
  FOR SELECT USING (auth.uid() = owner_id);

CREATE POLICY "Users can insert own pets" ON pets
  FOR INSERT WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Users can update own pets" ON pets
  FOR UPDATE USING (auth.uid() = owner_id);

CREATE POLICY "Users can delete own pets" ON pets
  FOR DELETE USING (auth.uid() = owner_id);

-- RLS Policies for visits
CREATE POLICY "Users can view own visits" ON visits
  FOR SELECT USING (auth.uid() = owner_id);

CREATE POLICY "Users can insert own visits" ON visits
  FOR INSERT WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Users can update own visits" ON visits
  FOR UPDATE USING (auth.uid() = owner_id);

CREATE POLICY "Users can delete own visits" ON visits
  FOR DELETE USING (auth.uid() = owner_id);

-- RLS Policies for attachments
CREATE POLICY "Users can view own attachments" ON attachments
  FOR SELECT USING (auth.uid() = owner_id);

CREATE POLICY "Users can insert own attachments" ON attachments
  FOR INSERT WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Users can delete own attachments" ON attachments
  FOR DELETE USING (auth.uid() = owner_id);

-- RLS Policies for reminders
CREATE POLICY "Users can view own reminders" ON reminders
  FOR SELECT USING (auth.uid() = owner_id);

CREATE POLICY "Users can insert own reminders" ON reminders
  FOR INSERT WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Users can update own reminders" ON reminders
  FOR UPDATE USING (auth.uid() = owner_id);

CREATE POLICY "Users can delete own reminders" ON reminders
  FOR DELETE USING (auth.uid() = owner_id);

-- RLS Policies for subscriptions
CREATE POLICY "Users can view own subscriptions" ON subscriptions
  FOR SELECT USING (auth.uid() = owner_id);

CREATE POLICY "Users can insert own subscriptions" ON subscriptions
  FOR INSERT WITH CHECK (auth.uid() = owner_id);
