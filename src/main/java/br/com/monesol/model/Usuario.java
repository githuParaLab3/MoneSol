 package br.com.monesol.model;

public class Usuario {
	
	 public enum TipoUsuario {
	        ADMIN,
	        DONO_GERADORA,
	        CONSUMIDOR_PARCEIRO
	    }
	 
	private String cpfCnpj;
    private String nome;
    private String email;
    private String senha;
    private String contato;
    private String endereco;
    private TipoUsuario tipo;


	public Usuario(String cpfCnpj, String nome, String email, String senha, String contato, String endereco,
			TipoUsuario tipo) {
		this.cpfCnpj = cpfCnpj;
		this.nome = nome;
		this.email = email;
		this.senha = senha;
		this.contato = contato;
		this.endereco = endereco;
		this.tipo = tipo;
	}

	public String getCpfCnpj() {
		return cpfCnpj;
	}

	public void setCpfCnpj(String cpfCnpj) {
		this.cpfCnpj = cpfCnpj;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getSenha() {
		return senha;
	}

	public void setSenha(String senha) {
		this.senha = senha;
	}

	public String getContato() {
		return contato;
	}

	public void setContato(String contato) {
		this.contato = contato;
	}

	public String getEndereco() {
		return endereco;
	}

	public void setEndereco(String endereco) {
		this.endereco = endereco;
	}

	public TipoUsuario getTipo() {
		return tipo;
	}

	public void setTipo(TipoUsuario tipo) {
		this.tipo = tipo;
	}
    
}
