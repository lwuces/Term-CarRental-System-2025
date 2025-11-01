using System;
using System.Configuration;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarRentalSystem.Pages.Admin
{
    public partial class ManageBranches : AdminBasePage // (สืบทอด AdminBasePage)
    {
        CarRentalDataDataContext db = new CarRentalDataDataContext(
            ConfigurationManager.ConnectionStrings["CarRentalDBConnectionString"].ConnectionString
        );

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBranches();
            }
        }

        private void LoadBranches()
        {
            GridViewBranches.DataSource = db.Branches.ToList();
            GridViewBranches.DataBind();
        }

        // (เพิ่มสาขาใหม่)
        protected void btnAddBranch_Click(object sender, EventArgs e)
        {
            Branch newBranch = new Branch { Name = txtBranchName.Text };
            db.Branches.InsertOnSubmit(newBranch);
            db.SubmitChanges();

            txtBranchName.Text = "";
            lblStatus.Text = "Branch added successfully!";
            lblStatus.ForeColor = System.Drawing.Color.Green;
            LoadBranches(); // โหลดตารางใหม่
        }

        // (ลบสาขา)
        protected void GridViewBranches_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int branchID = (int)GridViewBranches.DataKeys[e.RowIndex].Value;
            var branch = db.Branches.Single(b => b.BranchID == branchID);
            db.Branches.DeleteOnSubmit(branch);
            db.SubmitChanges();
            LoadBranches();
        }
    }
}