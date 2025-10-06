/*
  # HEIC Converter Pro - Database Schema

  1. New Tables
    - `profiles`
      - `id` (uuid, primary key, references auth.users)
      - `email` (text)
      - `full_name` (text)
      - `phone_number` (text)
      - `is_pro` (boolean, default false)
      - `conversion_count` (integer, default 0)
      - `max_conversions` (integer, default 50)
      - `pro_expires_at` (timestamptz)
      - `created_at` (timestamptz)
      - `updated_at` (timestamptz)

    - `conversions`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references profiles)
      - `original_filename` (text)
      - `original_size` (bigint)
      - `output_format` (text: 'jpg', 'png', 'pdf')
      - `output_filename` (text)
      - `output_size` (bigint)
      - `status` (text: 'pending', 'processing', 'completed', 'failed')
      - `error_message` (text)
      - `storage_path` (text)
      - `created_at` (timestamptz)
      - `completed_at` (timestamptz)

    - `subscriptions`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references profiles, unique)
      - `subscription_type` (text: 'pro_monthly', 'pro_yearly', 'pro_lifetime')
      - `purchase_token` (text)
      - `expires_at` (timestamptz)
      - `is_active` (boolean, default true)
      - `created_at` (timestamptz)
      - `updated_at` (timestamptz)

    - `user_settings`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references profiles, unique)
      - `theme_mode` (text: 'light', 'dark', 'system', default 'system')
      - `default_output_format` (text, default 'jpg')
      - `quality_preset` (text: 'high', 'medium', 'low', default 'high')
      - `auto_delete_after_conversion` (boolean, default false)
      - `show_ads` (boolean, default true)
      - `created_at` (timestamptz)
      - `updated_at` (timestamptz)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users to access their own data
    - Add policies for user profile creation on signup
    - Add policies for conversion management
    - Add policies for subscription management
*/

-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
  email text UNIQUE NOT NULL,
  full_name text,
  phone_number text,
  is_pro boolean DEFAULT false,
  conversion_count integer DEFAULT 0,
  max_conversions integer DEFAULT 50,
  pro_expires_at timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Create conversions table
CREATE TABLE IF NOT EXISTS conversions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  original_filename text NOT NULL,
  original_size bigint DEFAULT 0,
  output_format text NOT NULL CHECK (output_format IN ('jpg', 'png', 'pdf')),
  output_filename text,
  output_size bigint DEFAULT 0,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed')),
  error_message text,
  storage_path text,
  created_at timestamptz DEFAULT now(),
  completed_at timestamptz
);

ALTER TABLE conversions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own conversions"
  ON conversions FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own conversions"
  ON conversions FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own conversions"
  ON conversions FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own conversions"
  ON conversions FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Create subscriptions table
CREATE TABLE IF NOT EXISTS subscriptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid UNIQUE NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  subscription_type text NOT NULL CHECK (subscription_type IN ('pro_monthly', 'pro_yearly', 'pro_lifetime')),
  purchase_token text,
  expires_at timestamptz,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own subscription"
  ON subscriptions FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own subscription"
  ON subscriptions FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own subscription"
  ON subscriptions FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Create user_settings table
CREATE TABLE IF NOT EXISTS user_settings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid UNIQUE NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  theme_mode text DEFAULT 'system' CHECK (theme_mode IN ('light', 'dark', 'system')),
  default_output_format text DEFAULT 'jpg' CHECK (default_output_format IN ('jpg', 'png', 'pdf')),
  quality_preset text DEFAULT 'high' CHECK (quality_preset IN ('high', 'medium', 'low')),
  auto_delete_after_conversion boolean DEFAULT false,
  show_ads boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE user_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own settings"
  ON user_settings FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own settings"
  ON user_settings FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own settings"
  ON user_settings FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_conversions_user_id ON conversions(user_id);
CREATE INDEX IF NOT EXISTS idx_conversions_status ON conversions(status);
CREATE INDEX IF NOT EXISTS idx_conversions_created_at ON conversions(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_expires_at ON subscriptions(expires_at);

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for updated_at
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_subscriptions_updated_at
  BEFORE UPDATE ON subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_settings_updated_at
  BEFORE UPDATE ON user_settings
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Storage bucket for HEIC files
INSERT INTO storage.buckets (id, name, public) VALUES ('heic-files', 'heic-files', false) ON CONFLICT DO NOTHING;

-- Storage policies
CREATE POLICY "Users can upload own files"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'heic-files' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can view own files"
  ON storage.objects FOR SELECT
  TO authenticated
  USING (bucket_id = 'heic-files' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can delete own files"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'heic-files' AND auth.uid()::text = (storage.foldername(name))[1]);
