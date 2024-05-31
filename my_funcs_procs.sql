CREATE OR REPLACE FUNCTION GET_NB_WORKERS(FACTORY_ID NUMBER) RETURN NUMBER IS
    nb_workers NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO nb_workers
    FROM ALL_WORKERS
    WHERE FACTORY_ID = FACTORY_ID;
    RETURN nb_workers;
END GET_NB_WORKERS;



CREATE OR REPLACE FUNCTION GET_NB_BIG_ROBOTS RETURN NUMBER IS
    nb_big_robots NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO nb_big_robots
    FROM ROBOTS_HAS_SPARE_PARTS
    GROUP BY robot_id
    HAVING COUNT(spare_part_id) > 3;
    RETURN nb_big_robots;
END GET_NB_BIG_ROBOTS;


CREATE OR REPLACE FUNCTION GET_BEST_SUPPLIER RETURN VARCHAR2 IS
    best_supplier VARCHAR2(100);
BEGIN
    SELECT supplier_name
    INTO best_supplier
    FROM BEST_SUPPLIERS
    WHERE ROWNUM = 1;
    RETURN best_supplier;
END GET_BEST_SUPPLIER;


CREATE OR REPLACE FUNCTION GET_OLDEST_WORKER RETURN NUMBER IS
    oldest_worker_id NUMBER;
BEGIN
    SELECT worker_id
    INTO oldest_worker_id
    FROM (
        SELECT worker_id
        FROM ALL_WORKERS
        ORDER BY start_date ASC
    )
    WHERE ROWNUM = 1;
    RETURN oldest_worker_id;
END GET_OLDEST_WORKER;

CREATE OR REPLACE PROCEDURE SEED_DATA_WORKERS(NB_WORKERS NUMBER, FACTORY_ID NUMBER) IS
BEGIN
    FOR i IN 1..NB_WORKERS LOOP
        INSERT INTO WORKERS_FACTORY_1 (first_name, last_name, age, first_day, last_day)
        VALUES ('worker_f_' || TO_CHAR(i), 'worker_l_' || TO_CHAR(i), DBMS_RANDOM.VALUE(20, 60),
                (SELECT TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2065-01-01','J'), TO_CHAR(DATE '2070-01-01','J'))), 'J') FROM DUAL), NULL);
    END LOOP;
    COMMIT;
END SEED_DATA_WORKERS;

CREATE OR REPLACE PROCEDURE ADD_NEW_ROBOT(MODEL_NAME VARCHAR2(50)) IS
BEGIN
    INSERT INTO ROBOTS (model)
    SELECT MODEL_NAME FROM ROBOTS_FACTORIES;
    COMMIT;
END ADD_NEW_ROBOT;
CREATE OR REPLACE PROCEDURE SEED_DATA_SPARE_PARTS(NB_SPARE_PARTS NUMBER) IS
    colors VARCHAR2(10);
    part_name VARCHAR2(100);
BEGIN
    FOR i IN 1..NB_SPARE_PARTS LOOP
        SELECT CASE MOD(i, 5)
            WHEN 0 THEN 'red'
            WHEN 1 THEN 'gray'
            WHEN 2 THEN 'black'
            WHEN 3 THEN 'blue'
            ELSE 'silver'
        END INTO colors FROM DUAL;

        part_name := 'part_' || TO_CHAR(i);
        INSERT INTO SPARE_PARTS (color, name) VALUES (colors, part_name);
    END LOOP;
    COMMIT;
END SEED_DATA_SPARE_PARTS;

