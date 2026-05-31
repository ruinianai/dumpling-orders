-- 在 Supabase SQL Editor 里粘贴并运行这段代码
-- 位置：Supabase 左侧菜单 → SQL Editor → New Query → 粘贴 → 点 Run

-- 1. 建表
CREATE TABLE IF NOT EXISTS orders (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  customer_name TEXT NOT NULL,
  filling TEXT NOT NULL,
  weight NUMERIC NOT NULL DEFAULT 1,
  type TEXT NOT NULL DEFAULT 'cooked' CHECK (type IN ('cooked', 'raw')),
  notes TEXT DEFAULT '',
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'done')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  done_at TIMESTAMPTZ
);

-- 2. 开启实时推送
ALTER PUBLICATION supabase_realtime ADD TABLE orders;

-- 3. 允许公开读写（不涉及支付，无需用户认证）
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can insert" ON orders
  FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "Anyone can read" ON orders
  FOR SELECT TO anon USING (true);

CREATE POLICY "Anyone can update" ON orders
  FOR UPDATE TO anon USING (true);

CREATE POLICY "Anyone can delete" ON orders
  FOR DELETE TO anon USING (true);
