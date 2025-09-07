<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Login - MoneSol</title>
   <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css" />
</head>
<body>

	<jsp:include page="/pages/outros/mensagens.jsp" />


<header style="background: #FFD600; padding: 12px 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); display: flex; align-items: center;">
    <a href="${pageContext.request.contextPath}/index.jsp" style="text-decoration: none; color: inherit;">
        <span style="font-weight: 900; font-size: 2rem; color: #212121; letter-spacing: 1.5px;">
            MoneSol
        </span>
    </a>
</header>

<div class="container">
    <h2>Entrar no MoneSol</h2>
    <form action="${pageContext.request.contextPath}/UsuarioController" method="post">
        <input type="hidden" name="action" value="login" />

      
   <label for="cpfCnpj">CPF ou CNPJ</label>
        <input type="text" id="cpfCnpj" name="cpfCnpj" required />

        <label for="senha">Senha</label>
        <input type="password" id="senha" name="senha" required />

        <button type="submit">Entrar</button>
    </form>
    <a class="back-link" href="${pageContext.request.contextPath}/pages/usuario/cadastro.jsp">Não tem uma conta?
 Cadastre-se</a>
</div>

</body>
</html>