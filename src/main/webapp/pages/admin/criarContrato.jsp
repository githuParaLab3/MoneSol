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
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #fff8e1; color: #2e2e2e; min-height: 100vh; margin: 0; padding: 0; }
        main { max-width: 600px; margin: 50px auto; background: #fff; border: 1.5px solid #f7c600; border-radius: 12px; padding: 30px 25px; box-shadow: 0 8px 25px rgba(247, 198, 0, 0.25); }
        h1 { font-size: 2rem; font-weight: 900; color: #212121; margin-bottom: 25px; display: flex; align-items: center; gap: 16px; }
        .btn-back { text-decoration: none; color: #212121; border: 2px solid #212121; border-radius: 30px; padding: 8px 20px; font-weight: 700; transition: background 0.25s ease, color 0.25s ease; cursor: pointer; user-select: none; font-size: 0.9rem; display: inline-flex; align-items: center; gap: 6px; }
        .btn-back:hover { background: #212121; color: #ffd600; }
        label { display: block; font-weight: 700; margin-bottom: 8px; color: #555; }
        input[type="date"], input[type="number"], select { width: 100%; padding: 10px 14px; margin-bottom: 20px; border-radius: 8px; border: 1px solid #f7c600; background: #f9f6d8; font-size: 1rem; color: #212121; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        button[type="submit"] { background: #212121; color: #ffd600; font-weight: 700; border: none; border-radius: 30px; padding: 12px 28px; font-size: 1rem; cursor: pointer; user-select: none; width: 100%; transition: background 0.25s ease; }
        button[type="submit"]:hover { background: #000; }
    </style>
</head>
<body>
<jsp:include page="/pages/outros/mensagens.jsp" />

<main>
    <h1>
        <a href="<%= request.getContextPath() %>/pages/admin/gerenciarContratos.jsp" class="btn-back">
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

