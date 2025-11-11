<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PatientForm.aspx.cs" Inherits="HealthcareApp.PatientForm" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Healthcare Management System</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />

    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .sidebar {
            height: 100vh;
            background: linear-gradient(180deg, #0d6efd, #0b5ed7);
            color: white;
            position: fixed;
            left: 0;
            top: 0;
            width: 240px;
            padding-top: 30px;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
        }

        .sidebar h3 {
            text-align: center;
            font-weight: bold;
            margin-bottom: 40px;
        }

        .sidebar a {
            display: block;
            color: #fff;
            padding: 12px 20px;
            text-decoration: none;
            font-size: 1rem;
            border-radius: 8px;
            transition: background 0.3s;
        }

        .sidebar a:hover,
        .sidebar a.active {
            background-color: #ffffff22;
        }

        .main-content {
            margin-left: 260px;
            padding: 30px 40px;
        }

        .card {
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        .kpi-card {
            border-left: 5px solid #0d6efd;
        }

        .kpi-card.green { border-left-color: #198754; }
        .kpi-card.orange { border-left-color: #fd7e14; }

        .kpi-label { color: #6c757d; font-size: 0.9rem; }
        .kpi-value { font-size: 1.5rem; font-weight: 700; }

        .table th {
            background-color: #0d6efd;
            color: white;
            text-align: center;
        }

        footer {
            text-align: center;
            margin-top: 40px;
            color: #6c757d;
            font-size: 0.9rem;
        }

        .btn-primary {
            background-color: #0d6efd;
            border-color: #0d6efd;
        }
        .btn-primary:hover {
            background-color: #0b5ed7;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <!-- Sidebar -->
        <div class="sidebar">
            <h3><i class="bi bi-hospital"></i> HealthCare</h3>
            <a href="PatientForm.aspx" class="active"><i class="bi bi-person-lines-fill me-2"></i> Patients</a>
        </div>

        <!-- Main content -->
        <div class="main-content">
            <h2 class="fw-bold mb-4"><i class="bi bi-person-vcard-fill text-primary me-2"></i>Patient Management</h2>

            <!-- Dashboard KPIs -->
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <div class="card p-3 kpi-card">
                        <div class="kpi-label">Total Patients</div>
                        <asp:Label ID="lblTotal" runat="server" CssClass="kpi-value"></asp:Label>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card p-3 kpi-card green">
                        <div class="kpi-label">Average Age</div>
                        <asp:Label ID="lblAvgAge" runat="server" CssClass="kpi-value"></asp:Label>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card p-3 kpi-card orange">
                        <div class="kpi-label">Most Common Disease</div>
                        <asp:Label ID="lblTopDisease" runat="server" CssClass="kpi-value"></asp:Label>
                    </div>
                </div>
            </div>

            <!-- Form Section -->
            <div class="card p-4 mb-4">
                <h4 class="text-center text-primary mb-3">Add New Patient</h4>

                <asp:Label ID="lblMessage" runat="server" CssClass="text-success fw-bold"></asp:Label>

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label for="txtName" class="form-label">Name:</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ControlToValidate="txtName" runat="server"
                            ErrorMessage="Name required" CssClass="text-danger" ValidationGroup="saveGroup" />
                    </div>

                    <div class="col-md-4 mb-3">
                        <label for="txtAge" class="form-label">Age:</label>
                        <asp:TextBox ID="txtAge" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ControlToValidate="txtAge" runat="server"
                            ErrorMessage="Age required" CssClass="text-danger" ValidationGroup="saveGroup" />
                        <asp:RegularExpressionValidator ControlToValidate="txtAge" runat="server"
                            ValidationExpression="^\d+$" ErrorMessage="Numbers only"
                            CssClass="text-danger" ValidationGroup="saveGroup" />
                    </div>

                    <div class="col-md-4 mb-3">
                        <label for="txtDisease" class="form-label">Disease:</label>
                        <asp:TextBox ID="txtDisease" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ControlToValidate="txtDisease" runat="server"
                            ErrorMessage="Disease required" CssClass="text-danger" ValidationGroup="saveGroup" />
                    </div>
                </div>

                <div class="text-center">
                    <asp:Button Text="Add Patient" ID="btnSave" runat="server"
                        OnClick="btnSave_Click" CssClass="btn btn-primary px-4" ValidationGroup="saveGroup" />
                </div>
            </div>

            <!-- Search + Grid -->
            <div class="card p-3">
                <div class="input-group mb-3">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by name or disease" />
                    <asp:Button Text="Search" ID="btnSearch" runat="server" CssClass="btn btn-outline-secondary"
                        OnClick="btnSearch_Click" CausesValidation="false" />
                    <asp:Button Text="Clear" ID="btnClear" runat="server" CssClass="btn btn-outline-danger"
                        OnClick="btnClear_Click" CausesValidation="false" />
                </div>

                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false"
                    CssClass="table table-bordered table-striped text-center"
                    DataKeyNames="PatientID"
                    AllowPaging="true" PageSize="5"
                    OnPageIndexChanging="GridView1_PageIndexChanging"
                    OnRowEditing="GridView1_RowEditing"
                    OnRowUpdating="GridView1_RowUpdating"
                    OnRowDeleting="GridView1_RowDeleting"
                    OnRowCancelingEdit="GridView1_RowCancelingEdit">

                    <Columns>
                        <asp:BoundField DataField="PatientID" HeaderText="ID" ReadOnly="true" />
                        <asp:BoundField DataField="Name" HeaderText="Name" />
                        <asp:BoundField DataField="Age" HeaderText="Age" />
                        <asp:BoundField DataField="Disease" HeaderText="Disease" />
                        <asp:BoundField DataField="RegistrationDate" HeaderText="Registered On"
                                        DataFormatString="{0:yyyy-MM-dd HH:mm}" ReadOnly="true" />
                        <asp:CommandField ShowEditButton="true" ShowDeleteButton="true" />
                    </Columns>
                </asp:GridView>
            </div>

            <footer>
                <p>© 2025 Healthcare System • Built with ❤️ by <b>Monish</b></p>
            </footer>
        </div>
    </form>
</body>
</html>
