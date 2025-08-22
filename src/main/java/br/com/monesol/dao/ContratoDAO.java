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
    	String sql = "INSERT INTO Contrato (vigenciaInicio, vigenciaFim, reajustePeriodicoMeses, limiteMinimoEnergiaKWh, precoPorKWh, modeloComercial, observacoes, regraAlocacao, qtdcontratada, unidadeGeradora, usuario) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

      
            stmt.setDate(1, Date.valueOf(contrato.getVigenciaInicio()));
            stmt.setDate(2, Date.valueOf(contrato.getVigenciaFim()));
            stmt.setInt(3, contrato.getReajustePeriodicoMeses());

            if (contrato.getLimiteMinimoEnergiaKWh() != null) {
                stmt.setDouble(4, contrato.getLimiteMinimoEnergiaKWh());
            } else {
                stmt.setNull(4, Types.DOUBLE);
            }

            stmt.setDouble(5, contrato.getPrecoPorKWh());
            stmt.setString(6, contrato.getModeloComercial());
            stmt.setString(7, contrato.getObservacoes());
            stmt.setString(8, contrato.getRegraAlocacao());
            stmt.setDouble(9, contrato.getQtdContratada());
            stmt.setInt(10, contrato.getUnidadeGeradora().getId());
            stmt.setString(11, contrato.getUsuario().getCpfCnpj());

            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                contrato.setId(rs.getInt(1));
            }
            stmt.close();
        }
    }

    public Contrato buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM Contrato WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Contrato contrato = preencherContrato(rs);
                contrato.setId(id);
                return contrato;
            }
            stmt.close();
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
                contrato.setId(rs.getInt("id"));
                lista.add(contrato);
            }
            stmt.close();
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
                contrato.setId(rs.getInt("id"));
                lista.add(contrato);
            }
            stmt.close();
        }

        return lista;
    }

    public void atualizar(Contrato contrato) throws SQLException {
        String sql = "UPDATE Contrato SET vigenciaInicio = ?, vigenciaFim = ?, reajustePeriodicoMeses = ?, limiteMinimoEnergiaKWh = ?, precoPorKWh = ?, modeloComercial = ?, observacoes = ?, regraAlocacao = ?, qtdcontratada = ?, unidadeGeradora = ?, usuario = ? WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            
            stmt.setDate(1, Date.valueOf(contrato.getVigenciaInicio()));
            stmt.setDate(2, Date.valueOf(contrato.getVigenciaFim()));
            stmt.setInt(3, contrato.getReajustePeriodicoMeses());

            if (contrato.getLimiteMinimoEnergiaKWh() != null) {
                stmt.setDouble(4, contrato.getLimiteMinimoEnergiaKWh());
            } else {
                stmt.setNull(4, Types.DOUBLE);
            }

            stmt.setDouble(5, contrato.getPrecoPorKWh());
            stmt.setString(6, contrato.getModeloComercial());
            stmt.setString(7, contrato.getObservacoes());
            stmt.setString(8, contrato.getRegraAlocacao());
            stmt.setDouble(9, contrato.getQtdContratada());
            stmt.setInt(10, contrato.getUnidadeGeradora().getId());
            stmt.setString(11, contrato.getUsuario().getCpfCnpj());
            stmt.setInt(12, contrato.getId());

            stmt.executeUpdate();
            stmt.close();
        }
    }

    public void excluir(int id) throws SQLException {
        String sql = "DELETE FROM Contrato WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
            stmt.close();
        }
    }

  
    private Contrato preencherContrato(ResultSet rs) throws SQLException {
        UnidadeGeradora unidade = new UnidadeGeradora("", 0.0, 0.0);
        unidade.setId(rs.getInt("unidadeGeradora"));

        Usuario usuario = new Usuario(null, null, null, null, null, null, null);
        usuario.setCpfCnpj(rs.getString("usuario"));

        return new Contrato(
            rs.getDate("vigenciaInicio").toLocalDate(),
            rs.getDate("vigenciaFim").toLocalDate(),
            rs.getInt("reajustePeriodicoMeses"),
            rs.getObject("limiteMinimoEnergiaKWh") != null ? rs.getDouble("limiteMinimoEnergiaKWh") : null,
            rs.getDouble("precoPorKWh"),
            rs.getString("modeloComercial"),
            rs.getString("observacoes"),
            rs.getString("regraAlocacao"),
            rs.getDouble("qtdcontratada"),
            unidade,
            usuario
        );
    }
}
