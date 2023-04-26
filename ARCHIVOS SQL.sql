----------------COMANDOS CREATE---------------------

--TABLA PUESTOS-----------------------------------
CREATE TABLE PUESTOS(
    Id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Nombre VARCHAR2(50),
    Descripcion VARCHAR2(100),
    Salario DECIMAL
)


--TABLA CLIENTES-----------------------------------
CREATE TABLE CLIENTES(
    DPI NUMBER PRIMARY KEY,
    Nombre VARCHAR2(100),
    Apellidos VARCHAR2(100),
    Fecha_Nacimiento DATE,
    Correo VARCHAR2(100),
    Telefono INT,
    NIT VARCHAR2(20)
)


--TABLA DIRECCIONES-----------------------------------
CREATE TABLE DIRECCIONES(
    Id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    DPI_Cliente NUMBER,
    CONSTRAINT fk_direccion_cliente FOREIGN KEY (DPI_Cliente) REFERENCES CLIENTES(DPI),
    Direccion VARCHAR2(100),
    Municipio VARCHAR2(50),
    Zona INT
)


--TABLA RESTAURANTES-----------------------------------
CREATE TABLE RESTAURANTES(
	Id VARCHAR2(100) PRIMARY KEY,
	Direccion VARCHAR2(100),
    Municipio VARCHAR2(100),
    Zona INT,
    Telefono INT,
    Personal INT,
    Parqueo NUMBER
)


--TABLA ORDENES-----------------------------------
CREATE TABLE ORDENES(
    Id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    DPI_Cliente NUMBER,
    Id_Direccion INT,
    CONSTRAINT fk_orden_direccion FOREIGN KEY (Id_Direccion) REFERENCES DIRECCIONES(Id),
    Canal CHAR,
    Inicio DATE,
    Entrega DATE,
    IdRestaurante VARCHAR2(100),
    CONSTRAINT fk_orden_restaurante FOREIGN KEY (IdRestaurante) REFERENCES RESTAURANTES(Id),
    Estado VARCHAR2(20)
)


--TABLA DETALLE-----------------------------------
CREATE TABLE DETALLE(
    Id_Orden INT,
    CONSTRAINT fk_detalle_orden FOREIGN KEY (Id_Orden) REFERENCES ORDENES(Id),
    TipoProducto CHAR,
    Producto INT,
    Cantidad INT,
    Observacion VARCHAR2(100)
)


--TABLA EMPLEADOS-----------------------------------
CREATE TABLE EMPLEADOS(
	Id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
	Nombre VARCHAR2(100),
    Apellidos VARCHAR2(100),
    Fecha_Nacimiento DATE,
    Correo VARCHAR2(100),
    Telefono INT,
    Direccion VARCHAR2(100),
    DPI NUMBER,
   	Puesto INT,
    CONSTRAINT fk_empleado_puesto FOREIGN KEY (Puesto) REFERENCES PUESTOS(Id),
   	Fecha_Inicio DATE,
    IdRestaurante VARCHAR2(100),
    CONSTRAINT fk_empleado_restaurante FOREIGN KEY (IdRestaurante) REFERENCES RESTAURANTES(Id)
)


--TABLA HISTORIAL-----------------------------------
CREATE TABLE Historial(
	ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	fecha_ejecucion DATE,
	tabla VARCHAR2(100),
	tipo VARCHAR2(25)
	CONSTRAINT pk_historial PRIMARY KEY (ID)
)




----------------COMANDOS DE FUNCIONES---------------------

--TABLA CLIENTES-----------------------------------
CREATE OR REPLACE FUNCTION GETCURRENTDATE RETURN DATE AS
BEGIN
    RETURN SYSDATE;
END;


-----------------------------------------------------------
----------------COMANDOS DE TIGRES-------------------------

--INSERT RESTAURANTE-----------------------------------
CREATE OR REPLACE TRIGGER tr_insert_restaurante
AFTER INSERT ON restaurantes
FOR EACH ROW
BEGIN
    -- Insertar un registro en la tabla historial
    INSERT INTO historial (fecha_ejecucion, tabla, tipo)
    VALUES (GETCURRENTDATE(), 'Se ha insertado un registro en RESTAURANTES', 'INSERT');
END;


