<%@ Page Title="Manage Cars" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="ManageCars.aspx.cs" Inherits="CarRentalSystem.Pages.Admin.ManageCars" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <%-- 1. ใช้คลาสจัดกลาง (แต่ตั้งค่า max-width ให้กว้างขึ้นสำหรับตาราง) --%>
    <div class="main-content-centered" style="max-width: 1000px;">

        <%-- 2. สร้าง Panel (การ์ด) หนึ่งใบหุ้มทุกอย่าง --%>
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title" style="display: inline-block; padding-top: 7px;">Manage Cars</h3>

                <%-- 3. ย้ายปุ่ม Add New Car มาไว้ที่หัว Panel ด้านขวา --%>
                <button type="button" class="btn btn-success pull-right" data-toggle="modal" data-target="#addCarModal">
                    <span class="glyphicon glyphicon-plus"></span>
                </button>
                <div class="clearfix"></div>
            </div>

            <div class="panel-body">
                
                <div class="row" style="margin-bottom: 15px;">
                    <div class="col-md-6"> 
                        <asp:TextBox ID="txtSearchLicensePlate" runat="server" 
                            CssClass="form-control" 
                            placeholder="Search by License Plate and press Enter..." 
                            AutoPostBack="true" 
                            OnTextChanged="txtSearchLicensePlate_TextChanged"></asp:TextBox>
                    </div>
                </div>
                
                <asp:UpdatePanel ID="upGrid" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:Label ID="lblGridStatus" runat="server" CssClass="text-danger" EnableViewState="false"></asp:Label>

                        <%-- (VVV แก้ไข) ย้อนกลับไปใช้ Event เก่าๆ 4 บรรทัด) --%>
                        <asp:GridView ID="GridViewCars" runat="server" CssClass="table table-hover"
                            AutoGenerateColumns="False" DataKeyNames="CarID"
                            
                            OnRowEditing="GridViewCars_RowEditing"
                            OnRowCancelingEdit="GridViewCars_RowCancelingEdit"
                            OnRowUpdating="GridViewCars_RowUpdating"
                            OnRowDeleting="GridViewCars_RowDeleting" 
                            
                            BorderStyle="None" GridLines="None"
                            AllowPaging="True"  
                            PageSize="10"       
                            OnPageIndexChanging="GridViewCars_PageIndexChanging"
                            >
                            
                            <PagerStyle CssClass="pagination-ys" HorizontalAlign="Center" /> 

                            <Columns>
                                <asp:BoundField DataField="CarID" HeaderText="ID" ReadOnly="True" />
                                
                                <asp:TemplateField HeaderText="Model">
                                    <ItemTemplate><%# Eval("Model") %></ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtEditModel" runat="server" Text='<%# Bind("Model") %>' CssClass="form-control"></asp:TextBox>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Plate">
                                    <ItemTemplate><%# Eval("LicensePlate") %></ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtEditLicense" runat="server" Text='<%# Bind("LicensePlate") %>' CssClass="form-control"></asp:TextBox>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate><%# Eval("Status") %></ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtEditStatus" runat="server" Text='<%# Bind("Status") %>' CssClass="form-control"></asp:TextBox>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Gear">
                                    <ItemTemplate><%# Eval("Gear") %></ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtEditGear" runat="server" Text='<%# Bind("Gear") %>' CssClass="form-control"></asp:TextBox>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="CC">
                                    <ItemTemplate><%# Eval("EngineCC") %></ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtEditEngineCC" runat="server" Text='<%# Bind("EngineCC") %>' CssClass="form-control" TextMode="Number"></asp:TextBox>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Rate (฿)">
                                    <ItemTemplate>
                                        <%# Eval("DailyRate", "{0:N0}") %>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtEditDailyRate" runat="server" Text='<%# Bind("DailyRate", "{0:N2}") %>' CssClass="form-control" TextMode="Number"></asp:TextBox>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Branch">
                                    <ItemTemplate><%# Eval("Branch.Name") %></ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlEditBranch" runat="server" CssClass="form-control"
                                            DataSourceID="SqlDataSourceBranches" DataTextField="Name" DataValueField="BranchID"
                                            SelectedValue='<%# Bind("BranchID") %>'>
                                        </asp:DropDownList>
                                    </EditItemTemplate>
                                </asp:TemplateField>

                                <%-- (VVV ย้อนกลับ) ใช้ CommandField (Edit/Update/Cancel) --%>
                                <asp:CommandField ShowEditButton="True" ButtonType="Button" ControlStyle-CssClass="btn btn-warning btn-xs" />
                                
                                <%-- (VVV ย้อนกลับ) ใช้ปุ่ม Delete (TemplateField) --%>
                                <asp:TemplateField ShowHeader="False">
                                    <ItemTemplate>
                                        <asp:Button ID="btnDelete" runat="server" Text="Delete"
                                            CssClass="btn btn-danger btn-xs"
                                            CommandName="Delete"
                                            OnClientClick="return confirm('คุณแน่ใจหรือไม่ว่าต้องการลบรถคันนี้?');" />
                                    </ItemTemplate>
                                </asp:TemplateField>

                            </Columns>
                        </asp:GridView>
                    </ContentTemplate>
                         <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="txtSearchLicensePlate" EventName="TextChanged" />
                        </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <%-- Modal "Add New Car" (เหมือนเดิม) --%>
     <div class="modal fade" id="addCarModal" tabindex="-1" role="dialog" aria-labelledby="addCarModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <asp:UpdatePanel ID="upAddCarModal" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title" id="addCarModalLabel">Add New Car</h4>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Model (e.g., 'Toyota Yaris'):</label>
                                        <asp:TextBox ID="txtAddModel" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>License Plate:</label>
                                        <asp:TextBox ID="txtAddLicense" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                            </div> 
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Car Type:</label>
                                        <asp:DropDownList ID="ddlAddType" runat="server" CssClass="form-control" DataTextField="TypeName" DataValueField="TypeID"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Branch:</label>
                                        <asp:DropDownList ID="ddlAddBranch" runat="server" CssClass="form-control" DataTextField="Name" DataValueField="BranchID"></asp:DropDownList>
                                    </div>
                                </div>
                            </div> 
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Gear:</label>
                                        <asp:RadioButtonList ID="rblAddGear" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Value="Auto" Selected="True">Auto</asp:ListItem>
                                            <asp:ListItem Value="Manual">Manual</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Engine CC:</label>
                                        <asp:TextBox ID="txtAddEngine" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                                    </div>
                                </div>
                            </div> 
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label>Daily Rate (฿):</label>
                                        <asp:TextBox ID="txtAddDailyRate" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                                    </div>
                                </div>
                            </div> 
                            <asp:Label ID="lblAddStatus" runat="server" EnableViewState="false" CssClass="text-danger"></asp:Label>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            <asp:Button ID="btnSaveCar" runat="server" Text="Save New Car" CssClass="btn btn-primary" OnClick="btnSaveCar_Click" />
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    <%-- (สิ้นสุด Modal "Add") --%>

    <%-- (ลบ Modal "Edit Car" ทิ้ง) --%>

    <%-- (SQL DataSources) --%>
    <asp:SqlDataSource ID="SqlDataSourceBranches" runat="server"
        ConnectionString="<%$ ConnectionStrings:CarRentalDBConnectionString %>"
        SelectCommand="SELECT [BranchID], [Name] FROM [Branch]"></asp:SqlDataSource>
</asp:Content>