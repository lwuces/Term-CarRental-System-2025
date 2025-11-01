using System;
using System.Configuration;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarRentalSystem.Pages.Admin
{
    public partial class ManageCars : AdminBasePage // (สืบทอด AdminBasePage)
    {
        CarRentalDataDataContext db = new CarRentalDataDataContext(
            ConfigurationManager.ConnectionStrings["CarRentalDBConnectionString"].ConnectionString
        );

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCars();
                LoadAddDropdowns();
            }
        }

        // โหลดข้อมูลตาราง GridView
        private void LoadCars()
        {
            GridViewCars.DataSource = db.Cars.ToList();
            GridViewCars.DataBind();
        }

        // โหลดข้อมูล Dropdown สำหรับ "ฟอร์มเพิ่ม"
        private void LoadAddDropdowns()
        {
            ddlAddBranch.DataSource = db.Branches.ToList();
            ddlAddBranch.DataBind();

            ddlAddType.DataSource = db.CarTypes.ToList();
            ddlAddType.DataBind();
        }

        // --- ส่วนการเพิ่มรถ (Add Car Panel) ---

        // (ฟังก์ชัน btnShowAddPanel_Click ถูกลบไปแล้ว)

        protected void btnSaveCar_Click(object sender, EventArgs e)
        {
            try
            {
                // (1. ตรวจสอบข้อมูล)
                if (string.IsNullOrEmpty(txtAddModel.Text) ||
                    string.IsNullOrEmpty(txtAddLicense.Text) ||
                    string.IsNullOrEmpty(txtAddDailyRate.Text))
                {
                    lblAddStatus.Text = "Model, License Plate, and Daily Rate are required.";
                    upAddCarModal.Update(); // อัปเดตเฉพาะใน Modal เพื่อแสดง Error
                    return;
                }

                // (2. บันทึกข้อมูล - อัปเดตล่าสุด)
                Car newCar = new Car
                {
                    Model = txtAddModel.Text,
                    LicensePlate = txtAddLicense.Text,
                    TypeID = Convert.ToInt32(ddlAddType.SelectedValue),
                    BranchID = Convert.ToInt32(ddlAddBranch.SelectedValue),
                    Gear = rblAddGear.SelectedValue,
                    EngineCC = Convert.ToInt32(txtAddEngine.Text),
                    DailyRate = Convert.ToDecimal(txtAddDailyRate.Text), // (เพิ่ม DailyRate)
                    Status = "Available"
                };
                db.Cars.InsertOnSubmit(newCar);
                db.SubmitChanges();

                // (3. ถ้าสำเร็จ)
                LoadCars(); // โหลดข้อมูล GridView ใหม่
                upGrid.Update(); // สั่งให้ UpdatePanel ของ GridView รีเฟรช

                // (4. เคลียร์ฟอร์มใน Modal)
                txtAddModel.Text = "";
                txtAddLicense.Text = "";
                txtAddEngine.Text = "";
                txtAddDailyRate.Text = ""; // (เพิ่ม DailyRate)
                lblAddStatus.Text = "";
                upAddCarModal.Update(); // อัปเดต Modal (เคลียร์ค่า)

                // (5. สั่งปิด Modal ด้วย JavaScript)
                ScriptManager.RegisterStartupScript(this, this.GetType(), "HideAddModal", "$('#addCarModal').modal('hide');", true);
            }
            catch (Exception ex)
            {
                lblAddStatus.Text = "Error saving car: " + ex.Message;
                upAddCarModal.Update(); // อัปเดตเฉพาะใน Modal เพื่อแสดง Error
            }
        }

        // --- ส่วนการแก้ไข (Grid View Events) ---

        protected void GridViewCars_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridViewCars.EditIndex = e.NewEditIndex;
            LoadCars();
            upGrid.Update(); // (อัปเดต Grid Panel)
        }

        protected void GridViewCars_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridViewCars.EditIndex = -1;
            LoadCars();
            upGrid.Update(); // (อัปเดต Grid Panel)
        }

        protected void GridViewCars_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            // 1. ดึง ID ของแถว
            int carID = (int)GridViewCars.DataKeys[e.RowIndex].Value;

            // 2. ค้นหาคอนโทรลโดยใช้ "FindControl" (วิธีที่ถูกต้อง)
            TextBox txtModel = (TextBox)GridViewCars.Rows[e.RowIndex].FindControl("txtEditModel");
            TextBox txtLicense = (TextBox)GridViewCars.Rows[e.RowIndex].FindControl("txtEditLicense");
            TextBox txtStatus = (TextBox)GridViewCars.Rows[e.RowIndex].FindControl("txtEditStatus");
            TextBox txtGear = (TextBox)GridViewCars.Rows[e.RowIndex].FindControl("txtEditGear");
            TextBox txtEngineCC = (TextBox)GridViewCars.Rows[e.RowIndex].FindControl("txtEditEngineCC");
            TextBox txtEditDailyRate = (TextBox)GridViewCars.Rows[e.RowIndex].FindControl("txtEditDailyRate"); // (เพิ่ม DailyRate)
            DropDownList ddlBranch = (DropDownList)GridViewCars.Rows[e.RowIndex].FindControl("ddlEditBranch");

            // 3. ค้นหา
            Car carToUpdate = db.Cars.Single(c => c.CarID == carID);

            // 4. อัปเดต (ตรวจสอบ null ก่อน)
            if (txtModel != null && txtLicense != null && txtStatus != null && txtGear != null && txtEngineCC != null && txtEditDailyRate != null && ddlBranch != null)
            {
                carToUpdate.Model = txtModel.Text;
                carToUpdate.LicensePlate = txtLicense.Text;
                carToUpdate.Status = txtStatus.Text;
                carToUpdate.Gear = txtGear.Text;
                carToUpdate.EngineCC = Convert.ToInt32(txtEngineCC.Text);
                carToUpdate.DailyRate = Convert.ToDecimal(txtEditDailyRate.Text); // (เพิ่ม DailyRate)
                carToUpdate.BranchID = Convert.ToInt32(ddlBranch.SelectedValue);

                // 5. บันทึก
                db.SubmitChanges();
            }

            // 6. ออกจากโหมด Edit (เหมือนเดิม)
            GridViewCars.EditIndex = -1;
            LoadCars();
            upGrid.Update(); // (อัปเดต Grid Panel)
        }

        protected void GridViewCars_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                // 1. ดึง ID ของแถว
                int carID = (int)GridViewCars.DataKeys[e.RowIndex].Value;

                // 2. ค้นหารถ
                Car carToArchive = db.Cars.Single(c => c.CarID == carID);

                // 3. (แก้ไข) เปลี่ยนจากการลบ เป็นการอัปเดตสถานะ
                carToArchive.Status = "Archived";

                // 4. บันทึก
                db.SubmitChanges();

                // 5. โหลดตารางใหม่
                LoadCars();
                upGrid.Update(); // (อัปเดต Grid Panel)
            }
            catch (Exception ex)
            {
                // (แก้ไข) ใช้งาน 'ex' เพื่อแสดงข้อความ Error
                lblGridStatus.Text = "Error deleting car: " + ex.Message;
                upGrid.Update(); // (อัปเดต Grid Panel เพื่อโชว์ Error)
            }
        }
    }
}