--INSERT PUESTOS-----------------------------------
CREATE OR REPLACE TRIGGER tr_insert_puesto
AFTER INSERT ON PUESTOS
FOR EACH ROW
BEGIN
    -- Insertar un registro en la tabla historial
    INSERT INTO historial (fecha_ejecucion, tabla, tipo)
    VALUES (GETCURRENTDATE(), 'Se ha insertado un registro en PUESTOS', 'INSERT');
END;


--INSERT EMPLEADOS-----------------------------------
CREATE OR REPLACE TRIGGER tr_insert_empleado
AFTER INSERT ON EMPLEADOS
FOR EACH ROW
BEGIN
    -- Insertar un registro en la tabla historial
    INSERT INTO historial (fecha_ejecucion, tabla, tipo)
    VALUES (GETCURRENTDATE(), 'Se ha insertado un registro en EMPLEADOS', 'INSERT');
END;


--INSERT DIRECCIONES-----------------------------------
CREATE OR REPLACE TRIGGER tr_insert_Direcciones
AFTER INSERT ON DIRECCIONES
FOR EACH ROW
BEGIN
    -- Insertar un registro en la tabla historial
    INSERT INTO historial (fecha_ejecucion, tabla, tipo)
    VALUES (GETCURRENTDATE(), 'Se ha insertado un registro en DIRECCIONES', 'INSERT');
END;


--INSERT DETALLLE-----------------------------------
CREATE OR REPLACE TRIGGER tr_insert_Detalle
AFTER INSERT ON DETALLE
FOR EACH ROW
BEGIN
    -- Insertar un registro en la tabla historial
    INSERT INTO historial (fecha_ejecucion, tabla, tipo)
    VALUES (GETCURRENTDATE(), 'Se ha insertado un registro en DETALLE', 'INSERT');
END;


--INSERT CLIENTES-----------------------------------
CREATE OR REPLACE TRIGGER tr_insert_Clientes
AFTER INSERT ON CLIENTES
FOR EACH ROW
BEGIN
    -- Insertar un registro en la tabla historial
    INSERT INTO historial (fecha_ejecucion, tabla, tipo)
    VALUES (GETCURRENTDATE(), 'Se ha insertado un registro en CLIENTES', 'INSERT');
END;


--INSERT ORDENES-----------------------------------
CREATE OR REPLACE TRIGGER tr_insert_Ordenes
AFTER INSERT ON ORDENES
FOR EACH ROW
BEGIN
    -- Insertar un registro en la tabla historial
    INSERT INTO historial (fecha_ejecucion, tabla, tipo)
    VALUES (GETCURRENTDATE(), 'Se ha insertado un registro en ORDENES', 'INSERT');
END;


--UPDATE ORDENES-----------------------------------
CREATE OR REPLACE TRIGGER tr_update_Ordenes
AFTER UPDATE ON ORDENES
FOR EACH ROW
BEGIN
    -- Insertar un registro en la tabla historial
    INSERT INTO historial (fecha_ejecucion, tabla, tipo)
    VALUES (GETCURRENTDATE(), 'Se ha actualizado un registro en ORDENES', 'UPDATE');
END;



-----------------------------------------------------------
----------------COMANDOS DE FUNCIONES----------------------

--RESTAURANTE VALIDACIONES----------------------------------
CREATE OR REPLACE PROCEDURE insertar_restaurante (
    p_id IN VARCHAR2,
    p_address IN VARCHAR2,
    p_municipio IN VARCHAR2,
    p_zona IN NUMBER,
    p_phone IN NUMBER,
    p_personal IN NUMBER,
    p_has_parking IN NUMBER
) AS
BEGIN
    -- Verificar si la zona es positiva
    IF p_zona < 0 THEN
        DBMS_OUTPUT.PUT_LINE('La zona debe ser Positiva.'); -- Imprimir mensaje de error
        RETURN; -- Salir del procedimiento
    END IF;
    
    IF existeRestaurate(p_id) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El restaurante ya existe'); -- Imprimir mensaje de error
        RETURN; -- Salir del procedimiento
    END IF;
   
    -- Insertar el registro en la tabla restaurante
    INSERT INTO RESTAURANTES(ID, DIRECCION , municipio, ZONA, TELEFONO , PERSONAL , PARQUEO)
    VALUES (p_id, p_address, p_municipio, p_zona, p_phone, p_personal, p_has_parking);
    
    -- Imprimir un mensaje indicando que la inserción se realizó con éxito
    DBMS_OUTPUT.PUT_LINE('Registro insertado en la tabla restaurante.');
