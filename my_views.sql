-- Création des tables
CREATE TABLE FACTORIES (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    main_location VARCHAR2(255)
);

CREATE TABLE WORKERS_FACTORY_1 (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    first_name VARCHAR2(100),
    last_name VARCHAR2(100),
    age NUMBER,
    first_day DATE,
    last_day DATE
);

CREATE TABLE WORKERS_FACTORY_2 (
    worker_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    first_name VARCHAR2(100),
    last_name VARCHAR2(100),
    start_date DATE,
    end_date DATE
);

CREATE TABLE SUPPLIERS (
    supplier_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name VARCHAR2(100)
);

CREATE TABLE SPARE_PARTS (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    color VARCHAR2(10) CHECK(color IN ('red', 'gray', 'black', 'blue', 'silver')),
    name VARCHAR2(100)
);

CREATE TABLE SUPPLIERS_BRING_TO_FACTORY_1 (
    supplier_id NUMBER REFERENCES suppliers(supplier_id),
    spare_part_id NUMBER REFERENCES spare_parts(id),
    delivery_date DATE,
    quantity NUMBER CHECK(quantity > 0)
);

CREATE TABLE SUPPLIERS_BRING_TO_FACTORY_2 (
    supplier_id NUMBER REFERENCES suppliers(supplier_id) NOT NULL,
    spare_part_id NUMBER REFERENCES spare_parts(id) NOT NULL,
    delivery_date DATE,
    quantity NUMBER CHECK(quantity > 0),
    recipient_worker_id NUMBER REFERENCES workers_factory_2(worker_id) NOT NULL
);

CREATE TABLE ROBOTS (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    model VARCHAR2(50)
);

CREATE TABLE ROBOTS_HAS_SPARE_PARTS (
    robot_id NUMBER REFERENCES robots(id),
    spare_part_id NUMBER REFERENCES spare_parts(id)
);

CREATE TABLE ROBOTS_FROM_FACTORY (
    robot_id NUMBER REFERENCES robots(id),
    factory_id NUMBER REFERENCES factories(id)
);

CREATE TABLE AUDIT_ROBOT (
    robot_id NUMBER REFERENCES robots(id),
    created_at DATE
);

-- Insertion de données
INSERT INTO FACTORIES (main_location) VALUES ('Usine principale A');
INSERT INTO FACTORIES (main_location) VALUES ('Usine principale B');

INSERT INTO WORKERS_FACTORY_1 (first_name, last_name, age, first_day, last_day)
VALUES ('John', 'Doe', 30, DATE '2022-01-01', NULL);  -- Exemple d'un employé toujours présent
INSERT INTO WORKERS_FACTORY_1 (first_name, last_name, age, first_day, last_day)
VALUES ('Jane', 'Smith', 25, DATE '2023-03-15', DATE '2023-12-31');  -- Exemple d'un employé parti

INSERT INTO WORKERS_FACTORY_2 (first_name, last_name, start_date, end_date)
VALUES ('Anna', 'Brown', DATE '2023-06-01', NULL);  -- Exemple d'un employé toujours présent
INSERT INTO WORKERS_FACTORY_2 (first_name, last_name, start_date, end_date)
VALUES ('David', 'Anderson', DATE '2024-01-15', DATE '2024-12-31');  -- Exemple d'un employé parti

INSERT INTO SUPPLIERS (name) VALUES ('Supplier A');
INSERT INTO SUPPLIERS (name) VALUES ('Supplier B');

INSERT INTO SPARE_PARTS (color, name) VALUES ('red', 'Spark plug');
INSERT INTO SPARE_PARTS (color, name) VALUES ('black', 'Gearbox');

INSERT INTO SUPPLIERS_BRING_TO_FACTORY_1 (supplier_id, spare_part_id, delivery_date, quantity)
VALUES (1, 1, DATE '2023-01-15', 1500);  -- Exemple de livraison du Supplier A à l'usine 1
INSERT INTO SUPPLIERS_BRING_TO_FACTORY_1 (supplier_id, spare_part_id, delivery_date, quantity)
VALUES (2, 2, DATE '2023-02-20', 1200);  -- Exemple de livraison du Supplier B à l'usine 1

-- Ajouter d'autres insertions de données si nécessaire

-- Insérer des robots dans la table ROBOTS
INSERT INTO ROBOTS (id, model) VALUES (1, 'Robot A');
INSERT INTO ROBOTS (id, model) VALUES (2, 'Robot B');
-- Ajoutez d'autres robots si nécessaire

-- Associer les robots aux usines dans la table ROBOTS_FROM_FACTORY
INSERT INTO ROBOTS_FROM_FACTORY (robot_id, factory_id) VALUES (1, 1);
INSERT INTO ROBOTS_FROM_FACTORY (robot_id, factory_id) VALUES (2, 2); 
-- Robot B associé à Usine B
-- Ajoutez d'autres associations si nécessaire
