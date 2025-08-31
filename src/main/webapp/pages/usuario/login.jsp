<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Login - MoneSol</title>
    <link rel="stylesheet" href="../styles/main.css" />
    <style>
        body {
            background: #fffde7;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
            margin: 0;
        }

        .container {
            max-width: 500px;
            margin: 80px auto;
            background: #ffffff;
            border: 2px solid #ffd600;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(255, 214, 0, 0.3);
            padding: 40px 30px;
        }

        h2 {
            text-align: center;
            color: #212121;
            margin-bottom: 30px;
            font-size: 2rem;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        label {
            font-weight: 600;
            color: #424242;
        }

        input[type="text"],
        input[type="password"] {
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 1rem;
        }

        button {
            background: #ffd600;
            color: #212121;
            font-weight: 700;
            padding: 14px;
            font-size: 1.1rem;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background: #ffeb3b;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 25px;
            color: #388e3c;
            text-decoration: none;
            font-weight: 600;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
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
    <a class="back-link" href="${pageContext.request.contextPath}/pages/usuario/cadastro.jsp">Não tem uma conta? Cadastre-se</a>
</div>

</body>
</html>
