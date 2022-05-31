SET NOCOUNT ON


DECLARE @xmlData XML---------------XML
 SET @xmlData = (
		SELECT *
		FROM OPENROWSET(BULK 'C:\Users\david\Desktop\ProyectoBD\Datos_Tarea3.xml', SINGLE_BLOB) 
		AS xmlData
		);



-----------------------------------Variables para trabajar mejor
DECLARE @Fechas TABLE ( --tabla para manejar las fechas
	sec INT IDENTITY (1, 1),
	FechaOperacion DATE
)

DECLARE @EmpleadosInsertar TABLE (    --tabala para los empleados a insertar
	Sec INT IDENTITY(1,1),
	FechaNacimiento DATE,
	Nombre VARCHAR(64),
	IdTipoDocumento INT,
	ValorDocumento INT,
	IdDepartamento INT,
	IdPuesto INT,
	Usuario VARCHAR(64),
	Password VARCHAR(64)
)

DECLARE @EmpleadosBorrar TABLE ( -- tabla para los empleados a borrar
	Sec INT IDENTITY(1,1),
	ValorDocumento INT
)

DECLARE @InsertarDeduccionesEmpleado TABLE ( -- tabla para las deducciones  a insertar
	Sec INT IDENTITY(1,1),
	monto MONEY,
	ValorDocumento INT,
	IdDeduccion INT
)

DECLARE @EliminarDeduccionesEmpleado TABLE ( -- tabla para eliminar deducciones
	Sec INT IDENTITY(1,1),
	ValorDocumento INT,
	IdDeduccion INT
)

DECLARE @Asistencias TABLE (--tabla para las asistencias
	Sec INT IDENTITY(1,1),
	ValorDocumento INT,
	Entrada smalldatetime,
	Salida smalldatetime
)

DECLARE @NuevosHorarios TABLE (--tablas para las jornadas
	Sec INT IDENTITY(1,1),
	IdJornada INT,
	ValorDocumentoIdentidad INT
)

-------------------------------------------------------
--Declarar variables

DECLARE @FechaItera DATE
DECLARE @FechaFin DATE
DECLARE @diaFlag INT
DECLARE @FechaFinSemana DATE
DECLARE @RecorrerSemanas DATE
DECLARE @Semanas INT
DECLARE @Primera INT = 1
DECLARE @SecInicio INT
DECLARE @SecFinal INT
DECLARE @SecItera INT
DECLARE @FechaEntrada DATETIME
DECLARE @FechaSalida DATETIME
DECLARE @ValorDocumentoIdentidad INT
DECLARE @Secuencia INT

--Ejecutar script cargar catalogo

EXEC BorrarDatos-- SCRIPT PARA BORRAR DATOS
EXEC cargarDatosCatalogo



INSERT INTO @Fechas
SELECT T.Item.value('@Fecha', 'DATE') AS FechaOperacion
FROM @xmlData.nodes('Datos/Operacion') AS T(Item)


SET @FechaItera = (SELECT MIN(f.FechaOperacion)
					FROM @Fechas f)
SET @FechaFin  = (SELECT MAX(f.FechaOperacion)
					FROM @Fechas f)


