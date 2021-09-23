alter table "public"."RoomMember" drop constraint "RoomMember_room_id_fkey",
  add constraint "RoomMember_room_id_fkey"
  foreign key ("room_id")
  references "public"."Room"
  ("id") on update cascade on delete cascade;
