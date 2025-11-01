using System;
using System.Configuration;
using System.Linq;
using System.Web.UI.WebControls;

// (ตรวจสอบ Namespace ของคุณ)
namespace CarRentalSystem.Pages.Admin
{
    // (สำคัญ!) เปลี่ยนจาก System.Web.UI.Page เป็น AdminBasePage
    public partial class Dashboard : AdminBasePage
    {
        CarRentalDataDataContext db = new CarRentalDataDataContext(
            ConfigurationManager.ConnectionStrings["CarRentalDBConnectionString"].ConnectionString
        );

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboardStats();
            }
        }

        private void LoadDashboardStats()
        {
            lblTotalCars.Text = db.Cars.Count().ToString();
            lblTotalCustomers.Text = db.Customers.Count().ToString();
            lblActiveRentals.Text = db.Rentals.Count(r => r.ActualReturnDate == null).ToString();
        }
    }
}