package br.com.monesol.dao;

import br.com.monesol.model.Medicao;
import br.com.monesol.model.UnidadeGeradora;
import br.com.monesol.util.Conexao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MedicaoDAO {

    public void cadastrar(Medicao medicao) throws SQLException {
        String sql = "INSERT INTO Medicao (dataMedicao, energiaGerada, energiaConsumidaLocalmente, energiaInjetadaNaRede, unidadeGeradora) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setTimestamp(1, Timestamp.valueOf(medicao.getDataMedicao()));
            stmt.setDouble(2, medicao.getEnergiaGerada());
            stmt.setDouble(3, medicao.getEnergiaConsumidaLocalmente());
            stmt.setDouble(4, medicao.getEnergiaInjetadaNaRede());
            stmt.setInt(5, medicao.getUnidadeGeradora().getId());

            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                medicao.setId(rs.getInt(1));
            }
            stmt.close();
        }
    }

    public Medicao buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM Medicao WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int idUnidade = rs.getInt("unidadeGeradora");
                UnidadeGeradora unidade = new UnidadeGeradora();
                unidade.setId(idUnidade);

                Medicao medicao = new Medicao(
                    rs.getTimestamp("dataMedicao").toLocalDateTime(),
                    rs.getDouble("energiaGerada"),
                    rs.getDouble("energiaConsumidaLocalmente"),
                    rs.getDouble("energiaInjetadaNaRede"),
                    unidade
                );
                medicao.setId(rs.getInt("id"));
                return medicao;
            }
        }

        return null;
    }


    public List<Medicao> listarPorUnidade(int idUnidade) throws SQLException {
        String sql = "SELECT m.* FROM Medicao m WHERE m.unidadeGeradora = ? ORDER BY dataMedicao DESC";
        List<Medicao> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idUnidade);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                UnidadeGeradora unidade = new UnidadeGeradora("", 0.0, 0.0,"", 0.0, 0.0,""); 
                unidade.setId(idUnidade);

                Medicao medicao = new Medicao(
                    rs.getTimestamp("dataMedicao").toLocalDateTime(),
                    rs.getDouble("energiaGerada"),
                    rs.getDouble("energiaConsumidaLocalmente"),
                    rs.getDouble("energiaInjetadaNaRede"),
                    unidade
                );
                medicao.setId(rs.getInt("id"));

                lista.add(medicao);
            }
            
            stmt.close();
        }

        return lista;
    }

    public void atualizar(Medicao medicao) throws SQLException {
        String sql = "UPDATE Medicao SET dataMedicao = ?, energiaGerada = ?, energiaConsumidaLocalmente = ?, energiaInjetadaNaRede = ?, unidadeGeradora = ? WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setTimestamp(1, Timestamp.valueOf(medicao.getDataMedicao()));
            stmt.setDouble(2, medicao.getEnergiaGerada());
            stmt.setDouble(3, medicao.getEnergiaConsumidaLocalmente());
            stmt.setDouble(4, medicao.getEnergiaInjetadaNaRede());
            stmt.setInt(5, medicao.getUnidadeGeradora().getId());
            stmt.setInt(6, medicao.getId());

            stmt.executeUpdate();
            
            stmt.close();
        }
    }

    public void excluir(int id) throws SQLException {
        String sql = "DELETE FROM Medicao WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
            stmt.close();
        }
    }
}
