# Caminho para o arquivo JSON
$holidayFilePath = "Feriados.json"
$logFilePath = $MyInvocation.MyCommand.Path -replace '\.ps1$', '.log'

function Write-Log {
    param (
        [string]$Message        
    )

    if (-not [string]::IsNullOrWhiteSpace($Message)) {
        
        # Escreve no arquivo de log
        $logMessageFile = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message"        
        Add-content -Path $logFilePath -Value $logMessageFile

        # Escreve no Visualizador de Eventos do Windows
        #New-EventLog -LogName Application -Source "PowerShell Log" -ErrorAction SilentlyContinue
        #Write-EventLog -LogName Application -Source "PowerShell Log" -EntryType Information -EventId 0 -Message $logMessage
                
        # Escreve na saída host
        Write-Host $Message
    }else {
        # Se a mensagem estiver vazia, pula uma linha no arquivo de log
        Add-Content -Path $logFilePath -Value ""
    }
}

function Check-Holiday {
    # Ler o conteúdo do arquivo JSON
    $conteudo = Get-Content $holidayFilePath | ConvertFrom-Json

    # Lista para armazenar as datas
    $datas = @()

    # Percorrer as propriedades do objeto JSON
    foreach ($propriedade in $conteudo | Get-Member -MemberType NoteProperty) {
        # Adicionar as datas da propriedade à lista
        $holidays += $conteudo.$($propriedade.Name)
    }

    Write-Log "Feriados: $holidays"

    # Formata a data atual para os formatos dd-MM e dd-MM-yyyy
    $currentDate_ddMM = Get-Date -Format 'dd-MM'
    $currentDate_ddMMyyyy = Get-Date -Format 'dd-MM-yyyy'

    Write-Log "Datas verificar: $currentDate_ddMM | $currentDate_ddMMyyyy"

    # Verifica se a data atual está presente na lista de feriados
    if ($holidays -contains $currentDate_ddMM -or $holidays -contains $currentDate_ddMMyyyy) {        
        return $true
    } else {        
        return $false        
    }
}

Write-Log

$checkHolidayResult = Check-Holiday

if ( $checkHolidayResult ) {
    Write-Log -Message "É um feriado."
} else {
    Write-Log -Message "Não é um feriado."
}

