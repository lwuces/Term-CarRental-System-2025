using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarRentalSystem.Pages
{
    public partial class Register : System.Web.UI.Page
    {
        CarRentalDataDataContext db = new CarRentalDataDataContext(
            ConfigurationManager.ConnectionStrings["CarRentalDBConnectionString"].ConnectionString
        );

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        // (ฟังก์ชันที่แก้ไขแล้ว)
        protected void btnRegister_Click(object sender, EventArgs e)
        {
            try
            {
                // 1. ตรวจสอบว่า Email นี้มีคนใช้หรือยัง
                var existingCustomer = db.Customers.FirstOrDefault(c => c.Email == txtRegEmail.Text);

                if (existingCustomer != null)
                {
                    lblRegStatus.Text = "อีเมลนี้ถูกใช้งานแล้ว";
                    lblRegStatus.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                // 2. สร้าง Customer ใหม่
                Customer newCustomer = new Customer
                {
                    FirstName = txtRegFirstName.Text,
                    LastName = txtRegLastName.Text,
                    Email = txtRegEmail.Text,
                    Tel = txtRegTel.Text,
                    Password = txtRegPassword.Text
                };

                // 3. บันทึกลงฐานข้อมูล
                db.Customers.InsertOnSubmit(newCustomer);
                db.SubmitChanges();

                // 4. (ส่วนที่แก้ไข) สร้าง JavaScript เพื่อแจ้งเตือนและ Redirect
                string script = "alert('คุณลงทะเบียนแล้ว'); window.location.href='Login.aspx';";

                // 5. สั่งให้ Client (Browser) รัน Script นี้
                ClientScript.RegisterStartupScript(
                    this.GetType(),
                    "RegisterSuccessScript",
                    script,
                    true // true = เพิ่มแท็ก <script> อัตโนมัติ
                );

                // (เราไม่จำเป็นต้องใช้ lblRegStatus หรือปิดปุ่ม btnRegister อีกต่อไป เพราะหน้าจะเปลี่ยนทันที)
            }
            catch (Exception ex)
            {
                lblRegStatus.Text = "เกิดข้อผิดพลาด: " + ex.Message;
                lblRegStatus.ForeColor = System.Drawing.Color.Red;
            }
        }
    }
}