<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="MyRentals.aspx.cs" Inherits="CarRentalSystem.Pages.MyRentals" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h3>My Confirmed Rentals</h3>

    <%-- (ใหม่) ส่วนนี้จะแสดงข้อความ "Booking Confirmed" ถ้าถูกส่งมาจากหน้า Booking --%>
    <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success">
        ✅ <strong>Booking Confirmed!</strong> Your rental details are below.
   
    </asp:Panel>

    <%-- เราจะใช้ GridView เพื่อสร้างตารางให้เหมือนในรูป --%>
    <asp:GridView ID="GridView1" runat="server"
        AutoGenerateColumns="False"
        CssClass="table table-hover"
        GridLines="None"
        HeaderStyle-CssClass="table-header-custom">
        <Columns>
            <asp:BoundField DataField="BookingDate" HeaderText="Booking Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
            <asp:BoundField DataField="LicensePlate" HeaderText="Plate" />

            <%-- เราใช้ TemplateField เพื่อใส่ HTML (<strong>) ได้ --%>
            <asp:TemplateField HeaderText="Vehicle">
                <ItemTemplate>
                    <strong><%# Eval("Model") %></strong>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:BoundField DataField="BranchName" HeaderText="Branch" />
            <asp:BoundField DataField="StartDate" HeaderText="Start Date" DataFormatString="{0:yyyy-MM-dd}" />
            <asp:BoundField DataField="ExpectedReturnDate" HeaderText="End Date" DataFormatString="{0:yyyy-MM-dd}" />
            <asp:BoundField DataField="Days" HeaderText="Days" />
            <asp:BoundField DataField="TotalFee" HeaderText="Total Cost ($)" DataFormatString="{0:N0}" />
        </Columns>
        <EmptyDataTemplate>
            <div class="alert alert-info">You do not have any rental history.</div>
        </EmptyDataTemplate>
    </asp:GridView>

</asp:Content>
