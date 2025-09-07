<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="br.com.monesol.model.*, br.com.monesol.dao.*" %>
<%@ page import="java.util.List" %>

<%
    HttpSession sessao = request.getSession(false);
    Usuario usuarioLogado = (sessao != null) ? (Usuario) sessao.getAttribute("usuarioLogado") : null;
    if (usuarioLogado == null || !"ADMIN".equalsIgnoreCase(usuarioLogado.getTipo().name())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    UsuarioDAO usuarioDAO = new UsuarioDAO();
    List<Usuario> listaUsuarios = usuarioDAO.listarTodos();
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<title>Gerenciar Usuários - Admin MoneSol</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/adminGerenciamento.css" />
</head>
<body>

<jsp:include page="/pages/outros/mensagens.jsp" />

<jsp:include page="/pages/usuario/header.jsp" />

<div class="container">
    <div class="top-actions">
        <h1>Gerenciar Usuários</h1>
        <a href="<%= request.getContextPath() %>/pages/admin/criarUsuario.jsp" class="btn btn-create">+ Novo Usuário</a>
    </div>


    <% if (listaUsuarios != null && !listaUsuarios.isEmpty()) { %>
        <table>
            <thead>
                <tr>
                    <th>CPF/CNPJ</th>
                    <th>Nome</th>
                    <th>Email</th>
                    <th>Contato</th>
                    <th>Endereço</th>
                    <th>Tipo</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>
                <% for (Usuario u : listaUsuarios) { %>
                <tr>
                    <td><%= u.getCpfCnpj() %></td>
                    <td><%= u.getNome() %></td>
                    <td><%= u.getEmail() %></td>
                    <td><%= u.getContato() != null ? u.getContato() : "-" %></td>
                    <td><%= u.getEndereco() != null ? u.getEndereco() : "-" %></td>
                    <td><%= u.getTipo() %></td>
                    <td>
                        <div class="actions">
                            <form action="<%= request.getContextPath() %>/pages/admin/editarUsuario.jsp" method="get">
                                <input type="hidden" name="cpfCnpj" value="<%= u.getCpfCnpj() %>" />
                                <button type="submit" class="btn">Editar</button>
                            </form>
                            <form action="<%= request.getContextPath() %>/UsuarioController" method="post">
                                <input type="hidden" name="action" value="deletar" />
                                <input type="hidden" name="cpfCnpj" value="<%= u.getCpfCnpj() %>" />
                                <button type="submit" class="btn" onclick="return confirm('Deseja realmente deletar este usuário?');">Deletar</button>
                            </form>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    <% } else { %>
        <p>Nenhum usuário cadastrado.</p>
    <% } %>
</div>

</body>
</html>
