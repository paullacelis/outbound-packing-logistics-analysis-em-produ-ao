# 📦 Análise Logística: Packing de Produção e Monitoramento de SLA (Rebin ➔ Pack ➔ SLAM)

## 📌 Visão Geral do Projeto
Este projeto simula um estudo de caso e modelagem de dados voltados para o setor de **Outbound** em um Centro de Distribuição (*Fulfillment Center*). 

O objetivo principal é identificar gargalos operacionais no fluxo entre o abastecimento das colmeias no **Rebin**, o processamento nas bancadas de **Pack** e a validação final na balança (**SLAM**), medindo o impacto direto no descumprimento do tempo de ciclo (*SLA*) dos carrinhos de 35 colmeias.

---

## 🎯 Problema de Negócio e Regras
Em operações de alto volume, a falta de sincronia entre linhas de abastecimento e embalagem gera acúmulo de pacotes e estouros de janela de envio. 

**Parâmetros de SLA Utilizados:**
* **Capacidade Esperada:** Meta de 300 pacotes/hora por bancada (mínimo aceitável: 250 pcts/h).
* **Meta de Ciclo do Carrinho (35 colmeias):**
  * 🟢 **No Prazo:** Até 15 minutos (≤ 15 min)
  * 🟡 **Aceitável:** 15 a 20 minutos
  * 🔴 **Atrasado (Gargalo):** Acima de 20 minutos (> 20 min)

---

## 📐 Modelagem de Dados Relacional
A base simulada é composta por mais de 90.000 registros distribuídos em um modelo relacional:

1. **`tb_rebin`**: Registra ID do carrinho, operador, linha e timestamp da montagem.
2. **`tb_pack`**: Registra o pacote, bancada composta (Ex: `L01-B04`), operador de Pack e o tempo de ciclo do carrinho.
3. **`tb_slam`**: Registra o timestamp da pesagem e o status da balança (`Aprovado` / `Rejeitado`).

---

## 🛠️ Tecnologias Utilizadas
* **Python (Pandas / NumPy):** Geração de massa de dados realista, simulação de eventos e tratamento inicial.
* **SQL:** Consultas de junção (*JOINs*), agregações por bancada/turno e cálculo condicional de SLA.
* **Power BI:** Desenvolvimento de dashboards interativos de controle operacional e monitoramento de KPIs em tempo real.

---

## 🖼️ Dashboard Outbound Pacing
![Dashboard Outbound Pacing](dashboard/primeiro%20dashboard%20outbound.png)

---

## 📊 Principais Insights Identificados
* **Gargalos Operacionais:** Identificação do tempo de espera acumulado na transição entre a montagem no Rebin e o início do Pack.
* **Capacidade vs. Demanda:** Mapeamento de bancadas operando abaixo do limite mínimo aceitável de 250 pcts/h.
* **Impacto no SLA:** Análise do percentual de carrinhos que excederam o limite crítico de 20 minutos e o seu impacto no despacho final.

---

## 📌 Histórico de Versões e Atualizações

### v1.0 - Monitoramento Inicial e SLA
* Criação dos KPIs de Tempo Médio Real, Bancadas Necessárias e Tempo Alvo.
* Gráfico de linhas para comparação individual de ciclo por bancada.
* Formatação condicional visual para alertas de risco de atraso.

### v2.0 - [Em Desenvolvimento]
* Ajuste dinâmico da fórmula de Tempo Alvo considerando a restrição física de 40 bancadas.
* Rebalanceamento de carga e simulação de Pacing.

---

## 📁 Estrutura do Repositório
```text
├── data/
│   ├── tb_rebin.csv
│   ├── tb_pack.csv
│   └── tb_slam.csv
├── scripts/
│   ├── data_generator.py
│   └── queries.sql
├── dashboard/
│   └── outbound_pacing.pbix
└── README.md
