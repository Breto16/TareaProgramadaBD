using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;   

namespace TP1
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            PageBody.Attributes.Add("bgcolor","003d33");
        }
        SqlConnection con = new SqlConnection(@"Data Source = BRETONDESKTOP\SQLEXPRESS; Initial Catalog = TareaProgramada2; Persist Security Info=True;User ID = sa; Password=password22");

        protected void btn_Ingresar_Click(object sender, EventArgs e)
        {
            if(txt_Usuario.Text == "" || txt_Password.Text == "")
            {
                lbl_Error.Text = "Uno o más campos están vacíos";
            }
            else
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("SP_Login", con)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    cmd.Connection.Open();
                    cmd.Parameters.Add("@inUsuario", SqlDbType.VarChar, 16).Value = txt_Usuario.Text;
                    cmd.Parameters.Add("@inPassword", SqlDbType.VarChar, 16).Value = txt_Password.Text;
                    cmd.Parameters.Add("@outResult", SqlDbType.Int).Value = 1;
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        Response.Redirect("Productos.aspx");
                    }
                    else
                    {
                        lbl_Error.Text = "Combinación de usuario/password no existe en la Base de Datos";
                    }
                }catch (Exception err)
                {
                    lbl_Error.Text = err+"Ocurrió un error inesperado en la Base de Datos";
                }
                finally
                {
                    con.Close();
                }
            }
        }

        
    }
}