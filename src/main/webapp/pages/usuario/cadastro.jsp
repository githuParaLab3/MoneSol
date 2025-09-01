<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="br.com.monesol.model.Usuario" %>
<%@ page import="java.util.Map" %>
<%
    Usuario formData = (Usuario) request.getAttribute("formData");
    if (formData == null) {
        formData = new Usuario("", "", "", "", "", "", null); 
    }
    Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Cadastro - MoneSol</title>
    <link rel="stylesheet" href="../styles/main.css" />
    <style>
        :root {
            --primary-color: #ffd600;
            --dark-text: #212121;
            --light-text: #555;
            --background-color: #fff8e1;
            --card-background: #ffffff;
            --border-color: #ccc;
            --error-color: #d32f2f;
        }

        body { 
            background: var(--background-color); 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            color: #333; 
            margin: 0; 
        }

        .container { 
            max-width: 600px; 
            margin: 40px auto; 
            background: var(--card-background); 
            border: 2px solid var(--primary-color); 
            border-radius: 15px; 
            box-shadow: 0 5px 20px rgba(255, 214, 0, 0.3); 
            padding: 30px 40px; 
        }

        h2 { 
            text-align: center; 
            color: var(--dark-text); 
            margin-bottom: 30px; 
            font-size: 2rem; 
        }

        .form-group { 
            margin-bottom: 18px; 
        }

        label { 
            font-weight: 600; 
            color: #424242; 
        }

        input[type="text"], 
        input[type="email"], 
        input[type="password"], 
        select { 
            width: 100%; 
            padding: 12px; 
            border: 1px solid var(--border-color); 
            border-radius: 8px; 
            font-size: 1rem; 
            margin-top: 5px;
            box-sizing: border-box;
        }

        button[type="submit"] { 
            background: var(--primary-color); 
            color: var(--dark-text); 
            font-weight: 700; 
            padding: 14px; 
            font-size: 1.1rem; 
            border: none; 
            border-radius: 30px; 
            cursor: pointer; 
            transition: background-color 0.3s ease; 
            margin-top: 15px; 
            width: 100%;
        }
        button[type="submit"]:hover { 
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
            gap: 15px; 
            margin-top: 8px; 
            flex-wrap: wrap;
        }
        .radio-btn { 
            cursor: pointer; 
            user-select: none; 
            border: 2px solid var(--border-color); 
            padding: 10px 18px; 
            border-radius: 30px; 
            font-weight: 600; 
            color: var(--light-text); 
            transition: all 0.2s ease; 
            display: flex; 
            align-items: center; 
            gap: 8px; 
        }
        .radio-btn input[type="radio"] { 
            display: none; 
        }
        .radio-btn.checked, .radio-btn:hover { 
            border-color: var(--primary-color); 
            background-color: #fffde7; 
        }

        .label-container { 
            display: flex; 
            align-items: center; 
            gap: 8px; 
        }
        .tooltip { 
            position: relative; 
            display: inline-block; 
            cursor: help; 
            background-color: #e0e0e0; 
            color: var(--light-text); 
            width: 20px; 
            height: 20px; 
            border-radius: 50%; 
            text-align: center; 
            font-weight: bold; 
            line-height: 20px; 
            font-size: 14px; 
        }
        .tooltip .tooltip-text { 
            visibility: hidden; 
            width: 220px; 
            background-color: #333; 
            color: #fff; 
            text-align: center; 
            border-radius: 6px; 
            padding: 8px; 
            position: absolute; 
            z-index: 1; 
            bottom: 125%; 
            left: 50%; 
            margin-left: -110px; 
            opacity: 0; 
            transition: opacity 0.3s; 
        }
        .tooltip:hover .tooltip-text { 
            visibility: visible; 
            opacity: 1; 
        }

        .endereco-grid { 
            display: grid; 
            grid-template-columns: repeat(6, 1fr); 
            gap: 10px; 
            margin-top: 5px;
        }
        .grid-col-2 { grid-column: span 2; }
        .grid-col-3 { grid-column: span 3; }
        .grid-col-4 { grid-column: span 4; }

        .error-message { 
            color: var(--error-color); 
            font-size: 0.9rem; 
            margin-top: 5px; 
            font-weight: 600; 
            min-height: 1.2em; 
        }
        .input-error { 
            border-color: var(--error-color) !important; 
            background-color: #ffebee; 
        }
    </style>
