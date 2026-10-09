-- Ejecutar UNA VEZ en Supabase SQL Editor como propietario del proyecto.
-- NO colocar service_role keys ni credenciales de administrador en el navegador.
create extension if not exists pgcrypto;
create table if not exists public.board_contributions (
 id uuid primary key default gen_random_uuid(),
 board text not null check (board = 'MCU_Board(2)'),
 target text not null check (left(target,13) = 'MCU_Board(2)|'),
 ref text not null, pin text, net text, side text,
 type text not null, value text, conditions text, note text not null default '', author text,
 user_id uuid not null default auth.uid() references auth.users(id),
 status text not null default 'pending' check(status in ('pending','approved','rejected')),
 created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
 constraint lengths check(length(target)<=250 and length(ref)<=80 and length(coalesce(note,''))<=2500 and length(coalesce(value,''))<=100 and length(coalesce(conditions,''))<=220)
);
create table if not exists public.board_admins (user_id uuid primary key references auth.users(id));
-- Administradores: agregar manualmente su UUID desde Authentication > Users:
-- insert into public.board_admins(user_id) values ('UUID-AQUI');
alter table public.board_contributions enable row level security;
alter table public.board_admins enable row level security;
revoke all on public.board_contributions from anon;
revoke all on public.board_admins from anon;
grant select on public.board_contributions to anon,authenticated;
grant insert on public.board_contributions to authenticated;
grant update on public.board_contributions to authenticated;
grant select on public.board_admins to authenticated;
create policy "admins read own status" on public.board_admins for select to authenticated using(user_id=auth.uid());
create policy "read approved or own or admin" on public.board_contributions for select to anon,authenticated
 using(status='approved' or user_id=auth.uid() or exists(select 1 from public.board_admins a where a.user_id=auth.uid()));
create policy "insert pending own" on public.board_contributions for insert to authenticated
 with check(user_id=auth.uid() and status='pending');
create policy "admin review" on public.board_contributions for update to authenticated
 using(exists(select 1 from public.board_admins a where a.user_id=auth.uid()))
 with check(exists(select 1 from public.board_admins a where a.user_id=auth.uid()));
-- Moderación desde Supabase Table Editor con cuenta administradora del proyecto.
-- Antes de aprobar, verificar revisión de placa, valor, GND y condiciones.
