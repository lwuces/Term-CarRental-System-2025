using System;
using System.Configuration;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Linq;

namespace CarRentalSystem.Pages.Admin
{
    public partial class ManageCars : AdminBasePage
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["CarRentalDBConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // (คงการแก้ไขนี้ไว้) ย้าย LoadAddDropdowns() ออกมานอก IsPostBack
            LoadAddDropdowns();

            if (!IsPostBack)
            {
                LoadCars();
            }
        }

        // (ฟังก์ชัน LoadCars ... แก้ไขให้ใช้ 'using' เพื่อแก้ Error)
        private void LoadCars(string licensePlateSearch = null)
        {
            lblGridStatus.Text = "";

            using (CarRentalDataDataContext db = new CarRentalDataDataContext(connectionString))
            {
                var options = new DataLoadOptions();
                options.LoadWith<Car>(c => c.Branch);
                db.LoadOptions = options;

                IQueryable<Car> query = db.Cars;

                if (!string.IsNullOrEmpty(licensePlateSearch))
                {
                    query = query.Where(c => c.LicensePlate.Contains(licensePlateSearch));
                }

                query = query.OrderBy(c => c.CarID);

                GridViewCars.DataSource = query.ToList();
                GridViewCars.DataBind();
            }
        }

        // (ฟังก์ชัน LoadAddDropdowns ... แก้ไขให้ใช้ 'using')
        private void LoadAddDropdowns()
        {
            using (CarRentalDataDataContext db = new CarRentalDataDataContext(connectionString))
            {
                if (ddlAddBranch != null)
                {
                    ddlAddBranch.DataSource = db.Branches.ToList();
                    ddlAddBranch.DataBind();
                }
                if (ddlAddType != null)
                {
                    ddlAddType.DataSource = db.CarTypes.ToList();
                    ddlAddType.DataBind();
                }
            }
        }

        // --- ส่วนการเพิ่มรถ (Add Car Panel) --- (เหมือนเดิม)
        protected void btnSaveCar_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(txtAddModel.Text) ||
                    string.IsNullOrEmpty(txtAddLicense.Text) ||
                    string.IsNullOrEmpty(txtAddDailyRate.Text))
                {
                    lblAddStatus.Text = "Model, License Plate, and Daily Rate are required.";
                    upAddCarModal.Update();
                    return;
                }

                using (CarRentalDataDataContext db = new CarRentalDataDataContext(connectionString))
                {
                    Car newCar = new Car
                    {
                        Model = txtAddModel.Text,
                        LicensePlate = txtAddLicense.Text,
                        TypeID = Convert.ToInt32(ddlAddType.SelectedValue),
                        BranchID = Convert.ToInt32(ddlAddBranch.SelectedValue),
                        Gear = rblAddGear.SelectedValue, // (ใช้ rblAddGear)
                        EngineCC = Convert.ToInt32(txtAddEngine.Text),
                        DailyRate = Convert.ToDecimal(txtAddDailyRate.Text),
                        Status = "Available"
                    };
                    db.Cars.InsertOnSubmit(newCar);
                    db.SubmitChanges();
                }

                LoadCars(txtSearchLicensePlate.Text);
                upGrid.Update();

                txtAddModel.Text = "";
                txtAddLicense.Text = "";
                txtAddEngine.Text = "";
                txtAddDailyRate.Text = "";
                lblAddStatus.Text = "";
                upAddCarModal.Update();

                ScriptManager.RegisterStartupScript(this, this.GetType(), "HideAddModal", "$('#addCarModal').modal('hide');", true);
            }
            catch (Exception ex)
            {
                lblAddStatus.Text = "Error saving car: " + ex.Message;
                upAddCarModal.Update();
            }
        }

        // --- (VVV ย้อนกลับ) นำฟังก์ชัน Inline Edit กลับมา ---

        protected void GridViewCars_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridViewCars.EditIndex = e.NewEditIndex;
            LoadCars(txtSearchLicensePlate.Text);
            upGrid.Update();
        }

        protected void GridViewCars_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridViewCars.EditIndex = -1;
            LoadCars(txtSearchLicensePlate.Text);
            upGrid.Update();
        }

        protected void GridViewCars_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int carID = (int)GridViewCars.DataKeys[e.RowIndex].Value;
            TextBox txtModel = (TextBox)GridViewCars.Rows[e.RowIndex].FindControl("txtEditModel");
            TextBox txtLicense = (TextBox)GridViewCars.Rows[e.RowIndex].FindControl("txtEditLicense");
            TextBox txtStatus = (TextBox)GridViewCars.Rows[e.RowIndex].FindControl("txtEditStatus");
            TextBox txtGear = (TextBox)GridViewCars.Rows[e.RowIndex].FindControl("txtEditGear");
            TextBox txtEngineCC = (TextBox)GridViewCars.Rows[e.RowIndex].FindControl("txtEditEngineCC");
            TextBox txtEditDailyRate = (TextBox)GridViewCars.Rows[e.RowIndex].FindControl("txtEditDailyRate");
            DropDownList ddlBranch = (DropDownList)GridViewCars.Rows[e.RowIndex].FindControl("ddlEditBranch");

            using (CarRentalDataDataContext db = new CarRentalDataDataContext(connectionString))
            {
                Car carToUpdate = db.Cars.Single(c => c.CarID == carID);

                if (txtModel != null && txtLicense != null && txtStatus != null && txtGear != null && txtEngineCC != null && txtEditDailyRate != null && ddlBranch != null)
                {
                    carToUpdate.Model = txtModel.Text;
                    carToUpdate.LicensePlate = txtLicense.Text;
                    carToUpdate.Status = txtStatus.Text;
                    carToUpdate.Gear = txtGear.Text;
                    carToUpdate.EngineCC = Convert.ToInt32(txtEngineCC.Text);
                    carToUpdate.DailyRate = Convert.ToDecimal(txtEditDailyRate.Text);
                    carToUpdate.BranchID = Convert.ToInt32(ddlBranch.SelectedValue);
                    db.SubmitChanges();
                }
            }

            GridViewCars.EditIndex = -1;
            LoadCars(txtSearchLicensePlate.Text);
            upGrid.Update();
        }

        protected void GridViewCars_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int carID = (int)GridViewCars.DataKeys[e.RowIndex].Value;

                using (CarRentalDataDataContext db = new CarRentalDataDataContext(connectionString))
                {
                    var rentalsToDelete = db.Rentals.Where(r => r.CarID == carID);
                    db.Rentals.DeleteAllOnSubmit(rentalsToDelete);
                    Car carToDelete = db.Cars.Single(c => c.CarID == carID);
                    db.Cars.DeleteOnSubmit(carToDelete);
                    db.SubmitChanges();
                }

                LoadCars(txtSearchLicensePlate.Text);
                upGrid.Update();
            }
            catch (Exception ex)
            {
                lblGridStatus.Text = "Error deleting car: " + ex.Message;
                upGrid.Update();
            }
        }

        // --- (AAA สิ้นสุดฟังก์ชัน Inline Edit) ---


        // --- (ส่วน Paging และ Search ... เหมือนเดิม) ---

        protected void GridViewCars_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewCars.PageIndex = e.NewPageIndex;
            LoadCars(txtSearchLicensePlate.Text);
            upGrid.Update();
        }

        protected void txtSearchLicensePlate_TextChanged(object sender, EventArgs e)
        {
            GridViewCars.PageIndex = 0;
            LoadCars(txtSearchLicensePlate.Text);
            upGrid.Update();
        }
    }
}