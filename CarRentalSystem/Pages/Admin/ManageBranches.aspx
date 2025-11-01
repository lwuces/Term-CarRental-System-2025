<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="ManageBranches.aspx.cs" Inherits="CarRentalSystem.Pages.Admin.ManageBranches" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <%-- 1. ใช้คลาสจัดกลาง (เหมือนหน้า Dashboard) --%>
    <div class="main-content-centered">
        <h2>Manage Branches</h2>
        <hr />

        <%-- 2. สร้างแถว (Row) สำหรับแบ่ง 2 คอลัมน์ --%>
        <div class="row">

            <%-- 3. คอลัมน์ซ้าย (col-md-5) : ฟอร์มเพิ่มสาขา --%>
            <div class="col-md-5">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h4>Add New Branch</h4>
                    </div>
                    <div class="panel-body">
                        <div class="form-group">
                            <label>Branch Name:</label>
                            <asp:TextBox ID="txtBranchName" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <asp:Button ID="btnAddBranch" runat="server" Text="Add Branch" CssClass="btn btn-success"
                            OnClick="btnAddBranch_Click"
                            OnClientClick="return confirm('Are you sure you want to add this new branch?');" />
                        <br />
                        <asp:Label ID="lblStatus" runat="server" EnableViewState="false" Style="margin-top: 10px; display: inline-block;"></asp:Label>
                    </div>
                </div>
            </div>

            <%-- 4. คอลัมน์ขวา (col-md-7) : ตารางแสดงสาขา --%>
            <div class="col-md-7">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h4>Existing Branches</h4>
                    </div>

                    <%-- (ถูกต้อง) เปิด panel-body ที่นี่ --%>
                    <div class="panel-body" style="padding: 0;">

                        <%-- (ถูกต้อง) GridView อยู่ข้างใน panel-body --%>
                        <asp:GridView ID="GridViewBranches" runat="server" CssClass="table table-hover"
                            AutoGenerateColumns="False" DataKeyNames="BranchID"
                            OnRowDeleting="GridViewBranches_RowDeleting"
                            BorderStyle="None" GridLines="None">
                            <Columns>
                                <asp:BoundField DataField="BranchID" HeaderText="ID" ReadOnly="True" />
                                <asp:BoundField DataField="Name" HeaderText="Branch Name" />
                                <asp:CommandField ShowDeleteButton="True" ButtonType="Button" ControlStyle-CssClass="btn btn-danger btn-xs" />
                            </Columns>
                            <HeaderStyle CssClass="table-header-custom" />
                        </asp:GridView>

                    </div>
                    <%-- (ถูกต้อง) ปิด panel-body ที่นี่ --%>
                </div>
            </div>

        </div>
        <%-- (ปิด Row) --%>
    </div>
    <%-- (ปิด main-content-centered) --%>
</asp:Content>
