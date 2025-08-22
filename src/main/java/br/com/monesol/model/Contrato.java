package br.com.monesol.model;

import java.time.LocalDate;

public class Contrato {

    public enum StatusContrato {
        PENDENTE,
        ATIVO,
        CANCELADO,
        ENCERRADO
    }

    private int id;
    private StatusContrato statusContrato;
    private LocalDate vigenciaInicio;
    private LocalDate vigenciaFim;
    private int reajustePeriodico;
    private String observacoes;
    private String regrasExcecoes;
    private double quantidadeContratada;
    private UnidadeGeradora unidadeGeradora;
    private Usuario usuario;

    public Contrato() {
        this.statusContrato = StatusContrato.PENDENTE;
    }

    public Contrato(LocalDate vigenciaInicio, LocalDate vigenciaFim, int reajustePeriodico,
                    String observacoes, String regrasExcecoes, double quantidadeContratada,
                    UnidadeGeradora unidadeGeradora, Usuario usuario) {
        this.vigenciaInicio = vigenciaInicio;
        this.vigenciaFim = vigenciaFim;
        this.reajustePeriodico = reajustePeriodico;
        this.observacoes = observacoes;
        this.regrasExcecoes = regrasExcecoes;
        this.quantidadeContratada = quantidadeContratada;
        this.unidadeGeradora = unidadeGeradora;
        this.usuario = usuario;
        this.statusContrato = StatusContrato.PENDENTE;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public StatusContrato getStatusContrato() {
        return statusContrato;
    }

    public void setStatusContrato(StatusContrato statusContrato) {
        this.statusContrato = statusContrato;
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

    public int getReajustePeriodico() {
        return reajustePeriodico;
    }

    public void setReajustePeriodico(int reajustePeriodico) {
        this.reajustePeriodico = reajustePeriodico;
    }

    public String getObservacoes() {
        return observacoes;
    }

    public void setObservacoes(String observacoes) {
        this.observacoes = observacoes;
    }

    public String getRegrasExcecoes() {
        return regrasExcecoes;
    }

    public void setRegrasExcecoes(String regrasExcecoes) {
        this.regrasExcecoes = regrasExcecoes;
    }

    public double getQuantidadeContratada() {
        return quantidadeContratada;
    }

    public void setQuantidadeContratada(double quantidadeContratada) {
        this.quantidadeContratada = quantidadeContratada;
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
