package br.com.monesol.dao;

import br.com.monesol.model.UnidadeGeradora;
import br.com.monesol.util.Conexao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UnidadeGeradoraDAO {

    public void cadastrar(UnidadeGeradora unidade) throws SQLException {
        String sql = "INSERT INTO UnidadeGeradora (localizacao, potenciaInstalada, eficienciaMedia, usuario, precoPorKWh, quantidadeMinimaAceita) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, unidade.getLocalizacao());
            stmt.setDouble(2, unidade.getPotenciaInstalada());
            stmt.setDouble(3, unidade.getEficienciaMedia());
            stmt.setString(4, unidade.getCpfCnpjUsuario());
            stmt.setDouble(5, unidade.getPrecoPorKWh());
            stmt.setDouble(6, unidade.getQuantidadeMinimaAceita());

            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                unidade.setId(rs.getInt(1));
            }
        }
    }

    public UnidadeGeradora buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM UnidadeGeradora WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                UnidadeGeradora unidade = mapResultSet(rs);
                return unidade;
            }
        }
        return null;
    }

    public List<UnidadeGeradora> listarTodas() throws SQLException {
        List<UnidadeGeradora> lista = new ArrayList<>();
        String sql = "SELECT * FROM UnidadeGeradora";

        try (Connection conn = Conexao.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                lista.add(mapResultSet(rs));
            }
        }
        return lista;
    }

    public List<UnidadeGeradora> listarPorUsuario(String cpfCnpj) throws SQLException {
        List<UnidadeGeradora> lista = new ArrayList<>();
        String sql = "SELECT * FROM UnidadeGeradora WHERE usuario = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, cpfCnpj);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                lista.add(mapResultSet(rs));
            }
        }
        return lista;
    }

    public List<UnidadeGeradora> buscarPorLocalizacao(String localizacao) throws SQLException {
        String sql = "SELECT * FROM UnidadeGeradora WHERE localizacao LIKE ?";
        List<UnidadeGeradora> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + localizacao + "%");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                lista.add(mapResultSet(rs));
            }
        }
        return lista;
    }

    public void atualizar(UnidadeGeradora unidade) throws SQLException {
        String sql = "UPDATE UnidadeGeradora SET localizacao = ?, potenciaInstalada = ?, eficienciaMedia = ?, usuario = ?, precoPorKWh = ?, quantidadeMinimaAceita = ? WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, unidade.getLocalizacao());
            stmt.setDouble(2, unidade.getPotenciaInstalada());
            stmt.setDouble(3, unidade.getEficienciaMedia());
            stmt.setString(4, unidade.getCpfCnpjUsuario());
            stmt.setDouble(5, unidade.getPrecoPorKWh());
            stmt.setDouble(6, unidade.getQuantidadeMinimaAceita());
            stmt.setInt(7, unidade.getId());

            stmt.executeUpdate();
        }
    }

    public void excluir(int id) throws SQLException {
        String sql = "DELETE FROM UnidadeGeradora WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    // 🔹 Método auxiliar para reduzir duplicação de código
    private UnidadeGeradora mapResultSet(ResultSet rs) throws SQLException {
        UnidadeGeradora unidade = new UnidadeGeradora();
        unidade.setId(rs.getInt("id"));
        unidade.setLocalizacao(rs.getString("localizacao"));
        unidade.setPotenciaInstalada(rs.getDouble("potenciaInstalada"));
        unidade.setEficienciaMedia(rs.getDouble("eficienciaMedia"));
        unidade.setCpfCnpjUsuario(rs.getString("usuario"));
        unidade.setPrecoPorKWh(rs.getDouble("precoPorKWh"));
        unidade.setQuantidadeMinimaAceita(rs.getDouble("quantidadeMinimaAceita"));
        return unidade;
    }
}
