package br.com.monesol.dao;

import br.com.monesol.model.UnidadeGeradora;
import br.com.monesol.util.Conexao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UnidadeGeradoraDAO {

    public void cadastrar(UnidadeGeradora unidade) throws SQLException {
        String sql = "INSERT INTO UnidadeGeradora (localizacao, potenciaInstalada, eficienciaMedia, usuario) VALUES (?, ?, ?, ?)";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, unidade.getLocalizacao());
            stmt.setDouble(2, unidade.getPotenciaInstalada());
            stmt.setDouble(3, unidade.getEficienciaMedia());
            stmt.setString(4, unidade.getCpfCnpjUsuario()); 

            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                unidade.setId(rs.getInt(1));
            }

            stmt.close();
        }
    }

    public UnidadeGeradora buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM UnidadeGeradora WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                UnidadeGeradora unidade = new UnidadeGeradora(
                    rs.getString("localizacao"),
                    rs.getDouble("potenciaInstalada"),
                    rs.getDouble("eficienciaMedia")
                );
                unidade.setId(rs.getInt("id"));
                unidade.setCpfCnpjUsuario(rs.getString("usuario"));
                return unidade;
            }

            stmt.close();
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
                UnidadeGeradora unidade = new UnidadeGeradora(
                    rs.getString("localizacao"),
                    rs.getDouble("potenciaInstalada"),
                    rs.getDouble("eficienciaMedia")
                );
                unidade.setId(rs.getInt("id"));
                unidade.setCpfCnpjUsuario(rs.getString("usuario"));
                lista.add(unidade);
            }

            stmt.close();
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
                UnidadeGeradora unidade = new UnidadeGeradora(
                    rs.getString("localizacao"),
                    rs.getDouble("potenciaInstalada"),
                    rs.getDouble("eficienciaMedia")
                );
                unidade.setId(rs.getInt("id"));
                unidade.setCpfCnpjUsuario(rs.getString("usuario"));
                lista.add(unidade);
            }

            stmt.close();
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
                UnidadeGeradora unidade = new UnidadeGeradora(
                    rs.getString("localizacao"),
                    rs.getDouble("potenciaInstalada"),
                    rs.getDouble("eficienciaMedia")
                );
                unidade.setId(rs.getInt("id"));
                unidade.setCpfCnpjUsuario(rs.getString("usuario"));
                lista.add(unidade);
            }
            stmt.close();
        }

        return lista;
    }

    public void atualizar(UnidadeGeradora unidade) throws SQLException {
        String sql = "UPDATE UnidadeGeradora SET localizacao = ?, potenciaInstalada = ?, eficienciaMedia = ?, usuario = ? WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, unidade.getLocalizacao());
            stmt.setDouble(2, unidade.getPotenciaInstalada());
            stmt.setDouble(3, unidade.getEficienciaMedia());
            stmt.setString(4, unidade.getCpfCnpjUsuario());
            stmt.setInt(5, unidade.getId());

            stmt.executeUpdate();
            stmt.close();
        }
    }

    public void excluir(int id) throws SQLException {
        String sql = "DELETE FROM UnidadeGeradora WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
            stmt.close();
        }
    }
}
