<%-- 
    Document   : view_bill.jsp
    Created on : May 6, 2025, 10:18:44 AM
    Author     : RasinduPerera
--%>

<%@ page import="java.util.*, model.*, java.text.SimpleDateFormat, java.sql.Timestamp" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<html>
<head>
    <title>Bill</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        @media print {
            .no-print { display: none; }
            .bill-container { width: 100%; }
            .selected-bills { display: block !important; }
            .unselected-bills { display: none !important; }
            .print-bill {
                border: none !important;
                box-shadow: none !important;
            }
            .print-bill .table {
                border: 1px solid #000 !important;
            }
            .print-bill .table th,
            .print-bill .table td {
                border: 1px solid #000 !important;
            }
            .print-instructions {
                display: none !important;
            }
            .selected-items-container {
                display: none !important;
            }
        }
        .bill-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            padding-bottom: 100px; /* Add padding for the fixed bottom bar */
        }
        .order-section {
            margin-bottom: 30px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .selected-bills {
            display: block !important;
        }
        .unselected-bills {
            display: none;
        }
        .print-bill {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .bill-header {
            text-align: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #000;
        }
        .bill-footer {
            margin-top: 20px;
            padding-top: 10px;
            border-top: 2px solid #000;
        }
        .selected-items-container {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            background: white;
            padding: 15px;
            box-shadow: 0 -2px 10px rgba(0,0,0,0.1);
            z-index: 1000;
            display: none;
        }
        .selected-items-container .btn {
            margin-left: 10px;
        }
        .print-instructions {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .print-instructions ol {
            margin-bottom: 0;
        }
        .print-instructions li {
            margin-bottom: 5px;
        }
        .total-display {
            font-size: 1.2em;
            font-weight: bold;
            color: #28a745;
        }
    </style>
    <script>
        const calculateSelectedTotal = () => {
            let total = 0;
            document.querySelectorAll('.selected-bills').forEach(bill => {
                const totalElement = bill.querySelector('.bill-total');
                if (totalElement) {
                    total += parseFloat(totalElement.dataset.total);
                }
            });
            const formattedTotal = 'Rs. ' + total.toFixed();
            document.getElementById('selected-total').textContent = formattedTotal;
            const container = document.getElementById('selected-items-container');
            if (total > 0) {
                container.style.display = 'block';
            } else {
                container.style.display = 'none';
            }
        };
        // Store the values in global variables when the page loads
        const tableNumber = '<%= request.getAttribute("tableId") %>'; // Will be string "null" if attribute is null
        const currentDate = '<%= sdf.format(new Date()) %>';
        
        const printSelectedBills = () => {
            const selectedBills = document.querySelectorAll('.selected-bills');
            if (selectedBills.length === 0) {
                alert('Please select at least one bill to print');
                return;
            }

            // Get the selected total from the span
            const selectedTotal = document.getElementById('selected-total').textContent;

            // Prepare table number for printing
            let tableNumStr = tableNumber ? String(tableNumber).trim() : "";
            let tableNumForPrint = tableNumStr;
            if (tableNumStr === 'null' || tableNumStr === '' || tableNumStr.toLowerCase() === 'false') {
                tableNumForPrint = 'N/A';
            }

            // Prepare date for printing - format to match thermal receipt style
            const now = new Date();
            const dateForPrint = now.toLocaleDateString('en-US', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric'
            }) + ', ' + now.toLocaleTimeString('en-US', {
                hour: '2-digit',
                minute: '2-digit',
                hour12: true
            });

            // Create print content for thermal printer style
            let printHTML = '<!DOCTYPE html><html><head><title>Restaurant Bill</title><style>';
            printHTML += 'body { font-family: "Courier New", monospace; margin: 0; padding: 10px; font-size: 12px; width: 80mm; }';
            printHTML += '.receipt { width: 100%; }';
            printHTML += '.header { text-align: center; margin-bottom: 10px; }';
            printHTML += '.header h1 { font-size: 16px; font-weight: bold; margin: 0; }';
            printHTML += '.header p { margin: 2px 0; font-size: 12px; }';
            printHTML += '.info { margin: 10px 0; border-top: 1px dashed #000; border-bottom: 1px dashed #000; padding: 5px 0; }';
            printHTML += '.info p { margin: 2px 0; display: flex; justify-content: space-between; }';
            printHTML += '.items { width: 100%; }';
            printHTML += '.item { display: flex; justify-content: space-between; margin-bottom: 5px; }';
            printHTML += '.item-name { flex: 1; }';
            printHTML += '.item-qty { width: 40px; text-align: center; }';
            printHTML += '.item-amt { width: 80px; text-align: right; }';
            printHTML += '.subtotal { margin-top: 10px; padding-top: 5px; border-top: 1px dashed #000; }';
            printHTML += '.subtotal p { display: flex; justify-content: space-between; margin: 2px 0; }';
            printHTML += '.total { font-weight: bold; font-size: 14px; margin-top: 5px; }';
            printHTML += '.payment { margin-top: 10px; padding-top: 5px; border-top: 1px dashed #000; }';
            printHTML += '.payment p { margin: 2px 0; }';
            printHTML += '.footer { text-align: center; margin-top: 10px; font-size: 10px; }';
            printHTML += '</style></head><body><div class="receipt">';
            
            // Restaurant header
            printHTML += '<div class="header">';
            printHTML += '<h1>China Pearl Restaurant</h1>';
            printHTML += '<p>No. 27 Galle Road,Wellawatte</p>';
            printHTML += '<p>COLOMBO, SRI LANKA</p>';
            printHTML += '<p>PHONE: 077-1234567</p>';
           
            printHTML += '<h2>Invoice</h2>';
            printHTML += '</div>';
            
            // Bill info
            printHTML += '<div class="info">';
            printHTML += '<p><span>Date:</span> <span>' + dateForPrint + '</span></p>';
            printHTML += '<p><span>Table No:</span> <span>' + tableNumForPrint + '</span></p>';
            printHTML += '<p><span>Bill No:</span> <span>TB' + Math.floor(Math.random() * 1000) + '</span></p>';
            printHTML += '<p><span>Payment Mode:</span> <span>Cash</span></p>';
            printHTML += '</div>';
            
            // Items header
            printHTML += '<div class="items-header">';
            printHTML += '<div class="item" style="font-weight: bold; border-bottom: 1px solid #000;">';
            printHTML += '<span class="item-name">Item</span>';
            printHTML += '<span class="item-qty">Qty</span>';
            printHTML += '<span class="item-amt">Amt</span>';
            printHTML += '</div>';
            printHTML += '</div>';
            
            // Items from selected bills
            let allItems = [];
            let subTotal = 0;
            
            selectedBills.forEach(bill => {
                const rows = bill.querySelectorAll('tbody tr');
                rows.forEach(row => {
                    const cells = row.querySelectorAll('td');
                    if (cells.length >= 4) {
                        const itemName = cells[0].textContent.trim();
                        const qty = cells[1].textContent.trim();
                        // Remove currency symbol and convert to number
                        const amt = parseFloat(cells[3].textContent.replace('Rs.', '').trim());
                        
                        allItems.push({itemName, qty, amt});
                        subTotal += amt;
                    }
                });
            });
            
            // Print all items
            allItems.forEach(item => {
                printHTML += '<div class="item">';
                printHTML += '<span class="item-name">' + item.itemName + '</span>';
                printHTML += '<span class="item-qty">' + item.qty + '</span>';
                printHTML += '<span class="item-amt">' + item.amt.toFixed(2) + '</span>';
                printHTML += '</div>';
            });
            
            // Calculate subtotal and taxes
            const discount = Math.round(subTotal * 0.03); // 3% discount 
            const taxableValue = subTotal - discount;
            const cgst = Math.round(taxableValue * 0.025); // 2.5% tax
            const sgst = Math.round(taxableValue * 0.025); // 2.5% tax
            const total = Math.round(taxableValue + cgst + sgst);
            
            // Subtotal and calculations
            printHTML += '<div class="subtotal">';
            printHTML += '<p><span>Total</span> <span>' + subTotal.toFixed(2) + '</span></p>';
            // printHTML += '<p><span>(-) Discount</span> <span>' + discount.toFixed(2) + '</span></p>';
            // printHTML += '<p><span>CGST @ 2.5%</span> <span>' + cgst.toFixed(2) + '</span></p>';
            // printHTML += '<p><span>SGST @ 2.5%</span> <span>' + sgst.toFixed(2) + '</span></p>';
            
            // Final total
            // printHTML += '<p class="total"><span>TOTAL</span> <span>Rs ' + total.toFixed(2) + '</span></p>';
            // printHTML += '</div>';
            
            // Payment details
            // printHTML += '<div class="payment">';
            // printHTML += '<p><span>Cash:</span> <span>Rs ' + total.toFixed(2) + '</span></p>';
            
            // printHTML += '</div>';
            
            // Footer
            printHTML += '<div class="footer">';
            
            printHTML += '<p>Thank you for your visit!</p>';
            printHTML += '</div>';
            
            printHTML += '</div></body></html>';

            // Open new window and print
            const printWindow = window.open('', '_blank');
            if (printWindow) {
                printWindow.document.write(printHTML);
                printWindow.document.close();
                printWindow.focus();

                setTimeout(() => {
                    printWindow.print();
                }, 500);
            } else {
                alert('Failed to open print window. Please check your popup blocker settings.');
            }
        };

        const toggleBillSelection = billId => {
            const billSection = document.getElementById('bill-' + billId);
            const checkbox = document.getElementById('select-' + billId);
            if (checkbox.checked) {
                billSection.classList.remove('unselected-bills');
                billSection.classList.add('selected-bills');
            } else {
                billSection.classList.remove('selected-bills');
                billSection.classList.add('unselected-bills');
            }
            calculateSelectedTotal();
        };

        

        const attachEventListeners = () => {
            document.querySelectorAll('.form-check-input').forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    toggleBillSelection(this.id.replace('select-', ''));
                });
            });
        };

        document.addEventListener('DOMContentLoaded', () => {
            attachEventListeners();
            calculateSelectedTotal();
        });
    </script>
