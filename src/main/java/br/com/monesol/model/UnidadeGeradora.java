package br.com.monesol.model;

public class UnidadeGeradora {
    private int id;
    private String localizacao;
    private double potenciaInstalada;
    private double eficienciaMedia;
    private String cpfCnpjUsuario; 

    public UnidadeGeradora() {
    }

    public UnidadeGeradora(String localizacao, double potenciaInstalada, double eficienciaMedia) {
        this.localizacao = localizacao;
        this.potenciaInstalada = potenciaInstalada;
        this.eficienciaMedia = eficienciaMedia;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getLocalizacao() {
        return localizacao;
    }

    public void setLocalizacao(String localizacao) {
        this.localizacao = localizacao;
    }

    public double getPotenciaInstalada() {
        return potenciaInstalada;
    }

    public void setPotenciaInstalada(double potenciaInstalada) {
        this.potenciaInstalada = potenciaInstalada;
    }

    public double getEficienciaMedia() {
        return eficienciaMedia;
    }

    public void setEficienciaMedia(double eficienciaMedia) {
        this.eficienciaMedia = eficienciaMedia;
    }

    public String getCpfCnpjUsuario() {
        return cpfCnpjUsuario;
    }

    public void setCpfCnpjUsuario(String cpfCnpjUsuario) {
        this.cpfCnpjUsuario = cpfCnpjUsuario;
    }
}