END;


CREATE OR REPLACE FUNCTION existeRestaurate (
	p_id IN varchar2
) RETURN INT AS
    v_count NUMBER;
BEGIN
    -- Contar la cantidad de registros en la tabla restaurante que tienen el mismo ID
    SELECT COUNT(*) INTO v_count FROM RESTAURANTES WHERE id = p_id;
    -- Retornar TRUE si no se encontró ningún registro con el mismo ID, FALSE en caso contrario
    IF v_count = 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END;



--RESTAURANTE PUESTO-----------------------------------------
CREATE OR REPLACE PROCEDURE insertar_puesto (
    p_nombre IN VARCHAR2,
    p_descripcion IN VARCHAR2,
    p_salario IN DECIMAL
) AS
BEGIN
    -- Verificar si la zona es positiva
    IF  p_salario < 0 THEN
        DBMS_OUTPUT.PUT_LINE('El salario debe ser positivo.'); -- Imprimir mensaje de error
        RETURN; -- Salir del procedimiento
    END IF;
    
    INSERT INTO ASOCIADO (NOMBRE , DESCRIPCION, SALARIO) 
    VALUES (p_nombre, p_descripcion, p_salario)
    
    DBMS_OUTPUT.PUT_LINE('Registro insertado en la tabla PUESTO.');
END;



--RESTAURANTE EMPLEADO-----------------------------------------
CREATE OR REPLACE PROCEDURE insertar_empleado (
    p_nombre IN VARCHAR2,
    p_apellido IN VARCHAR2,
    p_fecha IN DATE,
    p_correo IN VARCHAR2,
    p_telefono IN NUMBER,
    p_direccion IN VARCHAR2,
    p_dpi IN NUMBER,
    p_puesto IN NUMBER,
    p_fecha_inicio IN DATE,
    p_id_restaurante IN VARCHAR2
) AS
    v_max_personal NUMBER;
    v_personal_actual NUMBER;
