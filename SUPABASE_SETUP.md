# Supabase setup

Run the SQL in `supabase/migrations/20260330_create_profiles_auth_sync.sql`
inside the Supabase SQL Editor.

That migration creates:

- `public.profiles`
- automatic profile creation from `auth.users`
- `display_name` syncing from signup metadata
- row-level security so users only access their own profile

The app auth screen sends:

- `email`
- `password`
- `display_name`

The dedicated auth screen in the app is powered by `supabase_flutter` and uses
the project URL and anon key configured in `lib/services/supabase_service.dart`.

For the current early-stage flow, disable email confirmation in your Supabase
Auth settings so sign up goes straight into the app without a verification step.
