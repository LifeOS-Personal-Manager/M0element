create table if not exists public.lifeos_states (
  id text primary key,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.lifeos_states enable row level security;
alter table public.lifeos_states replica identity full;

grant select, insert, update, delete on table public.lifeos_states to anon, authenticated;

drop policy if exists "lifeos public read" on public.lifeos_states;
drop policy if exists "lifeos public insert" on public.lifeos_states;
drop policy if exists "lifeos public update" on public.lifeos_states;
drop policy if exists "lifeos public delete" on public.lifeos_states;

create policy "lifeos public read"
on public.lifeos_states
for select
to anon, authenticated
using (true);

create policy "lifeos public insert"
on public.lifeos_states
for insert
to anon, authenticated
with check (true);

create policy "lifeos public update"
on public.lifeos_states
for update
to anon, authenticated
using (true)
with check (true);

create policy "lifeos public delete"
on public.lifeos_states
for delete
to anon, authenticated
using (true);

do $$
begin
  alter publication supabase_realtime add table public.lifeos_states;
exception
  when duplicate_object then null;
  when undefined_object then
    create publication supabase_realtime for table public.lifeos_states;
end $$;
