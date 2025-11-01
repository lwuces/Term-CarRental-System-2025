using System;
using System.Collections.Generic;
using System.Configuration; // (จำเป็นสำหรับ ConnectionString)
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarRentalSystem.Pages
{
    public partial class Booking : System.Web.UI.Page
    {
        // สร้างตัวแปร DataContext
        CarRentalDataDataContext db = new CarRentalDataDataContext(
            ConfigurationManager.ConnectionStrings["CarRentalDBConnectionString"].ConnectionString
        );

        // (เพิ่มตัวแปร Global)
        // เราใช้ ViewState เพื่อเก็บค่าเหล่านี้ไว้ แม้จะมีการ PostBack
        private decimal DailyRate
        {
            get { return (decimal)(ViewState["DailyRate"] ?? 0m); }
            set { ViewState["DailyRate"] = value; }
        }

        private int RentalBranchID
        {
            get { return (int)(ViewState["RentalBranchID"] ?? 0); }
            set { ViewState["RentalBranchID"] = value; }
        }

        private int SelectedCarID
        {
            get { return (int)(ViewState["SelectedCarID"] ?? 0); }
            set { ViewState["SelectedCarID"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. ตรวจสอบ Login
            if (Session["CustomerID"] == null)
            {
                string returnUrl = Server.UrlEncode(Request.Url.PathAndQuery);
                Response.Redirect($"~/Pages/Login.aspx?ReturnUrl={returnUrl}");
                return;
            }

            if (!IsPostBack) // โหลดครั้งแรกเท่านั้น
            {
                // 2. ดึง CarID จาก URL
                if (string.IsNullOrEmpty(Request.QueryString["CarID"]))
                {
                    Response.Redirect("CarList.aspx");
                    return;
                }
                SelectedCarID = Convert.ToInt32(Request.QueryString["CarID"]);

                // 3. โหลดข้อมูลรถ (เพื่อเอา Rate มาคำนวณ)
                LoadCarDetails(SelectedCarID);

                // 4. โหลดข้อมูลผู้ใช้
                LoadLoggedInCustomer();
            }
        }

        private void LoadCarDetails(int carID)
        {
            var carDetails = (from car in db.Cars
                              join type in db.CarTypes on car.TypeID equals type.TypeID
                              join branch in db.Branches on car.BranchID equals branch.BranchID
                              join rate in db.RentalRates on car.TypeID equals rate.TypeID
                              where car.CarID == carID && rate.SeasonName == "Normal"
                              select new
                              {
                                  car.Model,
                                  type.TypeName,
                                  branch.Name,
                                  car.LicensePlate,
                                  rate.DailyRate,
                                  car.BranchID
                              }).FirstOrDefault();

            if (carDetails == null)
            {
                Response.Redirect("CarList.aspx");
                return;
            }

            // แสดงผลใน Label
            lblModel.Text = carDetails.Model;
            lblLicensePlate.Text = carDetails.LicensePlate;
            lblBranch.Text = carDetails.Name;
            lblRate.Text = carDetails.DailyRate.ToString("N0"); // N0 = ไม่มีทศนิยม

            // เก็บค่า Global ไว้ใช้ (ผ่าน ViewState)
            DailyRate = carDetails.DailyRate;
            RentalBranchID = carDetails.BranchID;
        }

        // ฟังก์ชันสำหรับดึงชื่อลูกค้าจาก Session
        private void LoadLoggedInCustomer()
        {
            lblCustomerName.Text = Session["CustomerName"].ToString();
        }

        // ฟังก์ชันนี้จะทำงานเมื่อผู้ใช้เปลี่ยนวันที่ (เพราะเราตั้ง AutoPostBack=true)
        protected void Date_Changed(object sender, EventArgs e)
        {
            CalculateTotal();
        }

        // ฟังก์ชันคำนวณราคารวม
        private void CalculateTotal()
        {
            // ตรวจสอบว่าเลือกวันที่ครบหรือยัง
            if (string.IsNullOrEmpty(txtStartDate.Text) || string.IsNullOrEmpty(txtReturnDate.Text))
            {
                btnConfirmBooking.Enabled = false;
                return;
            }

            DateTime startDate;
            DateTime endDate;

            // ป้องกันการป้อนวันที่ผิดรูปแบบ
            if (!DateTime.TryParse(txtStartDate.Text, out startDate) || !DateTime.TryParse(txtReturnDate.Text, out endDate))
            {
                lblStatus.Text = "รูปแบบวันที่ไม่ถูกต้อง";
                btnConfirmBooking.Enabled = false;
                return;
            }


            if (endDate <= startDate)
            {
                lblStatus.Text = "วันที่คืนรถต้องอยู่หลังวันที่รับรถ";
                btnConfirmBooking.Enabled = false;
                lblDays.Text = "0";
                lblTotalCost.Text = "0.00";
                return;
            }

            // คำนวณ
            TimeSpan rentalTime = endDate - startDate;
            int totalDays = (int)Math.Ceiling(rentalTime.TotalDays); // ปัดเศษวันขึ้น
            decimal totalCost = totalDays * DailyRate; // ใช้ DailyRate จาก ViewState

            // อัปเดต UI
            lblStartDate.Text = startDate.ToString("dd MMM yyyy");
            lblReturnDate.Text = endDate.ToString("dd MMM yyyy");
            lblDays.Text = totalDays.ToString();
            lblTotalCost.Text = totalCost.ToString("N0");

            // เปิดปุ่มจอง
            lblStatus.Text = "";
            btnConfirmBooking.Enabled = true;
        }

        // ฟังก์ชันเมื่อกดปุ่มยืนยัน
        protected void btnConfirmBooking_Click(object sender, EventArgs e)
        {
            try
            {
                // 1. ดึงข้อมูลจาก Session และ Form
                int custID = (int)Session["CustomerID"];
                DateTime startDate = Convert.ToDateTime(txtStartDate.Text);
                DateTime endDate = Convert.ToDateTime(txtReturnDate.Text);
                decimal totalCost = Convert.ToDecimal(lblTotalCost.Text.Replace(",", "")); // (เผื่อมี ,)

                // 2. สร้าง
                Rental newRental = new Rental
                {
                    CustomerID = custID,
                    CarID = SelectedCarID, // ใช้ CarID จาก ViewState
                    StartDate = startDate,
                    ExpectedReturnDate = endDate,
                    ActualReturnDate = null, // (ยังไม่คืน)
                    RentalBranchID = RentalBranchID, // ใช้ BranchID จาก ViewState
                    TotalFee = totalCost,
                    LateFee = 0
                };

                // 3. อัปเดตสถานะรถ
                Car carToUpdate = db.Cars.Single(c => c.CarID == SelectedCarID);
                carToUpdate.Status = "Rented";

                // 4. บันทึก
                db.Rentals.InsertOnSubmit(newRental);
                db.SubmitChanges();

                // 5. (สำคัญ) ส่งไปหน้า MyRentals พร้อมสถานะ
                Response.Redirect("~/Pages/MyRentals.aspx?status=success");
            }
            catch (Exception ex)
            {
                lblStatus.Text = "เกิดข้อผิดพลาดในการจอง: " + ex.Message;
            }
        }
    }
}