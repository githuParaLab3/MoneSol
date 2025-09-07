<%-- src/main/webapp/components/mensagens.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    String mensagemSucesso = (String) session.getAttribute("mensagemSucesso");
    String mensagemErro = (String) session.getAttribute("mensagemErro");
    String mensagemInfo = (String) session.getAttribute("mensagemInfo");
    
    if (mensagemSucesso == null) mensagemSucesso = (String) request.getAttribute("mensagemSucesso");
    if (mensagemErro == null) mensagemErro = (String) request.getAttribute("mensagemErro");
    if (mensagemInfo == null) mensagemInfo = (String) request.getAttribute("mensagemInfo");

    if (mensagemSucesso != null) session.removeAttribute("mensagemSucesso");
    if (mensagemErro != null) session.removeAttribute("mensagemErro");
    if (mensagemInfo != null) session.removeAttribute("mensagemInfo");
%>
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/mensagens.css" />


<div class="flash-messages" id="flashMessages">
    <% if (mensagemSucesso != null && !mensagemSucesso.trim().isEmpty()) { %>
        <div class="flash-message flash-success" onclick="fecharMensagem(this)">
            <button class="flash-close" onclick="event.stopPropagation(); fecharMensagem(this.parentElement)">&times;</button>
            <%= mensagemSucesso %>
        </div>
    <% } %>
    
    <% if (mensagemErro != null && !mensagemErro.trim().isEmpty()) { %>
        <div class="flash-message flash-error" onclick="fecharMensagem(this)">
 
            <button class="flash-close" onclick="event.stopPropagation(); fecharMensagem(this.parentElement)">&times;</button>
            <%= mensagemErro %>
        </div>
    <% } %>
    
    <% if (mensagemInfo != null && !mensagemInfo.trim().isEmpty()) { %>
        <div class="flash-message flash-info" onclick="fecharMensagem(this)">
            <button class="flash-close" onclick="event.stopPropagation(); fecharMensagem(this.parentElement)">&times;</button>
            <%= mensagemInfo %>
  
        </div>
    <% } %>
</div>

<script src="${pageContext.request.contextPath}/assets/js/mensagens.js"></script>