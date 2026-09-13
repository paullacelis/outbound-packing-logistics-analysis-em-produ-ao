-- =============================================================================
-- PROJETO: Análise de Outbound, Pacing e SLA de Ciclo no FC
-- DESCRIÇÃO: Consultas SQL para unificação da base relacional (Rebin -> Pack -> SLAM)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. CONSULTA PRINCIPAL: Unificação do Fluxo e Classificação de SLA
-- -----------------------------------------------------------------------------
SELECT 
    p.id_pacote,
    p.id_carrinho,
    p.id_bancada,
    p.id_op_pack,
    r.linha_rebin,
    r.id_op_rebin,
    r.dt_inicio_montagem AS rebin_inicio,
    r.dt_fim_montagem AS rebin_fim,
    p.dt_inicio_pack AS pack_inicio,
    p.dt_fim_pack AS pack_fim,
    s.dt_pesagem AS slam_pesagem,
    s.status_balanca AS status_slam,
    
    -- Tempo de espera entre Rebin e Pack (minutos)
    ROUND(TIMESTAMPDIFF(SECOND, r.dt_fim_montagem, p.dt_inicio_pack) / 60.0, 2) AS tempo_espera_rebin_pack_min,
    
    -- Tempo total de ciclo da colmeia no Pack (minutos)
    p.tempo_ciclo_carrinho_min,
    
    -- Classificação de SLA da Colmeia (Meta <=15m | Aceitável 15-20m | Atrasado >20m)
    CASE 
        WHEN p.tempo_ciclo_carrinho_min <= 15 THEN 'No Prazo (<=15m)'
        WHEN p.tempo_ciclo_carrinho_min BETWEEN 15.01 AND 20 THEN 'Aceitável (15-20m)'
        ELSE 'Atrasado (>20m)'
    END AS status_sla_colmeia

FROM tb_pack p
INNER JOIN tb_rebin r ON p.id_carrinho = r.id_carrinho
LEFT JOIN tb_slam s ON p.id_pacote = s.id_pacote;


-- -----------------------------------------------------------------------------
-- 2. MÉTRICAS DE DESEMPENHO POR BANCADA (Linha + Mesa)
-- -----------------------------------------------------------------------------
SELECT 
    p.id_bancada,
    COUNT(DISTINCT p.id_pacote) AS total_pacotes_embalados,
    COUNT(DISTINCT p.id_carrinho) AS total_carrinhos_processados,
    ROUND(AVG(p.tempo_ciclo_carrinho_min), 2) AS tempo_medio_carrinho_min,
    
    -- Percentual de carrinhos que estouraram o SLA de 20 minutos
    ROUND(
        (SUM(CASE WHEN p.tempo_ciclo_carrinho_min > 20 THEN 1 ELSE 0 END) * 100.0) / COUNT(DISTINCT p.id_carrinho), 
        2
    ) AS pct_estouro_sla

FROM tb_pack p
GROUP BY p.id_bancada
ORDER BY pct_estouro_sla DESC;


-- -----------------------------------------------------------------------------
-- 3. MONITORAMENTO DE REJEITO NA BALANÇA (SLAM)
-- -----------------------------------------------------------------------------
SELECT 
    p.id_bancada,
    COUNT(s.id_pacote) AS total_pesados,
    SUM(CASE WHEN s.status_balanca = 'Rejeitado' THEN 1 ELSE 0 END) AS total_rejeitados,
    ROUND(
        (SUM(CASE WHEN s.status_balanca = 'Rejeitado' THEN 1 ELSE 0 END) * 100.0) / COUNT(s.id_pacote), 
        2
    ) AS taxa_rejeicao_pct
FROM tb_pack p
INNER JOIN tb_slam s ON p.id_pacote = s.id_pacote
GROUP BY p.id_bancada
HAVING taxa_rejeicao_pct > 0
ORDER BY taxa_rejeicao_pct DESC;