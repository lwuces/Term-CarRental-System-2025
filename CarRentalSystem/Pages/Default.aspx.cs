using System;
using System.Configuration; // ต้องมีตัวนี้
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarRentalSystem
{
    public partial class _Default : Page
    {
        CarRentalDataDataContext db = new CarRentalDataDataContext(
            ConfigurationManager.ConnectionStrings["CarRentalDBConnectionString"].ConnectionString
        );

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // โหลดสาขาใส่ Dropdown (จากขั้นตอนก่อน)
                LoadBranches();

                // (เราลบ LoadDashboardStats(); ออกจากตรงนี้แล้ว)
            }
        }

        // (เราลบฟังก์ชัน LoadDashboardStats() ทั้งหมดออกจากตรงนี้แล้ว)

        // ฟังก์ชันเดิม: สำหรับโหลดสาขา
        private void LoadBranches()
        {
            ddlPickupBranch.DataSource = db.Branches.ToList();
            ddlPickupBranch.DataTextField = "Name";
            ddlPickupBranch.DataValueField = "BranchID";
            ddlPickupBranch.DataBind();
            ddlPickupBranch.Items.Insert(0, new ListItem("-- ทุกสาขา --", ""));
        }

        // ฟังก์ชันเดิม: สำหรับปุ่มค้นหา
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string branchID = ddlPickupBranch.SelectedValue;
            string pickupDate = txtPickupDate.Text;

            // ส่งผู้ใช้ไปหน้า CarList พร้อมค่าค้นหา
            Response.Redirect($"~/Pages/CarList.aspx?branch={branchID}&pickup={pickupDate}");
        }
    }
}