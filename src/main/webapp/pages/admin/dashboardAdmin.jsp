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
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css" />
</head>
<body>

<jsp:include page="/pages/outros/mensagens.jsp" />
<jsp:include page="/pages/usuario/header.jsp" />

<div class="container">

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

    <div class="cards">
        <div class="card">
            <h2>Usuários</h2>
            <p>Gerencie todos os usuários</p>
            <a href="<%= request.getContextPath() %>/pages/admin/gerenciarUsuarios.jsp" class="btn">Acessar</a>
        </div>
        <div class="card">
            <h2>Unidades</h2>
            <p>Visualize e edite unidades</p>
            <a href="<%= request.getContextPath() %>/pages/admin/gerenciarUnidades.jsp" class="btn">Acessar</a>
        </div>
        <div class="card">
            <h2>Contratos</h2>
            <p>Ver todos os contratos</p>
            <a href="<%= request.getContextPath() %>/pages/admin/gerenciarContratos.jsp" class="btn">Acessar</a>
        </div>
    </div>

</div>

</body>
</html>
