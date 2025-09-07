<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="br.com.monesol.model.Usuario, br.com.monesol.dao.UsuarioDAO, java.util.List" %>

<%
    HttpSession sessao = request.getSession(false);
    Usuario usuarioLogado = (sessao != null) ? (Usuario) sessao.getAttribute("usuarioLogado") : null;
    if (usuarioLogado == null || !"ADMIN".equalsIgnoreCase(usuarioLogado.getTipo().name())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    UsuarioDAO usuarioDAO = new UsuarioDAO();
    List<Usuario> donos = usuarioDAO.listarTodos(); 
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Criar Nova Unidade Geradora - Admin MoneSol</title>
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
        Criar Nova Unidade
    </h1>
    <form action="<%= request.getContextPath() %>/UnidadeGeradoraController" method="post">
        <input type="hidden" name="action" value="adicionar" />

        <label for="cpfCnpjDono">Dono da Unidade</label>
        <select id="cpfCnpjDono" name="cpfCnpjDono" required>
            <option value="">Selecione um Dono</option>
            <% for (Usuario dono : donos) {
                if (dono.getTipo().name().equals("DONO_GERADORA")) { %>
                    <option value="<%= dono.getCpfCnpj() %>"><%= dono.getNome() %> (<%= dono.getCpfCnpj() %>)</option>
            <%  }
            } %>
        </select>

        <label for="localizacao">Localização</label>
        <input type="text" id="localizacao" name="localizacao" required />

        <label for="potenciaInstalada">Potência Instalada (kW)</label>
        <input type="number" step="0.01" id="potenciaInstalada" name="potenciaInstalada" required />

        <label for="eficienciaMedia">Eficiência Média (%)</label>
        <input type="number" step="0.01" id="eficienciaMedia" name="eficienciaMedia" />

        <label for="precoPorKWh">Preço por kWh (R$)</label>
        <input type="number" step="0.01" id="precoPorKWh" name="precoPorKWh" required />

        <label for="quantidadeMinimaAceita">Quantidade Mínima Aceite (kWh)</label>
        <input type="number" step="0.01" id="quantidadeMinimaAceita" name="quantidadeMinimaAceita" />

        <label for="regraDeExcecoes">Regras e Exceções</label>
        <textarea id="regraDeExcecoes" name="regraDeExcecoes" rows="3"></textarea>
        
        <label for="quantidadeMaximaComerciavel">Quantidade Máxima Comerciável (kWh)</label>
        <input type="number" step="0.01" id="quantidadeMaximaComerciavel" name="quantidadeMaximaComerciavel" placeholder="Ex: 200.00" />

        <button type="submit">Criar Unidade</button>
    </form>
</main>
</body>
</html>
