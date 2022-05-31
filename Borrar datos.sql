DELETE FROM dbo.Usuario/*Limpia la tabla empelados*/
DBCC CHECKIDENT ('Usuario', RESEED, 0)/*Reinicia el identify*/

DELETE FROM dbo.DeduccionXEmpleado/*Limpia la tabla empelados*/
DBCC CHECKIDENT ('DeduccionXEmpleado', RESEED, 0)/*Reinicia el identify*/

DELETE FROM dbo.Jornada
DBCC CHECKIDENT ('Jornada', RESEED, 0)


DELETE FROM dbo.SemanaPlanilla
DBCC CHECKIDENT ('SemanaPlanilla', RESEED, 0)


DELETE FROM dbo.MesPlanilla
DBCC CHECKIDENT ('MesPlanilla', RESEED, 0)

DELETE FROM FijaNoObligatoria
DBCC CHECKIDENT ('FijaNoObligatoria', RESEED, 0)

DELETE FROM dbo.Empleado/*Limpia la tabla empelados*/
DBCC CHECKIDENT ('Empleado', RESEED, 0)/*Reinicia el identify*/

DELETE FROM dbo.DeduccionXEmpleado/*Limpia la tabla empelados*/
DBCC CHECKIDENT ('DeduccionXEmpleado', RESEED, 0)/*Reinicia el identify*/

DELETE FROM dbo.Jornada
DBCC CHECKIDENT ('Jornada', RESEED, 0)

DELETE FROM dbo.SemanaPlanilla
DBCC CHECKIDENT ('SemanaPlanilla', RESEED, 0)


DELETE FROM	[dbo].[FijaNoObligatoria]
DBCC CHECKIDENT ('[FijaNoObligatoria]', RESEED, 0)


DELETE FROM	dbo.Usuario
DBCC CHECKIDENT ('Usuario', RESEED, 0)

DELETE FROM dbo.Empleado/*Limpia la tabla empelados*/
DBCC CHECKIDENT ('Empleado', RESEED, 0)/*Reinicia el identify*/

DELETE FROM dbo.TipoDocuIdentidad/*Limpia la tabla empelados*/


DELETE FROM dbo.Departamento/*Limpia la tabla empelados*/

DELETE FROM dbo.Puesto/*Limpia la tabla empelados*/

DELETE FROM dbo.Feriado/*Limpia la tabla empelados*/
DBCC CHECKIDENT ('Feriado', RESEED, 0)/*Reinicia el identify*/


DELETE FROM dbo.TipoJornada

DELETE FROM TipoDeduccion

DELETE FROM [dbo].[DeduccionPorcentualObligatoria]
DBCC CHECKIDENT ('[DeduccionPorcentualObligatoria]', RESEED, 0)/*Reinicia el identify*/

DELETE FROM [TipoMovPlantilla]

