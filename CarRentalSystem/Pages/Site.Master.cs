using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarRentalSystem
{
    public partial class SiteMaster : MasterPage
    {
        // (ในไฟล์ Site.Master.cs)
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["CustomerID"] != null)
            {
                // --- ผู้ใช้ล็อกอินแล้ว ---
                liLogin.Visible = false;
                liLogout.Visible = true;
                lblWelcome.Text = "Welcome, " + Session["CustomerName"].ToString();

                // (ส่วนที่เพิ่ม) ตรวจสอบสิทธิ์ Admin
                if (Session["IsAdmin"] != null && (bool)Session["IsAdmin"] == true)
                {
                    // ถ้าเป็น Admin:
                    liMyRentals.Visible = false; // ซ่อนลิงก์ลูกค้า

                    // แสดงลิงก์ Admin
                    liAdminDashboard.Visible = true;
                    liManageCars.Visible = true;
                    liManageBranches.Visible = true;
                    liManageReturns.Visible = true; // (เพิ่มบรรทัดนี้)
                }
                else
                {
                    // ถ้าเป็น Customer ทั่วไป:
                    liMyRentals.Visible = true; // แสดงลิงก์ลูกค้า

                    // ซ่อนลิงก์ Admin
                    liAdminDashboard.Visible = false;
                    liManageCars.Visible = false;
                    liManageBranches.Visible = false;
                    liManageReturns.Visible = false; // (เพิ่มบรรทัดนี้)
                }
            }
            else
            {
                // --- ผู้ใช้ยังไม่ได้ล็อกอิน ---
                liLogin.Visible = true;
                liLogout.Visible = false;
                lblWelcome.Text = "";

                // ซ่อนลิงก์ทั้งหมด
                liMyRentals.Visible = false;
                liAdminDashboard.Visible = false;
                liManageCars.Visible = false;
                liManageBranches.Visible = false;
                liManageReturns.Visible = false; // (เพิ่มบรรทัดนี้)
            }
        }

        // (ฟังก์ชัน lnkLogout_Click เหมือนเดิม)
        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("~/Pages/Default.aspx");
        }
    }
}