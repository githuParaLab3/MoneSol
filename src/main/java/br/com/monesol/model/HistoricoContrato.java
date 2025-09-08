package br.com.monesol.model;

import java.time.LocalDateTime;

public class HistoricoContrato {
	public enum TipoHistorico {
        ALOCACAO,
        ALTERACAO_CONTRATUAL,
        OUTRO
    }

    private int id;
    private LocalDateTime dataHistorico;
    private String titulo;
    private String descricao;
    private TipoHistorico tipo;
    private Contrato contrato;
    
	public HistoricoContrato(LocalDateTime dataHistorico, String titulo, String descricao, TipoHistorico tipo,
			Contrato contrato) {
		this.dataHistorico = dataHistorico;
		this.titulo = titulo;
		this.descricao = descricao;
		this.tipo = tipo;
		this.contrato = contrato;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public LocalDateTime getDataHistorico() {
		return dataHistorico;
	}

	public void setDataHistorico(LocalDateTime dataHistorico) {
		this.dataHistorico = dataHistorico;
	}

	public String getTitulo() {
		return titulo;
	}

	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}

	public String getDescricao() {
		return descricao;
	}

	public void setDescricao(String descricao) {
		this.descricao = descricao;
	}

	public TipoHistorico getTipo() {
		return tipo;
	}

	public void setTipo(TipoHistorico tipo) {
		this.tipo = tipo;
	}

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}
    
    
}
