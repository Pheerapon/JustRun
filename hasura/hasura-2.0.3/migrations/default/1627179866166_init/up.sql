SET check_function_bodies = false;
CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;
CREATE FUNCTION public.update_user_money() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE oldMoney INTEGER;
BEGIN
    SELECT money INTO oldMoney FROM "User" WHERE id = NEW.user_id;
    UPDATE "User" SET money = (oldMoney + NEW.money) WHERE id = NEW.user_id;
RETURN NEW;
END;
$$;
CREATE TABLE public."Badges" (
    level integer NOT NULL,
    title text NOT NULL,
    subtitle text NOT NULL,
    id integer NOT NULL
);

INSERT INTO public."Badges" (
  id, level, subtitle, title
) VALUES
( 10,2,'reached','80 km' ),
( 11,2,'reached','150 km' ),
( 12,2,'In a row','66 days' ),
( 13,2,'In a row','100 days' ),
( 1,1,'reached','1 km' ),
( 2,1,'reached','5 km' ),
( 3,1,'reached','15 km' ),
( 4,1,'reached','21 km' ),
( 5,1,'reached','40 km' ),
( 6,1,'In a row','3 days' ),
( 7,1,'In a row','7 days' ),
( 8,1,'In a row','15 days' ),
( 9,1,'In a row','30 days' );

CREATE SEQUENCE public."Badges_id_badge_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public."Badges_id_badge_seq" OWNED BY public."Badges".id;
CREATE TABLE public."Gender" (
    id text NOT NULL
);
INSERT INTO public."Gender" (id) VALUES ('Female'), ('Male');
CREATE TABLE public."GetReward" (
    id integer NOT NULL,
    days_row integer NOT NULL,
    user_id text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    get_reward timestamp without time zone DEFAULT now() NOT NULL
);
CREATE SEQUENCE public."GetReward_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public."GetReward_id_seq" OWNED BY public."GetReward".id;
CREATE TABLE public."Goal" (
    distance double precision,
    step integer,
    user_id text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    id integer NOT NULL,
    "time" integer
);
CREATE SEQUENCE public."Goal_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public."Goal_id_seq" OWNED BY public."Goal".id;
CREATE TABLE public."RunHistory" (
    id integer NOT NULL,
    "time" text NOT NULL,
    avg integer NOT NULL,
    steps integer NOT NULL,
    image text NOT NULL,
    distance double precision NOT NULL,
    user_id text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    date timestamp without time zone NOT NULL,
    money integer NOT NULL
);
CREATE SEQUENCE public."RunHistory_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public."RunHistory_id_seq" OWNED BY public."RunHistory".id;
CREATE TABLE public."Skin" (
    id integer NOT NULL,
    name text NOT NULL,
    image_link text NOT NULL,
    gender text NOT NULL,
    price numeric NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
CREATE SEQUENCE public."Skin_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public."Skin_id_seq" OWNED BY public."Skin".id;
CREATE TABLE public."User" (
    id text DEFAULT gen_random_uuid() NOT NULL,
    gender text,
    name text NOT NULL,
    email text NOT NULL,
    money integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    user_skin_id integer
);
CREATE TABLE public."UserSkin" (
    id integer NOT NULL,
    user_id text NOT NULL,
    skin_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
CREATE SEQUENCE public."UserSkin_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public."UserSkin_id_seq" OWNED BY public."UserSkin".id;
ALTER TABLE ONLY public."Badges" ALTER COLUMN id SET DEFAULT nextval('public."Badges_id_badge_seq"'::regclass);
ALTER TABLE ONLY public."GetReward" ALTER COLUMN id SET DEFAULT nextval('public."GetReward_id_seq"'::regclass);
ALTER TABLE ONLY public."Goal" ALTER COLUMN id SET DEFAULT nextval('public."Goal_id_seq"'::regclass);
ALTER TABLE ONLY public."RunHistory" ALTER COLUMN id SET DEFAULT nextval('public."RunHistory_id_seq"'::regclass);
ALTER TABLE ONLY public."Skin" ALTER COLUMN id SET DEFAULT nextval('public."Skin_id_seq"'::regclass);
ALTER TABLE ONLY public."UserSkin" ALTER COLUMN id SET DEFAULT nextval('public."UserSkin_id_seq"'::regclass);
ALTER TABLE ONLY public."Badges"
    ADD CONSTRAINT "Badges_id_badge_key" UNIQUE (id);
ALTER TABLE ONLY public."Badges"
    ADD CONSTRAINT "Badges_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Gender"
    ADD CONSTRAINT "Gender_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."GetReward"
    ADD CONSTRAINT "GetReward_id_key" UNIQUE (id);
ALTER TABLE ONLY public."GetReward"
    ADD CONSTRAINT "GetReward_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."GetReward"
    ADD CONSTRAINT "GetReward_user_id_key" UNIQUE (user_id);
ALTER TABLE ONLY public."Goal"
    ADD CONSTRAINT "Goal_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Goal"
    ADD CONSTRAINT "Goal_user_id_key" UNIQUE (user_id);
ALTER TABLE ONLY public."RunHistory"
    ADD CONSTRAINT "RunHistory_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Skin"
    ADD CONSTRAINT "Skin_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."UserSkin"
    ADD CONSTRAINT "UserSkin_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_email_key" UNIQUE (email);
ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);
CREATE TRIGGER "set_public_GetReward_updated_at" BEFORE UPDATE ON public."GetReward" FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER "set_public_GetReward_updated_at" ON public."GetReward" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER "set_public_Goal_updated_at" BEFORE UPDATE ON public."Goal" FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER "set_public_Goal_updated_at" ON public."Goal" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER "set_public_RunHistory_updated_at" BEFORE UPDATE ON public."RunHistory" FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER "set_public_RunHistory_updated_at" ON public."RunHistory" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER "set_public_Skin_updated_at" BEFORE UPDATE ON public."Skin" FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER "set_public_Skin_updated_at" ON public."Skin" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER "set_public_UserSkin_updated_at" BEFORE UPDATE ON public."UserSkin" FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER "set_public_UserSkin_updated_at" ON public."UserSkin" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER "set_public_User_updated_at" BEFORE UPDATE ON public."User" FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER "set_public_User_updated_at" ON public."User" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER update_money AFTER INSERT OR UPDATE ON public."RunHistory" FOR EACH ROW EXECUTE FUNCTION public.update_user_money();
ALTER TABLE ONLY public."GetReward"
    ADD CONSTRAINT "GetReward_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."User"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public."Goal"
    ADD CONSTRAINT "Goal_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."User"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public."RunHistory"
    ADD CONSTRAINT "RunHistory_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."User"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public."Skin"
    ADD CONSTRAINT "Skin_gender_fkey" FOREIGN KEY (gender) REFERENCES public."Gender"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public."UserSkin"
    ADD CONSTRAINT "UserSkin_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."User"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_gender_fkey" FOREIGN KEY (gender) REFERENCES public."Gender"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_user_skin_id_fkey" FOREIGN KEY (user_skin_id) REFERENCES public."UserSkin"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
