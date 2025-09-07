<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="br.com.monesol.model.Usuario" %>
<%@ page import="br.com.monesol.dao.UsuarioDAO" %>

<%
    HttpSession sessao = request.getSession(false);
    Usuario usuarioLogado = (sessao != null) ? (Usuario) sessao.getAttribute("usuarioLogado") : null;
    if (usuarioLogado == null || !"ADMIN".equalsIgnoreCase(usuarioLogado.getTipo().name())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    String cpfCnpjParaEditar = request.getParameter("cpfCnpj");
    Usuario usuarioParaEditar = null;
    if (cpfCnpjParaEditar != null && !cpfCnpjParaEditar.isEmpty()) {
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        usuarioParaEditar = usuarioDAO.buscarPorCpfCnpj(cpfCnpjParaEditar);
    }

    if (usuarioParaEditar == null) {
        sessao.setAttribute("mensagemErro", "Utilizador não encontrado para edição.");
        response.sendRedirect(request.getContextPath() + "/pages/admin/gerenciarUsuarios.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Editar Utilizador - Admin MoneSol</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <!-- CSS global para formulários -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/forms.css" />
</head>
<body>
<jsp:include page="/pages/outros/mensagens.jsp" />

<main>
    <h1>
        <a href="javascript:history.back()" class="btn-back">
            &#8592; Voltar
        </a>
        Editar Utilizador
    </h1>
    <form action="<%= request.getContextPath() %>/UsuarioController" method="post">
        <input type="hidden" name="action" value="adminEditar" />
        <input type="hidden" name="cpfCnpj" value="<%= usuarioParaEditar.getCpfCnpj() %>" />

        <label for="nome">Nome</label>
        <input type="text" id="nome" name="nome" value="<%= usuarioParaEditar.getNome() %>" required />

        <label for="email">Email</label>
        <input type="email" id="email" name="email" value="<%= usuarioParaEditar.getEmail() %>" required />

        <label for="senha">Nova Senha (deixe em branco para não alterar)</label>
        <input type="password" id="senha" name="senha" />

        <label for="contato">Contacto</label>
        <input type="text" id="contato" name="contato" value="<%= usuarioParaEditar.getContato() != null ? usuarioParaEditar.getContato() : "" %>" />

        <label for="endereco">Endereço</label>
        <input type="text" id="endereco" name="endereco" value="<%= usuarioParaEditar.getEndereco() != null ? usuarioParaEditar.getEndereco() : "" %>" />
        
        <label for="tipo">Tipo de Utilizador</label>
        <select id="tipo" name="tipo" required>
            <option value="CONSUMIDOR_PARCEIRO" <%= "CONSUMIDOR_PARCEIRO".equals(usuarioParaEditar.getTipo().name()) ? "selected" : "" %>>Consumidor Parceiro</option>
            <option value="DONO_GERADORA" <%= "DONO_GERADORA".equals(usuarioParaEditar.getTipo().name()) ? "selected" : "" %>>Dono de Unidade</option>
            <option value="ADMIN" <%= "ADMIN".equals(usuarioParaEditar.getTipo().name()) ? "selected" : "" %>>Admin</option>
        </select>

        <button type="submit">Salvar Alterações</button>
    </form>
</main>
</body>
</html>
