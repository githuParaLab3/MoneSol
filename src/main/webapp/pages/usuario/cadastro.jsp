<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Cadastro - MoneSol</title>
    <link rel="stylesheet" href="../styles/main.css" />
    <style>
        body {
            background: #fff8e1;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
            margin: 0;
        }

        .container {
            max-width: 600px;
            margin: 60px auto;
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
        input[type="email"],
        input[type="password"],
        textarea {
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 1rem;
            resize: vertical;
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
            background: #ffea00;
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

      
        .tipo-usuario-radio-group {
            display: flex;
            gap: 20px;
            margin-top: 6px;
        }

        .radio-btn {
            cursor: pointer;
            user-select: none;
            border: 2px solid #ccc;
            padding: 12px 20px;
            border-radius: 30px;
            font-weight: 700;
            color: #555;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .radio-btn input[type="radio"] {
            display: none;
        }

        .radio-btn span {
            pointer-events: none;
        }

        .radio-btn input[type="radio"]:checked + span {
            background-color: #ffd600;
            color: #212121;
            border-radius: 30px;
            padding: 6px 14px;
            border: none;
        }

        .radio-btn:hover {
            border-color: #ffd600;
        }
    </style>
</head>
<body>
	<jsp:include page="/pages/outros/mensagens.jsp" />


<header style="background: #FFD600; padding: 12px 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); display: flex; align-items: center;">
    <a href="../../index.jsp" style="text-decoration: none; color: inherit;">
        <span style="font-weight: 900; font-size: 2rem; color: #212121; letter-spacing: 1.5px;">
            MoneSol
        </span>
    </a>
</header>

<div class="container">
    <h2>Crie sua conta na MoneSol</h2>
    <form action="../../UsuarioController" method="post">
        <input type="hidden" name="action" value="adicionar" />

        <label for="cpfCnpj">CPF/CNPJ</label>
        <input type="text" id="cpfCnpj" name="cpfCnpj" required />

        <label for="nome">Nome completo</label>
        <input type="text" id="nome" name="nome" required />

        <label for="email">E-mail</label>
        <input type="email" id="email" name="email" required />

        <label for="senha">Senha</label>
        <input type="password" id="senha" name="senha" required />

        <label for="contato">Contato</label>
        <input type="text" id="contato" name="contato" placeholder="Telefone ou celular" required />

        <label for="endereco">Endereço</label>
        <textarea id="endereco" name="endereco" rows="3" required></textarea>

        <label>Deseja se cadastrar como:</label>
        <div class="tipo-usuario-radio-group">
            <label class="radio-btn">
                <input type="radio" name="tipo" value="DONO_GERADORA" required />
                <span>Dono de Unidades</span>
            </label>
            <label class="radio-btn">
                <input type="radio" name="tipo" value="CONSUMIDOR_PARCEIRO" />
                <span>Consumidor</span>
            </label>
        </div>

        <button type="submit">Cadastrar</button>
    </form>
    <a class="back-link" href="./login.jsp">Já tem conta? Faça login</a>
</div>

<script>
function validarCPFouCNPJ(valor) {
    const apenasNumeros = valor.replace(/\D/g, "");

    if (apenasNumeros.length !== 11 && apenasNumeros.length !== 14) {
        return false;
    }
   
    const cpfRegex = /^\d{3}\.?\d{3}\.?\d{3}-?\d{2}$/;
    const cnpjRegex = /^\d{2}\.?\d{3}\.?\d{3}\/?\d{4}-?\d{2}$/;
    return cpfRegex.test(valor) || cnpjRegex.test(valor) || (!isNaN(apenasNumeros) && (apenasNumeros.length === 11 || apenasNumeros.length === 14));
}

function aplicarMascaraCpfCnpj(input) {
    input.addEventListener("input", function () {
        let value = input.value.replace(/\D/g, "");

        if (value.length > 14) {
            value = value.slice(0, 14);
        }

        if (value.length <= 11) {
            value = value.replace(/(\d{3})(\d)/, "$1.$2");
            value = value.replace(/(\d{3})(\d)/, "$1.$2");
            value = value.replace(/(\d{3})(\d{1,2})$/, "$1-$2");
        } else {
            value = value.replace(/^(\d{2})(\d)/, "$1.$2");
            value = value.replace(/^(\d{2})\.(\d{3})(\d)/, "$1.$2.$3");
            value = value.replace(/\.(\d{3})(\d)/, ".$1/$2");
            value = value.replace(/(\d{4})(\d)/, "$1-$2");
        }

        input.value = value;
    });
}

function aplicarMascaraTelefone(input) {
    input.addEventListener("input", function () {
        let valor = input.value.replace(/\D/g, ""); 
        
        if (valor.length > 11) {
            valor = valor.slice(0, 11); 
        }

        if (valor.length > 10) {
            // (XX) XXXXX-XXXX
            valor = valor.replace(/^(\d{2})(\d{5})(\d{4}).*/, "($1) $2-$3");
        } else if (valor.length > 5) {
            // (XX) XXXX-XXXX
            valor = valor.replace(/^(\d{2})(\d{4})(\d{0,4}).*/, "($1) $2-$3");
        } else if (valor.length > 2) {
            // (XX) XXXX
            valor = valor.replace(/^(\d{2})(\d{0,5})/, "($1) $2");
        } else if (valor.length > 0) {
            // (XX
            valor = valor.replace(/^(\d{0,2})/, "($1");
        }

        input.value = valor;
    });
}

document.addEventListener("DOMContentLoaded", function () {
    const contatoInput = document.getElementById("contato");
    if (contatoInput) {
        aplicarMascaraTelefone(contatoInput);
    }

    const cpfCnpjInput = document.getElementById("cpfCnpj");
    if (cpfCnpjInput) {
        aplicarMascaraCpfCnpj(cpfCnpjInput);
    }

    const form = document.querySelector("form");
    form.addEventListener("submit", function (e) {
        if (contatoInput) {
            contatoInput.value = contatoInput.value.replace(/\D/g, "");
        }
        if (cpfCnpjInput) {
            cpfCnpjInput.value = cpfCnpjInput.value.replace(/\D/g, "");
        }
    });
});
</script>

</body>
</html>
