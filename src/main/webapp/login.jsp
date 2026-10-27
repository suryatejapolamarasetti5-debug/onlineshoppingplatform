
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Login | Online Shopping</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: "Segoe UI", Arial, sans-serif;
            background: linear-gradient(135deg, #eef4ff, #f8fafc);
            color: #1e293b;
            display: flex;
            flex-direction: column;
        }

        /* Navigation bar */
        .navbar {
            width: 100%;
            padding: 18px 7%;
            background: #172554;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 3px 12px rgba(15, 23, 42, 0.12);
        }

        .brand {
            color: white;
            font-size: 22px;
            font-weight: 700;
            text-decoration: none;
            letter-spacing: 0.3px;
        }

        .brand span {
            color: #93c5fd;
        }

        .nav-link {
            color: #e2e8f0;
            text-decoration: none;
            font-size: 14px;
        }

        .nav-link:hover {
            color: white;
        }

        /* Main layout */
        
.page-content {
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    padding: 30px 18px;
    gap: 0;
}

.login-container {
    width: 100%;
    max-width: 420px;
    padding: 38px;
    background: white;
    border: 1px solid #e2e8f0;
    border-radius: 18px;
    box-shadow: 0 16px 45px rgba(30, 64, 175, 0.10);
}

        .login-icon {
            width: 62px;
            height: 62px;
            margin: 0 auto 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #eff6ff;
            border-radius: 16px;
            color: #2563eb;
            font-size: 30px;
        }

        .login-container h1 {
            margin: 0;
            text-align: center;
            font-size: 28px;
            color: #172554;
        }

        .subtitle {
            margin: 10px 0 28px;
            text-align: center;
            color: #64748b;
            font-size: 14px;
            line-height: 1.6;
        }

        /* Error message */
        .error {
            padding: 12px 14px;
            margin-bottom: 20px;
            background: #fef2f2;
            border: 1px solid #fecaca;
            border-radius: 8px;
            color: #b91c1c;
            text-align: center;
            font-size: 14px;
        }

        /* Form fields */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #334155;
            font-size: 14px;
            font-weight: 600;
        }

        .form-group input {
            width: 100%;
            padding: 13px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 9px;
            outline: none;
            background: #fff;
            color: #1e293b;
            font: inherit;
            font-size: 14px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .form-group input:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
        }

        .form-group input::placeholder {
            color: #94a3b8;
        }

        /* Remember me */
        .remember-me {
            display: flex;
            align-items: center;
            gap: 9px;
            margin: 4px 0 24px;
        }

        .remember-me input {
            width: 16px;
            height: 16px;
            margin: 0;
            accent-color: #2563eb;
            cursor: pointer;
        }

        .remember-me label {
            color: #475569;
            font-size: 13px;
            cursor: pointer;
        }

        /* Login button */
        .login-button {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 9px;
            background: #2563eb;
            color: white;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s, transform 0.2s;
        }

        .login-button:hover {
            background: #1d4ed8;
            transform: translateY(-1px);
        }

        .login-button:focus-visible {
            outline: 3px solid #93c5fd;
            outline-offset: 3px;
        }

        .login-note {
            margin: 24px 0 0;
            text-align: center;
            color: #64748b;
            font-size: 12px;
            line-height: 1.6;
        }
        .register-link {
    text-align: center;
    margin-top: 20px;
    font-size: 14px;
}

.register-link a {
    color: #2563eb;
    text-decoration: none;
    font-weight: bold;
}

.register-link a:hover {
    text-decoration: underline;
}

        /* Footer */
        .footer {
            padding: 18px;
            text-align: center;
            color: #64748b;
            font-size: 12px;
        }

        /* Mobile layout */
        @media (max-width: 480px) {
            .navbar {
                padding: 16px 5%;
            }

            .brand {
                font-size: 19px;
            }

            .login-container {
                padding: 28px 22px;
                border-radius: 14px;
            }

            .login-container h1 {
                font-size: 25px;
            }

            .page-content {
                padding: 28px 14px;
            }
        
        }
        
.register-section {
    width: 100%;
    max-width: 420px;
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;
    gap: 10px;
    margin-top: 8px;
    padding-top: 12px;
    border-top: 1px solid #e5e7eb;
}

