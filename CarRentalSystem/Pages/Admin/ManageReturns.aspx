<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="ManageReturns.aspx.cs" Inherits="CarRentalSystem.Pages.Admin.ManageReturns" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="main-content-centered" style="max-width: 1000px;">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3>Process Car Returns</h3>
            </div>
            <div class="panel-body">
                <%-- (แสดงข้อความ เมื่อคืนรถสำเร็จ) --%>
                <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success">
                    ✅ <strong>Return Confirmed!</strong> The car is now available.
               
                </asp:Panel>

                <asp:GridView ID="gvActiveRentals" runat="server" CssClass="table table-hover"
                    AutoGenerateColumns="False" DataKeyNames="RentalID"
                    OnRowCommand="gvActiveRentals_RowCommand"
                    GridLines="None" BorderStyle="None">
                    <Columns>
                        <asp:BoundField DataField="RentalID" HeaderText="Rental ID" />
                        <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                        <asp:BoundField DataField="Model" HeaderText="Vehicle" />
                        <asp:BoundField DataField="LicensePlate" HeaderText="Plate" />
                        <asp:BoundField DataField="StartDate" HeaderText="Start Date" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:BoundField DataField="ExpectedReturnDate" HeaderText="Expected Return" DataFormatString="{0:yyyy-MM-dd}" />

                        <%-- ปุ่มสำหรับ "เริ่ม" กระบวนการคืนรถ --%>
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:Button ID="btnProcessReturn" runat="server" Text="Process Return"
                                    CssClass="btn btn-warning btn-xs"
                                    CommandName="ProcessReturn"
                                    CommandArgument='<%# Eval("RentalID") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle CssClass="table-header-custom" />
                    <EmptyDataTemplate>
                        <div class="alert alert-info">There are no cars currently rented out.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
