package br.com.monesol.dao;

import br.com.monesol.model.Contrato;
import br.com.monesol.model.HistoricoContrato;
import br.com.monesol.model.HistoricoContrato.TipoHistorico;
import br.com.monesol.util.Conexao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HistoricoContratoDAO {

    public void cadastrar(HistoricoContrato historico) throws SQLException {
        String sql = "INSERT INTO HistoricoContrato (dataHistorico, titulo, descricao, tipo, contrato) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setTimestamp(1, Timestamp.valueOf(historico.getDataHistorico()));
            stmt.setString(2, historico.getTitulo());
            stmt.setString(3, historico.getDescricao());
            stmt.setString(4, historico.getTipo().name());
            stmt.setInt(5, historico.getContrato().getId());

            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                historico.setId(rs.getInt(1));
            }
            stmt.close();
        }
    }

    public HistoricoContrato buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM HistoricoContrato WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Contrato contrato = new Contrato();
                contrato.setId(rs.getInt("contrato"));

                HistoricoContrato historico = new HistoricoContrato(
                    rs.getTimestamp("dataHistorico").toLocalDateTime(),
                    rs.getString("titulo"),
                    rs.getString("descricao"),
                    TipoHistorico.valueOf(rs.getString("tipo")),
                    contrato
                );
                historico.setId(rs.getInt("id"));
                return historico;
            }
            stmt.close();
        }

        return null;
    }

    public List<HistoricoContrato> listarPorContrato(int idContrato) throws SQLException {
        List<HistoricoContrato> lista = new ArrayList<>();
        String sql = "SELECT * FROM HistoricoContrato WHERE contrato = ? ORDER BY dataHistorico DESC";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idContrato);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Contrato contrato = new Contrato();
                contrato.setId(idContrato);

                HistoricoContrato historico = new HistoricoContrato(
                    rs.getTimestamp("dataHistorico").toLocalDateTime(),
                    rs.getString("titulo"),
                    rs.getString("descricao"),
                    TipoHistorico.valueOf(rs.getString("tipo")),
                    contrato
                );
                historico.setId(rs.getInt("id"));
                lista.add(historico);
            }
            stmt.close();
        }

        return lista;
    }

    public void excluir(int id) throws SQLException {
        String sql = "DELETE FROM HistoricoContrato WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
            stmt.close();
        }
    }

    public void atualizar(HistoricoContrato historico) throws SQLException {
        String sql = "UPDATE HistoricoContrato SET dataHistorico = ?, titulo = ?, descricao = ?, tipo = ?, contrato = ? WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setTimestamp(1, Timestamp.valueOf(historico.getDataHistorico()));
            stmt.setString(2, historico.getTitulo());
            stmt.setString(3, historico.getDescricao());
            stmt.setString(4, historico.getTipo().name());
            stmt.setInt(5, historico.getContrato().getId());
            stmt.setInt(6, historico.getId());

            stmt.executeUpdate();
            stmt.close();
        }
    }
}
