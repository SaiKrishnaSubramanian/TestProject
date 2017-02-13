body {
    color: #061C3F;
    /* background-color: #f4f4f4; */
    background-color: #6d727c;
}

input,
select,
textarea {
    border-color: #eaeaea;
    color: inherit
}

input:active,
input:hover,
select:active,
select:hover,
textarea:active,
textarea:hover {
    border-color: #c8c8c8
}

table {
    border-collapse: separate;
    border-spacing: 10px; /* cellspacing */
    *border-collapse: expression('separate', cellSpacing = '10px');
}

table td, table th {
    padding: 10px; /* cellpadding */
}

table th{
    border-bottom: solid #333;
    border-bottom-width: .5px;
}

button {
    color: #fff;
    background-color: #536076
}

button:active,
button:hover {
    background-color: #3f4b61
}



a {
    color: inherit
}

a:hover {
    color: #837096;
}

input:-ms-input-placeholder,
textarea:-ms-input-placeholder {
    color: gray
}

.overlay {
    background-color: rgba(0, 0, 0, .4)
}

.dialog .container {
    background-color: #fff
}

.dialog .description,
.dialog h3~small {
    color: #061C3F;
}

.mainForm,
.mainContent {
    background-color: #fff
}

.headerSection {
    color: #fff;
    background-color: #18325C;
    
}


.footerSection {
    color: #FFFFFF;
    background-color: #18325C
}



.timePicker label.selected {
    color: #fff;
    background-color: #18325C;
    border-color: #18325C;
}



.datePicker .navigator.disabled {
    color: #c8c8c8
}


.datePicker .date {
    color: #c8c8c8
}

.datePicker .date:hover {
    background-color: #f4f4f4
}

.datePicker .empty,
.datePicker .empty:hover {
    background: transparent
}

.datePicker .bookable {
    color: inherit
}

.datePicker .not-bookable {
    color: #c8c8c8
}

.datePicker .selected {
    color: #fff
}

.datePicker .selected,
.datePicker .selected:hover {
    background-color: #18325C;
}


.timePicker li:hover {
    background-color: #0070D2;
    border-radius: 100px;
}

.serviceSection .dialog {
    color: #333
}

@media (min-width:1021px) {
    .headerSection {
        background-color: #18325C;
        //background-image: url('https://dl.dropboxusercontent.com/u/29195628/TimeTrade/Linkalator/ttlogo.png');
        background-repeat: no-repeat;
        background-position: 5px 5px;
        background-size: 20%;
        
    }
}


@media (max-width:1020px) {
    .headerSection {
        background-color: #18325C;
        //background-image: url('https://dl.dropboxusercontent.com/u/29195628/TimeTrade/Linkalator/ttlogo.png');
        background-repeat: no-repeat;
        background-position: 10px 20px;
        background-size: 55%;
        
    }
}

* {
    font-family: 'Cabin','Trebuchet MS', sans-serif;
}

*,
div:focus,
span:focus {
    outline: none
}

.focusable:focus,
:focus {
    outline: 1px dotted gray
}

body {
    padding: 0;
    margin: 0;
    font-size: 16px;
    overflow-x: hidden;
    overflow-y: auto;
    -webkit-tap-highlight-color: transparent;
    -webkit-font-smoothing: antialiased
}

button,
input,
select,
textarea {
    border-style: solid;
    border-collapse: collapse;
    font-size: inherit;
    border-radius: 0;
    box-sizing: border-box
}

button,
input,
select {
    min-height: 30px;
    line-height: 30px;
    padding: 0;
    margin: 0;
    border-width: 0;
    overflow: hidden
}

select{
    color:#061C3F;
    height:30px;
    border:solid;
    background-color:#FFF;
    border-width:1px;
}

input[type=text],
 {
    border-bottom-width: 1px
}

@media screen and (-webkit-min-device-pixel-ratio:0) and (min-resolution:.001dpcm){
}

input[type=radio] {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    padding: 0;
    margin: 0;
    opacity: 0;
    z-index: -1
}

input[type=radio]:focus+label {
    outline: 1px dotted gray
}

input,
textarea {
    padding: 9px 16px
}

textarea {
    resize: none;
    overflow: auto;
    border-width: 1px
}

button {
    padding: 7px 20px;
    cursor: pointer
}

button,
label span,
 {
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis
}

a {
    text-decoration: none;
    color: #3f4b61;
}

h1,
h3 {
    padding: 0;
    margin: 0;
    font-weight: 400;
    opacity: .9
}

h1 {
    font-size: 44px;
    font-family: 'Cabin','Trebuchet MS',sans-serif;
}

h3 {
    font-size: 18px;
    font-family: 'Cabin','Trebuchet MS',sans-serif;
    color:#061C3F;
}

var {
    font-style: normal
}


::-ms-clear {
    display: none
}

::-webkit-clear-button {
    display: none;
    -webkit-appearance: none
}


.circle {
    border-radius: 50%
}



.mainContent {
    max-width: 1024px;
    min-width: 320px;
    margin: 0 auto;
    text-align: center
}