</head>
<body>
    <div class="bill-container">
        <h2 class="text-center mb-4">Bill for Table <%= request.getAttribute("tableId") %></h2>
        <div id="current-date" style="display: none;"><%= sdf.format(new Date()) %></div>
        
        <!-- Add this button near where you show the order details or at the top of the page -->
        <form action="ReadyToBillServlet" method="post" class="mb-3">
            <input type="hidden" name="tableId" value="<%= request.getAttribute("tableId") %>">
            <button type="submit" class="btn btn-warning">
                <i class="bi bi-receipt"></i> Ready to Bill
            </button>
        </form>
        
        <%
        List<Order> orders = (List<Order>) request.getAttribute("orders");
        List<Bill> bills = (List<Bill>) request.getAttribute("bills");
        
        if (orders != null && !orders.isEmpty()) {
        %>
            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title">Pending Orders</h5>
                    <table class="table table-bordered">
                        <thead class="table-dark">
                            <tr>
                                <th>Order Time</th>
                                <th>Status</th>
                                
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Order order : orders) { %>
                                <tr>
                                    <td><%= sdf.format(order.getCreatedAt()) %></td>
                                    <td><%= order.getStatus() %></td>
                                    
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } %>

        <% if (bills != null && !bills.isEmpty()) { 
            Map<Timestamp, List<Bill>> billsByTime = new TreeMap<>(Collections.reverseOrder());
            for (Bill bill : bills) {
                billsByTime.computeIfAbsent(bill.getTime(), k -> new ArrayList<>()).add(bill);
            }
        %>
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Billed Orders</h5>
                    
                    <% for (Map.Entry<Timestamp, List<Bill>> entry : billsByTime.entrySet()) { 
                        Timestamp time = entry.getKey();
                        List<Bill> timeBills = entry.getValue();
                        double timeTotal = 0;
                    %>
                        <div class="order-section">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5>Order Time: <%= sdf.format(time) %></h5>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" 
                                           onchange="toggleBillSelection('<%= time.getTime() %>')" 
                                           id="select-<%= time.getTime() %>">
                                    <label class="form-check-label" for="select-<%= time.getTime() %>">
                                        Select for Print
                                    </label>
                                </div>
                            </div>
                            
                            <div id="bill-<%= time.getTime() %>" class="unselected-bills">
                                <table class="table table-bordered">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>Item</th>
                                            <th>Qty</th>
                                            <th>Price</th>
                                            <th>Total</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Bill bill : timeBills) { 
                                            timeTotal += bill.getTotal();
                                        %>
                                            <tr>
                                                <td><%= bill.getItemName() %></td>
                                                <td><%= bill.getQty() %></td>
                                                <td>Rs. <%= String.format("%.2f", bill.getPrice()) %></td>
                                                <td>Rs. <%= String.format("%.2f", bill.getTotal()) %></td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <td colspan="3" class="text-end"><strong>Time Total:</strong></td>
                                            <td class="bill-total" data-total="<%= timeTotal %>">
                                                <strong>Rs. <%= String.format("%.2f", timeTotal) %></strong>
                                            </td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>

            <!-- Selected Items Container -->
            <div id="selected-items-container" class="selected-items-container">
                <div class="container">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <strong>Selected Total: <span id="selected-total" class="total-display">Rs. 0.00</span></strong>
                        </div>
                        <div>
                            <button onclick="printSelectedBills()" class="btn btn-primary">Print Selected Bills</button>
                            <a href="cashier_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
                        </div>
                    </div>
                </div>
            </div>
        <% } else if (orders == null || orders.isEmpty()) { %>
            <div class="alert alert-info">
                No orders found for this table.
            </div>
            <div class="no-print mt-4">
                <a href="cashier_dashboard.jsp" class="btn btn-primary">Back to Dashboard</a>
            </div>
        <% } %>
    </div>
</body>
</html>