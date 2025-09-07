<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="br.com.monesol.model.*, br.com.monesol.dao.*, java.util.List" %>

<%
    HttpSession sessao = request.getSession(false);
    Usuario usuarioLogado = (sessao != null) ? (Usuario) sessao.getAttribute("usuarioLogado") : null;
    if (usuarioLogado == null || !"ADMIN".equalsIgnoreCase(usuarioLogado.getTipo().name())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    UsuarioDAO usuarioDAO = new UsuarioDAO();
    List<Usuario> usuarios = usuarioDAO.listarTodos();
    
    UnidadeGeradoraDAO unidadeDAO = new UnidadeGeradoraDAO();
    List<UnidadeGeradora> unidades = unidadeDAO.listarTodas();
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Criar Novo Contrato - Admin MoneSol</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/forms.css" />
</head>
<body>
<jsp:include page="/pages/outros/mensagens.jsp" />

<main>
    <h1>
        <a href="javascript:history.back()" class="btn-back">
            &#8592; Voltar
        </a>
        Criar Novo Contrato
    </h1>
    <form action="<%= request.getContextPath() %>/ContratoController" method="post">
        <input type="hidden" name="action" value="adminAdicionar" />

        <label for="cpfCnpjUsuario">Utilizador (Consumidor)</label>
        <select id="cpfCnpjUsuario" name="cpfCnpjUsuario" required>
            <option value="">Selecione um utilizador</option>
            <% for (Usuario u : usuarios) {
                if(u.getTipo().name().equals("CONSUMIDOR_PARCEIRO")) { %>
                    <option value="<%= u.getCpfCnpj() %>"><%= u.getNome() %> (<%= u.getCpfCnpj() %>)</option>
            <%  }
            } %>
        </select>
        
        <label for="idUnidade">Unidade Geradora</label>
        <select id="idUnidade" name="idUnidade" required>
            <option value="">Selecione uma unidade</option>
            <% for (UnidadeGeradora ug : unidades) { %>
                <option value="<%= ug.getId() %>"><%= ug.getLocalizacao() %> (ID: <%= ug.getId() %>)</option>
            <% } %>
        </select>
        
        <label for="vigenciaInicio">Início da Vigência</label>
        <input type="date" id="vigenciaInicio" name="vigenciaInicio" required />

        <label for="vigenciaFim">Fim da Vigência</label>
        <input type="date" id="vigenciaFim" name="vigenciaFim" required />
        
        <label for="reajustePeriodico">Período de Reajuste (meses)</label>
        <input type="number" id="reajustePeriodico" name="reajustePeriodico" min="1" required />

        <label for="quantidadeContratada">Quantidade Contratada (kWh)</label>
        <input type="number" id="quantidadeContratada" name="quantidadeContratada" step="0.01" min="0" required />

        <button type="submit">Criar Contrato</button>
    </form>
</main>
</body>
</html>