</head>
<body>
	<jsp:include page="/pages/outros/mensagens.jsp" />

    <header style="background: var(--primary-color); padding: 12px 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); display: flex; align-items: center;">
        <a href="../../index.jsp" style="text-decoration: none; color: inherit;">
            <span style="font-weight: 900; font-size: 2rem; color: var(--dark-text); letter-spacing: 1.5px;">MoneSol</span>
        </a>
    </header>

    <div class="container">
        <h2>Crie sua conta na MoneSol</h2>
        <form action="../../UsuarioController" method="post" id="cadastroForm" novalidate>
            <input type="hidden" name="action" value="adicionar" />

            <div class="form-group">
                <div class="label-container">
                    <label for="cpfCnpj">CPF/CNPJ</label>
                    <span class="tooltip">?<span class="tooltip-text">Digite seu CPF (11 dígitos) ou CNPJ (14 dígitos). Apenas números.</span></span>
                </div>
                <input type="text" id="cpfCnpj" name="cpfCnpj" required value="<%= formData.getCpfCnpj() %>" class="<%= errors != null && errors.containsKey("cpfCnpj") ? "input-error" : "" %>" />
                <div id="cpfCnpj-error" class="error-message"><%= errors != null ? errors.getOrDefault("cpfCnpj", "") : "" %></div>
            </div>

            <div class="form-group">
                <div class="label-container">
                    <label for="nome">Nome completo</label>
                    <span class="tooltip">?<span class="tooltip-text">Pelo menos o primeiro nome e um sobrenome são necessários.</span></span>
                </div>
                <input type="text" id="nome" name="nome" required value="<%= formData.getNome() %>" class="<%= errors != null && errors.containsKey("nome") ? "input-error" : "" %>"/>
                 <div id="nome-error" class="error-message"><%= errors != null ? errors.getOrDefault("nome", "") : "" %></div>
            </div>

            <div class="form-group">
                <div class="label-container">
                    <label for="email">E-mail</label>
                    <span class="tooltip">?<span class="tooltip-text">Use seu melhor e-mail para login e comunicação.</span></span>
                </div>
                <input type="email" id="email" name="email" required value="<%= formData.getEmail() %>" class="<%= errors != null && errors.containsKey("email") ? "input-error" : "" %>"/>
                <div id="email-error" class="error-message"><%= errors != null ? errors.getOrDefault("email", "") : "" %></div>
            </div>

            <div class="form-group">
                <div class="label-container">
                    <label for="senha">Senha</label>
                    <span class="tooltip">?<span class="tooltip-text">A senha deve ter no mínimo 6 caracteres.</span></span>
                </div>
                <input type="password" id="senha" name="senha" required class="<%= errors != null && errors.containsKey("senha") ? "input-error" : "" %>"/>
                <div id="senha-error" class="error-message"><%= errors != null ? errors.getOrDefault("senha", "") : "" %></div>
            </div>

            <div class="form-group">
                <div class="label-container">
                    <label for="contato">Contato</label>
                    <span class="tooltip">?<span class="tooltip-text">Inclua o DDD. Ex: (71) 98765-4321</span></span>
                </div>
                <input type="text" id="contato" name="contato" placeholder="Telefone ou celular" required value="<%= formData.getContato() %>" />
                <div id="contato-error" class="error-message"></div>
            </div>
            
            <div class="form-group">
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
	             <div id="endereco-error" class="error-message"></div>
            </div>
            <input type="hidden" id="endereco" name="endereco" />

            <div class="form-group">
                <div class="label-container"><label>Deseja se cadastrar como:</label></div>
                <div class="tipo-usuario-radio-group">
                    <label class="radio-btn"><input type="radio" name="tipo" value="DONO_GERADORA" required /><span>Dono de Unidades</span></label>
                    <label class="radio-btn"><input type="radio" name="tipo" value="CONSUMIDOR_PARCEIRO" /><span>Consumidor</span></label>
                </div>
                 <div id="tipo-error" class="error-message"></div>
            </div>

            <button type="submit">Cadastrar</button>
        </form>
        <a class="back-link" href="./login.jsp">Já tem conta? Faça login</a>
    </div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        // --- FUNÇÕES DE MÁSCARA ---
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
                    valor = valor.replace(/^(\d{2})(\d{5})(\d{4}).*/, "($1) $2-$3");
                } else if (valor.length > 5) {
                    valor = valor.replace(/^(\d{2})(\d{4})(\d{0,4}).*/, "($1) $2-$3");
                } else if (valor.length > 2) {
                    valor = valor.replace(/^(\d{2})(\d{0,5})/, "($1) $2");
                } else if (valor.length > 0) {
                    valor = valor.replace(/^(\d{0,2})/, "($1");
                }
                input.value = valor;
            });
        }
        
        function preencherEndereco(cep) {
	        cep = cep.replace(/\D/g, '');
	        if (cep.length !== 8) return;
	        fetch("https://viacep.com.br/ws/" + cep + "/json/")
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
	    
        const radioButtons = document.querySelectorAll('.radio-btn input[type="radio"]');
        radioButtons.forEach(radio => {
            radio.addEventListener('change', () => {
                document.querySelectorAll('.radio-btn').forEach(label => label.classList.remove('checked'));
                if (radio.checked) {
                    radio.parentElement.classList.add('checked');
                }
            });
        });

        aplicarMascaraTelefone(document.getElementById("contato"));
        aplicarMascaraCpfCnpj(document.getElementById("cpfCnpj"));
        document.getElementById('cep').addEventListener('blur', (e) => preencherEndereco(e.target.value));

        const form = document.getElementById("cadastroForm");
        form.addEventListener("submit", function (e) {
            
            const clearErrors = () => {
                document.querySelectorAll('.error-message').forEach(el => el.textContent = '');
                document.querySelectorAll('.input-error').forEach(el => el.classList.remove('input-error'));
            };

            const showError = (fieldId, message) => {
                const field = document.getElementById(fieldId);
                const errorField = document.getElementById(fieldId + '-error');
                if (field) field.classList.add('input-error');
                if (errorField) errorField.textContent = message;
                return false;
            };

            clearErrors();
            let isValid = true;

            const cpfCnpj = document.getElementById('cpfCnpj');
            const cpfCnpjValue = cpfCnpj.value.replace(/\D/g, '');
            if (cpfCnpjValue.length !== 11 && cpfCnpjValue.length !== 14) {
                isValid = showError('cpfCnpj', 'CPF deve ter 11 dígitos ou CNPJ 14.');
            }
            
            const nome = document.getElementById('nome');
            if (nome.value.trim().length < 3) {
				isValid = showError('nome', 'O nome completo é obrigatório.');
			}
			
			const email = document.getElementById('email');
			const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
			if (!emailRegex.test(email.value)) {
				isValid = showError('email', 'Por favor, insira um e-mail válido.');
			}
			
            const senha = document.getElementById('senha');
            if (senha.value.length < 6) {
                isValid = showError('senha', 'A senha deve ter no mínimo 6 caracteres.');
            }
            
            const requiredAddressFields = ['cep', 'logradouro', 'numero', 'bairro', 'cidade', 'estado'];
            let addressError = false;
            requiredAddressFields.forEach(fieldId => {
				const field = document.getElementById(fieldId);
				if (!field.value.trim()){
					field.classList.add('input-error');
					addressError = true;
				}
			});
			if(addressError) {
				isValid = showError('endereco', 'Todos os campos de endereço (exceto complemento) são obrigatórios.');
			}
            
            const tipoUsuario = form.querySelector('input[name="tipo"]:checked');
            if (!tipoUsuario) {
				isValid = showError('tipo', 'Por favor, selecione um tipo de cadastro.');
			}

            if (!isValid) {
                e.preventDefault(); 
            } else {
                document.getElementById("contato").value = document.getElementById("contato").value.replace(/\D/g, "");
                cpfCnpj.value = cpfCnpjValue;

                const logradouro = document.getElementById('logradouro').value.trim();
	            const numero = document.getElementById('numero').value.trim();
	            const complemento = document.getElementById('complemento').value.trim();
	            const bairro = document.getElementById('bairro').value.trim();
	            const cidade = document.getElementById('cidade').value.trim();
	            const estado = document.getElementById('estado').value.trim();
	            const cep = document.getElementById('cep').value.trim();
	            
	            const partes = [];
	            if (logradouro && numero) partes.push(logradouro + ', ' + numero);
	            if (complemento) partes.push(complemento);
	            if (bairro) partes.push(bairro);
	            if (cidade && estado) partes.push(cidade + ' - ' + estado);
	            if (cep) partes.push('CEP: ' + cep.replace(/\D/g, ''));

	            document.getElementById('endereco').value = partes.join('; ');
            }
        });
    });
</script>

</body>
</html>

