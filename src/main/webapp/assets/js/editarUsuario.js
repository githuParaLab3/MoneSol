document.addEventListener("DOMContentLoaded", function () {
    function aplicarMascaraTelefone(input) {
        if (!input) return;
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

    function parsearEndereco(enderecoCompleto) {
        if (!enderecoCompleto || typeof enderecoCompleto !== 'string') return;
        const partes = enderecoCompleto.split(' - ');
        let logradouro = '', numero = '', complemento = '', bairro = '', cidade = '', estado = '', cep = '';
        try {
            if (partes.length > 0 && partes[partes.length - 1].includes('CEP:')) {
                cep = partes.pop().replace('CEP:', '').trim();
            }
            if (partes.length > 0) {
                estado = partes.pop().trim();
            }
            if (partes.length > 0) {
                const bairroCidade = partes.pop().split(',');
                bairro = bairroCidade[0] ? bairroCidade[0].trim() : '';
                cidade = bairroCidade[1] ? bairroCidade[1].trim() : '';
            }
            if (partes.length > 0) {
                const logradouroCompleto = partes.pop().split(',');
                logradouro = logradouroCompleto[0] ? logradouroCompleto[0].trim() : '';
                numero = logradouroCompleto[1] ? logradouroCompleto[1].trim() : '';
                complemento = logradouroCompleto[2] ? logradouroCompleto[2].trim() : '';
            }

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

    const contatoInput = document.getElementById("contato");
    aplicarMascaraTelefone(contatoInput);
    
    const enderecoOriginal = document.getElementById("endereco").value;
    parsearEndereco(enderecoOriginal);
    
    const cepInput = document.getElementById('cep-visivel');
    cepInput.addEventListener('blur', (e) => preencherEnderecoViaCEP(e.target.value));

    const form = document.querySelector("form");
    form.addEventListener("submit", function (e) {
        if (contatoInput) {
            contatoInput.value = contatoInput.value.replace(/\D/g, "");
        }
        
        const logradouro = document.getElementById('logradouro-visivel').value.trim();
        const numero = document.getElementById('numero-visivel').value.trim();
        const complemento = document.getElementById('complemento-visivel').value.trim();
        const bairro = document.getElementById('bairro-visivel').value.trim();
        const cidade = document.getElementById('cidade-visivel').value.trim();
        const estado = document.getElementById('estado-visivel').value.trim();
        const cep = document.getElementById('cep-visivel').value.trim();
        
        const partes = [];
        const parte1 = [logradouro, numero, complemento].filter(Boolean).join(', ');
        if (parte1) partes.push(parte1);

        const parte2 = [bairro, cidade].filter(Boolean).join(', ');
        if (parte2) partes.push(parte2);
        if (estado) partes.push(estado);
        
        if (cep) partes.push('CEP: ' + cep.replace(/\D/g, ''));

        document.getElementById('endereco').value = partes.join(' - ');
    });
});