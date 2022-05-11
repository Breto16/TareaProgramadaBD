<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="TP1.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <style type="text/css">
        #PageBody {
            margin: 0px;
            height: 486px;
        }
    </style>
</head>

    

<body id="PageBody" runat="server">
    
    
    <form id="form1" runat="server">
        <div>
            <asp:Panel ID="Panel1" runat="server" BackColor="#003D33" Font-Size="Smaller" ForeColor="White" Height="60px" Font-Names="Segoe UI Light">
                &nbsp;<br />
                &nbsp; &nbsp;&nbsp;
                <asp:ImageButton ID="ImageButton1" runat="server" Height="30px" ImageAlign="Top" ImageUrl="~/Imagenes/round_home_white_24dp2X.png" style="margin-bottom: 0px" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="Label1" runat="server" Font-Names="Segoe UI Light" Font-Size="Large" Text="Segunda Tarea Programada"></asp:Label>
            </asp:Panel>
            <asp:Panel ID="Panel2" runat="server" BackColor="#00695C" ForeColor="White" Height="314px" HorizontalAlign="Right" style="margin-left: 0px; margin-right: 0px; margin-top: 0px" DefaultButton="btn_Ingresar">
                &nbsp;&nbsp;<br /> &nbsp;&nbsp;&nbsp;
                <asp:Label ID="Label2" runat="server" Font-Names="Segoe UI Light" Font-Size="XX-Large" Text="Login"></asp:Label>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <br />
                <br />
                <asp:Image ID="Image1" runat="server" Height="30px" ImageAlign="Top" ImageUrl="~/Imagenes/round_person_white_24dp.png" style="margin-top: 6px" />
                <asp:TextBox ID="txt_Usuario" runat="server" placeholder="Usuario" Height="35px" MaxLength="20" style="margin-left: 9px; margin-right: 200px; margin-top: 0px; margin-bottom: 16px;" Width="250px" Font-Bold="False" Font-Names="Segoe UI Light" Font-Size="X-Large" ForeColor="#003D33"></asp:TextBox>
                <br />
                <asp:Image ID="Image2" runat="server" Height="30px" ImageAlign="Top" ImageUrl="~/Imagenes/round_lock_white_24dp.png" style="margin-right: 0px; margin-top: 6px" />
                <asp:TextBox ID="txt_Password" runat="server" placeholder="Contraseña" Height="35px" MaxLength="20" style="margin-left: 9px; margin-right: 200px; margin-top: 0px; margin-bottom: 16px;" type="password" Width="250px" Font-Bold="False" Font-Names="Segoe UI Light" Font-Size="X-Large" ForeColor="#003D33"></asp:TextBox>
                <br />
                <asp:Label ID="lbl_Error" runat="server" Font-Names="Segoe UI Light" ForeColor="#99CC00"></asp:Label>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <br />
                <asp:Button ID="btn_Ingresar" runat="server" BackColor="#439889" BorderStyle="None" Font-Names="Segoe UI Light" Font-Size="X-Large" ForeColor="White" Height="48px" style="margin-right: 200px; margin-top: 18px; margin-bottom: 15px;" Text="Ingresar" Width="130px" OnClick="btn_Ingresar_Click" />
                <br />
                <br />
                <br />
                <br />
            </asp:Panel>
            <asp:Panel ID="Panel3" runat="server" BackColor="#003D33" Font-Names="Segoe UI Light" ForeColor="White">
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;
                <br />
            </asp:Panel>
        </div>
    </form>
    <p style="font-family: 'Segoe UI Light'; color: #FFFFFF">
&nbsp;&nbsp;&nbsp;&nbsp; Isaac Brenes Torres</p>
</body>
</html>
