CREATE TABLE "public"."Invite" ("id" serial NOT NULL, "user_id" text NOT NULL, "room_id" integer NOT NULL, "guest_email" text NOT NULL, "owner_name" text NOT NULL, "gender" text NOT NULL, "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), PRIMARY KEY ("id") , FOREIGN KEY ("room_id") REFERENCES "public"."Room"("id") ON UPDATE cascade ON DELETE cascade, FOREIGN KEY ("user_id") REFERENCES "public"."User"("id") ON UPDATE cascade ON DELETE cascade, UNIQUE ("guest_email", "room_id"));
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
CREATE TRIGGER "set_public_Invite_updated_at"
BEFORE UPDATE ON "public"."Invite"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_Invite_updated_at" ON "public"."Invite" 
IS 'trigger to set value of column "updated_at" to current timestamp on row update';
