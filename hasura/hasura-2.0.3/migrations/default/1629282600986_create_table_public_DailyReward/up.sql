CREATE TABLE "public"."DailyReward" ("id" serial NOT NULL, "days_row" integer NOT NULL, "current_daily" timestamp NOT NULL, "user_id" text NOT NULL, "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), PRIMARY KEY ("id") , FOREIGN KEY ("user_id") REFERENCES "public"."User"("id") ON UPDATE cascade ON DELETE cascade, UNIQUE ("id"), UNIQUE ("user_id"));
CREATE OR REPLACE FUNCTION "public"."set_current_timestamp_updated_at"()
RETURNS TRIGGER AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER "set_public_DailyReward_updated_at"
BEFORE UPDATE ON "public"."DailyReward"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_DailyReward_updated_at" ON "public"."DailyReward" 
IS 'trigger to set value of column "updated_at" to current timestamp on row update';
