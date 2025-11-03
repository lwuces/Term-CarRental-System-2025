using System;
using System.Configuration;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient; // ต้องเพิ่ม using นี้สำหรับ SqlException

namespace CarRentalSystem.Pages.Admin
{
    public partial class ManageBranches : AdminBasePage // (สืบทอด AdminBasePage)
    {
        // (ยังคงใช้ db ตัวเดิม แต่จะมีการสร้างใหม่ใน catch block เมื่อเกิด Error)
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

        // (ลบสาขา - แก้ไขเพื่อเพิ่ม Error Handling)
        protected void GridViewBranches_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int branchID = (int)GridViewBranches.DataKeys[e.RowIndex].Value;
            var branch = db.Branches.SingleOrDefault(b => b.BranchID == branchID);

            if (branch == null)
            {
                lblStatus.Text = "Error: Branch not found.";
                lblStatus.ForeColor = System.Drawing.Color.Red;
                LoadBranches();
                return;
            }

            db.Branches.DeleteOnSubmit(branch);

            try
            {
                db.SubmitChanges();
                lblStatus.Text = "Branch deleted successfully!";
                lblStatus.ForeColor = System.Drawing.Color.Green;
            }
            catch (SqlException ex)
            {
                // Error Code 547 มักจะหมายถึง Foreign Key Constraint Violation (FK)
                if (ex.Number == 547)
                {
                    lblStatus.Text = "❌ Cannot delete branch: This branch is currently linked to existing cars or rental records. Please re-assign or remove those records first.";
                }
                else
                {
                    // สำหรับ Error อื่นๆ
                    lblStatus.Text = "An unexpected database error occurred: " + ex.Message;
                }
                lblStatus.ForeColor = System.Drawing.Color.Red;

                // (สำคัญ) หาก SubmitChanges ล้มเหลว ต้องสร้าง DataContext ใหม่เพื่อล้างสถานะ
                db = new CarRentalDataDataContext(
                    ConfigurationManager.ConnectionStrings["CarRentalDBConnectionString"].ConnectionString
                );
            }
            catch (Exception ex)
            {
                // สำหรับ Error อื่นๆ ที่ไม่ใช่ SqlException
                lblStatus.Text = "An unexpected error occurred: " + ex.Message;
                lblStatus.ForeColor = System.Drawing.Color.Red;

                // (สำคัญ) หาก SubmitChanges ล้มเหลว ต้องสร้าง DataContext ใหม่เพื่อล้างสถานะ
                db = new CarRentalDataDataContext(
                    ConfigurationManager.ConnectionStrings["CarRentalDBConnectionString"].ConnectionString
                );
            }

            LoadBranches(); // โหลดตารางใหม่เสมอเพื่อให้ข้อมูลถูกต้อง
        }
    }
}