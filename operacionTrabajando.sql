SET NOCOUNT ON


DECLARE @xmlData XML---------------XML
 SET @xmlData = (
		SELECT *
		FROM OPENROWSET(BULK 'C:\Users\david\Desktop\ProyectoBD\Datos_Tarea3.xml', SINGLE_BLOB) 
		AS xmlData
		);



-----------------------------------Variables para trabajar mejor
DECLARE @Fechas TABLE (
					   sec INT IDENTITY (1, 1),
					   FechaOperacion DATE
					   )

DECLARE @EmpleadosInsertar TABLE (
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

DECLARE @EmpleadosBorrar TABLE (
								Sec INT IDENTITY(1,1),
								ValorDocumento INT
								)

DECLARE @InsertarDeduccionesEmpleado TABLE (
									Sec INT IDENTITY(1,1),
									monto MONEY,
									ValorDocumento INT,
									IdDeduccion INT
									)

DECLARE @EliminarDeduccionesEmpleado TABLE (
									Sec INT IDENTITY(1,1),
									ValorDocumento INT,
									IdDeduccion INT
									)

DECLARE @Asistencias TABLE (
							Sec INT IDENTITY(1,1),
							ValorDocumento INT,
							Entrada smalldatetime,
							Salida smalldatetime
							)

DECLARE @NuevosHorarios TABLE (
								Sec INT IDENTITY(1,1),
								IdJornada INT,
								ValorDocumentoIdentidad INT
								)

-------------------------------------------------------





INSERT INTO @Fechas
SELECT T.Item.value('@Fecha', 'DATE') AS FechaOperacion
FROM @xmlData.nodes('Datos/Operacion') AS T(Item)




DECLARE @FechaItera DATE, @FechaFin DATE-----------------------------------------DELCARA LOS VALORES DE FECHAS NECESARIOS @FechaItera, @FechaFin, @FechaFinSemana
SET @FechaItera = (SELECT MIN(f.FechaOperacion)
					FROM @Fechas f)
SET @FechaFin  = (SELECT MAX(f.FechaOperacion)
					FROM @Fechas f)

DECLARE @diaFlag INT, @FechaFinSemana DATE
SET @diaFlag = 1
SET @FechaFinSemana = DATEADD(DAY,6,@FechaItera)

	INSERT INTO dbo.SemanaPlanilla ([FechaInicio],
									[FechaFin]
									)
	SELECT  @FechaItera AS [FechaInicio],
			@FechaFinSemana AS [FechaFin]

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WHILE (@FechaItera <= @FechaFin)
BEGIN

	IF (@diaFlag = 8)
	BEGIN
	SET @FechaFinSemana = DATEADD(DAY,6,@FechaItera)
	INSERT INTO dbo.SemanaPlanilla ([FechaInicio],
									[FechaFin]
									)
	SELECT  @FechaItera AS [FechaInicio],
			@FechaFinSemana AS [FechaFin]
	SET @diaFlag = 1
	END;

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
	--<AsociaEmpleadoConDeduccion IdDeduccion="2" Monto="0.05" ValorDocumentoIdentidad="64818448" />
	-- Insertar deduccion no obligatorias
	IF (NOT EXISTS (SELECT * 
				FROM dbo.FijaNoObligatoria f 
				INNER JOIN @InsertarDeduccionesEmpleado E
				ON E.monto = F.Monto
				WHERE F.Monto = E.monto))
		BEGIN
			INSERT INTO dbo.FijaNoObligatoria
			Select  E.monto AS [Monto]
			FROM @InsertarDeduccionesEmpleado E


		END;




    INSERT dbo.DeduccionXEmpleado
	Select  E.Id as [IdEmpleado],
			I.IdDeduccion AS [IdTipoDeduccion],
			f.Id AS [IdFijaNoObligatoria],
			1
	FROM @InsertarDeduccionesEmpleado I
	INNER JOIN dbo.Empleado E 
	ON I.ValorDocumento = E.ValorDocumentoIdentificacion
	INNER JOIN dbo.FijaNoObligatoria f
	ON f.Monto = i.monto

	--select * from @InsertarDeduccionesEmpleado

	--select * from dbo.DeduccionXEmpleado


	 --desasociar (eliminar deducciones) ...
	declare @empleadoEliminar int
	declare @tipoEliminar int
	SELECT @empleadoEliminar= E.Id, @tipoEliminar = T.Id
	FROM @EliminarDeduccionesEmpleado D
	INNER JOIN dbo.Empleado E
	ON e.ValorDocumentoIdentificacion = D.ValorDocumento
	INNER JOIN DBO.TipoDeduccion T
	ON T.Id =D.IdDeduccion 



	UPDATE dbo.DeduccionXEmpleado
	set Activo=0
	where @empleadoEliminar = [IdEmpleado]  AND  @tipoEliminar = [IdTipoDeduccion]


	-----------------------------------------------------------------------------------------------------------------------------------------------------

	-- Procesar asistencias

	DECLARE @lo INT, @hi INT, @Entrada SMALLDATETIME, @Salida SMALLDATETIME, 
	@ValorDocIdentidad INT, @IdEmpleado INT,  @HoraInicioJornada TIME(0), @HoraFinJornada TIME(0),
	@horasOrdinarias INT, @SalarioXHora MONEY, @MontoGanadoHO MONEY, @EsJueves BIT, @EsFinMes BIT,
	@ultimaFecha INT, @HorasLaborales INT, @HorasExtra INT, @MontoGanadoHExtra MONEY, @IdJornadaAs INT




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

		DECLARE @HoraInicio date, @HoraFin date



		Select @HoraInicioJornada=TJ.HoraInicio, @HoraFinJornada=TJ.HoraFin, @IdJornadaAs = J.Id
		FROM dbo.SemanaPlanilla PS
		INNER JOIN dbo.Jornada J 
		ON PS.Id=J.IdSemanaPlanilla 
		INNER JOIN dbo.TipoJornada TJ 
		ON J.IdTipoJornada=TJ.Id
		WHERE (J.IdEmpleado=@IdEmpleado) and (@FechaItera between PS.FechaInicio and PS.FechaFin)


		
	
	----	--determinar horas ordinarias y horas laborales----------------------------------------------------------------------------------------------------------------

		set @horasOrdinarias =( DATEDIFF (hh, @Entrada, @Salida ))
		set @HorasLaborales = ( DATEDIFF (hh, @HoraInicioJornada, @HoraFinJornada ))

		


	--	--determinar monto ganado por horas ordinarias y horas Extra----------------------------------------------------------------------------------------------
		SELECT @SalarioXHora = P.SalarioXHora
		FROM dbo.Puesto P
		Inner join dbo.empleado E 
		ON E.IdPuesto = P.Id
		WHERE E.Id = @IdEmpleado

		
		SET @MontoGanadoHO = @horasOrdinarias*@SalarioXHora-----------@Monto Ganado Horas Ordinarias





		SET @HorasExtra = 0
		IF @horasOrdinarias - @HorasLaborales > 0
		BEGIN
			SET @HorasExtra =  @horasOrdinarias - @HorasLaborales 
			SET @MontoGanadoHExtra = (@HorasExtra*@SalarioXHora)*1.5-----------@Monto Ganado Horas EXTRA
		END;

		 
		

	----	--------------------------------------------------------------------------------------------------------------------------------------------------Determina si las extras son por 2

		Declare @dialibre DATE

		IF (EXISTS (SELECT * FROM dbo.Feriado f WHERE @FechaItera = f.Fecha) OR  DATENAME(DW, @FechaItera) = 'Sunday') AND (@horasOrdinarias - @HorasLaborales > 0)
		BEGIN
		
			SET @HorasExtra =  @horasOrdinarias - @HorasLaborales 
			SET @MontoGanadoHExtra = (@HorasExtra*@SalarioXHora)*2-----------@Monto Ganado Horas EXTRA FERIADO o Domingo
	
		END;
		
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
		--BEGIN TRANSACTION
		--	insertar asistencias ----------------------------------------------------------------------no lo he probado
		--	INSERT INTO dbo.MarcarAsistencia
		--	SELECT @IdJornadaAs AS [IdJornada],
		--			@Entrada AS [MarcarInicio],
		--			@Salida AS [MarcarFin]
						
			--insertar movimientoplanilla ()
			--select .... @montoGanadoHO ...
			--where  @horasOrdinarias>0
				
			--insertar movimientoplanilla ()
			--select .... @montoGanadoHExtrasNormal ...
			--where  @horasExtraOrdinariasNOrmales>0
				
			--insertar movimientoplanilla ()
			--select .... @montoGanadoHExtrasDobles ...
			--where  @horasExtraOrdinariasDobles>0
				
		--	IF @esJueves = 1
		--	Begin
		--			insertar movimientos de deduccion
		--			Cear instancia en semanaplanilla
		--			actualizar planillaxmesxemp
		--	end
				
		--	If #esfin de mes
		--	begin
		--		    crear instancia de PlanillaxMesxEmp
		--	end
				
		--	Update dbo.PlanillaSemanalXEmp
		----	set SalarioBruto=@montoGanadoHO+@montoGanadoHExtrasNormal+@horasExtraOrdinariasDobles
		----	where EdEmpleado=@idEmpleado and IdSemama=@IdSemana	
			
		--commit transaction
			
			
			
		
		set @lo = @lo+1
	
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

