BEGIN;

-- settimezone
SET TIME ZONE 'Asia/Bangkok';

--install uuid extension
CREATE extension IF NOT EXISTS "uuid-ossp";

--user_id -> U000001
--Products_id -> U000001
--orders_id -> U000001

--Craete sequence
CREATE SEQUENCE users_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE products_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE orders_id_seq START WITH 1 INCREMENT BY 1;

--auto update
CREATE OR REPLACE FUNCTION set_update_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.update_at = now();
    RETURN NEW;
END
$$ language 'plpgsql';

--Create enum
CREATE TYPE "oder_status" AS ENUM (
    'witing'
    'shipping'
    'completed'
    'canceled'
)




CREATE TABLE "users" (
  "id" VARCHAR(7) PRIMARY KEY DEFAULT CONCAT('U' , LPAD(NEXTVAL('users_id_seq')::TEXT, 6 ,'0')),
  "usersname" VARCHAR UNIQUE NOT NULL,
  "pasword" VARCHAR NOT NULL,
  "email" VARCHAR UNIQUE NOT NULL,
  "role_id" INT NOT NULL,
  "created_at" TIMESTAMP NOT NULL DEFAULT now() ,
  "updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE "oaute" (
  "id" uuid NOT NULL UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
  "users_id" VARCHAR NOT NULL,
  "access_token" VARCHAR NOT NULL,
  "refresh_token" VARCHAR NOT NULL,
  "created_at" TIMESTAMP NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE "roles" (
  "id" SERIAL PRIMARY KEY,
  "title" VARCHAR NOT NULL UNIQUE
);

CREATE TABLE "products" (
  "id" VARCHAR(7) PRIMARY KEY DEFAULT CONCAT('P' , LPAD(NEXTVAL('products_id_seq')::TEXT, 6 ,'0')),
  "title" VARCHAR NOT NULL,
  "description" VARCHAR NOT NULL DEFAULT '',
  "price" FLOAT NOT NULL DEFAULT 0,
  "created_at" TIMESTAMP NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE "images" (
  "id" uuid NOT NULL UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
  "filename" VARCHAR NOT NULL,
  "url" VARCHAR NOT NULL,
  "products_id" VARCHAR NOT NULL,
  "created_at" TIMESTAMP NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE "products_categories" (
  "id" uuid NOT NULL UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
  "products_id" VARCHAR NOT NULL,
  "categories_id" INT NOT NULL
);

CREATE TABLE "categories" (
  "id" SERIAL PRIMARY KEY,
  "title" VARCHAR UNIQUE NOT NULL
);

CREATE TABLE "orders" (
  "id" VARCHAR(7) PRIMARY KEY DEFAULT CONCAT('O' , LPAD(NEXTVAL('orders_id_seq')::TEXT, 6 ,'0')),
  "users_id" VARCHAR NOT NULL,
  "contact" VARCHAR NOT NULL,
  "address" VARCHAR NOT NULL,
  "transfer_slip" jsonb,
  "status" oder_status NOT NULL,
  "created_at" TIMESTAMP NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE "products_orders" (
  "id" uuid NOT NULL UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),,
  "order_id" VARCHAR NOT NULL,
  "qty" INT NOT NULL DEFAULT 1,
  "priduct" jsonb
);

ALTER TABLE "users" ADD FOREIGN KEY ("role_id") REFERENCES "roles" ("id");
ALTER TABLE "oaute" ADD FOREIGN KEY ("users_id") REFERENCES "users" ("id");
ALTER TABLE "images" ADD FOREIGN KEY ("products_id") REFERENCES "products" ("id");
ALTER TABLE "products_categories" ADD FOREIGN KEY ("products_id") REFERENCES "products" ("id");
ALTER TABLE "products_categories" ADD FOREIGN KEY ("categories_id") REFERENCES "categories" ("id");
ALTER TABLE "orders" ADD FOREIGN KEY ("users_id") REFERENCES "users" ("id");
ALTER TABLE "orders" ADD FOREIGN KEY ("id") REFERENCES "products_orders" ("order_id");

CREATE TRIGGER set_update_at_timestamp_users_table BEFORE UPDATE ON "users" FOR EACH ROW EXECUTE PROCEDURE set_update_at_column()
CREATE TRIGGER set_update_at_timestamp_oauth_table BEFORE UPDATE ON "oauth" FOR EACH ROW EXECUTE PROCEDURE set_update_at_column()
CREATE TRIGGER set_update_at_timestamp_products_table BEFORE UPDATE ON "products" FOR EACH ROW EXECUTE PROCEDURE set_update_at_column()
CREATE TRIGGER set_update_at_timestamp_images_table BEFORE UPDATE ON "images" FOR EACH ROW EXECUTE PROCEDURE set_update_at_column()
CREATE TRIGGER set_update_at_timestamp_orders_table BEFORE UPDATE ON "orders" FOR EACH ROW EXECUTE PROCEDURE set_update_at_column()

COMMIT;