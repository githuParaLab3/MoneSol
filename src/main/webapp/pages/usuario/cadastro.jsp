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
  	<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css" />

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

    <script src="${pageContext.request.contextPath}/assets/js/cadastro.js"></script>
</body>
</html>