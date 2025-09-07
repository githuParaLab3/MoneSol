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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/forms.css" />

</head>
<body>

	<jsp:include page="/pages/outros/mensagens.jsp" />

<main aria-label="Editar dados do usuário logado">
    <h1>
        <a href="javascript:history.back()" class="btn-back" aria-label="Voltar para a página anterior">
            &larr; Voltar
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

<script src="${pageContext.request.contextPath}/assets/js/editarUsuario.js"></script>

</body>
</html>