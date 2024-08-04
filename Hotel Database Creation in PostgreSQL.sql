-- Creating a database in PostgreSQL. CSV data was then uploaded using PostgreSQL's Import function.

CREATE TABLE "suppliers" (
  "supplier_id" SERIAL,
  "supplier" VARCHAR(180),
  "service_type" VARCHAR(180),
  "supplier_phone" VARCHAR(20),
  "contact_name" VARCHAR(180),
  PRIMARY KEY ("supplier_id")
);

CREATE TABLE "hotels" (
  "hotel_id" SERIAL,
  "hotel_name" VARCHAR(180),
  "address" VARCHAR(180),
  "city" VARCHAR(180),
  "state" VARCHAR(50),
  "website" VARCHAR(180),
  "total_rooms" SMALLINT,
  "front_desk_num" VARCHAR(20),
  "venue_yn" BOOLEAN,
  "manager_id" INTEGER,
  PRIMARY KEY ("hotel_id")
);

CREATE TABLE "orders" (
  "order_id" SERIAL,
  "supplier_id" INTEGER,
  "hotel_id" INTEGER,
  "order_date" DATE,
  "exp_arrival_date" DATE,
  "arrival_date" DATE,
  "total_paid" NUMERIC (10,2),
  PRIMARY KEY ("order_id"),
  CONSTRAINT "FK_orders.supplier_id"
    FOREIGN KEY ("supplier_id")
      REFERENCES "suppliers"("supplier_id"),
  CONSTRAINT "FK_orders.hotel_id"
    FOREIGN KEY ("hotel_id")
      REFERENCES "hotels"("hotel_id")
);

CREATE TABLE "items_services" (
  "items_services_id" SERIAL,
  "items_services_name" VARCHAR(180),
  "supplier_id" Type,
  "items_services_desc" TEXT,
  "service_type" VARCHAR(50),
  "amt_stock" INTEGER,
  "reorder_amt" INTEGER,
  "reorder_yn" BOOLEAN,
  PRIMARY KEY ("items_services_id"),
  CONSTRAINT "FK_items_services.supplier_id"
    FOREIGN KEY ("supplier_id")
      REFERENCES "suppliers"("supplier_id")
);

CREATE TABLE "departments" (
  "dept_id" SERIAL,
  "dept_name" VARCHAR(20),
  PRIMARY KEY ("dept_id")
);

CREATE TABLE "employees" (
  "employee_id" SERIAL,
  "dept_id" INTEGER,
  "hotel_id" INTEGER,
  "emp_first_name" VARCHAR(180),
  "emp_last_name" VARCHAR(180),
  "title" VARCHAR(180),
  "salary" NUMERIC (8,2),
  "status" VARCHAR(20),
  "phone_num" VARCHAR(20),
  "start_date" DATE,
  "end_date" DATE,
  "performance_score" SMALLINT,
  PRIMARY KEY ("employee_id"),
  CONSTRAINT "FK_employees.dept_id"
    FOREIGN KEY ("dept_id")
      REFERENCES "departments"("dept_id"),
  CONSTRAINT "FK_employees.hotel_id"
    FOREIGN KEY ("hotel_id")
      REFERENCES "hotels"("hotel_id")
);

CREATE TABLE "customers" (
  "cust_id" SERIAL,
  "cust_first_name" VARCHAR(180),
  "cust_last_name" VARCHAR(180),
  "email" VARCHAR(180),
  "phone_num" VARCHAR(20),
  "address" VARCHAR(100),
  "city" VARCHAR(100),
  "state_province" VARCHAR(20),
  "country" VARCHAR(20),
  "zip_code" VARCHAR(20),
  "card_num" CHAR(16),
  "vip_yn" BOOLEAN,
  PRIMARY KEY ("cust_id")
);

CREATE TABLE "room_info" (
  "room_type_id" SERIAL,
  "room_type" VARCHAR(50),
  "num_beds" SMALLINT,
  "kitchenette_yn" BOOLEAN,
  "smoking_yn" BOOLEAN,
  "price" NUMERIC (8,2),
  PRIMARY KEY ("room_type_id")
);

CREATE TABLE "reservations" (
  "res_id" SERIAL,
  "cust_id" INTEGER,
  "hotel_id" INTEGER,
  "room_type_id" INTEGER,
  "room_num" INTEGER,
  "guest_type" VARCHAR(20),
  "check_in_date" DATE,
  "check_out_date" DATE,
  "res_method" VARCHAR(20),
  "res_date" TIMESTAMP,
  "base_expense" NUMERIC (8,2),
  "extra_expenses" NUMERIC (8,2),
  "cancelled_yn" BOOLEAN,
  PRIMARY KEY ("res_id"),
  CONSTRAINT "FK_reservations.room_type_id"
    FOREIGN KEY ("room_type_id")
      REFERENCES "room_info"("room_type_id"),
  CONSTRAINT "FK_reservations.cust_id"
    FOREIGN KEY ("cust_id")
      REFERENCES "customers"("cust_id"),
  CONSTRAINT "FK_reservations.hotel_id"
    FOREIGN KEY ("hotel_id")
      REFERENCES "hotels"("hotel_id")
);

CREATE TABLE "is_per_order" (
  "(order_id, items_services_id)" (INTEGER, INTEGER),
  "quantity" INTEGER,
  "price" NUMERIC (8,2),
  PRIMARY KEY ("(order_id, items_services_id)"),
  CONSTRAINT "FK_is_per_order.(order_id, items_services_id)"
    FOREIGN KEY ("(order_id, items_services_id)")
      REFERENCES "items_services"("items_services_id"),
  CONSTRAINT "FK_is_per_order.(order_id, items_services_id)"
    FOREIGN KEY ("(order_id, items_services_id)")
      REFERENCES "orders"("order_id")
);

CREATE TABLE "reviews" (
  "review_id" SERIAL,
  "res_id" INTEGER,
  "cust_id" INTEGER,
  "hotel_id" INTEGER,
  "room_type_id" INTEGER,
  "employee_id" INTEGER,
  "overall_rating" SMALLINT,
  "review_txt" TEXT,
  "resolve_yn" BOOLEAN,
  "resolved_yn" BOOLEAN,
  PRIMARY KEY ("review_id"),
  CONSTRAINT "FK_reviews.res_id"
    FOREIGN KEY ("res_id")
      REFERENCES "reservations"("res_id"),
  CONSTRAINT "FK_reviews.cust_id"
    FOREIGN KEY ("cust_id")
      REFERENCES "customers"("cust_id"),
  CONSTRAINT "FK_reviews.hotel_id"
    FOREIGN KEY ("hotel_id")
      REFERENCES "hotels"("hotel_id"),
  CONSTRAINT "FK_reviews.room_type_id"
    FOREIGN KEY ("room_type_id")
      REFERENCES "room_info"("room_type_id"),
  CONSTRAINT "FK_reviews.employee_id"
    FOREIGN KEY ("employee_id")
      REFERENCES "employees"("employee_id")
); 
