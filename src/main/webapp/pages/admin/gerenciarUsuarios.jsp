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
<style>
    body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #fff8e1; color: #212121; margin: 0; padding: 0; }
    .container { max-width: 1100px; margin: 40px auto; padding: 0 20px; }
    h1 { text-align: center; font-size: 2.4rem; font-weight: 900; margin-bottom: 15px; color: #212121; }
    .top-actions { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 15px;}
    table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 12px; overflow: hidden; box-shadow: 0 5px 20px rgba(247,198,0,0.2); }
    th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #ffd600; }
    th { background: #ffd600; color: #212121; font-weight: 700; }
    tr:nth-child(even) { background: #fff9d1; }
    tr:hover { background: #fff3a0; }
    .btn { padding: 8px 16px; font-size: 0.9rem; border-radius: 20px; border: 1.5px solid #212121; font-weight: 700; cursor: pointer; background: transparent; transition: all 0.2s ease; text-decoration: none; }
    .btn:hover { background: #212121; color: #ffd600; border-color: #ffd600; }
    .btn-create { background: #212121; color: #ffd600; border-color: #212121; }
    .btn-create:hover { background: #000; color: #ffeb3b; }
    .actions { display: flex; gap: 5px; }
</style>
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
