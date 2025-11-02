<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CarRentalSystem._Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <%-- 1. ใช้คลาสจัดกลางที่เราเพิ่งสร้างใน Site.css --%>
    <div class="main-content-centered">

        <%-- 2. ส่วนต้อนรับ (เหมือนรูปที่ 1) --%>
        <h2> Welcome! 👋</h2>
        <p class="lead">Use the search form below or the navigation bar to manage cars, customers, and rental records.</p>

        <hr />

        <%-- 3. ส่วนค้นหา --%>
        <h3>ค้นหารถเช่า</h3>
        <div class="row">
            <%-- (เราจะจัดคอลัมน์ใหม่ให้อยู่กึ่งกลาง โดยใช้ offset) --%>
            <div class="col-md-3 col-md-offset-1">
                <label>เลือกสาขา:</label>
                <asp:DropDownList ID="ddlPickupBranch" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>
            <div class="col-md-3">
                <label>วันที่รับรถ:</label>
                <asp:TextBox ID="txtPickupDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <label>วันที่คืนรถ:</label>
                <asp:TextBox ID="txtReturnDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
            </div>
            <div class="col-md-2">
                <br />
                <asp:Button ID="btnSearch" runat="server" Text="ค้นหารถ" CssClass="btn btn-primary btn-lg" OnClick="btnSearch_Click" />
            </div>
        </div>

        <%-- (เราลบ <hr /> และ <div class="row">...</div> ของ Dashboard ออกจากตรงนี้) --%>

    </div>
    <%-- ปิด .main-content-centered --%>
</asp:Content>