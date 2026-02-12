--Actividad Modelado ER y Normalización: Envíos, Retail y Cuentas Bancarias


--Crear las tablas del diagrama usando lenguaje, --DDL --DML
----------------------------------------------------
DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS envio;
DROP TABLE IF EXISTS encomienda;

--1. Sistema de envío de encomiendas: DDL -- DML

-- Tabla cliente -- 
CREATE TABLE cliente ( 
id SERIAL PRIMARY KEY,
nombre VARCHAR(255) NOT NULL,
fono INTEGER NOT NULL,
direccion VARCHAR(255) NOT NULL,
comuna VARCHAR(255) NOT NULL
ON DELETE CASCADE 
ON UPDATE CASCADE 
);

-- Tabla envio --
CREATE TABLE envio ( 
id_cliente SERIAL PRIMARY KEY,
id_paquete INTEGER NOT NULL, 
numero_seguimiento INTEGER NOT NULL,
FOREIGN KEY (id_paquete) REFERENCES encomienda(id_paquete)
); 

-- Tabla encomienda --
CREATE TABLE encomienda ( 
id_paquete SERIAL PRIMARY KEY,
contenido VARCHAR(255) NOT NULL,
valor INTEGER NOT NULL
); 

---------------------------------------------------------------
--2. Sistema de ventas productos retail DDL -- DML
DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS detalle_pedido;
DROP TABLE IF EXISTS producto;
DROP TABLE IF EXISTS pago;

-- Tabla cliente --
CREATE TABLE cliente ( 
id SERIAL PRIMARY KEY,
nombre VARCHAR(255) NOT NULL,
primer_apellido VARCHAR(255) NOT NULL,
fono INTEGER NOT NULL,
direccion VARCHAR(255) NOT NULL,
e-mail VARCHAR(255) UNIQUE,
ON DELETE CASCADE -- Si se borra un cliente, sus cuentas se borran (Integridad Referencial) 
ON UPDATE CASCADE -- Si se actualiza el id_cliente, se actualiza en Cuentas 
);

--Tabla detalle_pedido--
CREATE TABLE detalle_pedido ( 
id SERIAL PRIMARY KEY,
SKU BIGINT NOT NULL,
nombre_producto VARCHAR(255) NOT NULL,
cantidad INTEGER CHECK (cantidad > 0) NOT NULL,
total INTEGER NOT NULL,
FOREIGN KEY (SKU) REFERENCES producto (SKU)
FOREIGN KEY (nombre_producto) REFERENCES producto (nombre)
); 

--Tabla producto--
CREATE TABLE producto ( 
SKU BIGINT PRIMARY KEY,
nombre VARCHAR(255) NOT NULL,
descripcion VARCHAR(255) NOT NULL,
precio INTEGER NOT NULL,
); 

--Tabla compra_pagada --
CREATE TABLE compra_pagada ( 
id SERIAL PRIMARY KEY,
valor_pago INTEGER NOT NULL,
tipo_transaccion VARCHAR(255) NOT NULL,
); 

---------------------------------------------------------------
--3. Sistema de banca: DDL -- DML --
DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS cuenta;
DROP TABLE IF EXISTS tipo_cuenta;
DROP TABLE IF EXISTS transaccion;

-- Tabla cliente --
CREATE TABLE cliente ( 
rut SERIAL PRIMARY KEY,
nombre VARCHAR(255) NOT NULL,
primer_apellido VARCHAR(255) NOT NULL,
fono INTEGER NOT NULL,
e-mail VARCHAR(255) UNIQUE,
ON DELETE CASCADE -- Si se borra un cliente, sus cuentas se borran (Integridad Referencial) 
ON UPDATE CASCADE -- Si se actualiza el id_cliente, se actualiza en Cuentas 
);

-- Tabla cuenta --
CREATE TABLE cuenta ( 
id_cta SERIAL PRIMARY KEY,
id_cliente INTEGER NOT NULL,
fecha_apertura DATE NOT NULL,
saldo PRIMARY KEY INTEGER NOT NULL,
);

--Tabla tipo_cuenta --
CREATE TABLE tipo_cuenta ( 
id SERIAL PRIMARY KEY,
corriente INTEGER NOT NULL,
ahorro INTEGER NOT NULL,
fondos_mutuos INTEGER NOT NULL,
);

-- Tabla transaccion --
CREATE TABLE transaccion ( 
id_transaccion SERIAL PRIMARY KEY,
id_cuenta INTEGER NOT NULL,
pago INTEGER NOT NULL,
transferencia INTEGER NOT NULL,
deposito INTEGER NOT NULL,
saldo INTEGER NOT NULL,
FOREIGN KEY (saldo) REFERENCES cuenta (saldo)
); 

--Indice, mejoran la performance de busqueda de datos
CREATE INDEX idx_rut_clientes ON cliente (rut);
CREATE INDEX idx_id_cliente_cuenta ON cuenta (id_cliente);

-- Crear SECUENCIAS (para autogenerar IDs si la base de datos lo requiere y no usa AUTOINCREMENT/IDENTITY)
CREATE SEQUENCE seq_id_cliente START WITH 1 INCREMENT BY 1; 
CREATE SEQUENCE seq_id_paquete START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_producto START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_nombre_producto START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_rut START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_cuenta START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_transaccion START WITH 1 INCREMENT BY 1;