.overlay {
    width: 100%;
    height: 100%
}

.dialog,
.overlay {
    position: fixed;
    top: 0;
    left: 0
}

.dialog {
    bottom: 0;
    right: 0;
    z-index: 100
}

.dialog .container {
    display: inline-block;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 350px;
    overflow: hidden;
    box-shadow: 0 0 6px 0 rgba(0, 0, 0, .2)
}

.dialog .buttons,
.dialog .content {
    padding: 16px 36px
}

.dialog .content {
    min-height: 100px;
    max-height: 420px;
    overflow-x: hidden;
    overflow-y: auto;
    box-sizing: border-box
}

.dialog div.content>div {
    margin: 20px 0
}

.dialog h3~small {
    display: block;
    margin: 8px 0 0
}


.dialog .description,
.dialog h3~small {
    font-size: 16px
}

.dialog .description.left {
    text-align: left
}


.dialog .buttons {
    padding: 0 36px 36px
}


.mainForm {
    text-align: center
}

.section {
    /* box-shadow: 0 -2px 6px 0 rgba(0, 0, 0, .1) */
    border-bottom: 1px solid #FFF;
    text-align: left;
}

.timeSection {
    background-color: #E7E7E7;
}

.resourceSection {
    background-color: #E7E7E7;
}

.headerSection h1 {
    display: inline-block;
    font-size: 24px;
    line-height: 44px;
        
}

.titleSection h1 {
    font-size: 32px;
}

.floatingDiv {
    float:left;
    margin-bottom: 40px;
    margin-right: 20px;
    text-align: left;
}


.footerSection {
    font-size: 16px;
    line-height: 20px;
    text-align: left;
    box-shadow: 0 0 6px 0 rgba(0, 0, 0, .1);
    border-bottom: none;
}


.footerSection p {
    margin: 8px 0;
    font-size: 12px;
    overflow: hidden;
    text-overflow: ellipsis
}



.bookingDetailsSection {
    padding-bottom: 35px;
    border-bottom: none;
}




.bookingDetailsText {
    min-height: 48px;
    overflow: hidden;
    padding: 0 10px;
    margin: 13px 0 15px
}


.timePicker ul {
    font-size: 0;
    text-align: left;
    padding: 0;
    margin: 0
}



.timePicker li {
    font-size: 16px;
    line-height: 20px;
    list-style: none;
    display: inline-block;
    position: relative
}




.timePicker label {
    cursor: pointer;
    display: block;
    overflow: hidden;
    white-space: nowrap
}


.picker {
    display: inline-block;
    vertical-align: top;
    margin-right: 40px;
    text-align: left
}

.datePicker,
.picker {
    width: 392px;
    
}

.datePicker{
    background-color: #FFF;
}

.datePicker .header {
    margin: 0 8px
}

.durationName{
    
}

.datePicker .monthName,
.datePicker .navigator {
    display: inline-block;
    text-align: center;
    vertical-align: middle;
    line-height: 48px
}

.datePicker .monthName {
    font-size: 18px;
    max-width: 200px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    margin-left: 8px;
}

.datePicker .navigator {
    cursor: pointer;
    width: 32px
}

.datePicker .navigator:hover {
    font-weight: 700
}

.datePicker .navigator.disabled {
    font-weight: inherit;
    cursor: default
}



.datePicker .dates {
    position: relative
}

.datePicker .date,
.datePicker .weekday {
    display: inline-block;
    text-align: center;
    vertical-align: middle;
    width: 36px;
    height: 36px;
    line-height: 36px;
    padding: 4px;
    margin: 2px 6px
}

.datePicker .date {
    cursor: pointer
}

.datePicker .empty,
.datePicker .empty:hover {
    cursor: auto
}


.timePicker {
    width: 100%;
    max-height: 290px;
    overflow-x: hidden;
    overflow-y: auto;
    margin-left: 40px;
}



.timePicker li {
    width: 30%;
    text-align: center;
    animation: fade-in 1s backwards;
    margin: 6px;
}

.timePicker label {
    padding: 11px 0;
    margin: 1px;
    background-color: #FFF;
    border-radius: 100px;

}



.customerDetails {
    display: block;
    margin: 0 auto
}

.customerDetails div {
    display: inline-block;
    width: 392px;
    vertical-align: top;
    margin: 0 40px;
    text-align: left
}

.formlabel{
    font-size: .75rem;
}

.customerDetails input {
    
    background-color: #fff;
    color: #16325c;
    border: 1px solid #d8dde6;
    border-radius: .25rem;
    width: 100%;
    transition: border .1s linear, background-color .1s linear;
    display: inline-block;
    padding: 0 1rem 0 .75rem;
    line-height: 1.875rem;
    min-height: calc(1.875rem + (1px * 2));
    margin-bottom: 15px;
}

.customerDetails textarea:active,
.customerDetails textarea:focus,
.customerDetails input:active,
.customerDetails input:focus {
    outline: 0;
    border-color: #1589ee;
    background-color: #fff;
    box-shadow: 0 0 3px #0070D2
}

.customerDetails span {
    display: block
}