SET @diaFlag = 1


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WHILE (@FechaItera <= @FechaFin)
BEGIN
  
	IF DATEPART(WEEKDAY, @FechaItera) = 6--CALCULO DE LA SEMANA Y EL MES
	BEGIN
		IF(DATENAME(MONTH,DATEADD(DAY,1,@FechaItera)) <> DATENAME(MONTH,DATEADD(DAY,-6,@FechaItera)))
		BEGIN
			SELECT @Semanas = 0
			SELECT @RecorrerSemanas = @FechaItera
			WHILE (DATENAME(MONTH,DATEADD(DAY,1,@FechaItera)) = (DATENAME(MONTH,@RecorrerSemanas)))
			BEGIN
				SET @RecorrerSemanas = (SELECT DATEADD(WEEK,1,@RecorrerSemanas))
				SET @Semanas = @Semanas+1
			END
				INSERT INTO dbo.MesPlanilla
				VALUES(@FechaItera, (SELECT DATEADD(DAY,7*@Semanas-1,@FechaItera)))
		END
		
		INSERT INTO dbo.SemanaPlanilla
		VALUES( (SELECT MAX(Id) AS Id FROM dbo.MesPlanilla),@FechaItera, (SELECT DATEADD(DAY,6,@FechaItera)))
	END

	----------------------------------------------------EmpleadosInsertar                                                                Insertar en orden o da error
	INSERT INTO @EmpleadosInsertar
	SELECT  T.Item.value('@FechaNacimiento', 'DATE') AS FechaNacimiento,
			T.Item.value('@Nombre', 'VARCHAR(64)') AS Nombre,
			T.Item.value('@idTipoDocumentacionIdentidad', 'INT') AS IdTipoDocumento,
			T.Item.value('@ValorDocumentoIdentidad', 'INT') AS ValorDocumento,
			T.Item.value('@idDepartamento', 'INT') AS IdDepartamento,
			T.Item.value('@idPuesto', 'INT') AS IdPuesto,
			T.Item.value('@Username', 'VARCHAR(64)') AS Usuario,
			T.Item.value('@Password', 'VARCHAR(64)') AS Password
	FROM @xmlData.nodes('Datos/Operacion[@Fecha = sql:variable("@FechaItera")]/NuevoEmpleado') AS T(Item) 



	------------------------------------------------EmpleadosBorrar
	INSERT INTO @EmpleadosBorrar
	SELECT T.Item.value('@ValorDocumentoIdentidad', 'INT') AS ValorDocumento
	FROM @xmlData.nodes('Datos/Operacion[@Fecha = sql:variable("@FechaItera")]/EliminarEmpleado') AS T(Item)

	----------------------------------------------------InsertarDeducciones

	INSERT INTO @InsertarDeduccionesEmpleado
	SELECT  T.Item.value('@Monto', 'MONEY') AS monto,  
			T.Item.value('@ValorDocumentoIdentidad', 'INT') AS ValorDocumento,
			T.Item.value('@IdDeduccion', 'INT') AS IdDeduccion	
	FROM @xmlData.nodes('Datos/Operacion[@Fecha = sql:variable("@FechaItera")]/AsociaEmpleadoConDeduccion')  AS T(Item)



	-----------------------------------------------EliminarDeducciones
	INSERT INTO @EliminarDeduccionesEmpleado
	SELECT  T.Item.value('@ValorDocumentoIdentidad', 'INT') AS ValorDocumento,
			T.Item.value('@IdDeduccion', 'INT') AS IdDeduccion
			
	FROM @xmlData.nodes('Datos/Operacion[@Fecha = sql:variable("@FechaItera")]/DesasociaEmpleadoConDeduccion') AS T(Item)

	--------------------------------------------insert @asistencias

	INSERT INTO @Asistencias 
	SELECT  T.Item.value('@ValorDocumentoIdentidad', 'INT') AS ValorDocumentoIdentidad,
			T.Item.value('@FechaEntrada', 'smalldatetime') AS Entrada,
			T.Item.value('@FechaSalida', 'smalldatetime') AS Salida
	FROM @xmlData.nodes('Datos/Operacion[@Fecha = sql:variable("@FechaItera")]/MarcaDeAsistencia') AS T(Item)

	--------------------------------------------insert @NuevosHorarios

	INSERT INTO @NuevosHorarios 
	SELECT  T.Item.value('@IdJornada', 'INT') AS IdJornada,
			T.Item.value('@ValorDocumentoIdentidad', 'INT') AS ValorDocumentoIdentidad
	FROM @xmlData.nodes('Datos/Operacion[@Fecha = sql:variable("@FechaItera")]/TipoDeJornadaProximaSemana') AS T(Item)

	-------------------------------------------------------------------------------------------------------------------------------- Insertar empleados


	INSERT dbo.Empleado([Nombre],
						[IdTipoIdentificacion],
						[ValorDocumentoIdentificacion],
						[IdDepartamento],
						[IdPuesto],
						[FechaNacimiento]
						)
	SELECT  E.Nombre,
			E.IdTipoDocumento,
			E.ValorDocumento,
			E.IdDepartamento,
			E.IdPuesto,
			E.FechaNacimiento
	FROM @EmpleadosInsertar E

	INSERT  dbo.Usuario([IdEmpleado],
						[Nombre],
						[Password],
						[EsAdministrador]
						)
	SELECT  E.Id,
			EXML.Nombre,
			EXML.Password,
			0
	FROM @EmpleadosInsertar EXML
	INNER JOIN dbo.Empleado E 
	ON EXML.ValorDocumento = E.ValorDocumentoIdentificacion


