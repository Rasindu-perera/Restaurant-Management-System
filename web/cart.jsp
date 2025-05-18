<%-- 
    Author     : RasinduPerera
--%>
<%@ page import="model.CartItem" %>
<%@ page import="java.util.List" %>
<%
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    double total = 0;
    Boolean orderSent = (Boolean) session.getAttribute("orderSent");
    if (orderSent == null) orderSent = false;
    
    // Add error handling
    String error = (String) request.getAttribute("error");
    String successMessage = (String) request.getAttribute("successMessage");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Cart</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <link rel="stylesheet" type="text/css" href="StyleCss/cart.css">
    <style>
        .error {
            color: #721c24;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 25px;
            padding: 12px;
            margin: 15px auto;
            max-width: 80%;
            text-align: center;
            font-weight: bold;
        }

        .success {
            color: #155724;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            border-radius: 25px;
            padding: 12px;
            margin: 15px auto;
            max-width: 80%;
            text-align: center;
            font-weight: bold;
        }

        .empty-cart {
            color: rgb(65, 123, 6);
            text-align: center;
            font-weight: bold;
            border: 3px solid rgb(65, 123, 6);
            border-radius: 50px;
            background-color: aliceblue;
            padding: 15px;
            margin: 20px auto;
            max-width: 80%;
        }

        /* Rating system styling */
        .rating-container {
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 20px;
            margin: 20px auto;
            max-width: 90%;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .rating-title {
            font-size: 24px;
            color: #333;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .rating {
            display: flex;
            flex-direction: row-reverse;
            justify-content: center;
            margin-bottom: 20px;
        }
        
        .rating > input {
            display: none;
        }
        
        .rating > label {
            cursor: pointer;
            width: 40px;
            height: 40px;
            margin: 0 5px;
            font-size: 35px;
            color: #ddd;
            transition: all 0.2s;
        }
        
        .rating > label:hover,
        .rating > label:hover ~ label,
        .rating > input:checked ~ label {
            color: #FFD700;
        }

        textarea.comment-box {
            width: 80%;
            padding: 12px;
            margin: 15px auto;
            border: 1px solid #ccc;
            border-radius: 10px;
            font-family: inherit;
            resize: vertical;
            box-shadow: inset 0 1px 3px rgba(0,0,0,.1);
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 15px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="cart-header"><h2>My Cart</h2></div>
        
        <% if (error != null) { %>
            <div class="error"><%= error %></div>
        <% } %>
        
        <% if (successMessage != null) { %>
            <div class="success"><%= successMessage %></div>
        <% } %>

        <% if (cart != null && !cart.isEmpty()) { %>
            <form action="updateCart" method="post">
                <div class="cart-box">
                    <table class="cart-table">
                        <tr>
                            <th><div class="text1">Item</div></th>
                            <th><div class="text1">Price</div></th>
                            <th><div class="text1">Quantity</div></th>
                            <th><div class="text1">Subtotal</div></th>
                            <th><div class="text1">Action</div></th>
                        </tr>
                        <% for (CartItem item : cart) {
                            double sub = item.getQuantity() * item.getItem().getPrice();
                            total += sub;
                        %>
                        <tr>
                            <td class="datacell">
                                <div class="item"><%= item.getItem().getName() %></div>
                            </td>
                            <td class="datacell">
                                <div class="price">Rs. <%= item.getItem().getPrice() %></div>
                            </td>
                            <td class="datacell">
                                <input type="number" name="quantities" value="<%= item.getQuantity() %>" min="1" class="input-box" />
                                <input type="hidden" name="itemIds" value="<%= item.getItem().getId() %>" />
                            </td>
                            <td class="datacell">
                                <div class="subtotal">Rs. <%= sub %></div>
                            </td>
                            <td class="datacell">
                                <button type="submit" formaction="removeFromCart" formmethod="post" name="itemId" value="<%= item.getItem().getId() %>" class="remove-button">Remove</button>
                            </td>
                        </tr>
                        <% } %>
                    </table>
                </div>
                
                <div style="text-align: center; margin: 20px 0;">
                    <input type="submit" value="Update Quantities" class="update-button" />
                </div>
            </form>

            <div class="total-box">
                <p><strong>Total: Rs. </strong><span class="total"><%= total %></span></p>
            </div>

            <div class="action-buttons">
                <form action="sendOrder" method="post">
                    <input type="submit" value="Send Order" class="button1"/>
                </form>
            </div>
        <% } else { %>
            <div class="empty-cart">Your cart is empty.</div>
            
            <div class="action-buttons">
                <form action="releaseTable" method="post">
                    <button type="submit" class="remove-button">Table Release</button>
                </form>
            </div>
        <% } %>

        <% if (orderSent) { %>
            <div class="rating-container">
                <div class="rating-title">Rate Your Experience</div>
                <form action="feedback" method="post">
                    <div class="rating">
                        <input type="radio" id="star5" name="rating" value="5" required />
                        <label for="star5" title="5 stars">&#9733;</label>
                        
                        <input type="radio" id="star4" name="rating" value="4" />
                        <label for="star4" title="4 stars">&#9733;</label>
                        
                        <input type="radio" id="star3" name="rating" value="3" />
                        <label for="star3" title="3 stars">&#9733;</label>
                        
                        <input type="radio" id="star2" name="rating" value="2" />
                        <label for="star2" title="2 stars">&#9733;</label>
                        
                        <input type="radio" id="star1" name="rating" value="1" />
                        <label for="star1" title="1 star">&#9733;</label>
                    </div>
                    
                    <textarea name="comment" placeholder="Additional comments (optional)" rows="3" class="comment-box"></textarea>
                    
                    <div class="action-buttons">
                        <button type="submit" class="button1">Submit Feedback</button>
                        
                        
                    </div>
                </form>
            </div>
            
            
        <% } %>

        <div class="action-buttons">
            <form action="menu" method="get">
                <input type="submit" value="Back to Menu" class="button3" />
            </form>
        </div>
    </div>
</body>
</html>