<%@ Control Language="AVR" AutoEventWireup="false" CodeFile="orders-pages-nav.ascx.vr" Inherits="orders_pages_nav" %>

    <nav class="bg-gray-500">
        <div id="sub-nav" class="flex flex-col items-start pt-4 pl-4 text-gray-700">
            <div class="pb-1 pr-4">
                <span class="text-xl text-gray-800 pb-2">Show customers by</span>
            </div>
            <a href="./orders-by-name.aspx" data-action="page-action" id="orders-by-name" class=""><span class="pl-3 text-lg">Name</span></a>
            <a href="./orders-by-address.aspx" data-action="page-action" id="orders-by-address" class=""><span class="pl-3 text-lg">Address</span></a>
            <a href="#" data-action="page-action" id="orders-by-sales" class=""><span class="pl-3 text-lg">Sales</span></a>
            <div class="pb-1 pr-4 pt-2">
                <span class="text-xl text-gray-800 pt-4 pb-2">Show orders by</span>
            </div>
            <a href="#" data-action="page-action" id="back-orders-by-name" class=""><span class="pl-3 text-lg">Name</span></a>
            <a href="#" data-action="page-action" id="back-orders-by-sales" class=""><span class="pl-3 text-lg">Sales</span></a>
        </div>
    </nav>            
