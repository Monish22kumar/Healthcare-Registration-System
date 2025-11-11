using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace HealthcareApp
{
    public partial class PatientForm : System.Web.UI.Page
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["HealthCon"].ConnectionString);

        protected void Page_Load(object sender, EventArgs e)
        {
            ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None;
            if (!IsPostBack)
            {
                ViewState["filter"] = null;
                BindGrid();
                LoadStats();
            }
        }

        // 🔹 Add Patient
        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            using (SqlCommand cmd = new SqlCommand("sp_AddPatient", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Name", txtName.Text);
                cmd.Parameters.AddWithValue("@Age", txtAge.Text);
                cmd.Parameters.AddWithValue("@Disease", txtDisease.Text);
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

            lblMessage.Text = "✅ Patient added successfully!";
            ClearForm();
            BindGrid();
            LoadStats();
        }

        // 🔹 Show Patients
        private void BindGrid()
        {
            DataTable dt = new DataTable();
            string filter = ViewState["filter"] as string;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;

                if (string.IsNullOrWhiteSpace(filter))
                {
                    cmd.CommandText = "sp_GetPatients";
                }
                else
                {
                    cmd.CommandText = "sp_SearchPatients";
                    cmd.Parameters.AddWithValue("@Search", filter);
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }

            GridView1.DataSource = dt;
            GridView1.DataBind();
        }

        // 🔹 Search
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            ViewState["filter"] = txtSearch.Text?.Trim();
            GridView1.PageIndex = 0;
            BindGrid();
        }

        // 🔹 Clear Search
        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ViewState["filter"] = null;
            lblMessage.Text = "";
            GridView1.PageIndex = 0;
            BindGrid();
        }

        // 🔹 Edit
        protected void GridView1_RowEditing(object sender, System.Web.UI.WebControls.GridViewEditEventArgs e)
        {
            GridView1.EditIndex = e.NewEditIndex;
            BindGrid();
        }

        // 🔹 Update
        protected void GridView1_RowUpdating(object sender, System.Web.UI.WebControls.GridViewUpdateEventArgs e)
        {
            int id = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);
            string name = ((System.Web.UI.WebControls.TextBox)GridView1.Rows[e.RowIndex].Cells[1].Controls[0]).Text;
            string age = ((System.Web.UI.WebControls.TextBox)GridView1.Rows[e.RowIndex].Cells[2].Controls[0]).Text;
            string disease = ((System.Web.UI.WebControls.TextBox)GridView1.Rows[e.RowIndex].Cells[3].Controls[0]).Text;

            using (SqlCommand cmd = new SqlCommand("sp_UpdatePatient", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@PatientID", id);
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@Age", age);
                cmd.Parameters.AddWithValue("@Disease", disease);

                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

            GridView1.EditIndex = -1;
            lblMessage.Text = "✅ Patient updated successfully!";
            BindGrid();
            LoadStats();
        }

        // 🔹 Delete
        protected void GridView1_RowDeleting(object sender, System.Web.UI.WebControls.GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);

            using (SqlCommand cmd = new SqlCommand("sp_DeletePatient", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@PatientID", id);
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

            lblMessage.Text = "🗑️ Patient deleted!";
            BindGrid();
            LoadStats();
        }

        // 🔹 Cancel Edit
        protected void GridView1_RowCancelingEdit(object sender, System.Web.UI.WebControls.GridViewCancelEditEventArgs e)
        {
            GridView1.EditIndex = -1;
            BindGrid();
        }

        // 🔹 Paging
        protected void GridView1_PageIndexChanging(object sender, System.Web.UI.WebControls.GridViewPageEventArgs e)
        {
            GridView1.PageIndex = e.NewPageIndex;
            BindGrid();
        }

        // 🔹 Load KPI Stats
        private void LoadStats()
        {
            using (SqlCommand cmd = new SqlCommand("sp_GetStats", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                int total = Convert.ToInt32(ds.Tables[0].Rows[0][0]);
                lblTotal.Text = total.ToString();

                lblAvgAge.Text = ds.Tables[1].Rows[0][0] != DBNull.Value
                    ? Math.Round(Convert.ToDouble(ds.Tables[1].Rows[0][0]), 1).ToString()
                    : "—";

                lblTopDisease.Text = ds.Tables[2].Rows.Count > 0
                    ? ds.Tables[2].Rows[0][0].ToString()
                    : "—";
            }
        }

        // 🔹 Helper
        private void ClearForm()
        {
            txtName.Text = "";
            txtAge.Text = "";
            txtDisease.Text = "";
        }
    }
}
