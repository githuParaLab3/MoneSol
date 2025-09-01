<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="br.com.monesol.model.Usuario" %>

<%
    HttpSession sessao = request.getSession(false);
    Usuario usuario = (sessao != null) ? (Usuario) sessao.getAttribute("usuarioLogado") : null;
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Editar Meus Dados - MoneSol</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #fff8e1;
            color: #2e2e2e;
            min-height: 100vh;
            margin: 0;
            padding: 0;
        }
        main {
            max-width: 600px;
            margin: 50px auto;
            background: #fff;
            border: 1.5px solid #f7c600;
            border-radius: 12px;
            padding: 30px 25px;
            box-shadow: 0 8px 25px rgba(247, 198, 0, 0.25);
        }
        h1 {
            font-size: 2rem;
            font-weight: 900;
            color: #212121;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .btn-back {
            text-decoration: none;
            color: #212121;
            border: 2px solid #212121;
            border-radius: 30px;
            padding: 8px 20px;
            font-weight: 700;
            transition: background 0.25s ease, color 0.25s ease;
            cursor: pointer;
            user-select: none;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .btn-back:hover {
            background: #212121;
            color: #ffd600;
        }
        label {
            display: block;
            font-weight: 700;
            margin-bottom: 8px;
            color: #555;
        }
        input[type="text"],
        input[type="email"],
        input[type="password"],
        select {
            width: 100%;
            padding: 10px 14px;
            margin-bottom: 20px;
            border-radius: 8px;
            border: 1px solid #f7c600;
            background: #f9f6d8;
            font-size: 1rem;
            color: #212121;
            box-sizing: border-box;
        }
        button[type="submit"] {
            background: #212121;
            color: #ffd600;
            font-weight: 700;
            border: none;
            border-radius: 30px;
            padding: 12px 28px;
            font-size: 1rem;
            cursor: pointer;
            user-select: none;
            width: 100%;
            transition: background 0.25s ease;
        }
        button[type="submit"]:hover {
            background: #000;
        }
        
        /* --- CSS DO ENDEREÇO --- */
        .endereco-grid {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 10px;
            margin-bottom: 20px;
        }
        .endereco-grid input, .endereco-grid select {
            margin-bottom: 0; /* Reseta a margem para itens do grid */
        }
        .grid-col-2 { grid-column: span 2; }
        .grid-col-3 { grid-column: span 3; }
        .grid-col-4 { grid-column: span 4; }
    </style>
</head>
<body>

	<jsp:include page="/pages/outros/mensagens.jsp" />

<main aria-label="Editar dados do usuário logado">
    <h1>
        <a href="<%= request.getContextPath() %>/pages/usuario/dashboard.jsp" class="btn-back" aria-label="Voltar para o dashboard">
            &#8592; Voltar
        </a>
        Editar Meus Dados
    </h1>

    <form action="<%= request.getContextPath() %>/UsuarioController" method="post" novalidate>
        <input type="hidden" name="action" value="editar" />
        <input type="hidden" name="cpfCnpj" value="<%= usuario.getCpfCnpj() %>" />

        <label for="nome">Nome</label>
        <input type="text" id="nome" name="nome" value="<%= usuario.getNome() %>" required />

        <label for="email">Email</label>
        <input type="email" id="email" name="email" value="<%= usuario.getEmail() %>" required />

        <label for="senha">Senha (deixe vazio para não alterar)</label>
        <input type="password" id="senha" name="senha" />

        <label for="contato">Contato</label>
        <input type="text" id="contato" name="contato" value="<%= usuario.getContato() != null ? usuario.getContato() : "" %>" />
        
        <label>Endereço</label>
        <div class="endereco-grid">
             <input type="text" id="cep-visivel" placeholder="CEP" class="grid-col-2" />
             <input type="text" id="logradouro-visivel" placeholder="Logradouro (Rua, Av.)" class="grid-col-4" />
             <input type="text" id="numero-visivel" placeholder="Número" class="grid-col-2" />
             <input type="text" id="complemento-visivel" placeholder="Complemento (Opcional)" class="grid-col-4" />
             <input type="text" id="bairro-visivel" placeholder="Bairro" class="grid-col-3" />
             <input type="text" id="cidade-visivel" placeholder="Cidade" class="grid-col-3" />
             <select id="estado-visivel" class="grid-col-2">
                 <option value="">UF</option>
                 <option value="AC">AC</option><option value="AL">AL</option><option value="AP">AP</option><option value="AM">AM</option><option value="BA">BA</option><option value="CE">CE</option><option value="DF">DF</option><option value="ES">ES</option><option value="GO">GO</option><option value="MA">MA</option><option value="MT">MT</option><option value="MS">MS</option><option value="MG">MG</option><option value="PA">PA</option><option value="PB">PB</option><option value="PR">PR</option><option value="PE">PE</option><option value="PI">PI</option><option value="RJ">RJ</option><option value="RN">RN</option><option value="RS">RS</option><option value="RO">RO</option><option value="RR">RR</option><option value="SC">SC</option><option value="SP">SP</option><option value="SE">SE</option><option value="TO">TO</option>
             </select>
        </div>
        <input type="hidden" id="endereco" name="endereco" value="<%= usuario.getEndereco() != null ? usuario.getEndereco() : "" %>" />

        <button type="submit">Salvar Alterações</button>
    </form>
</main>

<script>
    // --- FUNÇÕES DE AJUDA ---

    function aplicarMascaraTelefone(input) {
        input.addEventListener("input", function () {
            let valor = input.value.replace(/\D/g, ""); 
            if (valor.length > 11) { valor = valor.slice(0, 11); }
            if (valor.length > 10) { valor = valor.replace(/^(\d{2})(\d{5})(\d{4}).*/, "($1) $2-$3"); } 
            else if (valor.length > 5) { valor = valor.replace(/^(\d{2})(\d{4})(\d{0,4}).*/, "($1) $2-$3"); } 
            else if (valor.length > 2) { valor = valor.replace(/^(\d{2})(\d{0,5})/, "($1) $2"); } 
            else if (valor.length > 0) { valor = valor.replace(/^(\d{0,2})/, "($1"); }
            input.value = valor;
        });
    }

    function preencherEnderecoViaCEP(cep) {
        cep = cep.replace(/\D/g, '');
        if (cep.length !== 8) return;
        fetch(`https://viacep.com.br/ws/${cep}/json/`)
            .then(response => response.json())
            .then(data => {
                if (!data.erro) {
                    document.getElementById('logradouro-visivel').value = data.logradouro;
                    document.getElementById('bairro-visivel').value = data.bairro;
                    document.getElementById('cidade-visivel').value = data.localidade;
                    document.getElementById('estado-visivel').value = data.uf;
                    document.getElementById('numero-visivel').focus();
                }
            })
            .catch(error => console.error('Erro ao buscar CEP:', error));
    }

    /**
     * Pega a string de endereço completa e a divide nos campos do formulário.
     * Formato esperado: "Rua, Numero, Complemento - Bairro, Cidade - UF - CEP: XXXXX"
     */
    function parsearEndereco(enderecoCompleto) {
        if (!enderecoCompleto || typeof enderecoCompleto !== 'string') return;

        const partes = enderecoCompleto.split(' - ');
        let logradouro = '', numero = '', complemento = '', bairro = '', cidade = '', estado = '', cep = '';

        try {
            // CEP (última parte)
            if (partes.length > 0 && partes[partes.length - 1].includes('CEP:')) {
                cep = partes.pop().replace('CEP:', '').trim();
            }
            // Estado (agora é a última parte)
            if (partes.length > 0) {
                estado = partes.pop().trim();
            }
            // Bairro e Cidade
            if (partes.length > 0) {
                const bairroCidade = partes.pop().split(',');
                bairro = bairroCidade[0] ? bairroCidade[0].trim() : '';
                cidade = bairroCidade[1] ? bairroCidade[1].trim() : '';
            }
            // Logradouro, Número e Complemento
            if (partes.length > 0) {
                const logradouroCompleto = partes.pop().split(',');
                logradouro = logradouroCompleto[0] ? logradouroCompleto[0].trim() : '';
                numero = logradouroCompleto[1] ? logradouroCompleto[1].trim() : '';
                complemento = logradouroCompleto[2] ? logradouroCompleto[2].trim() : '';
            }

            // Preenche os campos visíveis
            document.getElementById('cep-visivel').value = cep;
            document.getElementById('logradouro-visivel').value = logradouro;
            document.getElementById('numero-visivel').value = numero;
            document.getElementById('complemento-visivel').value = complemento;
            document.getElementById('bairro-visivel').value = bairro;
            document.getElementById('cidade-visivel').value = cidade;
            document.getElementById('estado-visivel').value = estado;
        } catch (e) {
            console.error("Não foi possível parsear o endereço:", enderecoCompleto, e);
        }
    }


    // --- LÓGICA PRINCIPAL DA PÁGINA ---
    document.addEventListener("DOMContentLoaded", function () {
        // Aplica máscara de telefone
        const contatoInput = document.getElementById("contato");
        aplicarMascaraTelefone(contatoInput);
        
        // Pega o endereço completo do campo escondido e preenche os campos visíveis
        const enderecoOriginal = document.getElementById("endereco").value;
        parsearEndereco(enderecoOriginal);
        
        // Adiciona o evento de auto-preenchimento ao campo CEP
        const cepInput = document.getElementById('cep-visivel');
        cepInput.addEventListener('blur', (e) => preencherEnderecoViaCEP(e.target.value));

        // Lógica de envio do formulário
        const form = document.querySelector("form");
        form.addEventListener("submit", function (e) {
            // Remove a máscara do telefone antes de enviar
            contatoInput.value = contatoInput.value.replace(/\D/g, "");
            
            // Pega os valores dos campos visíveis de endereço
            const logradouro = document.getElementById('logradouro-visivel').value.trim();
            const numero = document.getElementById('numero-visivel').value.trim();
            const complemento = document.getElementById('complemento-visivel').value.trim();
            const bairro = document.getElementById('bairro-visivel').value.trim();
            const cidade = document.getElementById('cidade-visivel').value.trim();
            const estado = document.getElementById('estado-visivel').value.trim();
            const cep = document.getElementById('cep-visivel').value.trim();
            
            // Monta a nova string de endereço
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