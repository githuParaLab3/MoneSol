<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="br.com.monesol.model.Usuario" %>

<%
    HttpSession sessao = request.getSession(false);
    Usuario usuarioLogado = (sessao != null) ? (Usuario) sessao.getAttribute("usuarioLogado") : null;
    if (usuarioLogado == null || !"ADMIN".equalsIgnoreCase(usuarioLogado.getTipo().name())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Criar Novo Usuário - Admin MoneSol</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #fff8e1; color: #2e2e2e; min-height: 100vh; margin: 0; padding: 0; }
        main { max-width: 600px; margin: 50px auto; background: #fff; border: 1.5px solid #f7c600; border-radius: 12px; padding: 30px 25px; box-shadow: 0 8px 25px rgba(247, 198, 0, 0.25); }
        h1 { font-size: 2rem; font-weight: 900; color: #212121; margin-bottom: 25px; display: flex; align-items: center; gap: 16px; }
        .btn-back { text-decoration: none; color: #212121; border: 2px solid #212121; border-radius: 30px; padding: 8px 20px; font-weight: 700; transition: background 0.25s ease, color 0.25s ease; cursor: pointer; user-select: none; font-size: 0.9rem; display: inline-flex; align-items: center; gap: 6px; }
        .btn-back:hover { background: #212121; color: #ffd600; }
        label { display: block; font-weight: 700; margin-bottom: 8px; color: #555; }
        input[type="text"], input[type="email"], input[type="password"], select { width: 100%; padding: 10px 14px; margin-bottom: 20px; border-radius: 8px; border: 1px solid #f7c600; background: #f9f6d8; font-size: 1rem; color: #212121; box-sizing: border-box; }
        button[type="submit"] { background: #212121; color: #ffd600; font-weight: 700; border: none; border-radius: 30px; padding: 12px 28px; font-size: 1rem; cursor: pointer; user-select: none; width: 100%; transition: background 0.25s ease; }
        button[type="submit"]:hover { background: #000; }
    </style>
</head>
<body>
<jsp:include page="/pages/outros/mensagens.jsp" />

<main>
    <h1>
        <a href="<%= request.getContextPath() %>/pages/admin/gerenciarUsuarios.jsp" class="btn-back">
            &#8592; Voltar
        </a>
        Criar Novo Usuário
    </h1>

    <form action="<%= request.getContextPath() %>/UsuarioController" method="post">
        <input type="hidden" name="action" value="adminAdicionar" />

        <label for="cpfCnpj">CPF/CNPJ</label>
        <input type="text" id="cpfCnpj" name="cpfCnpj" required />

        <label for="nome">Nome Completo</label>
        <input type="text" id="nome" name="nome" required />

        <label for="email">Email</label>
        <input type="email" id="email" name="email" required />

        <label for="senha">Senha</label>
        <input type="password" id="senha" name="senha" required />

        <label for="contato">Contato</label>
        <input type="text" id="contato" name="contato" />

        <label for="endereco">Endereço</label>
        <input type="text" id="endereco" name="endereco" />

        <label for="tipo">Tipo de Usuário</label>
        <select id="tipo" name="tipo" required>
            <option value="CONSUMIDOR_PARCEIRO">Consumidor Parceiro</option>
            <option value="DONO_GERADORA">Dono de Geradora</option>
            <option value="ADMIN">Admin</option>
        </select>

        <button type="submit">Criar Usuário</button>
    </form>
</main>
</body>
</html>

