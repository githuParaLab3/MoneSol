document.addEventListener("DOMContentLoaded", function () {
    function aplicarMascaraCpfCnpj(input) {
        if (!input) return;
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
    const cepInput = document.getElementById('cep');
    if(cepInput) {
        cepInput.addEventListener('blur', (e) => preencherEndereco(e.target.value));
    }

    const form = document.getElementById("cadastroForm");
    if (!form) return;

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
            const parte1 = [logradouro, numero, complemento].filter(Boolean).join(', ');
            if (parte1) partes.push(parte1);

            const parte2 = [bairro, cidade].filter(Boolean).join(', ');
            if (parte2) partes.push(parte2);
            if (estado) partes.push(estado);
            
            if (cep) partes.push('CEP: ' + cep.replace(/\D/g, ''));

            document.getElementById('endereco').value = partes.join(' - ');
        }
    });
});