CREATE OR ALTER TRIGGER TR_Persona_InsertarDeduccionObligatoria
ON dbo.Empleado
AFTER INSERT
AS
BEGIN
declare @lol int

SET NOCOUNT ON;

	INSERT INTO dbo.DeduccionXEmpleado( [IdEmpleado],
										[IdTipoDeduccion]
										)
	SELECT  E.ID,
			1
	FROM INSERTED E
	ORDER BY e.Id


SET NOCOUNT OFF;
END;