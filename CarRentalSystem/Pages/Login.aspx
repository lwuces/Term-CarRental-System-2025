<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="CarRentalSystem.Pages.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="login-page-wrapper">
        <div class="main-content-centered">
            
            <div class="login-card panel panel-default">
                
                <h3>เข้าสู่ระบบ</h3>
                <p style="color: #777; margin-bottom: 25px;">กรุณากรอกข้อมูลเพื่อเข้าใช้งาน</p>

                <div class="panel-body">
                    
                    <%-- (ลบ .form-wrapper) --%>
                        
                    <div class="form-group">
                        <div class="input-group">
                            <span class="input-group-addon">
                                <span class="glyphicon glyphicon-envelope"></span>
                            </span>
                            <asp:TextBox ID="txtLoginEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="อีเมล"></asp:TextBox>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <div class="input-group">
                            <span class="input-group-addon">
                                <span class="glyphicon glyphicon-lock"></span>
                            </span>
                            <asp:TextBox ID="txtLoginPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="รหัสผ่าน"></asp:TextBox>
                        </div>
                    </div>

                    <br /> 

                    <asp:Button ID="btnLogin" runat="server" Text="เข้าสู่ระบบ" CssClass="btn btn-primary btn-block" OnClick="btnLogin_Click" />
                    <asp:Label ID="lblLoginStatus" runat="server" ForeColor="Red" EnableViewState="false" CssClass="text-danger" style="display: block; margin-top: 10px;"></asp:Label>
                
                    <%-- (ปิด .form-wrapper) --%>

                </div>
                
                <div class="panel-footer" style="padding-top: 20px;">
                    ยังไม่เป็นสมาชิก? 
                    <a href="Register.aspx">ลงทะเบียนที่นี่</a>
                </div>
            </div>
        </div>
    </div> 

</asp:Content>