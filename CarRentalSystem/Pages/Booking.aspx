<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="Booking.aspx.cs" Inherits="CarRentalSystem.Pages.Booking" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <%-- ใช้ class ที่เราสร้างใน Site.css เพื่อจัดกลาง --%>
    <div class="main-content-centered">

        <div class="panel panel-default">
            <div class="panel-heading">
                <h3>Booking Summary</h3>
            </div>
            <div class="panel-body" style="text-align: left; padding: 25px;">

                <%-- ================================================ --%>
                <%-- VV นี่คือส่วนที่เพิ่มเข้ามาเพื่อแก้ Error VV --%>
                <h4>Customer Details</h4>
                <div class="form-group">
                    <label>ผู้เช่า:</label>
                    <h4><asp:Label ID="lblCustomerName" runat="server" Text="[Customer Name]"></asp:Label></h4>
                </div>
                <%-- ^^ สิ้นสุดส่วนที่เพิ่ม ^^ --%>
                <%-- ================================================ --%>

                <h4>Car & Rental Details</h4>
                <hr style="margin-top: 10px;" />

                <%-- ใช้ตารางแบบง่ายเพื่อจัดแถวให้สวยงาม --%>
                <table class="table table-borderless">
                    <tr>
                        <td style="width: 30%;"><strong>Vehicle:</strong></td>
                        <td>
                            <asp:Label ID="lblModel" runat="server" Text="[Model]"></asp:Label></td>
                    </tr>
                    <tr>
                        <td><strong>Plate Number:</strong></td>
                        <td>
                            <asp:Label ID="lblLicensePlate" runat="server" Text="[LicensePlate]"></asp:Label></td>
                    </tr>
                    <tr>
                        <td><strong>Branch:</strong></td>
                        <td>
                            <asp:Label ID="lblBranch" runat="server" Text="[Branch]"></asp:Label></td>
                    </tr>
                    <tr>
                        <td><strong>Pick-up Date:</strong></td>
                        <td>
                            <asp:Label ID="lblStartDate" runat="server" Text="[Date]"></asp:Label></td>
                    </tr>
                    <tr>
                        <td><strong>Return Date:</strong></td>
                        <td>
                            <asp:Label ID="lblReturnDate" runat="server" Text="[Date]"></asp:Label></td>
                    </tr>
                    <tr>
                        <td><strong>Rental Days:</strong></td>
                        <td>
                            <asp:Label ID="lblDays" runat="server" Text="0"></asp:Label>
                            วัน</td>
                    </tr>
                    <tr>
                        <td><strong>Daily Rate:</strong></td>
                        <td>
                            <asp:Label ID="lblRate" runat="server" Text="0.00"></asp:Label>
                            ฿</td>
                    </tr>

                    <%-- แถวสรุป Total Cost --%>
                    <tr style="font-size: 1.2em; border-top: 2px solid #eee;">
                        <td><strong>Total Cost:</strong></td>
                        <td><strong class="text-danger">
                            <asp:Label ID="lblTotalCost" runat="server" Text="0.00"></asp:Label>
                            ฿</strong></td>
                    </tr>
                </table>

                <%-- ส่วนของ Form ที่ซ่อนไว้ (เราจะย้าย txtStartDate/ReturnDate มาที่นี่) --%>
                <asp:Panel ID="pnlFormInput" runat="server" Visible="true">
                    <hr />
                    <h4>เลือกวันรับ-คืนรถ</h4>
                    <div class="form-group">
                        <label>วันที่รับรถ (Pick-up):</label>
                        <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control" TextMode="Date" AutoPostBack="true" OnTextChanged="Date_Changed"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>วันที่คืนรถ (Return):</label>
                        <asp:TextBox ID="txtReturnDate" runat="server" CssClass="form-control" TextMode="Date" AutoPostBack="true" OnTextChanged="Date_Changed"></asp:TextBox>
                    </div>
                </asp:Panel>

                <hr />
                <%-- ปุ่มยืนยัน --%>
                <asp:Button ID="btnConfirmBooking" runat="server" Text="Confirm Booking"
                    CssClass="btn btn-primary btn-lg btn-block" OnClick="btnConfirmBooking_Click" Enabled="false" />

                <%-- ใช้แสดงข้อความ Error --%>
                <asp:Label ID="lblStatus" runat="server" Text="" EnableViewState="false" CssClass="text-danger"></asp:Label>
            </div>
        </div>
    </div>

</asp:Content>