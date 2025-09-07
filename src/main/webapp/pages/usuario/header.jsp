<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="br.com.monesol.model.Usuario"%>

<%
    HttpSession sessao = request.getSession(false);
    Usuario usuarioLogado = (sessao != null) ? (Usuario) sessao.getAttribute("usuarioLogado") : null;
%>
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/header.css" />

<header>
	<a href="<%= request.getContextPath() %>/index.jsp" class="logo">MoneSol</a>

	<nav>
		<%
    if (usuarioLogado != null) {
        String tipoUsuario = usuarioLogado.getTipo().name();

        if ("ADMIN".equalsIgnoreCase(tipoUsuario)) {
%>
		<a
			href="<%= request.getContextPath() %>/pages/admin/dashboardAdmin.jsp">Dashboard</a>
		<a
			href="<%= request.getContextPath() %>/pages/admin/gerenciarUsuarios.jsp">Gerenciar
			Usuários</a> <a
			href="<%= request.getContextPath() %>/pages/admin/gerenciarUnidades.jsp">Gerenciar
			Unidades</a> <a
			href="<%= request.getContextPath() %>/pages/admin/gerenciarContratos.jsp">Gerenciar
			Contratos</a>
		<%
        } else if ("CONSUMIDOR_PARCEIRO".equalsIgnoreCase(tipoUsuario)) {
%>
		<a href="<%= request.getContextPath() %>/pages/usuario/dashboard.jsp">Dashboard</a>
		<a href="<%= request.getContextPath() %>/pages/unidadeGeradora/listaUnidadesDisponiveis.jsp">Marketplace</a>
		<a href="<%= request.getContextPath() %>/pages/outros/contato.jsp">Contato</a>
		<%
        } else if ("DONO_GERADORA".equalsIgnoreCase(tipoUsuario)) {
%>
		<a href="<%= request.getContextPath() %>/pages/usuario/dashboard.jsp">Dashboard</a>
		<a href="<%= request.getContextPath() %>/pages/outros/contato.jsp">Contato</a>
		<%
        }
    } else { 
%>
		<a href="<%= request.getContextPath() %>/pages/outros/sobre.jsp">Sobre</a>
		<a
			href="<%= request.getContextPath() %>/pages/outros/funcionalidades.jsp">O
			que oferecemos</a> <a
			href="<%= request.getContextPath() %>/pages/outros/contato.jsp">Contato</a>
		<%
    }
%>
	</nav>


	<%
        if (usuarioLogado != null) {
    %>
	<div class="user-info">
		<span class="user-welcome">Olá, <%= usuarioLogado.getNome() %>!
		</span>
		<form action="<%= request.getContextPath() %>/UsuarioController"
			method="post">
			<input type="hidden" name="action" value="logout" />
			<button type="submit" class="btn btn-logout">Sair</button>
		</form>
	</div>
	<%
        } else {
    %>
	<div class="auth-buttons">
		<button class="btn btn-login"
			onclick="window.location.href='<%= request.getContextPath() %>/pages/usuario/login.jsp'">Login</button>
		<button class="btn btn-register"
			onclick="window.location.href='<%= request.getContextPath() %>/pages/usuario/cadastro.jsp'">Cadastro</button>
	</div>
	<%
        }
    %>
</header>
