using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarRentalSystem.Pages.Admin
{
    // (สืบทอด AdminBasePage)
    public partial class ReturnSummary : AdminBasePage
    {
        CarRentalDataDataContext db = new CarRentalDataDataContext(
            ConfigurationManager.ConnectionStrings["CarRentalDBConnectionString"].ConnectionString
        );

        // --- (แก้ไข) 1. เปลี่ยนตัวแปร Global เป็น ViewState Properties ---
        private int RentalID
        {
            get { return (int)(ViewState["Return_RentalID"] ?? 0); }
            set { ViewState["Return_RentalID"] = value; }
        }
        private int CarID
        {
            get { return (int)(ViewState["Return_CarID"] ?? 0); }
            set { ViewState["Return_CarID"] = value; }
        }
        private decimal LateFee
        {
            get { return (decimal)(ViewState["Return_LateFee"] ?? 0m); }
            set { ViewState["Return_LateFee"] = value; }
        }
        // --- (สิ้นสุดการแก้ไข) ---

        protected void Page_Load(object sender, EventArgs e)
        {
            // --- (แก้ไข) 2. ย้ายการอ่าน URL เข้าไปใน !IsPostBack ---
            if (!IsPostBack)
            {
                // 1. ดึง RentalID จาก URL
                if (string.IsNullOrEmpty(Request.QueryString["RentalID"]))
                {
                    Response.Redirect("ManageReturns.aspx");
                    return;
                }

                // 2. เก็บ RentalID ลง ViewState (สำคัญ)
                this.RentalID = Convert.ToInt32(Request.QueryString["RentalID"]);

                // 3. โหลดข้อมูลและคำนวณค่าปรับ
                LoadSummary(this.RentalID);
            }
            // (เมื่อ PostBack ค่า RentalID, CarID, LateFee จะถูกดึงจาก ViewState อัตโนมัติ)
        }

        private void LoadSummary(int rentalID)
        {
            // (Query เหมือนเดิม)
            var data = (from r in db.Rentals
                        join c in db.Cars on r.CarID equals c.CarID
                        join cust in db.Customers on r.CustomerID equals cust.CustomerID
                        where r.RentalID == rentalID
                        select new
                        {
                            Rental = r,
                            Car = c,
                            Customer = cust
                        }).FirstOrDefault();

            if (data == null) { Response.Redirect("ManageReturns.aspx"); return; }

            // --- 3. (แก้ไข) เก็บค่าที่คำนวณได้ลง ViewState ---
            DateTime expectedDate = data.Rental.ExpectedReturnDate;
            DateTime actualDate = DateTime.Now.Date;

            TimeSpan diff = actualDate - expectedDate;
            int lateDays = (int)Math.Ceiling(diff.TotalDays);

            if (lateDays < 0) lateDays = 0;

            decimal penaltyRate = data.Car.DailyRate * 1.5m;

            // (เก็บค่าที่คำนวณได้ลง ViewState Properties)
            this.LateFee = lateDays * penaltyRate;
            this.CarID = data.Car.CarID;

            decimal newTotalCost = data.Rental.TotalFee.GetValueOrDefault(0) + this.LateFee;

            // --- 4. แสดงผล (เหมือนเดิม) ---
            lblCustomerName.Text = data.Customer.FirstName + " " + data.Customer.LastName;
            lblCarModel.Text = data.Car.Model;
            lblLicensePlate.Text = data.Car.LicensePlate;
            lblExpectedReturn.Text = expectedDate.ToString("dd MMM yyyy");
            lblActualReturn.Text = actualDate.ToString("dd MMM yyyy");
            lblOriginalFee.Text = data.Rental.TotalFee.GetValueOrDefault(0).ToString("N2");
            lblLateDays.Text = lateDays.ToString();
            lblLateFee.Text = this.LateFee.ToString("N2");
            lblTotalCost.Text = newTotalCost.ToString("N2");
        }

        // --- (แก้ไข) 5. ฟังก์ชันนี้จะดึงค่าจาก ViewState ---
        protected void btnConfirmReturn_Click(object sender, EventArgs e)
        {
            try
            {
                // 1. อัปเดตตาราง Rental
                // (ดึงค่าจาก ViewState)
                Rental rental = db.Rentals.Single(r => r.RentalID == this.RentalID);
                rental.ActualReturnDate = DateTime.Now.Date;
                rental.LateFee = this.LateFee;

                // 2. อัปเดตตาราง Car
                // (ดึงค่าจาก ViewState - นี่คือจุดที่แก้ Error)
                Car car = db.Cars.Single(c => c.CarID == this.CarID);
                car.Status = "Available";

                // 3. บันทึก
                db.SubmitChanges();

                // 4. ส่งกลับไปหน้าแรก พร้อมสถานะ
                Response.Redirect("ManageReturns.aspx?status=return_success");
            }
            catch (Exception ex)
            {
                lblStatus.Text = "Error processing return: " + ex.Message;
            }
        }
    }
}