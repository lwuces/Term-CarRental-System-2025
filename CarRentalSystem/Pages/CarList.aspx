<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Site.Master" AutoEventWireup="true" CodeBehind="CarList.aspx.cs" Inherits="CarRentalSystem.Pages.CarList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">

        <%-- --------------------------------------- --%>
        <%-- คอลัมน์ซ้าย: ฟิลเตอร์ (Sidebar) --%>
        <%-- --------------------------------------- --%>
        <div class="col-md-3">
            <h4><span class="glyphicon glyphicon-filter"></span>กรองผลลัพธ์</h4>
            <hr />

            <%-- 1. ฟิลเตอร์ "เกียร์" (Gear) --%>
            <div class="form-group">
                <label>เกียร์:</label>
                <asp:RadioButtonList ID="rblGear" runat="server"
                    CssClass="toggle-buttons" RepeatDirection="Horizontal"
                    AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                    <asp:ListItem Value="" Selected="True">ทั้งหมด</asp:ListItem>
                    <asp:ListItem Value="Auto">Auto</asp:ListItem>
                    <asp:ListItem Value="Manual">Manual</asp:ListItem>
                </asp:RadioButtonList>
            </div>

            <%-- 2. ฟิลเตอร์ "ยี่ห้อ" (Brand) --%>
            <div class="form-group">
                <label>ยี่ห้อรถ:</label>
                <asp:CheckBoxList ID="cblBrands" runat="server"
                    CssClass="toggle-buttons" RepeatDirection="Horizontal" RepeatColumns="2"
                    AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                    <%-- (ข้อมูลมาจาก DB) --%>
                </asp:CheckBoxList>
            </div>

            <%-- 3. ฟิลเตอร์ "ประเภทรถ" (Car Type) --%>
            <div class="form-group">
                <label>ประเภทรถ:</label>
                <asp:CheckBoxList ID="cblTypes" runat="server"
                    CssClass="toggle-buttons"
                    AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                    <%-- (ข้อมูลมาจาก DB) --%>
                </asp:CheckBoxList>
            </div>

            <%-- 4. ฟิลเตอร์ "ความจุเครื่องยนต์" (EngineCC) --%>
            <div class="form-group">
                <label>ความจุเครื่องยนต์:</label>
                <asp:RadioButtonList ID="rblEngine" runat="server" CssClass="toggle-buttons"
                    AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                    <asp:ListItem Value="" Selected="True">ทั้งหมด</asp:ListItem>
                    <asp:ListItem Value="1200">ต่ำกว่า 1400cc</asp:ListItem>
                    <asp:ListItem Value="1500">1400cc - 1800cc</asp:ListItem>
                    <asp:ListItem Value="2000">มากกว่า 1800cc</asp:ListItem>
                </asp:RadioButtonList>
            </div>

            <%-- (เราลบปุ่ม btnFilter ทิ้ง แล้วใช้ AutoPostBack แทน) --%>
        </div>


        <%-- --------------------------------------- --%>
        <%-- คอลัมน์ขวา: รายการรถ (Catalog) --%>
        <%-- --------------------------------------- --%>
        <div class="col-md-9">

            <%-- 5. ส่วน "เรียงลำดับ" (Sorting) --%>
            <div class="row">
                <div class="col-md-5 pull-right">
                    <div class="form-group">
                        <label class="control-label" style="margin-right: 10px;">เรียงลำดับโดย:</label>
                        <asp:DropDownList ID="ddlSortBy" runat="server"
                            CssClass="form-control" Style="display: inline-block; width: auto;"
                            AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                            <asp:ListItem Value="PriceAsc">ราคา - ต่ำไปสูง</asp:ListItem>
                            <asp:ListItem Value="PriceDesc">ราคา - สูงไปต่ำ</asp:ListItem>
                            <asp:ListItem Value="ModelAz">ชื่อ - A-Z</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <hr style="margin-top: 0;" />

            <%-- 6. ส่วนแสดงผล Repeater (เหมือนเดิม) --%>
            <asp:Repeater ID="Repeater1" runat="server" OnItemCommand="Repeater1_ItemCommand">
                <HeaderTemplate>
                    <div class="row">
                </HeaderTemplate>
                <ItemTemplate>
                    <div class="col-md-4" style="margin-bottom: 20px;">
                        <div class="panel panel-default">
                            <div class="panel-body">
                                <h4><%# Eval("Model") %></h4>
                                <p><%# Eval("TypeName") %> / <%# Eval("Gear") %> / <%# Eval("EngineCC") %>cc</p>
                                <h3 class="text-primary">฿ <%# Eval("DailyRate", "{0:N0}") %> / วัน
                                </h3>
                                <asp:Button ID="btnBook" runat="server"
                                    Text="จองเลย"
                                    CssClass="btn btn-success btn-block"
                                    CommandName="Select"
                                    CommandArgument='<%# Eval("CarID") %>' />
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    </div>
               
                </FooterTemplate>
            </asp:Repeater>

            <asp:Label ID="lblNoResults" runat="server" Text="ไม่พบรถยนต์ที่ตรงตามเงื่อนไข"
                Visible="false" CssClass="alert alert-warning"></asp:Label>

        </div>
    </div>

</asp:Content>
