package br.com.monesol.model;

import java.time.LocalDateTime;

public class Medicao {
	private int id;
    private LocalDateTime dataMedicao;
    private double energiaGerada;
    private double energiaConsumidaLocalmente;
    private double energiaInjetadaNaRede;
    private UnidadeGeradora unidadeGeradora;
    
    
	public Medicao(LocalDateTime dataMedicao, double energiaGerada, double energiaConsumidaLocalmente,
			double energiaInjetadaNaRede, UnidadeGeradora unidadeGeradora) {
		this.dataMedicao = dataMedicao;
		this.energiaGerada = energiaGerada;
		this.energiaConsumidaLocalmente = energiaConsumidaLocalmente;
		this.energiaInjetadaNaRede = energiaInjetadaNaRede;
		this.unidadeGeradora = unidadeGeradora;
	}


	public int getId() {
		return id;
	}


	public void setId(int id) {
		this.id = id;
	}


	public LocalDateTime getDataMedicao() {
		return dataMedicao;
	}


	public void setDataMedicao(LocalDateTime dataMedicao) {
		this.dataMedicao = dataMedicao;
	}


	public double getEnergiaGerada() {
		return energiaGerada;
	}


	public void setEnergiaGerada(double energiaGerada) {
		this.energiaGerada = energiaGerada;
	}


	public double getEnergiaConsumidaLocalmente() {
		return energiaConsumidaLocalmente;
	}


	public void setEnergiaConsumidaLocalmente(double energiaConsumidaLocalmente) {
		this.energiaConsumidaLocalmente = energiaConsumidaLocalmente;
	}


	public double getEnergiaInjetadaNaRede() {
		return energiaInjetadaNaRede;
	}


	public void setEnergiaInjetadaNaRede(double energiaInjetadaNaRede) {
		this.energiaInjetadaNaRede = energiaInjetadaNaRede;
	}


	public UnidadeGeradora getUnidadeGeradora() {
		return unidadeGeradora;
	}


	public void setUnidadeGeradora(UnidadeGeradora unidadeGeradora) {
		this.unidadeGeradora = unidadeGeradora;
	}
    
    
}
