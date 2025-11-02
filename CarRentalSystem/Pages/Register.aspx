<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="CarRentalSystem.Pages.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="login-page-wrapper">
        <div class="main-content-centered">
            
            <div class="login-card panel panel-default" style="max-width: 450px;">
                
                <h3>สร้างบัญชีใหม่</h3>
                <p style="color: #777; margin-bottom: 25px;">กรอกข้อมูลเพื่อลงทะเบียน</p>

                <div class="panel-body" style="padding:0;">
                    
                    <%-- (ลบ .form-wrapper) --%>
                    
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

                    <asp:Button ID="btnRegister" runat="server" Text="ยืนยันการลงทะเบียน" CssClass="btn btn-success btn-lg btn-block" OnClick="btnRegister_Click" />
                    <asp:Label ID="lblRegStatus" runat="server" EnableViewState="false" CssClass="text-danger" style="display: block; text-align: center; margin-top: 10px;"></asp:Label>

                    <%-- (ปิด .form-wrapper) --%>
                
                </div>
                
                <div class="panel-footer" style="padding-top: 20px;">
                    มีบัญชีอยู่แล้ว? 
                    <a href="Login.aspx">เข้าสู่ระบบที่นี่</a>
                </div>
            </div>
        </div>
    
    </div> 

</asp:Content>