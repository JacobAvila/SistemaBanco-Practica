
CREATE TABLE Cliente(
rfc varchar(13) primary key,
nombre varchar(50) NOT NULL,
calle varchar(30),
numero varchar(7),
colonia varchar(15),
ciudad varchar(15),
estado varchar(20),
cp varchar(5),
pais varchar(15)
);

CREATE TABLE Telefono(
rfc varchar(13),
numero varchar(10),
primary key (rfc, numero),
foreign key (rfc) references Cliente(rfc)
);


create table Cuenta(
no_cuenta int primary key identity(1,1),
tipo varchar(10) check(tipo in ('Ahorro', 'Cheques', 'Inversión')),
saldo money,
rfc varchar(13),
foreign key (rfc) references Cliente(rfc)
)

Create table Movimiento(
id_movimiento int primary key identity(1,1),
fecha datetime,
monto money,
no_cuenta int,
foreign key (no_cuenta) references Cuenta(no_cuenta) ON DELETE CASCADE ON UPDATE CASCADE
)

SELECT * FROm Telefono

--- Datos para tablas
INSERT INTO Cliente (rfc, nombre, calle, numero, colonia, ciudad, estado, cp, pais) 
VALUES('ABC123', 'Carlos Martinez', 'Av 1', '10', 'Progreso', 'CDMX', 'CDMX', '03510', 'México');

INSERT INTO Cliente (rfc, nombre, calle, numero, colonia, ciudad, estado, cp, pais) 
VALUES('BCD234', 'Beatriz Morales', 'Juan Escutia', '208', 'Los Volcanes', 'Puebla', 'Puebla', '85041', 'México');

INSERT INTO Cliente (rfc, nombre, calle, numero, colonia, ciudad, estado, cp, pais) 
VALUES('CDE345', 'Enrique Juarez', 'Lopez Mateos', '864', 'Jardines', 'Queretaro', 'Queretaro', '45887', 'México');

INSERT INTO Cliente (rfc, nombre, calle, numero, colonia, ciudad, estado, cp, pais) 
VALUES('DEF456', 'Juan Robles', 'Avena', '17', 'Industrial', 'CDMX', 'CDMX', '04280', 'México');

SELECT * FROM Cliente

INSERT INTO Telefono (rfc, numero) VALUES ('ABC123', '5544667788');
INSERT INTO Telefono (rfc, numero) VALUES ('ABC123', '5555998877');
INSERT INTO Telefono (rfc, numero) VALUES ('ABC123', '5566112233');
INSERT INTO Telefono (rfc, numero) VALUES ('BCD234', '5544667788');
INSERT INTO Telefono (rfc, numero) VALUES ('BCD234', '7894567895');
INSERT INTO Telefono (rfc, numero) VALUES ('CDE345', '8877996644');
INSERT INTO Telefono (rfc, numero) VALUES ('DEF456', '5511223344');

SELECT * FROM Cuenta

INSERT INTO Telefono VALUES('XYZ456', '5656565656')
SELECT * FROM Cliente
DELETE FROM Cliente WHERE rfc='GHI456'

ALTER TABLE Cuenta
ADD constraint FK__Cuenta__rfc__2A4B4B5E Foreign key (rfc) references Cliente(rfc) 
ON delete cascade on update cascade

-- CASCADE, SET NULL, SET DEFAULT, DO NOTHING

UPDATE Cliente SET RFC='DEF4567' WHERE rfc='DEF456'


-- datos para la tabla cuenta
INSERT INTO Cuenta (tipo, saldo, rfc) VALUES('Ahorro', 0, 'ABC123')
INSERT INTO Cuenta (tipo, saldo, rfc) VALUES('Inversión', 0, 'ABC123')
INSERT INTO Cuenta (tipo, saldo, rfc) VALUES('Ahorro', 0, 'BCD234')
INSERT INTO Cuenta (tipo, saldo, rfc) VALUES('Cheques', 0, 'CDE345')
INSERT INTO Cuenta (tipo, saldo, rfc) VALUES('Inversión', 0, 'CDE345')
INSERT INTO Cuenta (tipo, saldo, rfc) VALUES('Ahorro', 0, 'CDE345')
INSERT INTO Cuenta (tipo, saldo, rfc) VALUES('Ahorro', 0, 'DEF456')

SELECT * FROM Cuenta

-- Movimientos

