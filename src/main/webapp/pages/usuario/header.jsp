<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="br.com.monesol.model.Usuario"%>

<%
    HttpSession sessao = request.getSession(false);
    Usuario usuarioLogado = (sessao != null) ? (Usuario) sessao.getAttribute("usuarioLogado") : null;
%>

<style type="text/css">
header {
	background: #FFD600;
	padding: 15px 40px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1);
	position: sticky;
	top: 0;
	z-index: 1000;
}

header a.logo {
	font-weight: 900;
	font-size: 2.4rem;
	color: #212121;
	text-decoration: none;
	letter-spacing: 2px;
}

nav {
	display: flex;
	gap: 24px;
	flex-wrap: wrap;
}

nav a {
	color: #212121;
	text-decoration: none;
	font-weight: 600;
	font-size: 1.05rem;
	padding: 6px 12px;
	border-radius: 8px;
	transition: background-color 0.3s ease;
}

nav a:hover {
	background: #ffea00;
}

.auth-buttons, .user-info {
	display: flex;
	align-items: center;
	gap: 12px;
	flex-wrap: wrap;
}

.btn {
	padding: 8px 20px;
	font-weight: 700;
	border-radius: 30px;
	cursor: pointer;
	border: none;
	transition: background-color 0.3s ease;
	font-size: 1rem;
}

.btn-login {
	background: transparent;
	border: 2px solid #212121;
	color: #212121;
}

.btn-login:hover {
	background: #212121;
	color: #ffd600;
}

.btn-register {
	background: #212121;
	color: #ffd600;
}

.btn-register:hover {
	background: #000;
	color: #fff700;
}

.btn-logout {
	background: transparent;
	border: 2px solid #212121;
	color: #212121;
}

.btn-logout:hover {
	background: #212121;
	color: #ffd600;
}

.user-welcome {
	font-weight: 600;
	color: #212121;
}
</style>
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
		<a
			href="<%= request.getContextPath() %>/pages/unidadeGeradora/listaUnidadesDisponiveis.jsp">Marketplace</a>
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