---------------------------------------------------------------------------------------------------------------------EmpleadosBorrar


	UPDATE Empleado 
	SET Activo=0 
	FROM DBO.Empleado E
	INNER JOIN @EmpleadosBorrar B 
	ON B.ValorDocumento = E.ValorDocumentoIdentificacion
	WHERE E.ValorDocumentoIdentificacion = b.ValorDocumento
	


-------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------NuevosHorarios


	INSERT INTO dbo.Jornada([IdEmpleado],
							[IdSemanaPlanilla],
							[IdTipoJornada]
							)
	SELECT  E.Id AS [IdEmpleado],
			s.Id AS [IdSemanaPlanilla],
			N.IdJornada
	FROM @NuevosHorarios N
	INNER JOIN Dbo.Empleado E
	ON N.ValorDocumentoIdentidad = E.ValorDocumentoIdentificacion
	INNER JOIN DBO.SemanaPlanilla S
	ON @FechaItera between S.FechaInicio and S.FechaFin









	-------------------------------------------------------------------------------------------------------------------------------------

	-- Insertar deduccion no obligatorias                                No funciona porque el profe explico hoy que se hace mediante fechas
	--IF (NOT EXISTS (SELECT * 
	--				FROM dbo.FijaNoObligatoria f 
	--				INNER JOIN @InsertarDeduccionesEmpleado E
	--				ON E.monto = F.Monto
	--				WHERE F.Monto = E.monto)
	--				)
	--	BEGIN
	--		INSERT INTO dbo.FijaNoObligatoria
	--		SELECT  E.monto AS [Monto]
	--		FROM @InsertarDeduccionesEmpleado E


	--	END;




 --   INSERT dbo.DeduccionXEmpleado
	--SELECT  E.Id AS [IdEmpleado],
	--		I.IdDeduccion AS [IdTipoDeduccion],
	--		f.Id AS [IdFijaNoObligatoria],
	--		1
	--FROM @InsertarDeduccionesEmpleado I
	--INNER JOIN dbo.Empleado E 
	--ON I.ValorDocumento = E.ValorDocumentoIdentificacion
	--INNER JOIN dbo.FijaNoObligatoria f
	--ON f.Monto = i.monto


	-- --desasociar (eliminar deducciones) ...
	--DECLARE @empleadoEliminar INT
	--DECLARE @tipoEliminar INT
	--SELECT @empleadoEliminar= E.Id, @tipoEliminar = T.Id
	--FROM @EliminarDeduccionesEmpleado D
	--INNER JOIN dbo.Empleado E
	--ON e.ValorDocumentoIdentificacion = D.ValorDocumento
	--INNER JOIN DBO.TipoDeduccion T
	--ON T.Id =D.IdDeduccion 



	--UPDATE dbo.DeduccionXEmpleado
	--set Activo=0
	--where @empleadoEliminar = [IdEmpleado]  AND  @tipoEliminar = [IdTipoDeduccion]


	-----------------------------------------------------------------------------------------------------------------------------------------------------



	DECLARE @lo INT
	DECLARE @hi INT
	DECLARE @Entrada SMALLDATETIME
	DECLARE @Salida SMALLDATETIME
	DECLARE @ValorDocIdentidad INT
	DECLARE @IdEmpleado INT
	DECLARE @HoraInicioJornada TIME(0)
	DECLARE @HoraFinJornada TIME(0)
	DECLARE @horasOrdinarias INT
	DECLARE @SalarioXHora MONEY
	DECLARE @MontoGanadoHO MONEY
	DECLARE @EsJueves BIT
	DECLARE @EsFinMes BIT
	DECLARE @ultimaFecha INT
	DECLARE @HorasLaborales INT
	DECLARE @HorasExtra INT
	DECLARE @HorasExtraDoble INT
	DECLARE @MontoGanadoHExtra MONEY
	DECLARE @MontoGanadoHExtraDoble MONEY
	DECLARE @IdJornadaAs INT
	DECLARE @HorasLaboralesTrabajadas INT



	SELECT @lo=Min(A.Sec), @hi=Max(A.Sec)
	FROM @Asistencias A
	 

	WHILE (@lo<=@hi)
	BEGIN

		SELECT @Entrada=A.Entrada, @Salida=A.Salida, @ValorDocIdentidad= A.ValorDocumento
		FROM @Asistencias A
		WHERE A.Sec=@lo
		
		SELECT @IdEmpleado = E.Id
		FROM dbo.Empleado E
		WHERE E.ValorDocumentoIdentificacion = @ValorDocIdentidad


	----	--Determinar horas ordinarias-------------------------------------------------------------------------------------------------------------


	--	--determinar la jornada de esta semana de ese empleado

		DECLARE @HoraInicio DATE, @HoraFin DATE



		SELECT @HoraInicioJornada=TJ.HoraInicio, @HoraFinJornada=TJ.HoraFin, @IdJornadaAs = J.Id
		FROM dbo.SemanaPlanilla PS
		INNER JOIN dbo.Jornada J 
		ON PS.Id=J.IdSemanaPlanilla 
		INNER JOIN dbo.TipoJornada TJ 
		ON J.IdTipoJornada=TJ.Id
		WHERE (J.IdEmpleado=@IdEmpleado) AND (@FechaItera BETWEEN PS.FechaInicio AND PS.FechaFin)


		
	
	----	--determinar horas ordinarias y horas laborales----------------------------------------------------------------------------------------------------------------

		SET @horasOrdinarias =( DATEDIFF (hh, @Entrada, @Salida ))
		SET @HorasLaborales = ( DATEDIFF (hh, @HoraInicioJornada, @HoraFinJornada ))


	--	--determinar monto ganado por horas ordinarias y horas Extra----------------------------------------------------------------------------------------------
		SELECT @SalarioXHora = P.SalarioXHora
		FROM dbo.Puesto P
		INNER JOIN dbo.empleado E 
		ON E.IdPuesto = P.Id
		WHERE E.Id = @IdEmpleado

		SET @MontoGanadoHExtraDoble = 0
		SET @MontoGanadoHO = 0
		SET @MontoGanadoHExtra = 0
		SET @HorasExtraDoble = 0

		SET @MontoGanadoHO = @horasOrdinarias*@SalarioXHora-----------@Monto Ganado Horas Ordinarias
		SET @HorasLaboralesTrabajadas = @horasOrdinarias
		SET @HorasExtra = 0


		 
		

	----	--------------------------------------------------------------------------------------------------------------------------------------------------Determina si las extras son por 2

		DECLARE @dialibre DATE

		IF (EXISTS (SELECT Fecha 
					FROM dbo.Feriado f 
					WHERE @FechaItera = f.Fecha) 
					OR  DATENAME(DW, @FechaItera) = 'Sunday') 
					AND (@horasOrdinarias - @HorasLaborales > 0)
		BEGIN
			IF @horasOrdinarias - @HorasLaborales > 0
			BEGIN
				SET @HorasExtraDoble =  @horasOrdinarias - @HorasLaborales 
				SET @MontoGanadoHExtraDoble = (@HorasExtraDoble*@SalarioXHora)*2-----------@Monto Ganado Horas EXTRA FERIADO o Domingo
				SET @HorasLaboralesTrabajadas = @HorasLaboralesTrabajadas - @HorasExtraDoble
			END
		END
		ELSE
		BEGIN

			IF @horasOrdinarias - @HorasLaborales > 0
			BEGIN
				SET @HorasExtra =  @horasOrdinarias - @HorasLaborales 
				SET @MontoGanadoHExtra = (@HorasExtra*@SalarioXHora)*1.5-----------@Monto Ganado Horas EXTRA
				SET @HorasLaboralesTrabajadas = @HorasLaboralesTrabajadas - @HorasExtra
				
			END
		END
		
		Set @EsJueves = 0
		If  DATENAME(DW, @FechaItera) = 'Thursday'
		BEGIN
			SET @EsJueves = 1

			  
			   --calcular deduccionesObligatorias
			  
			   --calcular deducciones no obligatorias
		END;



		SET @ultimaFecha = DAY(DATEADD(d,1,@FechaItera))

		SET @EsFinMes = 0

		If @ultimaFecha = 1
		BEGIN
			SET @EsFinMes = 1
		END;
			
			
		--------------------------------------------------------Se empieza la transaction  
		BEGIN TRANSACTION
		----	insertar asistencias ----------------------------------------------------------------------no lo he probado
			INSERT INTO dbo.MarcarAsistencia
			SELECT @IdJornadaAs AS [IdJornada],
					@Entrada AS [MarcarInicio],
					@Salida AS [MarcarFin],
					@horasOrdinarias,
					@HorasExtra,
					@HorasExtraDoble

						
			--insertar movimientoplanilla ()-------------------------------------------------------------Nos faltan tablas por cargar para poder insertar un movimiento
			INSERT INTO [dbo].[MovPlanilla]
			select 
					1,
					@FechaItera,
					@MontoGanadoHO,
					@HorasLaboralesTrabajadas
					
			INSERT INTO [dbo].[MovPlanilla]
			SELECT 
					2,
					@FechaItera,
					@MontoGanadoHExtra,
					@HorasExtra
					
			WHERE  @HorasExtra>0

			INSERT INTO [dbo].[MovPlanilla]
			SELECT 
					3,
					@FechaItera,
					@MontoGanadoHExtraDoble,
					@HorasExtraDoble
					
			WHERE  @HorasExtraDoble>0
				

			IF @esJueves = 1
			BEGIN
				INSERT INTO[dbo].[PlanillaSemXEmpleado]
				SELECT 0,  
					(SELECT MAX(Id) FROM [dbo].[SemanaPlanilla]),
					@IdEmpleado,
					0

				--	actualizar planillaxmesxemp,
			END
				
			If @EsFinMes  = 1
			BEGIN
				   INSERT INTO [dbo].[PlanillaMesXEmpleado]
				   SELECT  (SELECT MAX(Id) FROM [dbo].MesPlanilla),
				   0,
				   0,
				   @IdEmpleado
			END
				
			Update [dbo].[PlanillaSemXEmpleado]
			SET [TotalSalarioBruto] = @MontoGanadoHExtra + @MontoGanadoHExtraDoble + @MontoGanadoHO
			WHERE IdEmpleado = @IdEmpleado AND [IdPlanillaSem] = (SELECT MAX(Id) FROM [dbo].MesPlanilla)
		COMMIT TRANSACTION 
			
			
			
		
		SET @lo = @lo+1
	
	END;











	DELETE FROM @EmpleadosInsertar/*Limpia la tabla empelados*/
	DELETE FROM @Asistencias
	DELETE FROM @EmpleadosBorrar
	DELETE FROM @EliminarDeduccionesEmpleado
	DELETE FROM @NuevosHorarios
	DELETE FROM @InsertarDeduccionesEmpleado


	SET @diaFlag = @diaFlag+1
	SET @FechaItera = DATEADD(DAY,1,@FechaItera)

END;









--INSERT INTO @TipoDeJornadaProximaSemana
--SELECT  T.Item.value('@IdJornada', 'INT') AS IdJornada,
--		T.Item.value('@ValorDocumentoIdentidad', 'INT') AS ValorDocumento
--FROM @xmlData.nodes('Datos/Operacion/TipoDeJornadaProximaSemana') AS T(Item)


	
--INSERT INTO @TipoJornada 
--SELECT  T.Item.value('@HoraEntrada', 'time') AS Entrada,
--		T.Item.value('@HoraSalida', 'time') AS Salida,
--		T.Item.value('@Id', 'int') AS idJornada,
--		T.Item.value('@Nombre', 'VARCHAR(64)') AS Nombre
--FROM @xmlData.nodes('Datos/Catalogos/TiposDeJornada/TipoDeJornada') AS T(Item)
SET NOCOUNT OFF;

