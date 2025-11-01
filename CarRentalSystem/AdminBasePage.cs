using System;
using System.Web.UI;

// นี่คือ "คลาสแม่" ที่หน้า Admin ทุกหน้าต้องสืบทอด
public class AdminBasePage : System.Web.UI.Page
{
    protected override void OnInit(EventArgs e)
    {
        // ตรวจสอบ Session ก่อนที่หน้าจะโหลด
        if (Session["IsAdmin"] == null || (bool)Session["IsAdmin"] == false)
        {
            // ถ้าไม่ใช่ Admin, ไล่กลับไปหน้า Login
            Response.Redirect("~/Pages/Login.aspx");
        }
        base.OnInit(e);
    }
}