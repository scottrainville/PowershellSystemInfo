#final project script
#Scott Rainville

function hitenter()
{
    write-host
    write-host "Hit Enter to continue."
    read-host
}

function checkinternet()
{
    $back = "false"
    while ($back -eq "false")
    {
        cls
        write "CHECK NETWORK CONNECTIVITY MENU"
        write ""
        write "1. Ping host/domain"
        write "2. Download HTML of specified website"
        write "3. IPconfig"
        write 'Or type back to go back.'

        $selection = read-host -prompt "Type the number of your choice."

        if ($selection -eq "back")
        {
            $back = "true"
        }
        elseif ($selection -eq "1")
        {
            $address = read-host -prompt "Type the IP or domain to ping."
            ping $address
            hitenter
        }
        elseif ($selection -eq "2")
        {
            $site = read-host -prompt 'Enter the domain of the website. Exclude the "http://".'
            $filename = read-host -prompt "Enter the filename to save as.:"
            $wget = new-object System.net.webClient
            $wget.DownloadString("http://$site") | out-file "$filename.html"
            hitenter
        }
        elseif ($selection -eq "3")
        {
            ipconfig
            hitenter
        }
    }
}

function securitylogs()
{
    cls
    $numlogs = read-host -prompt "How many of the most recent logs should be include in the search?"
    $numinputs = read-host -prompt "How many search terms do you want? Up to 5."
            $userInput = read-host -Prompt "Please specify a search term. Leave it blank to show all logs."
            if ($numinputs -gt 1)
            {
                $userInput2 = read-host -Prompt "Please specify a search term"
            }
            if ($numinputs -gt 2)
            {
                $userInput3 = read-host -Prompt "Please specify a search term"
            }
            if ($numinputs -gt 3)
            {
                $userInput4 = read-host -Prompt "Please specify a search term"
            }
            if ($numinputs -gt 4)
            {
                $userInput5 = read-host -Prompt "Please specify a search term"
            }

            if ($userinput2 -eq "")
            {
                get-eventlog System -newest $numlogs |Where-Object {$_.Message -match "$userInput"}
            }
            elseif ($userinput3 -eq "")
            {
                get-eventlog System -newest $numlogs |Where-Object {$_.Message -match "$userInput|$userinput2"}
            }
            elseif ($userinput4 -eq "")
            {
                get-eventlog System -newest $numlogs |Where-Object {$_.Message -match "$userInput|$userinput2|$userinput3"}
            }
            elseif ($userinput5 -eq "")
            {
                get-eventlog System -newest $numlogs |Where-Object {$_.Message -match "$userInput|$userinput2|$userinput3|$userinput4"}
            }
            else
            {
                get-eventlog System -newest $numlogs |Where-Object {$_.Message -match "$userInput|$userinput2|$userinput3|$userinput4|$userinput5"}
            }

            hitenter
}

function systemspecs()
{
    cls
    $cpu = get-WmiObject win32_processor | select -expandproperty Name
    write "CPU: $cpu"
    write ""

    $memory = Get-WmiObject -Class Win32_ComputerSystem | select -expandproperty TotalPhysicalMemory
    $GB = [math]::Round($memory/1073141824)
    
    write "Total Memory: $GB GB."
    write ""

    $Used = Get-PSDrive C | Select-Object -expandproperty Used
    $free = Get-PSDrive C | Select-Object -expandproperty Free

    $usedgb = [math]::Round($used/1073141824)
    $freegb = [math]::Round($free/1073141824)
    $totalgb = $usedgb + $freegb

    write "Disk Capacity: $totalgb GB."
    write "   Used: $usedgb GB."
    write "   Free: $freegb GB."

    hitenter

}


function menu()
{
    cls
    $exit = "false"
    while ($exit -eq "false")
    {
        cls
        write "MAIN MENU"
        write ""
        write "1. Check for internet connectivity"
        write "2. Search security logs"
        write "3. List running services"
        write "4. Search running processes"
        write "5. Search all system files"
        write "6. Show Basic system specs"
        write ""
        write 'Or type "exit" to exit.'
        write ""
        $choice = read-host -prompt "Type the number of your choice."

        if ($choice -eq "exit")
        {
            $exit = "true"
            write "Bye!"
        }
        elseif ($choice -eq "1")
        {
            checkinternet
        }
        elseif ($choice -eq "2")
        {
            securitylogs
        }
        elseif ($choice -eq "3")
        {
            cls
            get-service | where {$_.status -eq "Running"}
            hitenter
        }
        elseif ($choice -eq "4")
        {
            cls
            $searchterm = read-host -prompt "Enter the process name to search for. Leave blank to show all."
            get-process | where-object {$_.ProcessName -match $searchterm}
            hitenter
        }
        elseif ($choice -eq "5")
        {
            cls
            write "THIS WILL TAKE UP TO A WHILE TO COMPLETE."
            $cont = read-host -prompt 'Do you want to continue? Enter "y" or "n".'
            if ($cont -eq "y")
            {
                $filesearch = read-host -prompt "Enter the file name to search for. Leave blank to show all."
                write "searching..."
                dir C:\ -r | where-object {$_.Name -match $filesearch}
                hitenter
            }
            else
            {
                write "Exiting..."
                hitenter
            }
        }
        elseif ($choice -eq "6")
        {
            systemspecs
        }
    }

    hitenter
    cls
}

menu