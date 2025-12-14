@echo off
:: 1) Verifica se está como administrador
net session >nul 2>&1
if %errorLevel% NEQ 0 (
  :: 2) Reexecuta este .bat com elevação
  powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)
:: 3) Executa o script PowerShell (usa %~dp0 para pegar o folder do .bat)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0gerenciamento_atalhos.ps1"