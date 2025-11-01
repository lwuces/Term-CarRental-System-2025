using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarRentalSystem.Pages.Admin
{
    // (สำคัญ) สืบทอด AdminBasePage
    public partial class ManageReturns : AdminBasePage
    {
        CarRentalDataDataContext db = new CarRentalDataDataContext(
            ConfigurationManager.ConnectionStrings["CarRentalDBConnectionString"].ConnectionString
        );

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadActiveRentals();

                // (เช็คสถานะ ถ้าเพิ่งคืนรถเสร็จ)
                if (Request.QueryString["status"] == "return_success")
                {
                    pnlSuccess.Visible = true;
                }
            }
        }

        private void LoadActiveRentals()
        {
            // (Query) ดึงรายการเช่าที่ยังไม่คืน (ActualReturnDate = null)
            var activeRentals = from r in db.Rentals
                                join c in db.Cars on r.CarID equals c.CarID
                                join cust in db.Customers on r.CustomerID equals cust.CustomerID
                                where r.ActualReturnDate == null && c.Status == "Rented"
                                select new
                                {
                                    r.RentalID,
                                    CustomerName = cust.FirstName + " " + cust.LastName,
                                    c.Model,
                                    c.LicensePlate,
                                    r.StartDate,
                                    r.ExpectedReturnDate
                                };

            gvActiveRentals.DataSource = activeRentals.ToList();
            gvActiveRentals.DataBind();
        }

        // เมื่อ Admin คลิกปุ่ม "Process Return"
        protected void gvActiveRentals_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ProcessReturn")
            {
                string rentalID = e.CommandArgument.ToString();

                // ส่ง RentalID ไปยังหน้าที่ 2 (หน้าสรุป)
                Response.Redirect($"ReturnSummary.aspx?RentalID={rentalID}");
            }
        }
    }
}