BEGIN
    IF existePuesto(p_puesto) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Identificador de puesto inexistente'); -- Imprimir mensaje de error
        RETURN; -- Salir del procedimiento
    END IF;
    
    IF existeRestaurate(p_id_restaurante) = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Identificador de Restaurante inexistente'); -- Imprimir mensaje de error
        RETURN; -- Salir del procedimiento
    END IF;

    IF NOT REGEXP_LIKE(p_correo, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
        DBMS_OUTPUT.PUT_LINE('Correo no válido'); -- Imprimir mensaje de error
        RETURN; -- Salir del procedimiento
    END IF;

   SELECT PERSONAL INTO v_max_personal FROM RESTAURANTES WHERE Id = p_id_restaurante;
    
    -- Obtener la cantidad actual de personal para el restaurante
    SELECT COUNT(*) INTO v_personal_actual FROM EMPLEADO WHERE IdRestaurante = p_id_restaurante;
    
    -- Verificar si la cantidad actual de personal más uno (por el nuevo empleado a insertar) es mayor que el máximo permitido para el restaurante
    IF v_personal_actual + 1 > v_max_personal THEN
        DBMS_OUTPUT.PUT_LINE('El restaurante ya alcanzó el máximo de empleados permitido'); -- Imprimir mensaje de error
        RETURN; -- Salir del procedimiento
    END IF;

    INSERT INTO CLIENTES (NOMBRE, APELLIDOS, Fecha_Nacimiento, CORREO, TELEFONO, DIRECCION, DPI, PUESTO, Fecha_Inicio,IdRestaurante) 
    VALUES (p_nombre,p_apellido,p_fecha,p_correo,p_telefono,p_direccion,p_dpi,p_puesto,p_fecha_inicio,p_id_restaurante) 
   
    DBMS_OUTPUT.PUT_LINE('Registro insertado en la tabla EMPLEADO.');
END;

CREATE OR REPLACE FUNCTION existePuesto (
	p_id IN NUMBER
) RETURN INT AS
    v_count NUMBER;
BEGIN
    -- Contar la cantidad de registros en la tabla restaurante que tienen el mismo ID
    SELECT COUNT(*) INTO v_count FROM PUESTO WHERE id = p_id;
    -- Retornar TRUE si no se encontró ningún registro con el mismo ID, FALSE en caso contrario
    IF v_count = 0 THEN
        RETURN 0;
    ELSE
        RETURN 1;
    END IF;
END;




--RESTAURANTE CLIENTE-----------------------------------------
CREATE OR REPLACE PROCEDURE insertar_cliente (
    p_dpi IN NUMBER,
    p_nombre IN VARCHAR2,
    p_apellido IN VARCHAR2,
    p_fecha IN DATE,
    p_correo IN VARCHAR2,
    p_telefono IN NUMBER,
    p_nit IN VARCHAR2
) AS
BEGIN
    IF existeCliente(p_id_restaurante) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Cliente ya registrado'); -- Imprimir mensaje de error
        RETURN; -- Salir del procedimiento
    END IF;

    IF NOT REGEXP_LIKE(p_correo, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
        DBMS_OUTPUT.PUT_LINE('Correo no válido'); -- Imprimir mensaje de error
        RETURN; -- Salir del procedimiento
    END IF;

    IF LENGTH(p_nit) > 0 THEN
        INSERT INTO CLIENTES (DPI, NOMBRE, APELLIDO, Fecha_Nacimiento, CORREO, TELEFONO, NIT) 
        VALUES (p_dpi,p_nombre,p_apellido,p_fecha,p_correo,p_telefono,p_nit) 
    ELSE
        INSERT INTO CLIENTES (DPI, NOMBRE, APELLIDO, Fecha_Nacimiento, CORREO, TELEFONO, NIT) 
        VALUES (p_dpi,p_nombre,p_apellido,p_fecha,p_correo,p_telefono,'CF') 
    END IF;

    DBMS_OUTPUT.PUT_LINE('Registro insertado en la tabla EMPLEADO.');
END;

CREATE OR REPLACE FUNCTION existeCliente (
	p_id IN NUMBER
) RETURN INT AS
    v_count NUMBER;
BEGIN
    
    SELECT COUNT(*) INTO v_count FROM CLIENTES WHERE DPI = p_id;
    
    IF v_count = 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END;




--RESTAURANTE DIRECCION-----------------------------------------
CREATE OR REPLACE PROCEDURE insertar_direccion (
    p_dpi IN NUMBER,
    p_direccion IN VARCHAR2,
    p_municipio IN VARCHAR2,
    p_zona IN NUMBER
) AS
BEGIN
    IF existeCliente(p_id_restaurante) = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Identificador de cliente inexistente'); -- Imprimir mensaje de error
        RETURN; -- Salir del procedimiento
    END IF;

     IF p_zona < 0 THEN
        DBMS_OUTPUT.PUT_LINE('La zona debe ser Positiva.'); -- Imprimir mensaje de error
        RETURN; -- Salir del procedimiento
    END IF;

    INSERT INTO CLIENTES (DPI_Cliente, Direccion, Municipio, Zona) 
    VALUES (p_dpi,p_direccion,p_municipio,p_zona) 

    DBMS_OUTPUT.PUT_LINE('Registro insertado en la tabla EMPLEADO.');
END;




--RESTAURANTE ORDENES-----------------------------------------------
CREATE OR REPLACE PROCEDURE insertar_orden (
    p_dpi IN NUMBER,
    p_direccion IN VARCHAR2,
    p_municipio IN VARCHAR2,
    p_zona IN NUMBER
) AS
BEGIN
    IF existeCliente(p_id_restaurante) = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Identificador de cliente inexistente'); -- Imprimir mensaje de error
        RETURN; -- Salir del procedimiento
    END IF;

     IF p_zona < 0 THEN
        DBMS_OUTPUT.PUT_LINE('La zona debe ser Positiva.'); -- Imprimir mensaje de error
        RETURN; -- Salir del procedimiento
    END IF;

    INSERT INTO CLIENTES (DPI_Cliente, Direccion, Municipio, Zona) 
    VALUES (p_dpi,p_direccion,p_municipio,p_zona) 

    DBMS_OUTPUT.PUT_LINE('Registro insertado en la tabla EMPLEADO.');
END;