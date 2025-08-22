package br.com.monesol.model;

import java.time.LocalDateTime;

public class Documento {
	public enum TipoDocumento {
        MANUTENCAO,
        RELATORIO
    }

    private int id;
    private TipoDocumento tipo;
    private String descricao;
    private LocalDateTime dataDocumento;
    private String arquivo;
    private Contrato contrato;
    
	public Documento(TipoDocumento tipo, String descricao, LocalDateTime dataDocumento, String arquivo,
			Contrato contrato) {
		this.tipo = tipo;
		this.descricao = descricao;
		this.dataDocumento = dataDocumento;
		this.arquivo = arquivo;
		this.contrato = contrato;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public TipoDocumento getTipo() {
		return tipo;
	}

	public void setTipo(TipoDocumento tipo) {
		this.tipo = tipo;
	}

	public String getDescricao() {
		return descricao;
	}

	public void setDescricao(String descricao) {
		this.descricao = descricao;
	}

	public LocalDateTime getDataDocumento() {
		return dataDocumento;
	}

	public void setDataDocumento(LocalDateTime dataDocumento) {
		this.dataDocumento = dataDocumento;
	}

	public String getArquivo() {
		return arquivo;
	}

	public void setArquivo(String arquivo) {
		this.arquivo = arquivo;
	}

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}
    
}
