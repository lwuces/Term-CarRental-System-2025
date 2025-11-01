<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="CarRentalSystem.Pages.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3>เข้าสู่ระบบ</h3>
                </div>
                <div class="panel-body">
                    <div class="form-group">
                        <label>อีเมล:</label>
                        <asp:TextBox ID="txtLoginEmail" runat="server" CssClass="form-control" TextMode="Email"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>รหัสผ่าน:</label>
                        <asp:TextBox ID="txtLoginPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                    </div>
                    <br />
                    <asp:Button ID="btnLogin" runat="server" Text="เข้าสู่ระบบ" CssClass="btn btn-primary" OnClick="btnLogin_Click" />
                    <asp:Label ID="lblLoginStatus" runat="server" ForeColor="Red" EnableViewState="false" CssClass="pull-right"></asp:Label>
                </div>
                <div class="panel-footer">
                    <%-- นี่คือส่วนที่คุณขอ: ตัวเลือกลงทะเบียน --%>
                    ยังไม่เป็นสมาชิก? 
                   
                    <a href="Register.aspx">ลงทะเบียนที่นี่</a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
