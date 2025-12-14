# Obtém o caminho do diretório onde o script está localizado
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Carrega o assembly do Windows Forms para criar a interface gráfica
Add-Type -AssemblyName System.Windows.Forms

# Cria a janela de progresso
$Form = New-Object System.Windows.Forms.Form
$Form.Text = 'Atualizar os atalhos do publico'
$Form.Size = New-Object System.Drawing.Size(400, 230)
$Form.StartPosition = 'CenterScreen'

# Barra de progresso
$ProgressBar = New-Object System.Windows.Forms.ProgressBar
$ProgressBar.Minimum = 0
$ProgressBar.Maximum = 100
$ProgressBar.Size = New-Object System.Drawing.Size(350, 30)
$ProgressBar.Location = New-Object System.Drawing.Point(20, 50)
$Form.Controls.Add($ProgressBar)

# Rótulo de status
$Label = New-Object System.Windows.Forms.Label
$Label.Text = 'Iniciando...'
$Label.Size = New-Object System.Drawing.Size(350, 20)
$Label.Location = New-Object System.Drawing.Point(20, 20)
$Form.Controls.Add($Label)

# Rótulo de erro (invisível inicialmente)
$ErroLabel = New-Object System.Windows.Forms.Label
$ErroLabel.Text = 'Erro: Um ou mais computadores nao foram processados!'
$ErroLabel.ForeColor = 'Red'
$ErroLabel.Size = New-Object System.Drawing.Size(350, 60)
$ErroLabel.Location = New-Object System.Drawing.Point(20, 100)
$ErroLabel.Visible = $false
$Form.Controls.Add($ErroLabel)

# Botão de fechar
$FecharButton = New-Object System.Windows.Forms.Button
$FecharButton.Text = 'Fechar'
$FecharButton.Size = New-Object System.Drawing.Size(100, 30)
$FecharButton.Location = New-Object System.Drawing.Point(150, 160)  # Ajuste a posição conforme necessário
$FecharButton.Add_Click({
    $Form.Close()
})
$Form.Controls.Add($FecharButton)

# Exibe a janela
$Form.Show()

# Lista de IPs dos computadores
$computadores = Get-Content "$scriptDir\lista_ips.txt"

# Caminho da pasta com os novos atalhos no servidor
$atalhosFonte = "$scriptDir\atalhos_novos"

# Atalhos antigos a remover (um por linha em atalhos_antigos.txt)
$atalhosAntigos = Get-Content "$scriptDir\atalhos_remover.txt" | Where-Object { $_.Trim() -ne "" }

# Atalhos novos a copiar
# Atalhos novos a copiar (um por linha em atalhos_novos.txt)
$atalhosNovos = Get-Content "$scriptDir\atalhos_adicionar.txt" | Where-Object { $_.Trim() -ne "" }

# Caminhos para os logs
$logFalhas = "$scriptDir\relatorio\falhas_log.txt"
$logSucesso = "$scriptDir\relatorio\sucesso_log.txt"

# Limpa os arquivos de log anteriores, se existirem
if (Test-Path $logFalhas) { Remove-Item $logFalhas -Force }
if (Test-Path $logSucesso) { Remove-Item $logSucesso -Force }

$totalComputadores = $computadores.Count
$contador = 0
$erroOcorreu = $false

foreach ($ip in $computadores) {
    $destino = "\\$ip\c$\Users\Public\Desktop"

    # Atualiza o label e a barra de progresso
    $Label.Text = "Processando $ip..."
    $ProgressBar.Value = [int](($contador / $totalComputadores) * 100)

    if (Test-Path $destino) {
        try {
            # Remover atalhos antigos
            foreach ($atalho in $atalhosAntigos) {
                $caminho = Join-Path $destino $atalho
                if (Test-Path $caminho) {
                    Remove-Item $caminho -Force
                }
            }

            # Copiar atalhos novos
            foreach ($atalhoNovo in $atalhosNovos) {
                $fonte = Join-Path $atalhosFonte $atalhoNovo
                $dest = Join-Path $destino $atalhoNovo

                if (Test-Path $fonte) {
                    Copy-Item $fonte -Destination $dest -Force
                }
            }

            # Se tudo ocorreu bem, registra o sucesso
            Add-Content -Path $logSucesso -Value "$ip"
        }
        catch {
            # Erro no processamento
            Add-Content -Path $logFalhas -Value "$ip - Erro: $_"
            $erroOcorreu = $true
        }
    } else {
        # Caminho inacessível
        Add-Content -Path $logFalhas -Value "$ip"
        $erroOcorreu = $true
    }

    $contador++
}

# Finaliza a barra de progresso
$ProgressBar.Value = 100

# Contagem de resultados dos logs
$sucessos = (Get-Content "$scriptDir\relatorio\sucesso_log.txt" -ErrorAction SilentlyContinue | Measure-Object).Count
$falhas = (Get-Content "$scriptDir\relatorio\falhas_log.txt" -ErrorAction SilentlyContinue | Measure-Object).Count

# Atualiza a interface com resultado
# Atualiza a interface com resultado
if ($erroOcorreu -or $falhas -gt 0) {
    $ErroLabel.Text = "Erro: Um ou mais computadores nao foram processados!`nSucessos: $sucessos`nFalhas: $falhas"
    $ErroLabel.Visible = $true
    $Label.Text = 'Processo finalizado com erros!'
} else {
    $ErroLabel.Text = "Todos os computadores foram atualizados!`nSucessos: $sucessos"
    $ErroLabel.Visible = $true
    $Label.Text = 'Processo concluido com sucesso!'
}

# Mostra mensagem com totais e aguarda clique
[System.Windows.Forms.MessageBox]::Show("Processo concluido!`n`nSucessos: $sucessos`nFalhas: $falhas", "Resumo da execucao", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
# Fecha a janela após clique
$Form.Close()