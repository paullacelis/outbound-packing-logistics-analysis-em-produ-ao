# outbound-packing-logistics-analysis-em-produ-ao

# 📦 Análise Logística : Packing de Produção e Monitoramento de SLA (Rebin ➔ Pack ➔ SLAM)

## 📌 Visão Geral do Projeto
Este projeto simula um estudo de caso e modelagem de dados voltados para o setor de **Outbound** em um Centro de Distribuição (*Fulfillment Center*). 

O objetivo principal é identificar gargalos operacionais no fluxo entre o abastecimento das colmeias no **Rebin**, o processamento nas bancadas de **Pack** e a validação final na balança (**SLAM**), medindo o impacto direto no descumprimento do tempo de ciclo (*SLA*) dos carrinhos de 35 colmeias.

---

## 🎯 Problema de Negócio e Regras
Em operações de alto volume, a falta de sincronia entre linhas de abastecimento e embalagem gera acúmulo de pacotes e estouros de janela de envio. 

**Parâmetros de SLA Utilizados:**
* **Capacidade Esperada:** Meta de 300 pacotes/hora por bancada (mínimo aceitável: 250 pcts/h).
* **Meta de Ciclo do Carrinho (35 colmeias):**
  * 🟢 **No Prazo:** $\le 15$ minutos
  * 🟡 **Aceitável:** $15$ a $20$ minutos
  * 🔴 **Atrasado (Gargalo):** $> 20$ minutos

---

## 📐 Modelagem de Dados Relacional
A base simulada tem mais de 90.000 registros :

1. **`tb_rebin`**: Registra o ID do carrinho, operador, linha e carimbo de data/hora da montagem.
2. **`tb_pack`**: Registra o pacote, bancada composta (Ex: `L01-B04`), operador de Pack e o tempo de ciclo do carrinho.
3. **`tb_slam`**: Registra o carimbo de data/hora da pesagem e o status da balança (`Aprovado` / `Rejeitado`).

---

## 🛠️ Tecnologias Utilizadas
* **Python (Pandas / NumPy):** Geração de massa de dados realista e tratamento inicial.
* **SQL:** Consultas de junção (*JOINs*), agregações por bancada/turno e cálculo condicional de SLA.
* **Power BI:** Desenvolvimento de dashboards de controle operacional e monitoramento de KPIs.

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
