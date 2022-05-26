DECLARE @xmlData XML

  SET @xmlData = (
		SELECT *
		FROM OPENROWSET(BULK 'C:\Users\david\Desktop\ProyectoBD\Datos_Tarea3.xml', SINGLE_BLOB) 
		AS xmlData
		);



--TipoDocuIdentidad
INSERT INTO dbo.TipoDocuIdentidad(Id, Nombre)
SELECT  
	T.Item.value('@Id', 'INT'),
	T.Item.value('@Nombre', 'VARCHAR(64)')
FROM @xmlData.nodes('Datos/Catalogos/Tipos_de_Documento_de_Identificacion/TipoIdDoc') as T(Item)



--Puestos
INSERT INTO dbo.Puesto(Id,Nombre,SalarioXHora)
SELECT  
	T.Item.value('@Id', 'INT'),
	T.Item.value('@Nombre', 'VARCHAR(64)'),
	T.Item.value('@SalarioXHora', 'MONEY')
FROM @xmlData.nodes('Datos/Catalogos/Puestos/Puesto') AS T(Item)

--Departamentos
INSERT INTO dbo.Departamento(Id,Nombre)
SELECT  
	T.Item.value('@Id', 'INT'),
	T.Item.value('@Nombre', 'VARCHAR(64)')
FROM @xmlData.nodes('Datos/Catalogos/Departamentos/Departamento') AS T(Item)


--Usuarios
INSERT INTO dbo.Usuario(Password,
						EsAdministrador,
						Nombre)
SELECT  
	T.Item.value('@pwd', 'VARCHAR(64)'),
	T.Item.value('@tipo', 'BIT'),
	T.Item.value('@username', 'VARCHAR(64)')
	
FROM @xmlData.nodes('Datos/Usuarios/Usuario') AS T(Item)



----TipoJornada
INSERT INTO dbo.TipoJornada
SELECT  
	T.Item.value('@Id', 'INT') AS Id,
	T.Item.value('@Nombre', 'VARCHAR(64)') AS Nombre,
	T.Item.value('@HoraEntrada', 'time(0)') AS HoraInicio,
	T.Item.value('@HoraSalida', 'time(0)') AS HoraFin
FROM @xmlData.nodes('Datos/Catalogos/TiposDeJornada/TipoDeJornada') AS T(Item)





INSERT INTO dbo.Feriado
SELECT  T.Item.value('@Fecha','Date') as Fecha,
		T.Item.value('@Nombre', 'VARCHAR(64)') AS Nombre
FROM @xmlData.nodes('Datos/Catalogos/Feriados/Feriado') AS T(Item) 


--movimientos


INSERT INTO dbo.DeduccionPorcentualObligatoria
SELECT T.Item.value('@Valor', 'FLOAT') AS [Porcentaje]
FROM @xmlData.nodes('Datos/Catalogos/Deducciones/TipoDeDeduccion') AS T(Item)






INSERT INTO dbo.TipoDeduccion
SELECT  T.Item.value('@Id', 'INT') AS Id,
		T.Item.value('@Nombre', 'VARCHAR(64)') AS Nombre,
		T.Item.value('@Obligatorio', 'varchar(64)') AS [EsObligatorio],
		T.Item.value('@Porcentual', 'varchar(64)') AS [EsPorcentual],
		e.ID AS [IdDeduccionObligatoria]
FROM @xmlData.nodes('Datos/Catalogos/Deducciones/TipoDeDeduccion') AS T(Item)
Inner join dbo.DeduccionPorcentualObligatoria E 
ON e.Id= T.Item.value('@Id', 'INT')
WHERE E.Porcentaje = T.Item.value('@Valor', 'FLOAT')


INSERT INTO [dbo].[TipoMovPlantilla](Id,Nombre)
SELECT  T.Item.value('@Id', 'INT') AS Id,
		T.Item.value('@Nombre', 'VARCHAR(64)') AS Nombre
FROM @xmlData.nodes('Datos/Catalogos/TiposDeMovimiento/TipoDeMovimiento') AS T(Item)

