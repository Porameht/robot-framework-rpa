*** Settings ***
Documentation       Robot to solve the first challenge at rpachallenge.com,
...                 which consists of filling a form that randomly rearranges
...                 itself for ten times, with data taken from a provided
...                 Microsoft Excel file.

Library    RPA.Browser.Selenium
Library    RPA.Excel.Files
Library    RPA.HTTP               
Library    RPA.Desktop
Library    RPA.RobotLogListener

*** Tasks ***
Complete the challenge
    Start the challenge
    Fill the forms
    Collect the results

*** Keywords ***
Start the challenge
    Open Available Browser    https://rpachallenge.com/
    Download
    ...    http://rpachallenge.com/assets/downloadFiles/challenge.xlsx
    ...    overwrite=True
    Click Button    Start

Fill the forms
    ${prople}=    Get the list of prople from the Excel file
    FOR    ${person}    IN    @{prople}
        Fill and submit the form    ${person}
    END

Get the list of prople from the Excel file
    Open Workbook    challenge.xlsx
    ${table}=    Read Worksheet As Table    header=True
    Close Workbook
    RETURN    ${table}

# <label _ngcontent-c2="">First Name</label>
# <input
#   _ngcontent-c2=""
#   ng-reflect-name="labelFirstName"
#   id="cu1Yq"
#   name="cu1Yq"
#   class="ng-pristine ng-invalid ng-touched"
# />

Fill and submit the form
     [Arguments]    ${person}
     Input Text    css:input[ng-reflect-name="labelFirstName"]    ${person}[First Name]
     Input Text    css:input[ng-reflect-name="labelLastName"]    ${person}[Last Name]
     Input Text    css:input[ng-reflect-name="labelCompanyName"]    ${person}[Company Name]
     Input Text    css:input[ng-reflect-name="labelRole"]    ${person}[Role in Company]
     Input Text    css:input[ng-reflect-name="labelAddress"]    ${person}[Address]
     Input Text    css:input[ng-reflect-name="labelEmail"]    ${person}[Email]
     Input Text    css:input[ng-reflect-name="labelPhone"]    ${person}[Phone Number]
     Click Button    Submit

Collect the results
    Capture Element Screenshot    css:div.congratulations
    [Teardown]    Close All Browsers