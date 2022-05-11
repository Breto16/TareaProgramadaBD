using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace TP1
{
    public partial class Productos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            PageBody.Attributes.Add("bgcolor", "439889");
        }
        SqlConnection con = new SqlConnection(@"Data Source = BRETONDESKTOP\SQLEXPRESS; Initial Catalog = TareaProgramada2; Persist Security Info=True;User ID = sa; Password=password22");
        protected void btn_LogOut_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("Index.aspx");
        }

        protected void btn_filtrarNombre_Click(object sender, ImageClickEventArgs e)
        {
            if(txt_Filtro.Text == "")
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("SP_EmpleadosDefault", con)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    cmd.Connection.Open();
                    cmd.Parameters.Add("@outResult", SqlDbType.Int).Value = 1;
                    dtg_Articulos.DataSource = cmd.ExecuteReader();
                    dtg_Articulos.DataBind();
                }
                catch (Exception err)
                {
                    txt_Filtro.Text = err+"Ocurrió un error inesperado en la Base de Datos";
                }
                finally
                {
                    con.Close();
                }
            }
            else
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("SP_EmpleadosFiltro", con)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    cmd.Connection.Open();
                    cmd.Parameters.Add("@inFiltro", SqlDbType.VarChar,128).Value = txt_Filtro.Text;
                    cmd.Parameters.Add("@outResult", SqlDbType.Int).Value = 1;
                    dtg_Articulos.DataSource = cmd.ExecuteReader();
                    dtg_Articulos.DataBind();
                }
                catch (Exception err)
                {
                    txt_Filtro.Text = "Ocurrió un error inesperado en la Base de Datos";
                }
                finally
                {
                    con.Close();
                }
            }

        }

        protected void btn_Insertar_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("Insertar.aspx");
        }


        protected void btn_Puestos_Click(object sender, EventArgs e)
        {
            try
            {
                SqlCommand cmd = new SqlCommand("SP_PuestosDefault", con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Connection.Open();
                cmd.Parameters.Add("@outResult", SqlDbType.Int).Value = 1;
                dtg_Articulos.DataSource = cmd.ExecuteReader();
                dtg_Articulos.DataBind();
            }
            catch (Exception err)
            {
                txt_Filtro.Text = "Ocurrió un error inesperado en la Base de Datos";
            }
            finally
            {
                con.Close();
            }
        }

        
    }
}