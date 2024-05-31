-- Trigger pour la question 1
CREATE OR REPLACE TRIGGER Insert_Worker_All_Workers_Elapsed
INSTEAD OF INSERT ON ALL_WORKERS_ELAPSED
DECLARE
    v_error EXCEPTION;
BEGIN
    IF INSERTING THEN
        -- Insertion du worker dans la bonne table
        INSERT INTO WORKERS_FACTORY_1 (first_name, last_name, start_date)
        VALUES (:NEW.first_name, :NEW.last_name, SYSDATE);
    ELSE
        -- Erreur pour les opérations UPDATING et DELETING
        RAISE v_error;
    END IF;
EXCEPTION
    WHEN v_error THEN
        DBMS_OUTPUT.PUT_LINE('Opération non autorisée.');
END;


-- Trigger pour la question 2
CREATE OR REPLACE TRIGGER New_Robot_Audit
AFTER INSERT ON ROBOTS
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_ROBOT (robot_id, created_at)
    VALUES (:NEW.id, SYSDATE);
END;


-- Trigger pour la question 3
CREATE OR REPLACE TRIGGER Check_Factories_Count
BEFORE UPDATE OR DELETE ON FACTORIES
DECLARE
    v_error EXCEPTION;
    v_factory_count NUMBER;
    v_workers_factory_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_factory_count FROM FACTORIES;
    SELECT COUNT(*) INTO v_workers_factory_count FROM USER_TABLES WHERE TABLE_NAME LIKE 'WORKERS_FACTORY\_%';

    IF v_factory_count != v_workers_factory_count THEN
        RAISE v_error;
    END IF;
EXCEPTION
    WHEN v_error THEN
        DBMS_OUTPUT.PUT_LINE('Modification interdite. Le nombre d\'usines ne correspond pas au nombre de tables de travailleurs.');
END;


-- Trigger pour la question 4 (en supposant que la colonne de la durée du temps passé dans l'usine est nommée "time_spent")
CREATE OR REPLACE TRIGGER Calculate_Time_Spent
BEFORE INSERT OR UPDATE ON WORKERS_FACTORY_1
FOR EACH ROW
DECLARE
    v_start_date DATE;
    v_end_date DATE := :NEW.end_date;
BEGIN
    IF v_end_date IS NOT NULL THEN
        -- Calcul de la durée du temps passé dans l'usine
        v_start_date := :OLD.start_date;
        :NEW.time_spent := v_end_date - v_start_date;
    END IF;
END;

