<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="br.com.monesol.model.Usuario" %>

<%
    HttpSession sessao = request.getSession(false);
    Usuario usuarioLogado = (sessao != null) ? (Usuario) sessao.getAttribute("usuarioLogado") : null;
    if (usuarioLogado == null || !"ADMIN".equalsIgnoreCase(usuarioLogado.getTipo().name())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Criar Novo Usuário - Admin MoneSol</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/forms.css" />
</head>
<body>
<jsp:include page="/pages/outros/mensagens.jsp" />

<main>
    <h1>
        <a href="<%= request.getContextPath() %>/pages/admin/gerenciarUsuarios.jsp" class="btn-back">
            &#8592; Voltar
        </a>
        Criar Novo Usuário
    </h1>

    <form action="<%= request.getContextPath() %>/UsuarioController" method="post">
        <input type="hidden" name="action" value="adminAdicionar" />

        <label for="cpfCnpj">CPF/CNPJ</label>
        <input type="text" id="cpfCnpj" name="cpfCnpj" required />

        <label for="nome">Nome Completo</label>
        <input type="text" id="nome" name="nome" required />

        <label for="email">Email</label>
        <input type="email" id="email" name="email" required />

        <label for="senha">Senha</label>
        <input type="password" id="senha" name="senha" required />

        <label for="contato">Contato</label>
        <input type="text" id="contato" name="contato" />

        <label for="endereco">Endereço</label>
        <input type="text" id="endereco" name="endereco" />

        <label for="tipo">Tipo de Usuário</label>
        <select id="tipo" name="tipo" required>
            <option value="CONSUMIDOR_PARCEIRO">Consumidor Parceiro</option>
            <option value="DONO_GERADORA">Dono de Geradora</option>
            <option value="ADMIN">Admin</option>
        </select>

        <button type="submit">Criar Usuário</button>
    </form>
</main>
</body>
</html>
