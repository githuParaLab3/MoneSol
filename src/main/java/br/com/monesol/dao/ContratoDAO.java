package br.com.monesol.dao;

import br.com.monesol.model.Contrato;
import br.com.monesol.model.UnidadeGeradora;
import br.com.monesol.model.Usuario;
import br.com.monesol.util.Conexao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContratoDAO {

    public void cadastrar(Contrato contrato) throws SQLException {
        String sql = "INSERT INTO Contrato (vigenciaInicio, vigenciaFim, reajustePeriodico, quantidadeContratada, unidadeGeradora, usuario) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setDate(1, Date.valueOf(contrato.getVigenciaInicio()));
            stmt.setDate(2, Date.valueOf(contrato.getVigenciaFim()));
            stmt.setInt(3, contrato.getReajustePeriodico());
            stmt.setDouble(4, contrato.getQuantidadeContratada());
            stmt.setInt(5, contrato.getUnidadeGeradora().getId());
            stmt.setString(6, contrato.getUsuario().getCpfCnpj());

            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                contrato.setId(rs.getInt(1));
            }
        }
    }

    public Contrato buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM Contrato WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return preencherContrato(rs);
            }
        }
        return null;
    }

    public List<Contrato> listarPorUsuario(String cpfCnpj) throws SQLException {
        String sql = "SELECT * FROM Contrato WHERE usuario = ?";
        List<Contrato> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, cpfCnpj);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Contrato contrato = preencherContrato(rs);
                lista.add(contrato);
            }
        }
        return lista;
    }

    public List<Contrato> listarPorUnidade(int idUnidade) throws SQLException {
        String sql = "SELECT * FROM Contrato WHERE unidadeGeradora = ?";
        List<Contrato> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idUnidade);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Contrato contrato = preencherContrato(rs);
                lista.add(contrato);
            }
        }
        return lista;
    }

    public void atualizar(Contrato contrato) throws SQLException {
        String sql = "UPDATE Contrato SET vigenciaInicio = ?, vigenciaFim = ?, reajustePeriodico = ?, quantidadeContratada = ?, unidadeGeradora = ?, usuario = ? WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDate(1, Date.valueOf(contrato.getVigenciaInicio()));
            stmt.setDate(2, Date.valueOf(contrato.getVigenciaFim()));
            stmt.setInt(3, contrato.getReajustePeriodico());
            stmt.setDouble(4, contrato.getQuantidadeContratada());
            stmt.setInt(5, contrato.getUnidadeGeradora().getId());
            stmt.setString(6, contrato.getUsuario().getCpfCnpj());
            stmt.setInt(7, contrato.getId()); 

            stmt.executeUpdate();
        }
    }


    public void excluir(int id) throws SQLException {
        String sql = "DELETE FROM Contrato WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    private Contrato preencherContrato(ResultSet rs) throws SQLException {
        int idUnidade = rs.getInt("unidadeGeradora");
        
        UnidadeGeradora unidade = new UnidadeGeradora("", 0.0, 0.0, "", 0.0, 0.0,"", 0.0);
        unidade.setId(idUnidade);

        // CORREÇÃO: Buscar também o CPF/CNPJ do dono da unidade
        String sqlUnidade = "SELECT localizacao, usuario FROM UnidadeGeradora WHERE id = ?";
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmtUnidade = conn.prepareStatement(sqlUnidade)) {
            stmtUnidade.setInt(1, idUnidade);
            ResultSet rsUnidade = stmtUnidade.executeQuery();
            if (rsUnidade.next()) {
                unidade.setLocalizacao(rsUnidade.getString("localizacao"));
                // Adiciona a informação que faltava
                unidade.setCpfCnpjUsuario(rsUnidade.getString("usuario"));
            }
        }

        Usuario usuario = new Usuario(null,null,null,null,null,null,null);
        usuario.setCpfCnpj(rs.getString("usuario"));

        Contrato contrato = new Contrato();
        contrato.setId(rs.getInt("id"));
        contrato.setVigenciaInicio(rs.getDate("vigenciaInicio").toLocalDate());
        contrato.setVigenciaFim(rs.getDate("vigenciaFim").toLocalDate());
        contrato.setReajustePeriodico(rs.getInt("reajustePeriodico"));
        contrato.setQuantidadeContratada(rs.getDouble("quantidadeContratada"));
        contrato.setUnidadeGeradora(unidade);
        contrato.setUsuario(usuario);

        return contrato;
    }


    public boolean existeContratoUsuarioUnidade(String cpfCnpj, int idUnidade) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Contrato WHERE usuario = ? AND unidadeGeradora = ?";
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, cpfCnpj);
            stmt.setInt(2, idUnidade);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public List<Contrato> listarPorDonoGeradora(String cpfCnpjDono) throws SQLException {
        String sql = "SELECT c.* FROM Contrato c " +
                     "JOIN UnidadeGeradora u ON c.unidadeGeradora = u.id " +
                     "WHERE u.usuario = ?";
        List<Contrato> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, cpfCnpjDono);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Contrato contrato = preencherContrato(rs);
                lista.add(contrato);
            }
        }
        return lista;
    }

    public List<Contrato> listarTodos() throws SQLException {
        String sql = "SELECT * FROM Contrato";
        List<Contrato> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Contrato contrato = preencherContrato(rs);
                lista.add(contrato);
            }
        }
        return lista;
    }
    
    /**
     * Calcula a quantidade total contratada para uma unidade geradora específica.
     *
     * @param idUnidade O ID da Unidade Geradora.
     * @return A soma da quantidade contratada de todos os contratos existentes para a unidade.
     * @throws SQLException Se ocorrer um erro de acesso ao banco de dados.
     */
    public double calcularCapacidadeContratada(int idUnidade) throws SQLException {
        String sql = "SELECT SUM(quantidadeContratada) FROM Contrato WHERE unidadeGeradora = ?";
        double capacidadeContratada = 0.0;

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idUnidade);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                capacidadeContratada = rs.getDouble(1);
            }
        }
        return capacidadeContratada;
    }
}