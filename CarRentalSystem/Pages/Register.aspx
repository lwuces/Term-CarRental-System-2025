<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="CarRentalSystem.Pages.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3>ลงทะเบียนสมาชิกใหม่</h3>
                </div>
                <div class="panel-body">
                    <div class="form-group">
                        <label>ชื่อจริง:</label>
                        <asp:TextBox ID="txtRegFirstName" runat="server" CssClass="form-control" Required="true"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>นามสกุล:</label>
                        <asp:TextBox ID="txtRegLastName" runat="server" CssClass="form-control" Required="true"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>อีเมล (ใช้สำหรับ Login):</label>
                        <asp:TextBox ID="txtRegEmail" runat="server" CssClass="form-control" TextMode="Email" Required="true"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>เบอร์โทรศัพท์:</label>
                        <asp:TextBox ID="txtRegTel" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>รหัสผ่าน:</label>
                        <asp:TextBox ID="txtRegPassword" runat="server" CssClass="form-control" TextMode="Password" Required="true"></asp:TextBox>
                    </div>
                    <br />
                    <asp:Button ID="btnRegister" runat="server" Text="ยืนยันการลงทะเบียน" CssClass="btn btn-success btn-lg" OnClick="btnRegister_Click" />
                    <asp:Label ID="lblRegStatus" runat="server" EnableViewState="false" CssClass="pull-right"></asp:Label>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
