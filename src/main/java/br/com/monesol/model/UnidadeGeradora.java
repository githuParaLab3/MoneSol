package br.com.monesol.model;

public class UnidadeGeradora {
    private int id;
    private String localizacao;
    private double potenciaInstalada;
    private double eficienciaMedia;
    private String cpfCnpjUsuario; 
    private double precoPorKWh;
    private double quantidadeMinimaAceita;
    private String regraDeExcecoes; 

    public UnidadeGeradora() { }

    public UnidadeGeradora(String localizacao, double potenciaInstalada, double eficienciaMedia, 
                           String cpfCnpjUsuario, double precoPorKWh, double quantidadeMinimaAceita,
                           String regraDeExcecoes) {
        this.localizacao = localizacao;
        this.potenciaInstalada = potenciaInstalada;
        this.eficienciaMedia = eficienciaMedia;
        this.cpfCnpjUsuario = cpfCnpjUsuario;
        this.precoPorKWh = precoPorKWh;
        this.quantidadeMinimaAceita = quantidadeMinimaAceita;
        this.regraDeExcecoes = regraDeExcecoes;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getLocalizacao() { return localizacao; }
    public void setLocalizacao(String localizacao) { this.localizacao = localizacao; }

    public double getPotenciaInstalada() { return potenciaInstalada; }
    public void setPotenciaInstalada(double potenciaInstalada) { this.potenciaInstalada = potenciaInstalada; }

    public double getEficienciaMedia() { return eficienciaMedia; }
    public void setEficienciaMedia(double eficienciaMedia) { this.eficienciaMedia = eficienciaMedia; }

    public String getCpfCnpjUsuario() { return cpfCnpjUsuario; }
    public void setCpfCnpjUsuario(String cpfCnpjUsuario) { this.cpfCnpjUsuario = cpfCnpjUsuario; }

    public double getPrecoPorKWh() { return precoPorKWh; }
    public void setPrecoPorKWh(double precoPorKWh) { this.precoPorKWh = precoPorKWh; }

    public double getQuantidadeMinimaAceita() { return quantidadeMinimaAceita; }
    public void setQuantidadeMinimaAceita(double quantidadeMinimaAceita) { this.quantidadeMinimaAceita = quantidadeMinimaAceita; }

    public String getRegraDeExcecoes() { return regraDeExcecoes; }
    public void setRegraDeExcecoes(String regraDeExcecoes) { this.regraDeExcecoes = regraDeExcecoes; }
}
