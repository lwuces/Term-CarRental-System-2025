<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="CarRentalSystem.Pages.Admin.Dashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="main-content-centered">
        <h2>Admin Dashboard</h2>
        <p>Welcome, <%: Session["CustomerName"] %>!</p>
        <hr />
        
        <div class="row">
            <div class="col-md-4">
                <div class="dashboard-card">
                    <h4>Total Cars</h4>
                    <asp:Label ID="lblTotalCars" runat="server" Text="0" CssClass="dashboard-number"></asp:Label>
                </div>
            </div>
            <div class="col-md-4">
                <div class="dashboard-card">
                    <h4>Customers</h4>
                    <asp:Label ID="lblTotalCustomers" runat="server" Text="0" CssClass="dashboard-number"></asp:Label>
                </div>
            </div>
            <div class="col-md-4">
                <div class="dashboard-card">
                    <h4>Active Rentals</h4>
                    <asp:Label ID="lblActiveRentals" runat="server" Text="0" CssClass="dashboard-number"></asp:Label>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
