CREATE DATABASE SmartInCan; -- Se crea base de datos "SICan"
USE SmartInCan; -- Se selecciona la base de datos "SICan"

-- Se crea la tabla usuarios

CREATE TABLE usuarios (
    id_usuario BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(150) NOT NULL,
    correo VARCHAR(50) NOT NULL UNIQUE,
    telefono BIGINT NOT NULL,
    contraseña VARCHAR(150) NOT NULL
) ENGINE=InnoDB;

-- Se crea la tabla caneca

CREATE TABLE caneca (
    id_caneca INT PRIMARY KEY,
    contraseña VARCHAR(150) NOT NULL,
    tipo ENUM('aprovechable', 'organico', 'no aprovechable') NOT NULL,
    capacidad BIGINT NOT NULL
) ENGINE=InnoDB;

-- Se crea la tabla cuenta

CREATE TABLE cuenta (
    id_cuenta BIGINT PRIMARY KEY AUTO_INCREMENT,
    fecha TIMESTAMP NOT NULL,
    rol ENUM('admin', 'dinamizador', 'recolector', 'patrocinador'),
    id_usuario BIGINT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Se crea la tabla depositar

CREATE TABLE depositar (
    id_depositar BIGINT PRIMARY KEY AUTO_INCREMENT,
    fecha TIMESTAMP NOT NULL,
    puntos BIGINT NOT NULL,
    id_usuario BIGINT NOT NULL,
    id_caneca INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE NO ACTION ON UPDATE CASCADE,
    FOREIGN KEY (id_caneca) REFERENCES caneca(id_caneca) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Se crea la tabla residuos

CREATE TABLE residuos (
    id_residuos BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(150),
    descripcion VARCHAR(150),
    id_depositar BIGINT NOT NULL,
    FOREIGN KEY (id_depositar) REFERENCES depositar(id_depositar) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Se crea la tabla recompensas

CREATE TABLE recompensas (
    id_recompensas BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(150),
    can_puntos BIGINT,
    precio FLOAT
) ENGINE=InnoDB;

-- Se crea la tabla canjeos

CREATE TABLE canjeos (
    id_canjeos BIGINT PRIMARY KEY AUTO_INCREMENT,
    fecha DATE,
    can_puntos BIGINT,
    id_recompensas BIGINT NOT NULL,
    id_usuario BIGINT NOT NULL,
    FOREIGN KEY (id_recompensas) REFERENCES recompensas(id_recompensas) ON DELETE NO ACTION ON UPDATE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 1. Consulta de depósitos realizados por usuarios
CREATE VIEW vw_depositos_usuarios AS
SELECT 
    depositar.id_depositar,
    usuarios.nombre,
    caneca.tipo,
    depositar.puntos,
    depositar.fecha
FROM
    depositar
        INNER JOIN
    usuarios ON depositar.id_usuario = usuarios.id_usuario
        INNER JOIN
    caneca ON depositar.id_caneca = caneca.id_caneca;
SELECT * FROM vw_depositos_usuarios;

-- 2. Consulta de canjeos realizados por usuarios
CREATE VIEW vw_canjeos_recompensa AS
SELECT 
    canjeos.id_canjeos,
    usuarios.nombre,
    recompensas.nombre AS recompensa,
    canjeos.can_puntos,
    canjeos.fecha
FROM
    canjeos
        INNER JOIN
    usuarios ON canjeos.id_usuario = usuarios.id_usuario
        INNER JOIN
    recompensas ON canjeos.id_recompensas = recompensas.id_recompensas;
SELECT * FROM vw_canjeos_recompensa;

-- 3. Consulta de cuentas con roles
CREATE VIEW vw_cuenta_usuarios AS
SELECT cuenta.id_cuenta, usuarios.nombre, cuenta.rol, cuenta.fecha
	FROM cuenta
        INNER JOIN usuarios ON cuenta.id_usuario = usuarios.id_usuario;
SELECT * FROM vw_cuenta_usuarios;


-- 4. Consulta de recompensas ordenadas por precio
CREATE VIEW vw_recompensas_precio AS
SELECT * FROM recompensas 
	ORDER BY precio DESC;
SELECT * FROM vw_recompensas_precio;


-- 5. Consulta del total de puntos obtenidos
CREATE VIEW vw_total_puntos AS
SELECT SUM(puntos) AS total_puntos 
	FROM depositar;
SELECT * FROM vw_total_puntos;