.customerDetails textarea {
    width: 100%;
    vertical-align: bottom;
    background-color: #fff;
    color: #16325c;
    border: 1px solid #d8dde6;
    border-radius: .25rem;
}

@keyframes fade-in {
    0% {
        opacity: .5
    }
    to {
        opacity: 1
    }
}

@keyframes spin {
    0% {
        transform: rotate(0)
    }
    to {
        transform: rotate(1turn)
    }
}

@media (min-width:1021px) {
    .section {
        padding: 25px 35px 35px 35px
    }
    .serviceSection h3,
    .customerSection h3,
    .timeSection h3 {
        margin: 6px 0 36px;
        color: #061C3F;
    }
    .headerSection {
        padding: 5px 0;
        border-bottom: none;
    }
    
    .titleSection {
        padding: 16px 0 0 30px;
        border-bottom: none;
        text-align: left;
        margin-bottom: 25px;
    }
    
    .timeHeader{
    margin-left: 46px;
}
    
    .statusDiv {
    margin-left: 50px;
}
    
    .serviceSection h3 {
        margin: 0 0 4px
    }
    .footerSection {
        text-align: left;
        padding: 3px 0px 3px 20px;
    }
    .bookButton {
        margin: 48px auto 0;
        color: #fff;
        background-color: #0070d2;
        min-width: 240px;
        display: inline-block;
        text-align: center;
        border-radius: 10px;
    }
    .bookButton:hover {
        background-color: #78a4eb
    }
    
    .bookButtonContainer,
     {
        display: inline-block
    }
}

@media (max-width:1020px) {
    body {
        font-size: 15px;
    }
    h1,
    h3 {
        opacity: 1
    }
    h1 {
        font-size: 26px
    }
    h3 {
        font-size: 15px
    }
    .mainContent {
        max-width: 414px
    }
    .dialog .container {
        max-width: 414px
    }
    .dialog .buttons,
    .dialog .content {
        padding: 8px 28px
    }
    .dialog .buttons {
        padding: 0 28px 28px
    }
    .dialog div.content>div,
    .dialog h3~small {
        font-size: 15px
    }
    .section {
        padding: 35px 0 15px 20px;
    }
    .timeSection {
        padding: 35px 0 15px 0px;
    }
    .resourceSection {
        padding: 35px 20px 15px 20px;
    }
    
    .bookSection {
        padding: 35px 40px 0px 40px;
    }
    .headerSection {
        padding: 3px 3px 3px 0;
        border-bottom: none;
    }
    .timeHeader{
        margin-left: 40px;
    }
    
    .headerSection h1 {
        font-size: 16px;
        margin: 55px 0px 0px 120px;
    }
    .customerSection h3,
    .serviceSection h3,
    .timeSection h3 {
        margin: 4px 0 14px
    }
    
    .statusDiv {
    margin-left: 5px;
}
.serviceSection {
        text-align: left;
    }
    .customerSection {
        padding: 10px 0 24px 20px;
    }
    .footerSection {
        padding: 3px 0 3px 20px;
        text-align: left;
    }
.timePicker li {
        font-size: 15px;
        line-height: 20px
    }
    .picker {
        width: 100%;
        margin: 0;
        padding-bottom: 15px;
    }
    .timePicker {
        max-height: inherit
    }
    .datePicker {
        width: 336px;
        margin: auto
    }
    .datePicker .monthName,
    .datePicker .navigator {
        line-height: 40px
    }
    .datePicker .monthName {
        font-size: inherit
    }
    .datePicker .navigator {
        width: 28px
    }
    .datePicker .date,
    .datePicker .weekday {
        padding: 0;
        margin: 3px 6px
    }
    .timePicker {
        width: 360px;
        margin: 2px 0px 0px 30px;
    }
    .timePicker li {
        width: 105px
    }
    .customerDetails {
        margin: 0 auto
    }
    .customerDetails div {
        display: block;
        width: inherit;
        margin: 0 28px 20px
    }

    .customerDetails span {
        margin-top: 10px
    }
    
    .bookButton
     {
        display: block;
        width: 100%;
        color: #fff;
        background-color: #0070d2;
        text-align: center;
        min-width: 300px;
        border-radius: 10px;
    }
    .bookButton:hover {
    background-color: #78a4eb;
    }
    .bookButtonContainer,
     {
        margin: 0 28px 4px
    }
    .bookButtonContainer {
        padding-top: 8px
    }
}

@media (max-width:374px) {
    .dialog .container {
        max-width: 280px
    }
    .datePicker {
        width: 280px
    }
    .datePicker .header {
        margin: 0 4px
    }
    .datePicker .date,
    .datePicker .weekday {
        margin: 3px 2px
    }
    .timePicker {
        width: 276px
    }
    .timePicker li {
        width: 88px
    }
}
SF Quick Metadata LookupVersion: 1.3
Search For
Apex ClassVisualForce Page Apex TriggerVF Component
Custom ObjectCustom SettingStatic ResourceUser
Search By
API NameLabelFilter By App
Search Result
Select Metadata first to start here...

For Suggestion and Issue Contact Me
