<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="ReturnSummary.aspx.cs" Inherits="CarRentalSystem.Pages.Admin.ReturnSummary" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="main-content-centered">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3>Confirm Return & Calculate Fees</h3>
            </div>
            <div class="panel-body" style="text-align: left; padding: 25px;">
                
                <h4>Rental Details</h4>
                <table class="table table-borderless">
                    <tr><td style="width: 30%;"><strong>Customer:</strong></td>
                        <td><asp:Label ID="lblCustomerName" runat="server"></asp:Label></td></tr>
                    <tr><td><strong>Vehicle:</strong></td>
                        <td><asp:Label ID="lblCarModel" runat="server"></asp:Label></td></tr>
                    <tr><td><strong>Plate:</strong></td>
                        <td><asp:Label ID="lblLicensePlate" runat="server"></asp:Label></td></tr>
                </table>
                <hr />
                
                <h4>Fee Calculation</h4>
                <table class="table table-borderless">
                    <tr><td style="width: 30%;"><strong>Expected Return:</strong></td>
                        <td><asp:Label ID="lblExpectedReturn" runat="server"></asp:Label></td></tr>
                    <tr><td><strong>Actual Return:</strong></td>
                        <td><asp:Label ID="lblActualReturn" runat="server"></asp:Label> (Today)</td></tr>
                    <tr><td><strong>Original Cost:</strong></td>
                        <td><asp:Label ID="lblOriginalFee" runat="server"></asp:Label> ฿</td></tr>
                    
                    <%-- (ส่วนของค่าปรับ) --%>
                    <tr class="warning">
                        <td><strong>Late Days:</strong></td>
                        <td><asp:Label ID="lblLateDays" runat="server" Text="0"></asp:Label> วัน</td>
                    </tr>
                    <tr class="warning">
                        <td><strong>Late Fee (150%):</strong></td>
                        <td><asp:Label ID="lblLateFee" runat="server" Text="0.00"></asp:Label> ฿</td>
                    </tr>
                    
                    <tr style="font-size: 1.2em; border-top: 2px solid #eee;">
                        <td><strong>New Total Cost:</strong></td>
                        <td><strong class="text-danger"><asp:Label ID="lblTotalCost" runat="server"></asp:Label> ฿</strong></td>
                    </tr>
                </table>
                <hr />
                
                <asp:Button ID="btnConfirmReturn" runat="server" Text="Confirm Return" 
                    CssClass="btn btn-success btn-lg btn-block" OnClick="btnConfirmReturn_Click" />
                <asp:Label ID="lblStatus" runat="server" EnableViewState="false" CssClass="text-danger"></asp:Label>
            </div>
        </div>
    </div>
</asp:Content>