-- deposito de 2000 a la cuenta 1
INSERT INTO Movimiento (fecha, monto, no_cuenta) VALUES('2020-05-15', 2000, 1)
UPDATE Cuenta SET saldo = saldo + 2000 WHERE no_cuenta = 1

-- retiro de 800 de la cuenta 1
INSERT INTO Movimiento (fecha, monto, no_cuenta) VALUES('2020-05-20', -800, 1)
UPDATE Cuenta SET saldo = saldo - 800 WHERE no_cuenta = 1

-- deposito de 4000 a la cuenta 1
INSERT INTO Movimiento (fecha, monto, no_cuenta) VALUES('2020-05-20', 4000, 1)
UPDATE Cuenta SET saldo = saldo + 4000 WHERE no_cuenta = 1

-- deposito de 2000 a la cuenta 2
INSERT INTO Movimiento (fecha, monto, no_cuenta) VALUES(getDate(), 2000, 2)
UPDATE Cuenta SET saldo = saldo + 2000 WHERE no_cuenta = 2

-- retiro de 300 de la cuenta 2
INSERT INTO Movimiento (fecha, monto, no_cuenta) VALUES(getDate(), -300, 2)
UPDATE Cuenta SET saldo = saldo - 300 WHERE no_cuenta = 2

-- deposito de 8000 a la cuenta 3
declare @monto money, @no_cuenta int
set @no_cuenta = 3
set @monto = 8000

INSERT INTO Movimiento(fecha, monto, no_cuenta) VALUES(getDate(), @monto, @no_cuenta)
UPDATE Cuenta SET saldo = saldo + @monto WHERE no_cuenta = @no_cuenta


-- deposito de 3000 a la cuenta 3
declare @monto money, @no_cuenta int
set @no_cuenta = 3
set @monto = 3000

INSERT INTO Movimiento(fecha, monto, no_cuenta) VALUES(getDate(), @monto, @no_cuenta)
UPDATE Cuenta SET saldo = saldo + @monto WHERE no_cuenta = @no_cuenta

-- retiro de 4300 de la cuenta 3
declare @monto money, @no_cuenta int
set @no_cuenta = 3
set @monto = -4300

INSERT INTO Movimiento(fecha, monto, no_cuenta) VALUES(getDate(), @monto, @no_cuenta)
UPDATE Cuenta SET saldo = saldo + @monto WHERE no_cuenta = @no_cuenta

SELECT * FROM Cuenta
SELECT * FROM Movimiento

CREATE PROCEDURE sp_movimiento (@no_cuenta int, @monto money)
AS
declare @saldo money

begin transaction
begin try
if @monto < 0
begin
	SELECT @saldo = saldo FROM Cuenta WHERE no_cuenta = @no_cuenta
	set @monto = @monto * -1
	if @monto <= @saldo
	begin
		set @monto = @monto * -1
		INSERT INTO Movimiento (fecha, monto, no_cuenta) VALUES (getDate(), @monto, @no_cuenta)
	end
end
else
begin
	INSERT INTO Movimiento (fecha, monto, no_cuenta) VALUES (getDate(), @monto, @no_cuenta)
end
COMMIT
end try
begin catch
	rollback
end catch

exec sp_movimiento 4, 4600

exec sp_movimiento 4, -1100

SELECT * FROM Movimiento
delete from movimiento where id_movimiento = 11
SELECT * FROM cuenta

UPDATE Cuenta SET saldo = (SELECT SUM(monto) FROM Movimiento WHERE no_cuenta = 4) 
WHERE no_cuenta = 4

exec sp_movimiento 4, -3000

exec sp_movimiento 5, 9000
SELECT * FROM Movimiento
SELECT * FROM Cuenta

INSERT INTO movimiento (fecha, monto, no_cuenta)
VALUES(getdate(), 3000, 5)


CREATE TRIGGER tr_actSaldo ON Movimiento AFTER INSERT
AS
begin transaction
begin try
declare @monto money, @nocuenta int, @saldo money
SELECT @monto = monto, @nocuenta = no_cuenta FROM INSERTED
SELECT @saldo = SUM(monto) FROM Movimiento WHERE no_cuenta = @nocuenta

UPDATE Cuenta SET saldo = @saldo WHERE no_cuenta = @nocuenta
commit
end try
begin catch
rollback
end catch

INSERT INTO movimiento (fecha, monto, no_cuenta)
VALUES(getdate(), -2000, 5)


