<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Insertar.aspx.cs" Inherits="TP1.WebForm2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body id="PageBody" runat="server" style="height: 897px; margin: 0px">
    <form id="form1" runat="server">
        <div style="height: 886px">
            <asp:Panel ID="Panel1" runat="server" BackColor="#003D33" Font-Names="Segoe UI Light" Font-Size="Smaller" ForeColor="White" Height="60px">
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;
                <asp:ImageButton ID="btn_Logout" runat="server" Height="30px" ImageAlign="Top" ImageUrl="~/Imagenes/round_logout_white_24dp.png" OnClick="btn_Logout_Click" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="Label1" runat="server" Font-Names="Segoe UI Light" Font-Size="Large" Text="Segunda Tarea Programada"></asp:Label>
            </asp:Panel>
            <asp:Panel ID="Panel2" runat="server" BackColor="#00695C" Font-Size="Smaller" Height="65px">
                <br />
                &nbsp;&nbsp;&nbsp;
                <asp:ImageButton ID="btn_Regresar" runat="server" Height="30px" ImageAlign="Baseline" ImageUrl="~/Imagenes/round_arrow_back_white_24dp.png" OnClick="btn_Regresar_Click" />
            </asp:Panel>
            <asp:Panel ID="Panel3" runat="server" BackColor="#00695C" Height="805px" DefaultButton="btn_Insertar">
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="Label2" runat="server" Text="Insertar" Font-Names="Segoe UI Light" Font-Size="XX-Large" ForeColor="White"></asp:Label>
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:TareaProgramada2ConnectionString2 %>" SelectCommand="SELECT [id] FROM [TipoDocuIdentidad]"></asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:TareaProgramada2ConnectionString4 %>" SelectCommand="SELECT [Nombre] FROM [Puesto] WHERE ([Activo] = @Activo)">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="TRUE" Name="Activo" Type="Boolean" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:TareaProgramada2ConnectionString3 %>" SelectCommand="SELECT [id] FROM [Departamento]"></asp:SqlDataSource>
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:DropDownList ID="DropDownList2" runat="server" Font-Names="Segoe UI Light" Font-Size="X-Large" Height="35px" OnSelectedIndexChanged="DropDownList2_SelectedIndexChanged" style="margin-left: 18px" Width="259px" AutoPostBack="True">
                    <asp:ListItem Value="1">Empleados</asp:ListItem>
                    <asp:ListItem Value="2">Puestos</asp:ListItem>
                </asp:DropDownList>
                <br />
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;
                <asp:Label ID="Label4" runat="server" Font-Names="Segoe UI Light" Font-Size="X-Large" ForeColor="White" Text="Nombre"></asp:Label>
                <asp:TextBox ID="txt_Nombre" runat="server" Font-Names="Segoe UI Light" Font-Size="X-Large" ForeColor="#003D33" Height="35px"  style="margin-left: 18px" Width="250px"></asp:TextBox>
                <br />
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="Label5" runat="server" Font-Names="Segoe UI Light" Font-Size="X-Large" ForeColor="White" Text="Identificacion"></asp:Label>
                <asp:TextBox ID="txt_Salario" runat="server" Font-Names="Segoe UI Light" Font-Size="X-Large" ForeColor="#003D33" Height="35px"  style="margin-left: 18px" type="number" Width="250px"></asp:TextBox>
                &nbsp;&nbsp;&nbsp;
                <asp:Label ID="Label6" runat="server" Font-Names="Segoe UI Light" Font-Size="X-Large" ForeColor="White" Text="Tipo"></asp:Label>
                <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource1" DataTextField="id" DataValueField="id" Font-Names="Segoe UI Light" Font-Size="X-Large" Height="35px" style="margin-left: 18px" Width="259px">
                    <asp:ListItem Value="1">Empleados</asp:ListItem>
                    <asp:ListItem Value="2">Puestos</asp:ListItem>
                </asp:DropDownList>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <br />
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;
                <asp:Label ID="Label7" runat="server" Font-Names="Segoe UI Light" Font-Size="X-Large" ForeColor="White" Text="ID Departamento"></asp:Label>
                <asp:DropDownList ID="DropDownList4" runat="server" DataSourceID="SqlDataSource2" DataTextField="id" DataValueField="id" Font-Names="Segoe UI Light" Font-Size="X-Large" Height="35px" style="margin-left: 18px" Width="259px">
                    <asp:ListItem Value="1">Empleados</asp:ListItem>
                    <asp:ListItem Value="2">Puestos</asp:ListItem>
                </asp:DropDownList>
                &nbsp;&nbsp;&nbsp;
                <asp:Label ID="Label8" runat="server" Font-Names="Segoe UI Light" Font-Size="X-Large" ForeColor="White" Text="Puesto"></asp:Label>
                <asp:DropDownList ID="DropDownList5" runat="server" DataSourceID="SqlDataSource3" DataTextField="Nombre" DataValueField="Nombre" Font-Names="Segoe UI Light" Font-Size="X-Large" Height="35px" style="margin-left: 18px" Width="280px">
                    <asp:ListItem Value="1">Empleados</asp:ListItem>
                    <asp:ListItem Value="2">Puestos</asp:ListItem>
                </asp:DropDownList>
                <br />
                <br />
                <asp:Calendar ID="Calendar1" runat="server" style="margin-left: 103px" BackColor="White" BorderColor="#999999" CellPadding="4" DayNameFormat="Shortest" Font-Names="Verdana" Font-Size="8pt" ForeColor="Black" Height="180px" SelectedDate="2022-04-13" Width="200px">
                    <DayHeaderStyle BackColor="#CCCCCC" Font-Bold="True" Font-Size="7pt" />
                    <NextPrevStyle VerticalAlign="Bottom" />
                    <OtherMonthDayStyle ForeColor="#808080" />
                    <SelectedDayStyle BackColor="#666666" Font-Bold="True" ForeColor="White" />
                    <SelectorStyle BackColor="#CCCCCC" />
                    <TitleStyle BackColor="#999999" BorderColor="Black" Font-Bold="True" />
                    <TodayDayStyle BackColor="#CCCCCC" ForeColor="Black" />
                    <WeekendDayStyle BackColor="#FFFFCC" />
                </asp:Calendar>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;
                <asp:Label ID="lbl_Error" runat="server" Font-Names="Segoe UI Light" ForeColor="#99CC00"></asp:Label>
                <br />
                <asp:Button ID="btn_Insertar" runat="server" BackColor="#439889" BorderStyle="None" Font-Size="X-Large" ForeColor="White" Height="48px" style="margin-left: 105px; margin-top: 18px;" Text="Insertar" Width="130px" Font-Names="Segoe UI Light" OnClick="btn_Insertar_Click" />
            </asp:Panel>
        </div>
    <p style="font-family: 'Segoe UI Light'; color: #FFFFFF">
&nbsp;&nbsp;&nbsp; Isaac Brenes Torres</p>
    </form>
    </body>
</html>
