function fecharMensagem(elemento) {
    if (!elemento) return;
    elemento.style.animation = 'slideOut 0.3s ease-in forwards';
    setTimeout(() => {
        if (elemento && elemento.parentNode) {
            elemento.parentNode.removeChild(elemento);
        }
    }, 300);
}

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