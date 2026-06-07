-- ============================================
-- HYPE SHOES — Supabase Database Schema
-- Run this in Supabase → SQL Editor
-- ============================================

-- PRODUCTS TABLE
create table if not exists products (
  id            uuid default gen_random_uuid() primary key,
  name          text not null,
  category      text not null,
  price         integer not null,
  mrp           integer,
  description   text not null,
  sizes         integer[] default '{}',
  colors        text[] default '{}',
  image_url     text,
  video_url     text,
  badge         text,
  badge_type    text,
  in_stock      boolean default true,
  created_at    timestamptz default now()
);

-- ORDERS TABLE
create table if not exists orders (
  id              bigint generated always as identity primary key,
  customer_name   text not null,
  phone           text not null,
  email           text,
  address         text not null,
  items           text not null,
  total_amount    integer not null,
  payment_id      text,
  payment_status  text default 'pending',
  order_status    text default 'new',
  notes           text,
  created_at      timestamptz default now()
);

-- SETTINGS TABLE (for brand config)
create table if not exists settings (
  key   text primary key,
  value text
);

-- Insert default settings
insert into settings (key, value) values
  ('brand_name', 'HYPE'),
  ('tagline', 'Stay Fresh. Stay Hype.'),
  ('announcement', 'FREE DELIVERY PAN INDIA · EASY 7-DAY RETURNS'),
  ('instagram', '@hype.shoes'),
  ('telegram', 'https://t.me/HypeShoes'),
  ('whatsapp', '91XXXXXXXXXX')
on conflict (key) do nothing;

-- ============================================
-- ROW LEVEL SECURITY (RLS) — DATA PROTECTION
-- ============================================

-- Enable RLS on all tables
alter table products enable row level security;
alter table orders enable row level security;
alter table settings enable row level security;

-- PRODUCTS: Anyone can read (for the shop page)
create policy "Products are viewable by everyone"
  on products for select using (true);

-- PRODUCTS: Only authenticated admin can insert/update/delete
create policy "Admin can manage products"
  on products for all
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

-- ORDERS: Anyone can insert (place an order)
create policy "Anyone can place an order"
  on orders for insert with check (true);

-- ORDERS: Only admin can read all orders
create policy "Admin can read all orders"
  on orders for select
  using (auth.role() = 'authenticated');

-- ORDERS: Only admin can update order status
create policy "Admin can update order status"
  on orders for update
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

-- SETTINGS: Anyone can read
create policy "Settings are public"
  on settings for select using (true);

-- SETTINGS: Only admin can update
create policy "Admin can update settings"
  on settings for all
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

-- ============================================
-- STORAGE BUCKET for product images
-- ============================================
-- Run this separately in Supabase Storage section:
-- Create a bucket called "products" and set it to PUBLIC

-- Or run via SQL:
insert into storage.buckets (id, name, public)
  values ('products', 'products', true)
  on conflict (id) do nothing;

create policy "Product images are publicly viewable"
  on storage.objects for select
  using (bucket_id = 'products');

create policy "Admin can upload product images"
  on storage.objects for insert
  with check (bucket_id = 'products' and auth.role() = 'authenticated');

create policy "Admin can delete product images"
  on storage.objects for delete
  using (bucket_id = 'products' and auth.role() = 'authenticated');

-- ============================================
-- SAMPLE DATA (optional — remove in production)
-- ============================================
insert into products (name, category, price, mrp, description, sizes, image_url, badge, in_stock)
values
  ('Adidas Carbon Speed', 'Sports', 3499, 4299, 'Carbon-infused midsole for max energy return. Lightweight mesh upper. Perfect for daily runs and gym sessions.', '{6,7,8,9,10,11}', 'assets/shoe1.jpg', 'Hot', true),
  ('Brooks Velocity Pro', 'Sports', 4299, null, 'Nitrogen-infused cushioning for all-day comfort. Engineered mesh upper. Built for speed and endurance.', '{7,8,9,10,11}', 'assets/shoe2.jpg', 'New', true),
  ('Brooks Street Max', 'Casual', 2999, 3599, 'Street-ready silhouette meets daily comfort. Thick sole, bold design. Goes with every outfit.', '{6,7,8,9,10,11}', 'assets/shoe3.jpg', null, true);
