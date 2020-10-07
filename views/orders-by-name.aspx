<%@ Page Language="AVR" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" ValidateRequest="false"
    CodeFile="orders-by-name.aspx.vr" Inherits="views_orders_by_name" Title="Untitled Page" %>

<%@ Register Src="~/user-controls/orders-pages-nav.ascx" TagPrefix="uc1" TagName="orderspagesnav" %>

<%@ Import Namespace="asna.entities" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="navPlaceholder" runat="Server">
    <uc1:orderspagesnav runat="server" ID="orderspagesnav" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="bodyPlaceHolder" runat="Server">
    <main class="bg-gray-200 overflow-y-scroll">

        <div id="page-data-controls" class="mb-3">
            <button class="bg-gray-400 hover:bg-gray-300 text-gray-900 font-bold py-2 px-4 rounded inline-flex items-center">
                <svg aria-hidden="true" focusable="false" data-prefix="fas" data-icon="chevron-double-left"
                    class="w-4 svg-inline--fa fa-chevron-double-left fa-w-16" role="img" xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 512 512">
                    <path fill="currentColor" d="M34.5 239L228.9 44.7c9.4-9.4 24.6-9.4 33.9 0l22.7 22.7c9.4 9.4 9.4 24.5 0 33.9L131.5 256l154 154.7c9.3 9.4 9.3 24.5 0 33.9l-22.7 22.7c-9.4 9.4-24.6 9.4-33.9 0L34.5 273c-9.3-9.4-9.3-24.6 0-34zm192 34l194.3 194.3c9.4 9.4 24.6 9.4 33.9 0l22.7-22.7c9.4-9.4 9.4-24.5 0-33.9L323.5 256l154-154.7c9.3-9.4 9.3-24.5 0-33.9l-22.7-22.7c-9.4-9.4-24.6-9.4-33.9 0L226.5 239c-9.3 9.4-9.3 24.6 0 34z">
                    </path></svg>
            </button>

            <button class="bg-gray-400 hover:bg-gray-300 text-gray-900 font-bold py-2 px-4 rounded inline-flex items-center">
                <svg aria-hidden="true" focusable="false" data-prefix="fas" data-icon="chevron-left"
                    class="w-4 svg-inline--fa fa-chevron-left fa-w-10" role="img" xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 512 512">
                    <path fill="currentColor" d="M34.52 239.03L228.87 44.69c9.37-9.37 24.57-9.37 33.94 0l22.67 22.67c9.36 9.36 9.37 24.52.04 33.9L131.49 256l154.02 154.75c9.34 9.38 9.32 24.54-.04 33.9l-22.67 22.67c-9.37 9.37-24.57 9.37-33.94 0L34.52 272.97c-9.37-9.37-9.37-24.57 0-33.94z">
                    </path></svg>
            </button>

            <asp:LinkButton ID="show_next_page" runat="server" CssClass="bg-gray-400 hover:bg-gray-300 text-gray-900 font-bold py-2 px-4 rounded inline-flex items-center" CommandName="show_next_page">
                            <svg aria-hidden="true" focusable="false" data-prefix="fas" data-icon="chevron-right"
                                class="w-4 svg-inline--fa fa-chevron-right fa-w-10" role="img" xmlns="http://www.w3.org/2000/svg"
                                viewBox="0 0 512 512">
                                <path fill="currentColor" d="M285.476 272.971L91.132 467.314c-9.373 9.373-24.569 9.373-33.941 0l-22.667-22.667c-9.357-9.357-9.375-24.522-.04-33.901L188.505 256 34.484 101.255c-9.335-9.379-9.317-24.544.04-33.901l22.667-22.667c9.373-9.373 24.569-9.373 33.941 0L285.475 239.03c9.373 9.372 9.373 24.568.001 33.941z">
                                </path></svg>
            </asp:LinkButton>

            <button class="bg-gray-400 hover:bg-gray-300 text-gray-900 font-bold py-2 px-4 rounded inline-flex items-center">
                <svg aria-hidden="true" focusable="false" data-prefix="fas" data-icon="chevron-double-right"
                    class="w-4 svg-inline--fa fa-chevron-double-right fa-w-16" role="img" xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 512 512">
                    <path fill="currentColor" d="M477.5 273L283.1 467.3c-9.4 9.4-24.6 9.4-33.9 0l-22.7-22.7c-9.4-9.4-9.4-24.5 0-33.9l154-154.7-154-154.7c-9.3-9.4-9.3-24.5 0-33.9l22.7-22.7c9.4-9.4 24.6-9.4 33.9 0L477.5 239c9.3 9.4 9.3 24.6 0 34zm-192-34L91.1 44.7c-9.4-9.4-24.6-9.4-33.9 0L34.5 67.4c-9.4 9.4-9.4 24.5 0 33.9l154 154.7-154 154.7c-9.3 9.4-9.3 24.5 0 33.9l22.7 22.7c9.4 9.4 24.6 9.4 33.9 0L285.5 273c9.3-9.4 9.3-24.6 0-34z">
                    </path></svg>
            </button>

            <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
            <button id="submitform">click me</button>
        </div>


        <div id="main-content" class="">
            <asp:ListView ID="listviewCustomers" runat="server" OnItemCommand="listviewCustomersRowAction">
                <LayoutTemplate>


                    <div id="main-content" class="mb-3">


                        <div class="heading-row mb-4 bg-gray-300">
                            <div class="col-sm heading">
                                Name
                            </div>
                            <div class="col-md heading">
                                City, State, Zip
                            </div>
                            <div class="col-sm heading">
                                Actions
                            </div>
                        </div>

                    </div>

                    <asp:PlaceHolder runat="server" ID="itemPlaceholder" />
                </LayoutTemplate>

                <ItemTemplate>
                    <div class="data-row <%# Utility.GetEvenOddClass(Container.DataItemIndex) %>">
                        <div>
                            <%# (Container.DataItem *As Cmastnewl2_Buffer).cmname.Trim() %>
                        </div>
                        <div>
                            <%# (Container.DataItem *As Cmastnewl2_Buffer).cmcity.Trim() ++
                                  ", " ++ (Container.DataItem *As Cmastnewl2_Buffer).cmstate.Trim() ++
                                 " " + (Container.DataItem *As Cmastnewl2_Buffer).cmpostcode %>
                        </div>
                        <div>
                            <asp:LinkButton ID="linkbuttonUpdate" class="btn-1" runat="server"
                                CommandArgument="<%# Container.DisplayIndex %>" CommandName="showorders">Orders</asp:LinkButton>
                            <asp:LinkButton ID="linkbuttonEmail" class="btn-2" runat="server"
                                CommandArgument="<%# Container.DisplayIndex %>" CommandName="edit">Edit</asp:LinkButton>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:ListView>
        </div>
    </main>
    <input type="hidden" name="allhtml" id="allhtml" />
    
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="scriptPlaceHolder" runat="Server">
    <script src="../dist/js/index.js" defer></script>
</asp:Content>


