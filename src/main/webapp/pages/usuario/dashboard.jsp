<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="br.com.monesol.model.*, br.com.monesol.dao.*" %>
<%@ page import="java.util.List" %>

<%
    HttpSession sessao = request.getSession(false);
    Usuario usuario = (sessao != null) ? (Usuario) sessao.getAttribute("usuarioLogado") : null;
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
        return;
    }

    ContratoDAO contratoDAO = new ContratoDAO();
    List<Contrato> contratos;
    if (usuario.getTipo() == Usuario.TipoUsuario.DONO_GERADORA) {
        contratos = contratoDAO.listarPorDonoGeradora(usuario.getCpfCnpj());
    } else {
        contratos = contratoDAO.listarPorUsuario(usuario.getCpfCnpj());
    }

    UnidadeGeradoraDAO unidadeDAO = new UnidadeGeradoraDAO();
    List<UnidadeGeradora> unidades = unidadeDAO.listarPorUsuario(usuario.getCpfCnpj());
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Dashboard - MoneSol</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css" />
</head>
<body>

<jsp:include page="/pages/outros/mensagens.jsp" />
<jsp:include page="/pages/usuario/header.jsp" />

<div class="container">

    <div class="section" aria-label="Informações do usuário">
        <h2>Meus Dados</h2>
        <p><strong>Nome:</strong> <%= usuario.getNome() %></p>
        <p><strong>Email:</strong> <%= usuario.getEmail() %></p>
        <p><strong>CPF/CNPJ:</strong> <%= usuario.getCpfCnpj() %></p>
        <p><strong>Contato:</strong> <%= usuario.getContato() != null ? usuario.getContato() : "-" %></p>
        <p><strong>Endereço:</strong> <%= usuario.getEndereco() != null ? usuario.getEndereco() : "-" %></p>

        <form action="<%= request.getContextPath() %>/pages/usuario/editarUsuario.jsp" method="get" style="margin-top:10px;">
            <button type="submit" class="edit-button">Editar meus dados</button>
        </form>

        <form action="<%= request.getContextPath() %>/UsuarioController" method="post" style="margin-top:15px;"
              onsubmit="return confirm('Deseja realmente deletar sua conta? Esta ação não pode ser desfeita.');">
            <input type="hidden" name="action" value="deletar" />
            <input type="hidden" name="cpfCnpj" value="<%= usuario.getCpfCnpj() %>" />
            <button type="submit" class="edit-button" style="background:#d32f2f; color:#fff; border-color:#d32f2f;">
                Deletar Minha Conta
            </button>
        </form>
    </div>

    <div class="section" aria-label="Contratos do usuário">
        <h2>Meus Contratos</h2>
        <% if (contratos == null || contratos.isEmpty()) { %>
            <p>Você não possui contratos ativos.</p>
        <% } else { %>
            <ul class="units-list" role="list">
                <% for (Contrato c : contratos) { %>
                    <li>
                        <div class="unit-card">
                            <div class="unit-info">
                                <div class="unit-title">Contrato ID: <%= c.getId() %></div>
                                <div class="unit-sub"><strong>Vigência:</strong> 
                                    <%= (c.getVigenciaInicio() != null ? c.getVigenciaInicio() : "-") %> até 
                                    <%= (c.getVigenciaFim() != null ? c.getVigenciaFim() : "-") %>
                                </div>
                                <div class="unit-sub"><strong>Unidade:</strong> <%= c.getUnidadeGeradora() != null ? c.getUnidadeGeradora().getLocalizacao() : "-" %></div>
                                <div class="unit-sub"><strong>Qtd. Contratada:</strong> <%= c.getQuantidadeContratada() %> kWh</div>
                                <div class="unit-sub"><strong>Preço:</strong> R$ <%= String.format("%.4f", c.getUnidadeGeradora().getPrecoPorKWh()) %> / kWh</div>
                            </div>
                            <form method="post" action="<%= request.getContextPath() %>/ContratoController" style="margin:0; align-self:center;">
                                <input type="hidden" name="action" value="buscarPorId" />
                                <input type="hidden" name="id" value="<%= c.getId() %>" />
                                <button type="submit" class="edit-button">Detalhes</button>
                            </form>
                        </div>
                    </li>
                <% } %>
            </ul>
        <% } %>
    </div>

    <% if (usuario.getTipo() == Usuario.TipoUsuario.DONO_GERADORA) { %>
        <div class="section" aria-label="Unidades geradoras do usuário">
            <h2>
                Minhas Unidades Geradoras
                <a href="<%= request.getContextPath() %>/pages/unidadeGeradora/cadastrarUnidade.jsp" class="btn-nova-unidade">+ Nova Unidade</a>
            </h2>
            <% if (unidades == null || unidades.isEmpty()) { %>
                <p>Você não possui unidades geradoras cadastradas.</p>
            <% } else { %>
                <ul class="units-list" role="list">
                    <% for (UnidadeGeradora u : unidades) { %>
                        <li>
                            <a role="listitem" class="unit-card" href="<%= request.getContextPath() %>/UnidadeGeradoraController?action=buscarPorId&amp;id=<%= u.getId() %>">
                                <div>
                                    <div class="unit-title"><%= u.getLocalizacao() %></div>
                                    <div class="unit-sub">Potência instalada: <strong><%= String.format("%.2f", u.getPotenciaInstalada()) %> kW</strong></div>
                                    <div class="unit-sub">Qtd. Máxima Comerciável: <strong><%= String.format("%.2f", u.getQuantidadeMaximaComerciavel()) %> kWh</strong></div>
                                </div>
                                <div>&rsaquo;</div>
                            </a>
                        </li>
                    <% } %>
                </ul>
            <% } %>
        </div>
    <% } %>

</div>

</body>
</html>
