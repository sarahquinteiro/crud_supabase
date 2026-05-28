-- ============================================================
-- Script SQL – Parte 3: CRUD com Autenticação
-- Execute no SQL Editor: https://supabase.com/dashboard
-- ============================================================

-- 1. Criar a tabela users_data (vinculada ao auth.users)
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.users_data (
  id         uuid    DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id    uuid    REFERENCES auth.users(id),
  created_at timestamptz DEFAULT now(),
  name       text    NOT NULL,
  email      text    NOT NULL
);

-- 2. Habilitar Row Level Security (RLS)
-- ────────────────────────────────────────────────────────────
ALTER TABLE public.users_data ENABLE ROW LEVEL SECURITY;

-- 3. Policies — cada usuário só acessa os PRÓPRIOS registros
-- ────────────────────────────────────────────────────────────

-- SELECT: vê apenas seus próprios dados
CREATE POLICY "usuarios podem ver seus dados"
  ON public.users_data
  FOR SELECT
  TO authenticated
  USING ((SELECT auth.uid()) = user_id);

-- INSERT: só insere com seu próprio user_id
CREATE POLICY "usuarios podem inserir seus dados"
  ON public.users_data
  FOR INSERT
  TO authenticated
  WITH CHECK ((SELECT auth.uid()) = user_id);

-- UPDATE: só edita seus próprios registros
CREATE POLICY "usuarios podem atualizar seus dados"
  ON public.users_data
  FOR UPDATE
  TO authenticated
  USING ((SELECT auth.uid()) = user_id);

-- DELETE: só exclui seus próprios registros
CREATE POLICY "usuarios podem excluir seus dados"
  ON public.users_data
  FOR DELETE
  TO authenticated
  USING ((SELECT auth.uid()) = user_id);

-- 4. Permissões de tabela para a role authenticated
-- ────────────────────────────────────────────────────────────
GRANT SELECT, INSERT, UPDATE, DELETE ON public.users_data TO authenticated;
GRANT ALL ON public.users_data TO service_role;