.register-section p {
    display: none;
}

.register-btn,
.customer-btn {
    flex: 1;
    min-width: 0;
    display: inline-block;
    padding: 10px 6px;
    margin: 0;
    border-radius: 8px;
    text-align: center;
    text-decoration: none;
    font-size: 12px;
    font-weight: 600;
    white-space: nowrap;
    transition: 0.2s;
}

.register-btn {
    background: #059669;
    color: white;
}

.register-btn:hover {
    background: #047857;
}

.customer-btn {
    background: #dbeafe;
    color: #1d4ed8;
}

.customer-btn:hover {
    background: #bfdbfe;
}
@media (max-width: 480px) {
    .login-container {
        padding: 28px 22px;
    }

    .page-content {
        padding: 24px 14px;
    }

    .register-section {
        max-width: 420px;
    }

    .register-btn,
    .customer-btn {
        flex-basis: 100%;
    }
}
        
.register-section {
    margin-top: 25px;
    padding-top: 20px;
    border-top: 1px solid #e5e7eb;
    text-align: center;
}

.register-section p {
    color: #64748b;
    margin: 12px 0;
}

.register-btn,
.customer-btn {
    display: block;
    padding: 12px;
    margin: 10px 0;
    border-radius: 8px;
    text-decoration: none;
    font-weight: bold;
    transition: 0.2s;
}

.register-btn {
    background: #059669;
    color: white;
}

.register-btn:hover {
    background: #047857;
}

.customer-btn {
    background: #dbeafe;
    color: #1d4ed8;
}

.customer-btn:hover {
    background: #bfdbfe;
}
        
.register-link {
    width: 100%;
    max-width: 420px;
    text-align: center;
    margin: 16px 0 8px;
    font-size: 14px;
}

.register-link a {
    color: #2563eb;
    text-decoration: none;
    font-weight: 700;
}

.register-link a:hover {
    text-decoration: underline;
}
        
    </style>
</head>

<body>

    <header class="navbar">
        <a class="brand"
           href="${pageContext.request.contextPath}/">
            City<span>Shop</span>
        </a>

        <a class="nav-link"
           href="${pageContext.request.contextPath}/">
            Home
        </a>
    </header>

    <main class="page-content">

        <section class="login-container">

            <div class="login-icon" aria-hidden="true">
                &#128722;
            </div>

            <h1>Welcome Back</h1>

            <p class="subtitle">
                Sign in to your account to continue shopping.
            </p>
            <% if ("1".equals(request.getParameter("registered"))) { %>
    <p style="color: green; text-align: center;">
        Account created successfully! Please log in.
    </p>
<% } %>

            <%
                String error = request.getParameter("error");

                if ("1".equals(error)) {
            %>
                <p class="error" role="alert">
                    Invalid username or password. Please try again.
                </p>
            <%
                }
            %>

            <form action="${pageContext.request.contextPath}/login"
                  method="post">

                <div class="form-group">
                    <label for="username">Username</label>
                    <input
                        type="text"
                        id="username"
                        name="username"
                        placeholder="Enter your username"
                        autocomplete="username"
                        required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Enter your password"
                        autocomplete="current-password"
                        required>
                </div>

                <div class="remember-me">
                    <input
                        type="checkbox"
                        id="rememberMe"
                        name="rememberMe"
                        value="1">

                    <label for="rememberMe">Remember me</label>
                </div>

                <button type="submit" class="login-button">
                    Sign In
                </button>

            </form>

            <p class="login-note">
                Secure access to your online shopping account.
            </p>

        </section>
        <p class="register-link">
    Don't have an account?
    <a href="${pageContext.request.contextPath}/register.jsp">
        Create an account
    </a>
</p>

<div class="register-section">
    <p>New to CityShop?</p>

    <a href="seller-register.jsp" class="register-btn">
        🏪 Register as a Seller
    </a>

    <p>Want to shop instead?</p>

    <a href="register.jsp" class="customer-btn">
        👤 Create Customer Account
    </a>
</div>


    </main>

    <footer class="footer">
        &copy; 2026 ShopEase. All rights reserved.
    </footer>

</body>
</html>