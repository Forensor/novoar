--1era transaccion
BEGIN TRY
	BEGIN TRANSACTION T1
		INSERT INTO Cientifico_Pinguino (cientifico,
											pinguino,fecha_Examen) 
		VALUES (1,1,'10/03/2020');
	COMMIT TRANSACTION T1
	PRINT 'Operación realizada con éxito'
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION T1
	PRINT 'HA OCURRIDO UN ERROR. MIRA vErroresHOY PARA VER MÁS DETALLES'
	EXECUTE almacenar_error
END CATCH;
--2da transaccion
BEGIN TRY
	BEGIN TRANSACTION T2
		INSERT INTO Pinguino(nombre,sexo,estado_Muda,pareja,monitor,colonia)
		VALUES ('Pedro','M','Avanzado',NULL,2,1);
	COMMIT TRANSACTION T2
	PRINT 'Operación realizada con éxito'
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION T2
	PRINT 'HA OCURRIDO UN ERROR. MIRA vErroresHOY PARA VER MÁS DETALLES'
	EXECUTE almacenar_error
END CATCH;
--3era transaccion
BEGIN TRY
	BEGIN TRANSACTION T3
		UPDATE
			Pinguino
		SET
			nombre='Antonio'
		WHERE 
			cod_Pinguino='hola que tal';
	COMMIT TRANSACTION T3
	PRINT 'Operación realizada con éxito'
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION T3
	PRINT 'HA OCURRIDO UN ERROR. MIRA vErroresHOY PARA VER MÁS DETALLES'
	EXECUTE almacenar_error
END CATCH;
--4ta transaccion
BEGIN TRY
	BEGIN TRANSACTION T4
		UPDATE 
			Colonia
		SET 
			descripcion='Nueva descripción'
		where cod_Colonia=1;
	COMMIT TRANSACTION T4
	PRINT 'Operación realizada con éxito'
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION T4
	PRINT 'HA OCURRIDO UN ERROR. MIRA vErroresHOY PARA VER MÁS DETALLES'
	EXECUTE almacenar_error
END CATCH;
--5ta transaccion
BEGIN TRY
	BEGIN TRANSACTION T5
		DELETE FROM Cientifico_Pinguino where pinguino in (select cod_Pinguino from Pinguino where estado_Muda='Infantil');
		DELETE FROM Pinguino WHERE estado_Muda='Infantil';
	COMMIT TRANSACTION T5
	PRINT 'Operación realizada con éxito'
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION T5
	PRINT 'HA OCURRIDO UN ERROR. MIRA vErroresHOY PARA VER MÁS DETALLES'
	EXECUTE almacenar_error
END CATCH;
--6ta transaccion
BEGIN TRY
	BEGIN TRANSACTION T6
		DELETE FROM Equipo where cod_Equipo=2;
	COMMIT TRANSACTION T6
	PRINT 'Operación realizada con éxito'
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION T6
	PRINT 'HA OCURRIDO UN ERROR. MIRA vErroresHOY PARA VER MÁS DETALLES'
	EXECUTE almacenar_error
END CATCH;
--1era busqueda
DECLARE @cod_equipo INT;
BEGIN TRY
	IF @cod_equipo IS NULL
		RAISERROR('El valor de cod_equipo no es correcto', 16, 1);
	ELSE
		select *
		from Equipo as E
		inner join
		Cientifico as C
		ON
		C.equipo = E.cod_Equipo
		INNER JOIN
		Investigador AS I
		ON
		I.cod_Investigador = C.cod_Investigador
		INNER JOIN
		Cientifico_Pinguino AS CP
		ON
		CP.cientifico = C.cod_Investigador
		INNER JOIN
		Pinguino AS P
		ON
		CP.pinguino = P.cod_Pinguino
		WHERE E.cod_Equipo = @cod_equipo;
END TRY
BEGIN CATCH
	PRINT 'HA OCURRIDO UN ERROR. MIRA vErroresHOY PARA VER MÁS DETALLES'
	EXECUTE almacenar_error
END CATCH;
--2da busqueda
DECLARE @nombre_equipo nvarchar(8) = 'tNova';
BEGIN TRY
	IF @nombre_equipo IS NULL
		RAISERROR('El valor de nombre_equipo no es correcto', 16, 1);
	ELSE
		SELECT COUNT(I.COD_INVESTIGADOR) AS [Número de investigadores]
		FROM Investigador AS I
		inner join
		Monitor AS M
		ON
		M.cod_Investigador = I.cod_Investigador
		INNER JOIN
		Equipo AS E
		ON 
		M.equipo = E.cod_Equipo
		WHERE E.nombre=@nombre_equipo;
END TRY
BEGIN CATCH
	PRINT 'HA OCURRIDO UN ERROR. MIRA vErroresHOY PARA VER MÁS DETALLES'
	EXECUTE almacenar_error
END CATCH;
--3era busqueda
DECLARE @nombre_pinguino nvarchar(10) = 'Willy';
BEGIN TRY
	IF @nombre_pinguino IS NULL
		RAISERROR('El valor de nombre_pinguino no es correcto', 16, 1);
	ELSE
		SELECT C.nombre
		FROM Colonia AS C
		INNER JOIN
		Pinguino AS P
		ON
		P.colonia = C.cod_Colonia
		WHERE
		P.nombre=@nombre_pinguino
END TRY
BEGIN CATCH
	PRINT 'HA OCURRIDO UN ERROR. MIRA vErroresHOY PARA VER MÁS DETALLES'
	EXECUTE almacenar_error
END CATCH;
--4ta busqueda
DECLARE @coords int = 115956832;
BEGIN TRY
	IF @coords IS NULL
		RAISERROR('El valor de nombre_pinguino no es correcto', 16, 1);
	ELSE
		select *
		from Localizacion
		where coordenadas=@coords
END TRY
BEGIN CATCH
	PRINT 'HA OCURRIDO UN ERROR. MIRA vErroresHOY PARA VER MÁS DETALLES'
	EXECUTE almacenar_error
END CATCH;