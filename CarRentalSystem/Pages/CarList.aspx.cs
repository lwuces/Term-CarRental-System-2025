using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarRentalSystem.Pages
{
    public partial class CarList : System.Web.UI.Page
    {
        CarRentalDataDataContext db = new CarRentalDataDataContext(
            ConfigurationManager.ConnectionStrings["CarRentalDBConnectionString"].ConnectionString
        );

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadFilterOptions();
                LoadCarData();
            }
        }

        // ฟังก์ชันสำหรับโหลดตัวเลือกฟิลเตอร์
        private void LoadFilterOptions()
        {
            // โหลด "ยี่ห้อ"
            var brands = db.Cars
                           .Select(c => c.Model)
                           .AsEnumerable()
                           .Select(modelString => modelString.Split(' ')[0])
                           .Distinct()
                           .OrderBy(b => b);

            cblBrands.DataSource = brands.ToList();
            cblBrands.DataBind();

            // โหลด "ประเภทรถ"
            var types = db.CarTypes.OrderBy(t => t.TypeName);
            cblTypes.DataSource = types.ToList();
            cblTypes.DataTextField = "TypeName";
            cblTypes.DataValueField = "TypeID";
            cblTypes.DataBind();
        }

        // ฟังก์ชัน (แก้ไขใหม่): โหลดข้อมูลรถแบบ Dynamic
        private void LoadCarData()
        {
            // 1. (แก้ไข) ไม่ต้อง Join ตาราง RentalRate
            var query = from car in db.Cars
                        join type in db.CarTypes on car.TypeID equals type.TypeID
                        join branch in db.Branches on car.BranchID equals branch.BranchID
                        where car.Status == "Available"
                        select new
                        {
                            car.CarID,
                            car.LicensePlate,
                            car.Model,
                            // (Brand จะถูก Split ทีหลัง)
                            type.TypeName,
                            type.TypeID,
                            branch.Name,
                            branch.BranchID,
                            car.DailyRate, // <-- (ใช้ DailyRate จากตาราง Car)
                            car.Gear,
                            car.EngineCC
                        };

            // 2. (SQL) กรองข้อมูลจากหน้า Default (QueryString)
            if (!IsPostBack)
            {
                string selectedBranchID = Request.QueryString["branch"];
                if (!string.IsNullOrEmpty(selectedBranchID))
                {
                    int id = Convert.ToInt32(selectedBranchID);
                    query = query.Where(car => car.BranchID == id);
                }
            }

            // 3. (SQL) กรองข้อมูลที่ SQL เข้าใจ (เกียร์, ประเภท, เครื่องยนต์)
            string selectedGear = rblGear.SelectedValue;
            if (!string.IsNullOrEmpty(selectedGear))
            {
                query = query.Where(car => car.Gear == selectedGear);
            }

            List<int> selectedTypes = cblTypes.Items.Cast<ListItem>()
                                          .Where(li => li.Selected)
                                          .Select(li => Convert.ToInt32(li.Value))
                                          .ToList();
            if (selectedTypes.Count > 0)
            {
                query = query.Where(car => selectedTypes.Contains(car.TypeID));
            }

            string selectedEngine = rblEngine.SelectedValue;
            if (!string.IsNullOrEmpty(selectedEngine))
            {
                int engineValue = Convert.ToInt32(selectedEngine);
                if (engineValue == 1200) query = query.Where(car => car.EngineCC < 1400);
                else if (engineValue == 1500) query = query.Where(car => car.EngineCC >= 1400 && car.EngineCC <= 1800);
                else if (engineValue == 2000) query = query.Where(car => car.EngineCC > 1800);
            }

            // 4. (C#) สั่งรัน SQL และดึงข้อมูลเข้า Memory
            var resultsFromDb = query.AsEnumerable();

            // 5. (C#) กรองข้อมูลส่วนที่เหลือ (ยี่ห้อ) ที่ต้องใช้ .Split()
            List<string> selectedBrands = cblBrands.Items.Cast<ListItem>()
                                               .Where(li => li.Selected)
                                               .Select(li => li.Value)
                                               .ToList();
            if (selectedBrands.Count > 0)
            {
                resultsFromDb = resultsFromDb.Where(car => selectedBrands.Contains(car.Model.Split(' ')[0]));
            }

            // 6. (C#) เรียงลำดับ (Sorting)
            string sortBy = ddlSortBy.SelectedValue;
            switch (sortBy)
            {
                case "PriceAsc":
                    resultsFromDb = resultsFromDb.OrderBy(car => car.DailyRate);
                    break;
                case "PriceDesc":
                    resultsFromDb = resultsFromDb.OrderByDescending(car => car.DailyRate);
                    break;
                case "ModelAz":
                    resultsFromDb = resultsFromDb.OrderBy(car => car.Model);
                    break;
            }

            // 7. (C#) สร้างผลลัพธ์สุดท้าย (Projection) - ทำ .Split() ที่นี่
            var finalResults = resultsFromDb.Select(car => new
            {
                car.CarID,
                car.LicensePlate,
                car.Model,
                Brand = car.Model.Split(' ')[0], // <-- Split ปลอดภัยแล้ว
                car.TypeName,
                car.TypeID,
                BranchName = car.Name, // (เปลี่ยนชื่อให้ตรงกับ Repeater)
                car.BranchID,
                car.DailyRate,
                car.Gear,
                car.EngineCC
            }).ToList(); // <-- .ToList() ครั้งสุดท้าย

            // 8. (Binding) ผูกข้อมูล
            Repeater1.DataSource = finalResults;
            Repeater1.DataBind();

            lblNoResults.Visible = (finalResults.Count == 0);
        }

        // ฟังก์ชันใหม่: เมื่อมีการเปลี่ยนแปลงฟิลเตอร์
        protected void Filter_Changed(object sender, EventArgs e)
        {
            // เมื่อฟิลเตอร์ (rblGear, ddlSortBy ฯลฯ) เปลี่ยน
            // ให้โหลดข้อมูลรถใหม่
            LoadCarData();
        }

        // ฟังก์ชันเดิม: เมื่อคลิกปุ่ม "จองเลย" (ใน Repeater)
        protected void Repeater1_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Select")
            {
                // ดึง CarID ที่แนบมากับปุ่ม
                int selectedCarID = Convert.ToInt32(e.CommandArgument);
                string bookingUrl = $"~/Pages/Booking.aspx?CarID={selectedCarID}";

                // (โค้ดที่เพิ่มเข้ามา)
                // 1. ตรวจสอบว่า Login หรือยัง
                if (Session["CustomerID"] == null)
                {
                    // 2. ถ้ายังไม่ Login: ส่งไปหน้า Login
                    //    พร้อมแนบ URL หน้าจอง ("ReturnUrl") ไปด้วย
                    string loginUrl = $"~/Pages/Login.aspx?ReturnUrl={Server.UrlEncode(bookingUrl)}";
                    Response.Redirect(loginUrl);
                }
                else
                {
                    // 3. ถ้า Login แล้ว: ไปหน้าจองตามปกติ
                    Response.Redirect(bookingUrl);
                }
            }
        }
    }
}