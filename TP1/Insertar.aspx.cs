using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace TP1
{
    public partial class WebForm2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            PageBody.Attributes.Add("bgcolor", "003d33");
        }
        SqlConnection con = new SqlConnection(@"Data Source = BRETONDESKTOP\SQLEXPRESS; Initial Catalog = TareaProgramada2; Persist Security Info=True;User ID = sa; Password=password22");
        protected void btn_Logout_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("Index.aspx");
        }

        protected void btn_Regresar_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("Productos.aspx");
        }
        protected bool VNombre(string Nombre)
        {
            try
            {
                SqlCommand cmd = new SqlCommand("SP_VNombre", con)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Connection.Open();
                cmd.Parameters.Add("@Nombre", SqlDbType.VarChar, 128).Value = Nombre;
                
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    lbl_Error.Text = "Ya existe un artículo con este nombre";
                    con.Close();
                    return false;

                }
                else
                {
                    con.Close();
                    return true;
                }
            }
            catch (Exception err)
            {
                lbl_Error.Text = "Ocurrió un error inesperado en la Base de Datos";
                return false;
            }
            finally
            {
                con.Close();
            }
        }
        protected void btn_Insertar_Click(object sender, EventArgs e)
        {
            
                if (txt_Nombre.Text == "" || txt_Salario.Text == "")
                {
                    lbl_Error.Text = "Uno o más campos están vacíos";
                }
                else
                {
                    if (DropDownList2.Text == "1")
                    {
                        try
                        {
                        string Fecha = "";
                        DateTime capturedDate = Calendar1.SelectedDate;
                        Fecha = capturedDate.ToString("yyyy/MM/dd");

                        lbl_Error.Text = "F    " + Fecha;
                        lbl_Error.Text = "";
                        SqlCommand cmd = new SqlCommand("InsertarEmpleado", con)
                        {
                            CommandType = CommandType.StoredProcedure
                        };
                        cmd.Connection.Open();
                        cmd.Parameters.Add("@inNombre", SqlDbType.VarChar, 128).Value = txt_Nombre.Text;
                        cmd.Parameters.Add("@inIdTipoIdentificacion", SqlDbType.Int).Value = txt_Salario.Text;
                        cmd.Parameters.Add("@inValorDocumentoIdentificacion", SqlDbType.Int).Value = DropDownList1.Text;
                        cmd.Parameters.Add("@inIdDepartamento", SqlDbType.Int).Value = DropDownList4.Text;
                        cmd.Parameters.Add("@inPuesto", SqlDbType.VarChar, 128).Value = DropDownList5.Text;
                        cmd.Parameters.Add("@inFechaNacimiento", SqlDbType.VarChar,16).Value = Fecha;
                        //lbl_Error.Text = "DATO: " + DropDownList1.Text;
                        cmd.Parameters.Add("@inActivo", SqlDbType.Int).Value = 1;
                        cmd.Parameters.Add("@outResult", SqlDbType.Int).Value = 1;
                        SqlDataReader dr = cmd.ExecuteReader();
                        if (dr.Read())
                        {
                            lbl_Error.Text = "No se realizó la inserción";

                        }
                        else
                        {
                            lbl_Error.Text = "Articulo insertado correctamente";
                        }
                    }
                        catch (Exception err)
                        {
                            lbl_Error.Text = err+ "EMPOcurrió un error inesperado en la Base de Datos";
                        }
                        finally
                        {
                            con.Close();
                        }
                    }else if (DropDownList2.Text == "2")

                    {
                    lbl_Error.Text = "";
                    try
                        {
                            SqlCommand cmd = new SqlCommand("InsertarPuesto", con)
                            {
                                CommandType = CommandType.StoredProcedure
                            };
                            cmd.Connection.Open();
                            cmd.Parameters.Add("@inNombre", SqlDbType.VarChar, 128).Value = txt_Nombre.Text;
                            cmd.Parameters.Add("@inSalarioXHora", SqlDbType.Money).Value = txt_Salario.Text;
                            cmd.Parameters.Add("@inActivo", SqlDbType.Int).Value = 1;
                            cmd.Parameters.Add("@outResult", SqlDbType.Int).Value = 1;
                            SqlDataReader dr = cmd.ExecuteReader();
                            if (dr.Read())
                            {
                                lbl_Error.Text = "No se realizó la inserción";

                            }
                            else
                            {
                                lbl_Error.Text = "Articulo insertado correctamente";
                            }
                        }
                        catch (Exception err)
                        {
                            lbl_Error.Text = err + "PUOcurrió un error inesperado en la Base de Datos";
                        }
                        finally
                        {
                            con.Close();
                        }
                    }
                    else { lbl_Error.Text = "Propiedad Invalida | No deberia entrar aquí" + DropDownList2.Text; }
                }
            
        }

        protected void DropDownList2_SelectedIndexChanged(object sender, EventArgs e)
        {
            //lbl_Error.Text = DropDownList2.SelectedValue;
            if(DropDownList2.SelectedValue == "1")
            {
                Label5.Text = "Identificacion";
                Label6.Visible = true;
                Label7.Visible = true;
                Label8.Visible = true;
                DropDownList1.Visible = true;
                DropDownList4.Visible = true;
                DropDownList5.Visible = true;
                Calendar1.Visible = true;
            }
            else if (DropDownList2.SelectedValue == "2")
            {
                Label5.Text = "Salario por Hora";
                Label6.Visible = false;
                Label7.Visible = false;
                Label8.Visible = false;
                DropDownList1.Visible = false;
                DropDownList4.Visible = false;
                DropDownList5.Visible = false;
                Calendar1.Visible=false;
            }
        }

        

        
    }
}