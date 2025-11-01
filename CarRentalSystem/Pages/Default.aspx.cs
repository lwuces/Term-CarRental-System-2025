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
        // สร้างตัวแปร DataContext เพื่อเชื่อมต่อฐานข้อมูล
        CarRentalDataDataContext db = new CarRentalDataDataContext(
            ConfigurationManager.ConnectionStrings["CarRentalDBConnectionString"].ConnectionString
        );
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // โหลดสาขาใส่ Dropdown (จากขั้นตอนก่อน)
                LoadBranches();

                // ฟังก์ชันใหม่: โหลดข้อมูลตัวเลข Dashboard
                LoadDashboardStats();
            }
        }

        // ฟังก์ชันใหม่: สำหรับดึงข้อมูลมาแสดงบนการ์ด
        private void LoadDashboardStats()
        {
            // (นี่คือ Query ตัวอย่าง คุณสามารถปรับแก้ให้ซับซ้อนขึ้นได้)

            // นับรถทั้งหมด
            lblTotalCars.Text = db.Cars.Count().ToString();

            // นับลูกค้าทั้งหมด
            lblTotalCustomers.Text = db.Customers.Count().ToString();

            // นับการเช่าที่ยังไม่คืน (Active)
            lblActiveRentals.Text = db.Rentals.Count(r => r.ActualReturnDate == null).ToString();
        }

        // ฟังก์ชันเดิม: สำหรับโหลดสาขา
        private void LoadBranches()
        {
            ddlPickupBranch.DataSource = db.Branches.ToList();
            ddlPickupBranch.DataTextField = "Name";
            ddlPickupBranch.DataValueField = "BranchID";
            ddlPickupBranch.DataBind();
            // เพิ่มตัวเลือก "เลือกสาขา"
            ddlPickupBranch.Items.Insert(0, new ListItem("-- ทุกสาขา --", ""));
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            // ดึงค่าจาก DropDownList และ TextBox
            string branchID = ddlPickupBranch.SelectedValue;
            string pickupDate = txtPickupDate.Text;

            // ส่งผู้ใช้ไปยังหน้า CarList พร้อมแนบค่าค้นหาไปด้วย
            Response.Redirect($"CarList.aspx?branch={branchID}&pickup={pickupDate}");
        }
    }
}