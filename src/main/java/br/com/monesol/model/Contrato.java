package br.com.monesol.model;

import java.time.LocalDate;

public class Contrato {
	private int id; 
    private LocalDate vigenciaInicio;
    private LocalDate vigenciaFim;   
    private int reajustePeriodicoMeses;
    private Double limiteMinimoEnergiaKWh;
    private double precoPorKWh;
    private String modeloComercial;
    private String observacoes;
    private String regraAlocacao;
    private double qtdContratada;
    private UnidadeGeradora unidadeGeradora;
    private Usuario usuario;
    
	public Contrato(LocalDate vigenciaInicio, LocalDate vigenciaFim, int reajustePeriodicoMeses,
			Double limiteMinimoEnergiaKWh, double precoPorKWh, String modeloComercial, String observacoes,
			String regraAlocacao, double qtdContratada, UnidadeGeradora unidadeGeradora, Usuario usuario) {
		this.vigenciaInicio = vigenciaInicio;
		this.vigenciaFim = vigenciaFim;
		this.reajustePeriodicoMeses = reajustePeriodicoMeses;
		this.limiteMinimoEnergiaKWh = limiteMinimoEnergiaKWh;
		this.precoPorKWh = precoPorKWh;
		this.modeloComercial = modeloComercial;
		this.observacoes = observacoes;
		this.regraAlocacao = regraAlocacao;
		this.qtdContratada = qtdContratada;
		this.unidadeGeradora = unidadeGeradora;
		this.usuario = usuario;
	}
	
	public Contrato() {}
	

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public LocalDate getVigenciaInicio() {
		return vigenciaInicio;
	}

	public void setVigenciaInicio(LocalDate vigenciaInicio) {
		this.vigenciaInicio = vigenciaInicio;
	}

	public LocalDate getVigenciaFim() {
		return vigenciaFim;
	}

	public void setVigenciaFim(LocalDate vigenciaFim) {
		this.vigenciaFim = vigenciaFim;
	}

	public int getReajustePeriodicoMeses() {
		return reajustePeriodicoMeses;
	}

	public void setReajustePeriodicoMeses(int reajustePeriodicoMeses) {
		this.reajustePeriodicoMeses = reajustePeriodicoMeses;
	}

	public Double getLimiteMinimoEnergiaKWh() {
		return limiteMinimoEnergiaKWh;
	}

	public void setLimiteMinimoEnergiaKWh(Double limiteMinimoEnergiaKWh) {
		this.limiteMinimoEnergiaKWh = limiteMinimoEnergiaKWh;
	}

	public double getPrecoPorKWh() {
		return precoPorKWh;
	}

	public void setPrecoPorKWh(double precoPorKWh) {
		this.precoPorKWh = precoPorKWh;
	}

	public String getModeloComercial() {
		return modeloComercial;
	}

	public void setModeloComercial(String modeloComercial) {
		this.modeloComercial = modeloComercial;
	}

	public String getObservacoes() {
		return observacoes;
	}

	public void setObservacoes(String observacoes) {
		this.observacoes = observacoes;
	}

	public String getRegraAlocacao() {
		return regraAlocacao;
	}

	public void setRegraAlocacao(String regraAlocacao) {
		this.regraAlocacao = regraAlocacao;
	}

	public double getQtdContratada() {
		return qtdContratada;
	}

	public void setQtdContratada(double qtdContratada) {
		this.qtdContratada = qtdContratada;
	}

	public UnidadeGeradora getUnidadeGeradora() {
		return unidadeGeradora;
	}

	public void setUnidadeGeradora(UnidadeGeradora unidadeGeradora) {
		this.unidadeGeradora = unidadeGeradora;
	}

	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}
    
    
}
