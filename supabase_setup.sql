-- ════════════════════════════════════════════════
-- Run this in: Supabase → SQL Editor → New query
-- ════════════════════════════════════════════════

-- 1. Create the progress table
create table if not exists public.progress (
  user_id  uuid references auth.users(id) on delete cascade primary key,
  state    jsonb not null default '{}',
  updated_at timestamptz default now()
);

-- 2. Enable Row Level Security (users can only see their own data)
alter table public.progress enable row level security;

-- 3. Policy: users can read/write ONLY their own row
create policy "own_progress_all"
  on public.progress
  for all
  using  (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- 4. Grant permissions to authenticated users
grant all on public.progress to authenticated;

-- Done! Your database is ready.
