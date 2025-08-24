<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="br.com.monesol.model.Usuario" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    HttpSession sessao = request.getSession(false);
    Usuario usuarioLogado = (sessao != null) ? (Usuario) sessao.getAttribute("usuarioLogado") : null;
    if (usuarioLogado == null || !"ADMIN".equalsIgnoreCase(usuarioLogado.getTipo().name())) {
        response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Admin Dashboard - MoneSol</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/monesol.css" />
<style>
    /* Mantendo exatamente o mesmo estilo do dashboard comum */
    :root {
        --yellow:#ffd600;
        --dark:#212121;
        --bg:#fffde7;
        --radius:12px;
    }
    * { box-sizing:border-box; }
    body {
        background: var(--bg);
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        margin: 0;
        color: #333;
    }
    a { text-decoration: none; color: inherit; }
    .container {
        max-width: 1000px;
        margin: 40px auto;
        padding: 0 20px;
    }
    .section {
        background: #ffffff;
        border: 1px solid var(--yellow);
        border-radius: var(--radius);
        padding: 25px 30px;
        margin-bottom: 40px;
        box-shadow: 0 5px 20px rgba(255, 214, 0, 0.2);
    }
    h2 {
        margin: 0 0 15px;
        font-size: 1.5rem;
        color: var(--dark);
        border-bottom: 2px solid var(--yellow);
        padding-bottom: 8px;
    }
    .edit-button {
        background: var(--yellow);
        border: none;
        padding: 8px 16px;
        border-radius: 8px;
        cursor: pointer;
        font-weight: bold;
        color: var(--dark);
        transition: background 0.2s ease;
    }
    .edit-button:hover { background: #ffeb3b; }
    .cards {
        display: flex;
        gap: 20px;
        flex-wrap: wrap;
        justify-content: center;
    }
    .card {
        background:#fff;
        border:1.5px solid var(--yellow);
        border-radius:var(--radius);
        padding:25px;
        width:220px;
        text-align:center;
        box-shadow:0 5px 20px rgba(255,214,0,0.2);
        cursor:pointer;
        transition: transform 0.2s ease;
    }
    .card:hover { transform: translateY(-3px); }
    .card h2 { font-size:1.3rem; margin-bottom:10px; color:var(--dark); }
    .card p { font-size:0.95rem; margin-bottom:10px; }
    .btn { display:block; margin:0 auto; padding:10px 15px; background:var(--dark); color:var(--yellow); text-decoration:none; border-radius:30px; font-weight:700; }
    .btn:hover { background:#000; }
</style>
</head>
<body>

<jsp:include page="/pages/usuario/header.jsp" />

<div class="container">

    <!-- Dados do Admin -->
    <div class="section" aria-label="Informações do Admin">
        <h2>Meus Dados</h2>
        <p><strong>Nome:</strong> <%= usuarioLogado.getNome() %></p>
        <p><strong>Email:</strong> <%= usuarioLogado.getEmail() %></p>
        <p><strong>CPF/CNPJ:</strong> <%= usuarioLogado.getCpfCnpj() %></p>
        <p><strong>Contato:</strong> <%= usuarioLogado.getContato() != null ? usuarioLogado.getContato() : "-" %></p>
        <p><strong>Endereço:</strong> <%= usuarioLogado.getEndereco() != null ? usuarioLogado.getEndereco() : "-" %></p>
        <form action="<%= request.getContextPath() %>/pages/usuario/editarUsuario.jsp" method="get" style="margin-top:10px;">
            <button type="submit" class="edit-button">Editar meus dados</button>
        </form>
    </div>

    <!-- Cards administrativos -->
    <div class="cards">
        <div class="card">
            <h2>Usuários</h2>
            <p>Gerencie todos os usuários</p>
            <a href="<%= request.getContextPath() %>/admin/listaUsuarios.jsp" class="btn">Acessar</a>
        </div>
        <div class="card">
            <h2>Unidades</h2>
            <p>Visualize e edite unidades</p>
            <a href="<%= request.getContextPath() %>/admin/listaUnidades.jsp" class="btn">Acessar</a>
        </div>
        <div class="card">
            <h2>Contratos</h2>
            <p>Ver todos os contratos</p>
            <a href="<%= request.getContextPath() %>/admin/listaContratos.jsp" class="btn">Acessar</a>
        </div>
        <div class="card">
            <h2>Medições</h2>
            <p>Monitorar todas as medições</p>
            <a href="<%= request.getContextPath() %>/admin/listaMedicoes.jsp" class="btn">Acessar</a>
        </div>
        <div class="card">
            <h2>Relatórios</h2>
            <p>Exportar e gerar relatórios</p>
            <a href="<%= request.getContextPath() %>/admin/relatorios.jsp" class="btn">Acessar</a>
        </div>
    </div>

</div>

</body>
</html>
