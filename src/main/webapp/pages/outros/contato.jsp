<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Contato - MoneSol</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #fff8e1;
            color: #212121;
            min-height: 100vh;
        }
        main {
            max-width: 600px;
            margin: 30px auto;
            padding: 40px 20px;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 8px 25px rgba(255, 214, 0, 0.3);
        }
        h1 {
            font-weight: 900;
            font-size: 2.2rem;
            margin-bottom: 30px;
            text-align: center;
        }
        form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        input[type="text"],
        input[type="email"],
        textarea {
            padding: 14px 18px;
            font-size: 1rem;
            border: 2px solid #ffd600;
            border-radius: 12px;
            font-family: inherit;
            background: #fff;
            color: #212121;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
            resize: vertical;
        }
        input[type="text"]:focus,
        input[type="email"]:focus,
        textarea:focus {
            outline: none;
            border-color: #212121;
            box-shadow: 0 0 8px #ffd600cc;
        }
        button {
            background: #212121;
            color: #ffd600;
            font-weight: 700;
            padding: 16px 0;
            font-size: 1.15rem;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            box-shadow: 0 6px 15px rgba(33,33,33,0.4);
            transition: background-color 0.3s ease;
            user-select: none;
        }
        button:hover {
            background: #000;
        }
        .btn-logout {
    background: transparent;
    border: 2px solid #212121;
    color: #212121;
    padding: 8px 20px;
    font-weight: 700;
    border-radius: 30px;
    cursor: pointer;
    transition: background-color 0.3s ease;
    user-select: none;
    font-size: 1rem;
    box-shadow: none;
}

.btn-logout:hover {
    background: #212121;
    color: #ffd600;
    box-shadow: none; 
}
        
    </style>
</head>
<body>

<jsp:include page="/pages/usuario/header.jsp" />

<main role="main" aria-label="Formulário de Contato">
    <h1>Contato</h1>
    <form action="#" method="post" novalidate>
        <input type="text" name="nome" placeholder="Seu nome" required />
        <input type="email" name="email" placeholder="Seu e-mail" required />
        <textarea name="mensagem" rows="5" placeholder="Sua mensagem" required></textarea>
        <button type="submit">Enviar</button>
    </form>
</main>

</body>
</html>
