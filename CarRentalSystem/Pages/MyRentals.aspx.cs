using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarRentalSystem.Pages
{
    public partial class MyRentals : System.Web.UI.Page
    {
        CarRentalDataDataContext db = new CarRentalDataDataContext(
            ConfigurationManager.ConnectionStrings["CarRentalDBConnectionString"].ConnectionString
        );

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. (สำคัญ) ตรวจสอบ Login ก่อนเสมอ
            if (Session["CustomerID"] == null)
            {
                // ถ้ายังไม่ Login, ส่งไปหน้า Login พร้อม ReturnUrl
                string returnUrl = Server.UrlEncode(Request.Url.PathAndQuery);
                Response.Redirect($"~/Pages/Login.aspx?ReturnUrl={returnUrl}");
                return;
            }

            if (!IsPostBack)
            {
                // 2. โหลดประวัติการเช่า
                LoadRentalHistory();

                // 3. ตรวจสอบว่าจองสำเร็จหรือไม่
                CheckStatus();
            }
        }

        private void LoadRentalHistory()
        {
            // 4. ดึง CustomerID จาก Session
            int custID = (int)Session["CustomerID"];

            // 5. LINQ Query เพื่อดึงประวัติการเช่า
            var history = from r in db.Rentals
                          join c in db.Cars on r.CarID equals c.CarID
                          join b in db.Branches on r.RentalBranchID equals b.BranchID
                          where r.CustomerID == custID
                          orderby r.RentalID descending // (เอาล่าสุดขึ้นก่อน)
                          select new
                          {
                              BookingDate = r.StartDate, // (ในรูปคือวันที่จอง แต่เรามีแต่วันที่เริ่ม)
                              c.LicensePlate,
                              c.Model,
                              BranchName = b.Name,
                              r.StartDate,
                              r.ExpectedReturnDate,
                              // คำนวณ "Days"
                              Days = (r.ExpectedReturnDate - r.StartDate).Days,
                              r.TotalFee
                          };

            GridView1.DataSource = history.ToList();
            GridView1.DataBind();
        }

        // 6. ฟังก์ชันสำหรับแสดงข้อความ "จองสำเร็จ"
        private void CheckStatus()
        {
            if (Request.QueryString["status"] == "success")
            {
                pnlSuccess.Visible = true;
            }
        }
    }
}