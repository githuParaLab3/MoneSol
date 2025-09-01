<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Cadastro - MoneSol</title>
    <link rel="stylesheet" href="../styles/main.css" />
    <style>
        body { background: #fff8e1; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; color: #333; margin: 0; }
        .container { max-width: 600px; margin: 60px auto; background: #ffffff; border: 2px solid #ffd600; border-radius: 15px; box-shadow: 0 5px 20px rgba(255, 214, 0, 0.3); padding: 40px 30px; }
        h2 { text-align: center; color: #212121; margin-bottom: 30px; font-size: 2rem; }
        form { display: flex; flex-direction: column; gap: 15px; }
        label { font-weight: 600; color: #424242; }
        input[type="text"], input[type="email"], input[type="password"] { padding: 12px; border: 1px solid #ccc; border-radius: 8px; font-size: 1rem; margin-top: -10px; }
        button { background: #ffd600; color: #212121; font-weight: 700; padding: 14px; font-size: 1.1rem; border: none; border-radius: 30px; cursor: pointer; transition: background-color 0.3s ease; margin-top: 10px; }
        button:hover { background: #ffea00; }
        .back-link { display: block; text-align: center; margin-top: 25px; color: #388e3c; text-decoration: none; font-weight: 600; }
        .back-link:hover { text-decoration: underline; }
        .tipo-usuario-radio-group { display: flex; gap: 20px; margin-top: 6px; }
        .radio-btn { cursor: pointer; user-select: none; border: 2px solid #ccc; padding: 12px 20px; border-radius: 30px; font-weight: 700; color: #555; transition: all 0.3s ease; display: flex; align-items: center; gap: 10px; }
        .radio-btn input[type="radio"] { display: none; }
        .radio-btn span { pointer-events: none; }
        .radio-btn input[type="radio"]:checked + span { background-color: #ffd600; color: #212121; border-radius: 30px; padding: 6px 14px; border: none; }
        .radio-btn:hover { border-color: #ffd600; }
        .label-container { display: flex; align-items: center; gap: 8px; }
        .tooltip { position: relative; display: inline-block; cursor: help; background-color: #e0e0e0; color: #555; width: 20px; height: 20px; border-radius: 50%; text-align: center; font-weight: bold; line-height: 20px; font-size: 14px; }
        .tooltip .tooltip-text { visibility: hidden; width: 220px; background-color: #333; color: #fff; text-align: center; border-radius: 6px; padding: 8px; position: absolute; z-index: 1; bottom: 125%; left: 50%; margin-left: -110px; opacity: 0; transition: opacity 0.3s; }
        .tooltip .tooltip-text::after { content: ""; position: absolute; top: 100%; left: 50%; margin-left: -5px; border-width: 5px; border-style: solid; border-color: #333 transparent transparent transparent; }
        .tooltip:hover .tooltip-text { visibility: visible; opacity: 1; }
        .endereco-grid { display: grid; grid-template-columns: repeat(6, 1fr); gap: 10px; margin-top: -10px; }
        .endereco-grid input, .endereco-grid select { margin-top: 0; }
        .grid-col-2 { grid-column: span 2; }
        .grid-col-3 { grid-column: span 3; }
        .grid-col-4 { grid-column: span 4; }
        select#estado { padding: 12px; border: 1px solid #ccc; border-radius: 8px; font-size: 1rem; background-color: white; color: #555; }
    </style>
</head>
<body>
	<jsp:include page="/pages/outros/mensagens.jsp" />

    <header style="background: #FFD600; padding: 12px 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); display: flex; align-items: center;">
        <a href="../../index.jsp" style="text-decoration: none; color: inherit;">
            <span style="font-weight: 900; font-size: 2rem; color: #212121; letter-spacing: 1.5px;">MoneSol</span>
        </a>
    </header>

    <div class="container">
        <h2>Crie sua conta na MoneSol</h2>
        <form action="../../UsuarioController" method="post">
            <input type="hidden" name="action" value="adicionar" />

            <div class="label-container">
                <label for="cpfCnpj">CPF/CNPJ</label>
                <span class="tooltip">?<span class="tooltip-text">Digite seu CPF (11 dígitos) ou CNPJ (14 dígitos). Digite apenas números</span></span>
            </div>
            <input type="text" id="cpfCnpj" name="cpfCnpj" required />

            <div class="label-container"><label for="nome">Nome completo</label></div>
            <input type="text" id="nome" name="nome" required />

            <div class="label-container">
                <label for="email">E-mail</label>
                <span class="tooltip">?<span class="tooltip-text">Use seu melhor e-mail para login e comunicação.</span></span>
            </div>
            <input type="email" id="email" name="email" required />

            <div class="label-container">
                <label for="senha">Senha</label>
                <span class="tooltip">?<span class="tooltip-text">A senha deve ter no mínimo 6 caracteres.</span></span>
            </div>
            <input type="password" id="senha" name="senha" required />

            <div class="label-container">
                <label for="contato">Contato</label>
                <span class="tooltip">?<span class="tooltip-text">Inclua o DDD. Ex: (71) 98765-4321</span></span>
            </div>
            <input type="text" id="contato" name="contato" placeholder="Telefone ou celular" required />

            <div class="label-container"><label>Endereço</label></div>
            <div class="endereco-grid">
                <input type="text" id="cep" placeholder="CEP" class="grid-col-2" required />
                <input type="text" id="logradouro" placeholder="Logradouro (Rua, Av.)" class="grid-col-4" required />
                <input type="text" id="numero" placeholder="Número" class="grid-col-2" required />
                <input type="text" id="complemento" placeholder="Complemento (Opcional)" class="grid-col-4" />
                <input type="text" id="bairro" placeholder="Bairro" class="grid-col-3" required />
                <input type="text" id="cidade" placeholder="Cidade" class="grid-col-3" required />
                <select id="estado" class="grid-col-2" required>
                    <option value="">UF</option>
                    <option value="AC">AC</option><option value="AL">AL</option><option value="AP">AP</option><option value="AM">AM</option><option value="BA">BA</option><option value="CE">CE</option><option value="DF">DF</option><option value="ES">ES</option><option value="GO">GO</option><option value="MA">MA</option><option value="MT">MT</option><option value="MS">MS</option><option value="MG">MG</option><option value="PA">PA</option><option value="PB">PB</option><option value="PR">PR</option><option value="PE">PE</option><option value="PI">PI</option><option value="RJ">RJ</option><option value="RN">RN</option><option value="RS">RS</option><option value="RO">RO</option><option value="RR">RR</option><option value="SC">SC</option><option value="SP">SP</option><option value="SE">SE</option><option value="TO">TO</option>
                </select>
            </div>
            <input type="hidden" id="endereco" name="endereco" />

            <div class="label-container"><label>Deseja se cadastrar como:</label></div>
            <div class="tipo-usuario-radio-group">
                <label class="radio-btn"><input type="radio" name="tipo" value="DONO_GERADORA" required /><span>Dono de Unidades</span></label>
                <label class="radio-btn"><input type="radio" name="tipo" value="CONSUMIDOR_PARCEIRO" /><span>Consumidor</span></label>
            </div>

            <button type="submit">Cadastrar</button>
        </form>
        <a class="back-link" href="./login.jsp">Já tem conta? Faça login</a>
    </div>

<script>
    // --- SUAS FUNÇÕES ORIGINAIS ---
    function validarCPFouCNPJ(valor) {
        const apenasNumeros = valor.replace(/\D/g, "");
        if (apenasNumeros.length !== 11 && apenasNumeros.length !== 14) { return false; }
        const cpfRegex = /^\d{3}\.?\d{3}\.?\d{3}-?\d{2}$/;
        const cnpjRegex = /^\d{2}\.?\d{3}\.?\d{3}\/?\d{4}-?\d{2}$/;
        return cpfRegex.test(valor) || cnpjRegex.test(valor) || (!isNaN(apenasNumeros) && (apenasNumeros.length === 11 || apenasNumeros.length === 14));
    }

    function aplicarMascaraCpfCnpj(input) {
        input.addEventListener("input", function () {
            let value = input.value.replace(/\D/g, "");
            if (value.length > 14) { value = value.slice(0, 14); }
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
            if (valor.length > 11) { valor = valor.slice(0, 11); }
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

    // --- FUNÇÃO PARA BUSCAR ENDEREÇO PELO CEP ---
    function preencherEndereco(cep) {
        cep = cep.replace(/\D/g, '');
        if (cep.length !== 8) return;
        fetch(`https://viacep.com.br/ws/${cep}/json/`)
            .then(response => response.json())
            .then(data => {
                if (!data.erro) {
                    document.getElementById('logradouro').value = data.logradouro;
                    document.getElementById('bairro').value = data.bairro;
                    document.getElementById('cidade').value = data.localidade;
                    document.getElementById('estado').value = data.uf;
                    document.getElementById('numero').focus();
                }
            })
            .catch(error => console.error('Erro ao buscar CEP:', error));
    }

    // --- LÓGICA PRINCIPAL DA PÁGINA ---
    document.addEventListener("DOMContentLoaded", function () {
        // Aplica as máscaras
        const contatoInput = document.getElementById("contato");
        aplicarMascaraTelefone(contatoInput);

        const cpfCnpjInput = document.getElementById("cpfCnpj");
        aplicarMascaraCpfCnpj(cpfCnpjInput);

        // Adiciona o evento de auto-preenchimento ao campo CEP
        const cepInput = document.getElementById('cep');
        cepInput.addEventListener('blur', (e) => preencherEndereco(e.target.value));

        // Lógica de envio do formulário
        const form = document.querySelector("form");
        form.addEventListener("submit", function (e) {
            // Remove as máscaras antes de enviar para o backend
            contatoInput.value = contatoInput.value.replace(/\D/g, "");
            cpfCnpjInput.value = cpfCnpjInput.value.replace(/\D/g, "");

            // Pega os valores dos campos de endereço
            const logradouro = document.getElementById('logradouro').value.trim();
            const numero = document.getElementById('numero').value.trim();
            const complemento = document.getElementById('complemento').value.trim();
            const bairro = document.getElementById('bairro').value.trim();
            const cidade = document.getElementById('cidade').value.trim();
            const estado = document.getElementById('estado').value.trim();
            const cep = document.getElementById('cep').value.trim();
            
            // Monta a string de endereço de forma inteligente
            const partes = [];
            const parte1 = [logradouro, numero, complemento].filter(Boolean).join(', ');
            if (parte1) partes.push(parte1);

            const parte2 = [bairro, cidade].filter(Boolean).join(', ');
            if (parte2) partes.push(parte2);

            if (estado) partes.push(estado);
            
            if (cep) partes.push('CEP: ' + cep.replace(/\D/g, ''));

            const enderecoCompleto = partes.join(' - ');
            
            // Atribui a string final ao campo escondido que será enviado
            document.getElementById('endereco').value = enderecoCompleto;
        });
    });
</script>

</body>
</html>