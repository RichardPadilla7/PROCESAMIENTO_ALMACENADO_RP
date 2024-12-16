-- PROCESAMIENTO ALMACENADO
-- Richard Padilla
CREATE DATABASE PA;
USE PA;

CREATE TABLE cliente (
    ClienteID INT AUTO_INCREMENT PRIMARY KEY,  -- Campo para el ID único del cliente
    Nombre VARCHAR(100),                      -- Campo para el nombre del cliente
    Estatura DECIMAL(5,2),                    -- Campo para la estatura del cliente con dos decimales
    FechaNacimiento DATE,                     -- Campo para la fecha de nacimiento del cliente
    Sueldo DECIMAL(10,2)                      -- Campo para el sueldo del cliente con dos decimales
);

-- CREAR EL PROCESAMIENTO EN BASE A LOS DATOSA DE LA TABLA CLIENTE
DELIMITER $$

CREATE PROCEDURE SeleccionarClientes()
BEGIN
    SELECT * FROM cliente;
END $$

DELIMITER ;

-- LLAMAR EL PROCESAMIENTO
CALL SeleccionarClientes();

-- Procedimiento de Insertar (INSERT)
DELIMITER $$

CREATE PROCEDURE InsertarCliente (
    IN p_Nombre VARCHAR(100),
    IN p_Estatura DECIMAL(5,2),
    IN p_FechaNacimiento DATE,
    IN p_Sueldo DECIMAL(10,2)
)
BEGIN
    INSERT INTO cliente (Nombre, Estatura, FechaNacimiento, Sueldo)
    VALUES (p_Nombre, p_Estatura, p_FechaNacimiento, p_Sueldo);
END $$

DELIMITER ;

-- Ejecutar el procedimiento
CALL InsertarCliente('Juan Pérez', 1.75, '1990-05-15', 2500.00);



-- Procedimiento de Actualización (UPDATE)
DELIMITER $$

CREATE PROCEDURE ActualizarSueldoCliente (
    IN p_ClienteID INT,
    IN p_NuevoSueldo DECIMAL(10,2)
)
BEGIN
    UPDATE cliente
    SET Sueldo = p_NuevoSueldo
    WHERE ClienteID = p_ClienteID;
END $$

DELIMITER ;

CALL ActualizarSueldoCliente(1, 3000.00);

-- Procedimiento de Eliminación (DELETE)
DELIMITER $$

CREATE PROCEDURE EliminarCliente (
    IN p_ClienteID INT
)
BEGIN
    DELETE FROM cliente
    WHERE ClienteID = p_ClienteID;
END $$

DELIMITER ;


CALL EliminarCliente(1);




-- Introducción a Condiciones en Procedimientos Almacenados
CREATE TABLE ordenes (
    OrdenID INT AUTO_INCREMENT PRIMARY KEY,     -- ID único de la orden
    ClienteID INT,                              -- Clave foránea que referencia al cliente
    FechaOrden DATE,                            -- Fecha de la orden
    Total DECIMAL(10,2),                        -- Monto total de la orden
    Estado VARCHAR(20),                         -- Estado de la orden (Ejemplo: 'Pagado', 'Pendiente')
    FOREIGN KEY (ClienteID) REFERENCES cliente(ClienteID) -- Relación con la tabla cliente
);


DELIMITER $$

CREATE PROCEDURE InsertarOrden (
    IN p_ClienteID INT,
    IN p_FechaOrden DATE,
    IN p_Total DECIMAL(10,2),
    IN p_Estado VARCHAR(20)
)
BEGIN
    DECLARE v_Edad INT; -- Variable para almacenar la edad del cliente

    -- Calcular la edad del cliente
    SELECT TIMESTAMPDIFF(YEAR, FechaNacimiento, CURDATE())
    INTO v_Edad
    FROM cliente
    WHERE ClienteID = p_ClienteID;

    -- Verificar si la edad es mayor o igual a 22 años
    IF v_Edad >= 22 THEN
        INSERT INTO ordenes (ClienteID, FechaOrden, Total, Estado)
        VALUES (p_ClienteID, p_FechaOrden, p_Total, p_Estado);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente debe tener al menos 22 años para realizar una orden.';
    END IF;
END $$

DELIMITER ;


CALL InsertarOrden(1, '2024-06-28', 500.00, 'Pendiente');


-- Procedimiento para Actualizar una Orden
DELIMITER $$

CREATE PROCEDURE ActualizarOrden (
    IN p_OrdenID INT,
    IN p_NuevoEstado VARCHAR(20)
)
BEGIN
    UPDATE ordenes
    SET Estado = p_NuevoEstado
    WHERE OrdenID = p_OrdenID;
END $$

DELIMITER ;

CALL ActualizarOrden(1, 'Pagado');

-- Procedimiento para Eliminar una Orden
DELIMITER $$

CREATE PROCEDURE EliminarOrden (
    IN p_OrdenID INT
)
BEGIN
    DELETE FROM ordenes
    WHERE OrdenID = p_OrdenID;
END $$

DELIMITER ;

CALL EliminarOrden(1);








