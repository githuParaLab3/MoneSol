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
    List<Usuario> donos = usuarioDAO.listarTodos(); // Ou um método específico para donos
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Criar Nova Unidade Geradora - Admin MoneSol</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #fff8e1; color: #2e2e2e; min-height: 100vh; margin: 0; padding: 0; }
        main { max-width: 600px; margin: 50px auto; background: #fff; border: 1.5px solid #f7c600; border-radius: 12px; padding: 30px 25px; box-shadow: 0 8px 25px rgba(247, 198, 0, 0.25); }
        h1 { font-size: 2rem; font-weight: 900; color: #212121; margin-bottom: 25px; display: flex; align-items: center; gap: 16px; }
        .btn-back { text-decoration: none; color: #212121; border: 2px solid #212121; border-radius: 30px; padding: 8px 20px; font-weight: 700; transition: background 0.25s ease, color 0.25s ease; cursor: pointer; user-select: none; font-size: 0.9rem; display: inline-flex; align-items: center; gap: 6px; }
        .btn-back:hover { background: #212121; color: #ffd600; }
        label { display: block; font-weight: 700; margin-bottom: 8px; color: #555; }
        input[type="text"], input[type="number"], select, textarea { width: 100%; padding: 10px 14px; margin-bottom: 20px; border-radius: 8px; border: 1px solid #f7c600; background: #f9f6d8; font-size: 1rem; color: #212121; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        textarea { resize: vertical; }
        button[type="submit"] { background: #212121; color: #ffd600; font-weight: 700; border: none; border-radius: 30px; padding: 12px 28px; font-size: 1rem; cursor: pointer; user-select: none; width: 100%; transition: background 0.25s ease; }
        button[type="submit"]:hover { background: #000; }
    </style>
</head>
<body>
<jsp:include page="/pages/outros/mensagens.jsp" />

<main>
    <h1>
        <a href="<%= request.getContextPath() %>/pages/admin/gerenciarUnidades.jsp" class="btn-back">
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

        <button type="submit">Criar Unidade</button>
    </form>
</main>
</body>
</html>

