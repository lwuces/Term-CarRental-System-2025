using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarRentalSystem.Pages
{
    public partial class Login : System.Web.UI.Page
    {
        CarRentalDataDataContext db = new CarRentalDataDataContext(
            ConfigurationManager.ConnectionStrings["CarRentalDBConnectionString"].ConnectionString
        );

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            var customer = db.Customers.FirstOrDefault(c =>
                c.Email == txtLoginEmail.Text &&
                c.Password == txtLoginPassword.Text
            );

            if (customer == null)
            {
                lblLoginStatus.Text = "อีเมล หรือ รหัสผ่านไม่ถูกต้อง";
            }
            else
            {
                // 3. (แก้ไข) สร้าง SESSION
                Session["CustomerID"] = customer.CustomerID;
                Session["CustomerName"] = customer.FirstName;
                Session["IsAdmin"] = customer.IsAdmin; // (เพิ่ม!!)

                // 4. (แก้ไข) ตรวจสอบ Role เพื่อเปลี่ยนเส้นทาง
                if (customer.IsAdmin == true)
                {
                    // ถ้าเป็น Admin, ส่งไปหน้า Dashboard ของ Admin
                    Response.Redirect("Admin/Dashboard.aspx");
                }
                else
                {
                    // ถ้าเป็นลูกค้าทั่วไป, ตรวจสอบ ReturnUrl (เหมือนเดิม)
                    string returnUrl = Request.QueryString["ReturnUrl"];
                    if (!string.IsNullOrEmpty(returnUrl))
                    {
                        Response.Redirect(returnUrl); // (อาจต้องแก้ไข Path ถ้า ReturnUrl ไม่ได้มี /Pages/)
                    }
                    else
                    {
                        Response.Redirect("Default.aspx");
                    }
                }
            }
        }
    }
}