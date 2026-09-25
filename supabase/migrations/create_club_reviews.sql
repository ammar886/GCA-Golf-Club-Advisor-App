-- Migration: Create and configure club_reviews table with all golf course review fields
-- Status is set to 'pending' by default.

-- 1. Create table if it doesn't already exist
CREATE TABLE IF NOT EXISTS public.club_reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    club_id BIGINT NOT NULL REFERENCES public.golf_clubs(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    course_id BIGINT REFERENCES public.golf_courses(id) ON DELETE SET NULL,
    played_date DATE,
    overall_rating SMALLINT CHECK (overall_rating >= 0 AND overall_rating <= 5),
    
    -- Course Sub-Ratings
    course_condition NUMERIC(2,1) DEFAULT 0.0,
    greens NUMERIC(2,1) DEFAULT 0.0,
    fairways NUMERIC(2,1) DEFAULT 0.0,
    bunkers NUMERIC(2,1) DEFAULT 0.0,
    layout NUMERIC(2,1) DEFAULT 0.0,
    challenge NUMERIC(2,1) DEFAULT 0.0,
    scenery NUMERIC(2,1) DEFAULT 0.0,
    
    -- Facilities Sub-Ratings
    clubhouse NUMERIC(2,1) DEFAULT 0.0,
    pro_shop NUMERIC(2,1) DEFAULT 0.0,
    practice_facilities NUMERIC(2,1) DEFAULT 0.0,
    food_and_drink NUMERIC(2,1) DEFAULT 0.0,
    changing_rooms NUMERIC(2,1) DEFAULT 0.0,
    driving_range NUMERIC(2,1) DEFAULT 0.0,
    
    -- Experience Sub-Ratings
    welcome NUMERIC(2,1) DEFAULT 0.0,
    pace_of_play NUMERIC(2,1) DEFAULT 0.0,
    value_for_money NUMERIC(2,1) DEFAULT 0.0,
    
    -- General Feedback
    play_again BOOLEAN DEFAULT TRUE,
    comment TEXT,
    photos TEXT[] DEFAULT '{}',
    
    -- Moderation Status (stored with status 'pending' initially)
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Alter existing table if columns are missing (idempotent migration)
DO $$
BEGIN
    -- Update overall_rating check constraint to allow 0 (valid rating)
    ALTER TABLE public.club_reviews DROP CONSTRAINT IF EXISTS club_reviews_overall_rating_check;
    ALTER TABLE public.club_reviews ADD CONSTRAINT club_reviews_overall_rating_check CHECK (overall_rating >= 0 AND overall_rating <= 5);

    -- Core & Identification
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'club_reviews' AND column_name = 'course_id') THEN
        ALTER TABLE public.club_reviews ADD COLUMN course_id BIGINT REFERENCES public.golf_courses(id) ON DELETE SET NULL;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'club_reviews' AND column_name = 'played_date') THEN
        ALTER TABLE public.club_reviews ADD COLUMN played_date DATE;
    END IF;

    -- Course sub-ratings
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'club_reviews' AND column_name = 'course_condition') THEN
        ALTER TABLE public.club_reviews ADD COLUMN course_condition NUMERIC(2,1) DEFAULT 0.0;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'club_reviews' AND column_name = 'greens') THEN
        ALTER TABLE public.club_reviews ADD COLUMN greens NUMERIC(2,1) DEFAULT 0.0;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'club_reviews' AND column_name = 'fairways') THEN
        ALTER TABLE public.club_reviews ADD COLUMN fairways NUMERIC(2,1) DEFAULT 0.0;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'club_reviews' AND column_name = 'bunkers') THEN
        ALTER TABLE public.club_reviews ADD COLUMN bunkers NUMERIC(2,1) DEFAULT 0.0;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'club_reviews' AND column_name = 'layout') THEN
        ALTER TABLE public.club_reviews ADD COLUMN layout NUMERIC(2,1) DEFAULT 0.0;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'club_reviews' AND column_name = 'challenge') THEN
        ALTER TABLE public.club_reviews ADD COLUMN challenge NUMERIC(2,1) DEFAULT 0.0;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'club_reviews' AND column_name = 'scenery') THEN
        ALTER TABLE public.club_reviews ADD COLUMN scenery NUMERIC(2,1) DEFAULT 0.0;
    END IF;

    -- Facilities sub-ratings
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'club_reviews' AND column_name = 'clubhouse') THEN
        ALTER TABLE public.club_reviews ADD COLUMN clubhouse NUMERIC(2,1) DEFAULT 0.0;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'club_reviews' AND column_name = 'pro_shop') THEN
        ALTER TABLE public.club_reviews ADD COLUMN pro_shop NUMERIC(2,1) DEFAULT 0.0;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'club_reviews' AND column_name = 'practice_facilities') THEN
        ALTER TABLE public.club_reviews ADD COLUMN practice_facilities NUMERIC(2,1) DEFAULT 0.0;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'club_reviews' AND column_name = 'food_and_drink') THEN
        ALTER TABLE public.club_reviews ADD COLUMN food_and_drink NUMERIC(2,1) DEFAULT 0.0;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'club_reviews' AND column_name = 'changing_rooms') THEN
        ALTER TABLE public.club_reviews ADD COLUMN changing_rooms NUMERIC(2,1) DEFAULT 0.0;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'club_reviews' AND column_name = 'driving_range') THEN
        ALTER TABLE public.club_reviews ADD COLUMN driving_range NUMERIC(2,1) DEFAULT 0.0;
    END IF;

    -- Experience sub-ratings
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'club_reviews' AND column_name = 'welcome') THEN
        ALTER TABLE public.club_reviews ADD COLUMN welcome NUMERIC(2,1) DEFAULT 0.0;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'club_reviews' AND column_name = 'pace_of_play') THEN
        ALTER TABLE public.club_reviews ADD COLUMN pace_of_play NUMERIC(2,1) DEFAULT 0.0;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'club_reviews' AND column_name = 'value_for_money') THEN
        ALTER TABLE public.club_reviews ADD COLUMN value_for_money NUMERIC(2,1) DEFAULT 0.0;
    END IF;

    -- General feedback
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'club_reviews' AND column_name = 'play_again') THEN
        ALTER TABLE public.club_reviews ADD COLUMN play_again BOOLEAN DEFAULT TRUE;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'club_reviews' AND column_name = 'photos') THEN
        ALTER TABLE public.club_reviews ADD COLUMN photos TEXT[] DEFAULT '{}';
    END IF;

    -- Status column with default 'pending'
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'club_reviews' AND column_name = 'status') THEN
        ALTER TABLE public.club_reviews ADD COLUMN status TEXT NOT NULL DEFAULT 'pending';
    END IF;
