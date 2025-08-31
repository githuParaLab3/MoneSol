package br.com.monesol.model;

import java.time.LocalDate;

public class Contrato {

    private int id;
    private LocalDate vigenciaInicio;
    private LocalDate vigenciaFim;
    private int reajustePeriodico;
    private double quantidadeContratada;
    private UnidadeGeradora unidadeGeradora;
    private Usuario usuario;

    public Contrato() {
    }

    public Contrato(LocalDate vigenciaInicio, LocalDate vigenciaFim, int reajustePeriodico,
                    String observacoes, String regrasExcecoes, double quantidadeContratada,
                    UnidadeGeradora unidadeGeradora, Usuario usuario) {
        this.vigenciaInicio = vigenciaInicio;
        this.vigenciaFim = vigenciaFim;
        this.reajustePeriodico = reajustePeriodico;
        this.quantidadeContratada = quantidadeContratada;
        this.unidadeGeradora = unidadeGeradora;
        this.usuario = usuario;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public LocalDate getVigenciaInicio() { return vigenciaInicio; }
    public void setVigenciaInicio(LocalDate vigenciaInicio) { this.vigenciaInicio = vigenciaInicio; }

    public LocalDate getVigenciaFim() { return vigenciaFim; }
    public void setVigenciaFim(LocalDate vigenciaFim) { this.vigenciaFim = vigenciaFim; }

    public int getReajustePeriodico() { return reajustePeriodico; }
    public void setReajustePeriodico(int reajustePeriodico) { this.reajustePeriodico = reajustePeriodico; }

    public double getQuantidadeContratada() { return quantidadeContratada; }
    public void setQuantidadeContratada(double quantidadeContratada) { this.quantidadeContratada = quantidadeContratada; }

    public UnidadeGeradora getUnidadeGeradora() { return unidadeGeradora; }
    public void setUnidadeGeradora(UnidadeGeradora unidadeGeradora) { this.unidadeGeradora = unidadeGeradora; }

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }
}
