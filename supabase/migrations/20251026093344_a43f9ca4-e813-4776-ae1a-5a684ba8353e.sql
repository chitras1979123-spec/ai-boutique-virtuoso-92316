-- Fix 1: Resolve infinite recursion in user_roles table policy
-- The existing policy queries the same table it protects, causing infinite recursion
-- Replace it with a policy that uses the has_role security definer function

DROP POLICY IF EXISTS "Admins can manage roles" ON public.user_roles;

CREATE POLICY "Admins can manage roles" 
ON public.user_roles 
FOR ALL 
USING (public.has_role(auth.uid(), 'admin'));

-- Fix 2: Add missing SELECT policy for suppliers table
-- The suppliers table has RLS enabled but no SELECT policy for admins
-- This prevents admins from viewing supplier information

CREATE POLICY "Admins can view suppliers" 
ON public.suppliers 
FOR SELECT 
USING (public.has_role(auth.uid(), 'admin'));