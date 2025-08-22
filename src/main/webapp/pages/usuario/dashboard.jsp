<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="br.com.monesol.model.*, br.com.monesol.dao.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    HttpSession sessao = request.getSession(false);
    Usuario usuario = (sessao != null) ? (Usuario) sessao.getAttribute("usuarioLogado") : null;
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
        return;
    }

    ContratoDAO contratoDAO = new ContratoDAO();
    List<Contrato> contratos = contratoDAO.listarPorUsuario(usuario.getCpfCnpj());

    UnidadeGeradoraDAO unidadeDAO = new UnidadeGeradoraDAO();
    List<UnidadeGeradora> unidades = unidadeDAO.listarPorUsuario(usuario.getCpfCnpj());
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Dashboard - MoneSol</title>
<style>
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

    header {
        background: var(--yellow);
        padding: 15px 40px;
        display: flex;
        flex-wrap: wrap;
        align-items: center;
        justify-content: space-between;
        box-shadow: 0 3px 6px rgba(0,0,0,0.1);
        position: sticky;
        top: 0;
        z-index: 1000;
    }
    header h1 {
        font-weight: 900;
        font-size: 2.4rem;
        color: var(--dark);
        letter-spacing: 2px;
        margin: 0;
        user-select: none;
    }
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
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        align-items: center;
        gap: 8px;
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
    .edit-button:hover {
        background: #ffeb3b;
    }
    .btn-nova-unidade {
        background: var(--dark);
        color: var(--yellow);
        padding: 8px 20px;
        border-radius: 30px;
        font-weight: 700;
        cursor: pointer;
        border: none;
        transition: background-color 0.3s ease;
        user-select: none;
        font-size: 1rem;
        white-space: nowrap;
    }
    .btn-nova-unidade:hover {
        background: #000;
        color: #fff700;
    }
    .units-list {
        list-style: none;
        padding: 0;
        margin: 0;
        margin-top: 10px;
        display: flex;
        flex-direction: column;
        gap: 12px;
    }
    .unit-card {
        background: #ffffff;
        border: 1.5px solid var(--yellow);
        border-radius: var(--radius);
        padding: 16px 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 12px;
        box-shadow: 0 6px 20px rgba(255, 214, 0, 0.2);
        transition: transform .2s ease, box-shadow .2s ease;
    }
    .unit-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 30px rgba(255,214,0,0.35);
    }
    .unit-info {
        display: flex;
        flex-direction: column;
        gap: 4px;
        flex:1;
        min-width:0;
    }
    .unit-title {
        font-weight: 700;
        font-size: 1.1rem;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }
    .unit-sub {
        font-size: .9rem;
        color: #555;
    }
    .arrow {
        flex-shrink: 0;
        font-size: 1.5rem;
        color: var(--dark);
    }
    @media (max-width: 900px) {
        .unit-card {
            flex-direction: column;
            align-items: flex-start;
        }
        .arrow {
            margin-top: 6px;
        }
    }
</style>
</head>
<body>

<jsp:include page="/pages/usuario/header.jsp" />

<div class="container">

    <!-- Dados do Usuário -->
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
    </div>

    <!-- Contratos -->
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
                                <div class="unit-sub"><strong>Modelo:</strong> <%= c.getModeloComercial() != null ? c.getModeloComercial() : "-" %></div>
                                <div class="unit-sub"><strong>Qtd. Contratada:</strong> <%= c.getQtdContratada() %> kWh</div>
                                <div class="unit-sub"><strong>Preço:</strong> R$ <%= String.format("%.4f", c.getPrecoPorKWh()) %> / kWh</div>
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

    <!-- Unidades Geradoras -->
    <% if (usuario.getTipo() == br.com.monesol.model.Usuario.TipoUsuario.DONO_GERADORA) { %>
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
