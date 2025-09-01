<%-- src/main/webapp/components/mensagens.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    String mensagemSucesso = (String) session.getAttribute("mensagemSucesso");
    String mensagemErro = (String) session.getAttribute("mensagemErro");
    String mensagemInfo = (String) session.getAttribute("mensagemInfo");
    
    // Além da sessão, checa também o escopo da requisição para mensagens de erro/sucesso
    if (mensagemSucesso == null) mensagemSucesso = (String) request.getAttribute("mensagemSucesso");
    if (mensagemErro == null) mensagemErro = (String) request.getAttribute("mensagemErro");
    if (mensagemInfo == null) mensagemInfo = (String) request.getAttribute("mensagemInfo");

    // Remove as mensagens da sessão após a exibição
    if (mensagemSucesso != null) session.removeAttribute("mensagemSucesso");
    if (mensagemErro != null) session.removeAttribute("mensagemErro");
    if (mensagemInfo != null) session.removeAttribute("mensagemInfo");
%>

<style>
.flash-messages {
    position: fixed;
    top: 20px;
    right: 20px;
    z-index: 9999;
    max-width: 400px;
}

.flash-message {
    padding: 16px 20px;
    margin-bottom: 10px;
    border-radius: 8px;
    font-weight: 600;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    animation: slideIn 0.3s ease-out;
    cursor: pointer;
    position: relative;
    overflow: hidden;
}

.flash-message::before {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    height: 4px;
    width: 100%;
    background: rgba(255,255,255,0.3);
    animation: progressBar 4s linear forwards;
}

.flash-success {
    background: linear-gradient(135deg, #4caf50, #45a049);
    color: white;
    border-left: 5px solid #2e7d32;
}

.flash-error {
    background: linear-gradient(135deg, #f44336, #e53935);
    color: white;
    border-left: 5px solid #c62828;
}

.flash-info {
    background: linear-gradient(135deg, #2196f3, #1976d2);
    color: white;
    border-left: 5px solid #1565c0;
}

.flash-close {
    position: absolute;
    top: 8px;
    right: 12px;
    background: none;
    border: none;
    color: rgba(255,255,255,0.8);
    font-size: 18px;
    cursor: pointer;
    font-weight: bold;
    line-height: 1;
    padding: 0;
    width: 20px;
    height: 20px;
}

.flash-close:hover {
    color: white;
}

@keyframes slideIn {
    from {
        transform: translateX(100%);
        opacity: 0;
    }
    to {
        transform: translateX(0);
        opacity: 1;
    }
}

@keyframes slideOut {
    from {
        transform: translateX(0);
        opacity: 1;
    }
    to {
        transform: translateX(100%);
        opacity: 0;
    }
}

@keyframes progressBar {
    from { width: 100%; }
    to { width: 0%;
    }
}

@media (max-width: 768px) {
    .flash-messages {
        top: 10px;
        right: 10px;
    left: 10px;
        max-width: none;
    }
}
</style>

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

<script>
function fecharMensagem(elemento) {
    elemento.style.animation = 'slideOut 0.3s ease-in forwards';
    setTimeout(() => {
        if (elemento && elemento.parentNode) {
            elemento.parentNode.removeChild(elemento);
        }
    }, 300);
    }

// Auto-close mensagens após 4 segundos
document.addEventListener('DOMContentLoaded', function() {
    const mensagens = document.querySelectorAll('.flash-message');
    mensagens.forEach(function(mensagem) {
        setTimeout(function() {
            if (mensagem && mensagem.parentNode) {
                fecharMensagem(mensagem);
            }
        }, 4000);
    });
});
</script>