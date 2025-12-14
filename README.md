
# 📌 gerenciamento_atalhos.ps1 – Gerenciamento Centralizado de Atalhos Windows

O **`gerenciamento_atalhos.ps1`** é um script PowerShell desenvolvido para **padronização e gerenciamento remoto de atalhos** em ambientes Windows corporativos.

Ele permite **adicionar ou remover atalhos (.exe e .url)** na pasta **Public Desktop** dos computadores, com base em **listas de configuração externas**, facilitando a manutenção e a padronização do ambiente de trabalho dos usuários.

---

## 🎯 Finalidade

Este script tem como principais objetivos:

- Distribuir atalhos padronizados para múltiplas estações Windows
- Remover atalhos obsoletos ou não autorizados
- Garantir consistência visual e funcional no Desktop Público
- Automatizar alterações em massa de forma segura e controlada
- Reduzir intervenções manuais em estações de trabalho

---

## ⚙️ Funcionamento

Ao ser executado, o script:

1. Lê a lista de computadores a partir do arquivo `lista_ip.txt`
2. Analisa os atalhos definidos em:
   - `atalhos_adicionar.txt`
   - `atalhos_remover.txt`
3. Conecta-se remotamente às estações listadas
4. Realiza as ações necessárias na pasta:

C:\Users\Public\Desktop

5. Adiciona ou remove atalhos conforme definido nos arquivos de configuração

---

## 📂 Arquivos de Configuração

### 🔹 lista_ip.txt
Contém os **endereços IP ou nomes de host** das estações que receberão as alterações.

192.168.1.10
192.168.1.11
PC-FINANCEIRO


🔹 atalhos_adicionar.txt

Lista de atalhos que vão ser adicionados.

Suporta:
Arquivos .exe .url entre outros..

🔹 atalhos_remover.txt

Lista de atalhos que vão ser removidos.

Suporta:
Arquivos .exe .url entre outros..

---

## 📝 Logs de sucesso e falhas

O script gera automaticamente logs detalhados de execução, e validação das ações realizadas em cada estação.

---

## 🖥️ Requisitos

- Windows 10 ou superior
- PowerShell 5.1 ou superior
- Execução com privilégios de **Administrador**
- Utilização dentro de fluxo automatizado previamente definido

---

## 🏢 Ambiente Indicado

- Ambientes corporativos
- Estações de trabalho em domínio
- Servidores Windows
- Processos de padronização e segurança