END $$;

-- 3. Indexes for efficient lookup
CREATE INDEX IF NOT EXISTS idx_club_reviews_club_id ON public.club_reviews(club_id);
CREATE INDEX IF NOT EXISTS idx_club_reviews_user_id ON public.club_reviews(user_id);
CREATE INDEX IF NOT EXISTS idx_club_reviews_status ON public.club_reviews(status);
CREATE INDEX IF NOT EXISTS idx_club_reviews_created_at ON public.club_reviews(created_at DESC);

-- 4. Enable Row Level Security (RLS)
ALTER TABLE public.club_reviews ENABLE ROW LEVEL SECURITY;

-- Policy: Users can read approved reviews OR their own reviews
DROP POLICY IF EXISTS "Public can view approved reviews, users view own" ON public.club_reviews;
CREATE POLICY "Public can view approved reviews, users view own"
    ON public.club_reviews FOR SELECT
    USING (
        status = 'approved'
        OR auth.uid()::text = user_id::text
        OR EXISTS (
            SELECT 1 FROM public.users
            WHERE users.id::text = auth.uid()::text AND users.role = 'admin'
        )
    );

-- Policy: Authenticated users can insert their own reviews with status 'pending'
DROP POLICY IF EXISTS "Users can insert reviews" ON public.club_reviews;
CREATE POLICY "Users can insert reviews"
    ON public.club_reviews FOR INSERT
    WITH CHECK (
        auth.uid()::text = user_id::text
        OR auth.role() = 'anon'
    );

-- Policy: Users can update their own pending reviews, Admins can update any review
DROP POLICY IF EXISTS "Users can update own pending reviews" ON public.club_reviews;
CREATE POLICY "Users can update own pending reviews"
    ON public.club_reviews FOR UPDATE
    USING (
        (auth.uid()::text = user_id::text AND status = 'pending')
        OR EXISTS (
            SELECT 1 FROM public.users
            WHERE users.id::text = auth.uid()::text AND users.role = 'admin'
        )
    );
