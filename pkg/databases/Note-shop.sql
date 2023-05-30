CREATE TABLE "users" (
  "id" varchar PRIMARY KEY,
  "usersname" varchar UNIQUE,
  "pasword" varchar,
  "email" varchar UNIQUE,
  "role_id" int,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "oaute" (
  "id" varchar PRIMARY KEY,
  "users_id" varchar,
  "access_token" varchar,
  "refresh_token" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "roles" (
  "id" int PRIMARY KEY,
  "title" varchar
);

CREATE TABLE "products" (
  "id" varchar PRIMARY KEY,
  "title" varchar,
  "description" varchar,
  "price" float,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "images" (
  "id" varchar[PK],
  "filename" varchar,
  "url" varchar,
  "products_id" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "products_categories" (
  "id" varchar[PK],
  "products_id" varchar,
  "categories_id" int
);

CREATE TABLE "categories" (
  "id" int PRIMARY KEY,
  "title" varchar UNIQUE
);

CREATE TABLE "orders" (
  "id" varchar PRIMARY KEY,
  "users_id" varchar,
  "contact" varchar,
  "address" varchar,
  "transfer_slip" jsonb,
  "status" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "products_orders" (
  "id" varchar PRIMARY KEY,
  "order_id" varchar,
  "qty" int,
  "priduct" jsonb
);

ALTER TABLE "users" ADD FOREIGN KEY ("role_id") REFERENCES "roles" ("id");

ALTER TABLE "oaute" ADD FOREIGN KEY ("users_id") REFERENCES "users" ("id");

ALTER TABLE "images" ADD FOREIGN KEY ("products_id") REFERENCES "products" ("id");

ALTER TABLE "products_categories" ADD FOREIGN KEY ("products_id") REFERENCES "products" ("id");

ALTER TABLE "products_categories" ADD FOREIGN KEY ("categories_id") REFERENCES "categories" ("id");

ALTER TABLE "orders" ADD FOREIGN KEY ("users_id") REFERENCES "users" ("id");

ALTER TABLE "orders" ADD FOREIGN KEY ("id") REFERENCES "products_orders" ("order_id");
