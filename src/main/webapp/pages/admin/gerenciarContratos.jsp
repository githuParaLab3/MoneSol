<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="br.com.monesol.model.*" %>
<%@ page import="br.com.monesol.dao.*" %>
<%@ page import="java.util.List" %>

<%
    HttpSession sessao = request.getSession(false);
    Usuario usuarioLogado = (sessao != null) ? (Usuario) sessao.getAttribute("usuarioLogado") : null;
    if (usuarioLogado == null || !"ADMIN".equalsIgnoreCase(usuarioLogado.getTipo().name())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    ContratoDAO contratoDAO = new ContratoDAO();
    UnidadeGeradoraDAO unidadeDAO = new UnidadeGeradoraDAO();
    UsuarioDAO usuarioDAO = new UsuarioDAO();

    List<Contrato> listaContratos = contratoDAO.listarTodos();

    for (Contrato c : listaContratos) {
        c.setUsuario(usuarioDAO.buscarPorCpfCnpj(c.getUsuario().getCpfCnpj()));
        c.setUnidadeGeradora(unidadeDAO.buscarPorId(c.getUnidadeGeradora().getId()));
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<title>Gerenciar Contratos - Admin MoneSol</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: #fff8e1;
        color: #212121;
        margin: 0;
        padding: 0;
    }
    .container {
        max-width: 1100px;
        margin: 40px auto;
        padding: 0 20px;
    }
    h1 {
        text-align: center;
        font-size: 2.4rem;
        font-weight: 900;
        margin-bottom: 30px;
        color: #212121;
    }
    .top-actions {
        display: flex;
        justify-content: flex-end;
        margin-bottom: 15px;
        gap: 10px;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        background: #fff;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 5px 20px rgba(247,198,0,0.2);
    }
    th, td {
        padding: 12px 15px;
        text-align: left;
        border-bottom: 1px solid #ffd600;
        vertical-align: middle;
    }
    th {
        background: #ffd600;
        color: #212121;
        font-weight: 700;
    }
    tr:nth-child(even) {
        background: #fff9d1;
    }
    tr:hover {
        background: #fff3a0;
    }
    .btn {
        padding: 6px 12px;
        font-size: 0.9rem;
        border-radius: 20px;
        border: 1.5px solid #212121;
        font-weight: 700;
        cursor: pointer;
        background: transparent;
        margin: 2px;
        transition: all 0.2s ease;
    }
    .btn:hover {
        background: #212121;
        color: #ffd600;
        border-color: #ffd600;
    }
    .actions {
        display: flex;
        gap: 5px;
    }
</style>
</head>
<body>

<jsp:include page="/pages/usuario/header.jsp" />

<div class="container">
    <h1>Gerenciar Contratos</h1>

    

    <% if (listaContratos != null && !listaContratos.isEmpty()) { %>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Vigência Início</th>
                    <th>Vigência Fim</th>
                    <th>Quantidade Contratada</th>
                    <th>Unidade Geradora</th>
                    <th>Usuário</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>
                <% for (Contrato c : listaContratos) { %>
                <tr>
                    <td><%= c.getId() %></td>
                    <td><%= c.getVigenciaInicio() != null ? c.getVigenciaInicio() : "-" %></td>
                    <td><%= c.getVigenciaFim() != null ? c.getVigenciaFim() : "-" %></td>
                    <td><%= c.getQuantidadeContratada() %></td>
                    <td><%= c.getUnidadeGeradora() != null ? c.getUnidadeGeradora().getLocalizacao() : "-" %></td>
                    <td><%= c.getUsuario() != null ? c.getUsuario().getNome() : "-" %></td>
                    <td>
                        <div class="actions">
                            <form action="<%= request.getContextPath() %>/pages/contrato/editarContrato.jsp" method="get">
                                <input type="hidden" name="id" value="<%= c.getId() %>" />
                                <button type="submit" class="btn">Editar</button>
                            </form>
                            <form action="<%= request.getContextPath() %>/ContratoController" method="post">
                                <input type="hidden" name="action" value="deletar" />
                                <input type="hidden" name="id" value="<%= c.getId() %>" />
                                <button type="submit" class="btn" onclick="return confirm('Deseja realmente deletar este contrato?');">Deletar</button>
                            </form>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    <% } else { %>
        <p>Nenhum contrato cadastrado.</p>
    <% } %>
</div>

</body>
</html>