exec sp_movimiento 5, -1500



--- Alta de Cliente Nuevo (RFC, NOMBRE, TIPO, MONTO)
exec sp_NuevoCliente 'XYZ987', 'Peter Jackson', 'Ahorro', 2500

-- Verifica si el rfc ya existe
-- Si no existe
	-- Inserta el registro en la tabla Cliente
-- Inserta el registro en la tabla Cuenta
-- Obtiene el no_cuenta asignado por la BD
-- Inserta el Movimiento con el Monto Inicial



Create procedure sp_NuevoCliente @rfc varchar(13), @nombre varchar(30), @tipo varchar(10), @monto money
AS
begin transaction
begin try
	if not exists (SELECT * FROM Cliente WHERE rfc=@rfc)
	begin
		INSERT INTO cliente (rfc, nombre) VALUES (@rfc, @nombre)
	end
	INSERT INTO cuenta (tipo, saldo, rfc) VALUES(@tipo, 0, @rfc)
	declare @nocuenta int
	SELECT @nocuenta = @@IDENTITY
	INSERT INTO Movimiento(fecha, monto, no_cuenta) VALUES(getdate(), @monto, @nocuenta)
	COMMIT
end try
begin catch
	rollback
end catch

SELECT * FROM cuenta

exec sp_NuevoCliente 'WXY456', 'Marcos Lopez', 'Ahorro', 4500


--- Procedimiento para transferir de una cuenta de origen a una cuenta destino
CREATE Procedure sp_transferir @origen int, @destino int, @monto money
AS
begin transaction
begin try
	declare @monto_neg money
	set @monto_neg = @monto * -1
	exec sp_movimiento @origen, @monto_neg
	exec sp_movimiento @destino, @monto
	commit
end try
begin catch
	rollback
end catch

SELECT * FROm Cuenta

sp_transferir 5, 4, 2000


SELECT * FROM Cliente

SET IMPLICIT_TRANSACTIONS OFF
SET ANSI_DEFAULTS OFF

begin tran
INSERT INTO Cliente (rfc, nombre) VALUES('NMO456', 'Gabriel Mendez')
begin tran
INSERT INTO Cliente (rfc, nombre) VALUES('NOP123', 'Roberto Resendiz')
COMMIT
rollback


SELECT * FROM Cliente

SELECT c.rfc, nombre, COUNT(no_cuenta) as cuentas
FROM Cliente c, Cuenta ct
WHERE c.rfc = ct.rfc
group by c.rfc, nombre

SELECT count(no_cuenta) FROM Cuenta ct WHERE ct.rfc='JKL123'

CREATE VIEW clientes
AS
SELECT c.rfc, nombre, (SELECT count(no_cuenta) FROM Cuenta ct WHERE ct.rfc=c.rfc) as cuentas
FROM Cliente c



SELECT * FROM clientes
WHERE cuentas < 1

SELECT * FROM clientes

-- Depositos del mes de Octubre del cliente CDE345 
SELECT nombre, 'Octubre 2020' as Mes, sum(monto) as depositos
FROM Cliente c, Cuenta ct, Movimiento m
WHERE c.rfc=ct.rfc and ct.no_cuenta=m.no_cuenta
and c.rfc='CDE345' and month(fecha) = 10
and monto > 0
Group By nombre


declare @rfc varchar(13), @nombre varchar(30), @cuentas int
declare cursor_clientes CURSOR FOR SELECT rfc, nombre, cuentas from clientes

OPEN cursor_clientes

FETCH cursor_clientes INTO @rfc, @nombre, @cuentas
WHILE(@@FETCH_STATUS = 0)
begin
	print @rfc
	print @nombre
	print @cuentas
	FETCH cursor_clientes INTO @rfc, @nombre, @cuentas
end

CLOSE cursor_clientes
DEALLOCATE cursor_clientes

CREATE PROCEDURE NuevaCuenta @tipo varchar(15), @monto money, @rfc varchar(13)
AS
begin transaction
begin try
	INSERT INTO cuenta (tipo, saldo, rfc) VALUES(@tipo, 0, @rfc)
	declare @no_cuenta int
	Select @no_cuenta = @@IDENTITY
	INSERT INTO movimiento (fecha, monto, no_cuenta) VALUES(getDate(), @monto, @no_cuenta)
	commit
end try
begin catch
	rollback
end catch

SELECT * FROM cliente
SELECT * FROM Cuenta