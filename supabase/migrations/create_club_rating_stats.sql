-- Migration: Create club_rating_stats table and automated rating aggregation triggers
-- Computes and caches overall rating and 17 sub-ratings strictly for approved reviews.

-- 0. Ensure golf_clubs and club_reviews have required columns and constraints
ALTER TABLE public.golf_clubs ADD COLUMN IF NOT EXISTS review_count INT DEFAULT 0;
ALTER TABLE public.golf_clubs ADD COLUMN IF NOT EXISTS overall_rating NUMERIC(2,1) DEFAULT 0.0;

-- Ensure overall_rating in club_reviews allows 0 (0-5 stars)
ALTER TABLE public.club_reviews DROP CONSTRAINT IF EXISTS club_reviews_overall_rating_check;
ALTER TABLE public.club_reviews ADD CONSTRAINT club_reviews_overall_rating_check CHECK (overall_rating >= 0 AND overall_rating <= 5);

-- 1. Create table for precomputed club rating statistics
CREATE TABLE IF NOT EXISTS public.club_rating_stats (
    club_id BIGINT PRIMARY KEY REFERENCES public.golf_clubs(id) ON DELETE CASCADE,
    review_count INT NOT NULL DEFAULT 0,
    overall_rating NUMERIC(2,1) NOT NULL DEFAULT 0.0,
    
    -- Course Sub-Rating Averages
    avg_course_condition NUMERIC(2,1) NOT NULL DEFAULT 0.0,
    avg_greens NUMERIC(2,1) NOT NULL DEFAULT 0.0,
    avg_fairways NUMERIC(2,1) NOT NULL DEFAULT 0.0,
    avg_bunkers NUMERIC(2,1) NOT NULL DEFAULT 0.0,
    avg_layout NUMERIC(2,1) NOT NULL DEFAULT 0.0,
    avg_challenge NUMERIC(2,1) NOT NULL DEFAULT 0.0,
    avg_scenery NUMERIC(2,1) NOT NULL DEFAULT 0.0,
    
    -- Facilities Sub-Rating Averages
    avg_clubhouse NUMERIC(2,1) NOT NULL DEFAULT 0.0,
    avg_pro_shop NUMERIC(2,1) NOT NULL DEFAULT 0.0,
    avg_practice_facilities NUMERIC(2,1) NOT NULL DEFAULT 0.0,
    avg_food_and_drink NUMERIC(2,1) NOT NULL DEFAULT 0.0,
    avg_changing_rooms NUMERIC(2,1) NOT NULL DEFAULT 0.0,
    avg_driving_range NUMERIC(2,1) NOT NULL DEFAULT 0.0,
    
    -- Experience Sub-Rating Averages
    avg_welcome NUMERIC(2,1) NOT NULL DEFAULT 0.0,
    avg_pace_of_play NUMERIC(2,1) NOT NULL DEFAULT 0.0,
    avg_value_for_money NUMERIC(2,1) NOT NULL DEFAULT 0.0,
    
    -- Recommendation Percentage (0 - 100)
    recommend_percentage INT NOT NULL DEFAULT 0,
    
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Enable Row Level Security (RLS) and public read access
ALTER TABLE public.club_rating_stats ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can view club rating stats" ON public.club_rating_stats;
CREATE POLICY "Public can view club rating stats"
    ON public.club_rating_stats FOR SELECT
    USING (true);

-- 3. Function to recalculate ratings for a single club (ONLY approved reviews)
CREATE OR REPLACE FUNCTION public.recalculate_club_ratings(target_club_id BIGINT)
RETURNS VOID AS $$
DECLARE
    v_count INT;
    v_overall NUMERIC(2,1);
    v_course_condition NUMERIC(2,1);
    v_greens NUMERIC(2,1);
    v_fairways NUMERIC(2,1);
    v_bunkers NUMERIC(2,1);
    v_layout NUMERIC(2,1);
    v_challenge NUMERIC(2,1);
    v_scenery NUMERIC(2,1);
    v_clubhouse NUMERIC(2,1);
    v_pro_shop NUMERIC(2,1);
    v_practice_facilities NUMERIC(2,1);
    v_food_and_drink NUMERIC(2,1);
    v_changing_rooms NUMERIC(2,1);
    v_driving_range NUMERIC(2,1);
    v_welcome NUMERIC(2,1);
    v_pace_of_play NUMERIC(2,1);
    v_value_for_money NUMERIC(2,1);
    v_recommend_pct INT;
BEGIN
    SELECT
        COUNT(*)::INT,
        COALESCE(ROUND(AVG(overall_rating), 1), 0.0),
        COALESCE(ROUND(AVG(course_condition), 1), 0.0),
        COALESCE(ROUND(AVG(greens), 1), 0.0),
        COALESCE(ROUND(AVG(fairways), 1), 0.0),
        COALESCE(ROUND(AVG(bunkers), 1), 0.0),
        COALESCE(ROUND(AVG(layout), 1), 0.0),
        COALESCE(ROUND(AVG(challenge), 1), 0.0),
        COALESCE(ROUND(AVG(scenery), 1), 0.0),
        COALESCE(ROUND(AVG(clubhouse), 1), 0.0),
        COALESCE(ROUND(AVG(pro_shop), 1), 0.0),
        COALESCE(ROUND(AVG(practice_facilities), 1), 0.0),
        COALESCE(ROUND(AVG(food_and_drink), 1), 0.0),
        COALESCE(ROUND(AVG(changing_rooms), 1), 0.0),
        COALESCE(ROUND(AVG(driving_range), 1), 0.0),
        COALESCE(ROUND(AVG(welcome), 1), 0.0),
        COALESCE(ROUND(AVG(pace_of_play), 1), 0.0),
        COALESCE(ROUND(AVG(value_for_money), 1), 0.0),
        COALESCE(
            CASE 
                WHEN COUNT(*) > 0 THEN 
                    ROUND((COUNT(*) FILTER (WHERE play_again = TRUE) * 100.0) / COUNT(*), 0)::INT
                ELSE 0 
            END, 
            0
        )
    INTO
        v_count,
        v_overall,
        v_course_condition,
        v_greens,
        v_fairways,
        v_bunkers,
        v_layout,
        v_challenge,
        v_scenery,
        v_clubhouse,
        v_pro_shop,
        v_practice_facilities,
        v_food_and_drink,
        v_changing_rooms,
        v_driving_range,
        v_welcome,
        v_pace_of_play,
        v_value_for_money,
        v_recommend_pct
    FROM public.club_reviews
    WHERE club_id = target_club_id AND status = 'approved';

    -- Upsert precomputed aggregates
    INSERT INTO public.club_rating_stats (
        club_id,
        review_count,
        overall_rating,
        avg_course_condition,
        avg_greens,
        avg_fairways,
        avg_bunkers,
        avg_layout,
        avg_challenge,
        avg_scenery,
        avg_clubhouse,
        avg_pro_shop,
        avg_practice_facilities,
        avg_food_and_drink,
        avg_changing_rooms,
        avg_driving_range,
        avg_welcome,
        avg_pace_of_play,
        avg_value_for_money,
        recommend_percentage,
        updated_at
    ) VALUES (
        target_club_id,
        v_count,
        v_overall,
        v_course_condition,
        v_greens,
        v_fairways,
        v_bunkers,
        v_layout,
        v_challenge,
        v_scenery,
        v_clubhouse,
        v_pro_shop,
        v_practice_facilities,
        v_food_and_drink,
        v_changing_rooms,
        v_driving_range,
        v_welcome,
        v_pace_of_play,
        v_value_for_money,
        v_recommend_pct,
        NOW()
    )
    ON CONFLICT (club_id) DO UPDATE SET
        review_count = EXCLUDED.review_count,
        overall_rating = EXCLUDED.overall_rating,
        avg_course_condition = EXCLUDED.avg_course_condition,
        avg_greens = EXCLUDED.avg_greens,
        avg_fairways = EXCLUDED.avg_fairways,
        avg_bunkers = EXCLUDED.avg_bunkers,
        avg_layout = EXCLUDED.avg_layout,
        avg_challenge = EXCLUDED.avg_challenge,
        avg_scenery = EXCLUDED.avg_scenery,
        avg_clubhouse = EXCLUDED.avg_clubhouse,
        avg_pro_shop = EXCLUDED.avg_pro_shop,
        avg_practice_facilities = EXCLUDED.avg_practice_facilities,
        avg_food_and_drink = EXCLUDED.avg_food_and_drink,
        avg_changing_rooms = EXCLUDED.avg_changing_rooms,
        avg_driving_range = EXCLUDED.avg_driving_range,
        avg_welcome = EXCLUDED.avg_welcome,
        avg_pace_of_play = EXCLUDED.avg_pace_of_play,
        avg_value_for_money = EXCLUDED.avg_value_for_money,
        recommend_percentage = EXCLUDED.recommend_percentage,
        updated_at = NOW();

    -- Also keep golf_clubs base columns in sync for list & card views
    UPDATE public.golf_clubs
    SET 
        overall_rating = v_overall,
        review_count = v_count
    WHERE id = target_club_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 4. Trigger Function that fires on club_reviews modifications
CREATE OR REPLACE FUNCTION public.handle_club_review_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        -- Only recalculate if immediately inserted as approved
        IF (NEW.status = 'approved') THEN
            PERFORM public.recalculate_club_ratings(NEW.club_id);
        END IF;
    ELSIF (TG_OP = 'UPDATE') THEN
        -- Recalculate if status changed (e.g. pending -> approved, approved -> rejected)
        -- OR if an already approved review's ratings were modified
        IF (OLD.status <> NEW.status OR (OLD.status = 'approved' AND NEW.status = 'approved')) THEN
            PERFORM public.recalculate_club_ratings(NEW.club_id);
            -- If club_id changed on review, also recalculate the old club
            IF (OLD.club_id <> NEW.club_id) THEN
                PERFORM public.recalculate_club_ratings(OLD.club_id);
            END IF;
        END IF;
    ELSIF (TG_OP = 'DELETE') THEN
        -- If an approved review was deleted, recalculate
        IF (OLD.status = 'approved') THEN
            PERFORM public.recalculate_club_ratings(OLD.club_id);
        END IF;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. Attach the trigger to club_reviews
DROP TRIGGER IF EXISTS trg_club_reviews_rating_sync ON public.club_reviews;
CREATE TRIGGER trg_club_reviews_rating_sync
    AFTER INSERT OR UPDATE OR DELETE ON public.club_reviews
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_club_review_changes();
