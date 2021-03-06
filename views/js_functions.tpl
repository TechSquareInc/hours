

<script>

// FIRES ON PAGE LOAD (GET /hours)
$( document ).ready(function() {
	/* This function performs 5 things:
			1) anchors the page to a record display anchor <a name="{anchor}"> (var: anchor)
				anchor === "-1"   : top of the page, default value
				anchor === i (0-n): one of the records, including the new record form

			2) adds 'in' class to <div id="{'record'+collapseIndex}"> (var: collapseIndex)
				anchor === "-1"   : open new record form (id="record"+n)
				anchor === i (0-n): set the collapseIndex to equal anchor and open that form

			3) displays a resonse message from the logging server
				after sending records and redirect, this value will be passed in

			4) resets email and send confirmation elements to "false"
				prevents retention of old values as when hitting back in the browser

			5) focus one of (name, start, end) in <div id="{'record'+collapseIndex}">
				precident is in the order listed and is based on whether a value has been filled
	
	n = number of records as well as the index of the new record form
	i = index of the record
	*/ 
	// 1) will anchor to the record display <a name="{anchor}">
	var anchor = String(document.body.attributes["data-anchor"].value);
	window.location.hash = anchor;

	// 2) will open one of the collapse <div id="{'record'+collapseIndex}">
	var collapseIndex = String(document.body.attributes["data-default-collapse-index"].value);
	if (anchor !== "-1") { collapseIndex = anchor; }
	$("#record" + collapseIndex).addClass("in");

	// 3) displays response message from logging server, if it is passed in
	var msg = String(document.body.attributes["data-server-response"].value);
	if (msg != "") { alert(msg); }

	// 4) prevents old values from being retained
//	document.getElementById("emailConfirm").value = "false";
	document.getElementById("sendConfirm").value = "false";

	// 5) focuses one of the elements in the collapsing record form that was opened
	var name = $("#name" + collapseIndex);
	var start = $("#start" + collapseIndex);
	var end = $("#end" + collapseIndex);
	if 			(name.val() == false)  { name.focus(); }
	else if (start.val() == false) { start.focus(); }
	else if (end.val() == false)   { end.focus(); }
});

// ####################################################################################################

Date.prototype.yyyymmdd = function() {
  var mm = this.getMonth() + 1; // getMonth() is zero-based
  var dd = this.getDate();

  return [this.getFullYear(),
          (mm>9 ? '' : '0') + mm,
          (dd>9 ? '' : '0') + dd
         ].join('');
};



function createCookie(name,value,days) {
    if (days) {
        var date = new Date();
        date.setTime(date.getTime()+(days*24*60*60*1000));
        var expires = "; expires="+date.toGMTString();
    }
    else var expires = "";
    document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1,c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    }
    return null;
}

function eraseCookie(name) {
    createCookie(name,"",-1);
}


function lockRecord(){

    var str1 = "locked-";
    var str2 = readCookie("hours-app-date");
    var cookiename = str1.concat(str2);
    var iscookie = readCookie( cookiename );

    if ( iscookie ) {
        eraseCookie(cookiename);
        var printlock = document.getElementById("printlock");
        printlock.style.display= 'none';
        var nodes = document.getElementById("inputform").getElementsByTagName('*');
        for(var i = 0; i < nodes.length; i++){
            nodes[i].disabled = false;
        }  
    }
    else{
        createCookie( cookiename,"locked" , 30);
        var printlock = document.getElementById("printlock");
        printlock.style.display= 'inline-block';
        var nodes = document.getElementById("inputform").getElementsByTagName('*');
        for(var i = 0; i < nodes.length; i++){
            nodes[i].disabled = true;


        }  

    }
}

function checkLock(){
    var str1 = "locked-";
    var str2 = readCookie("hours-app-date");
    var cookiename = str1.concat(str2);
    var iscookie = readCookie( cookiename );
    if ( iscookie ) {
        var printlock = document.getElementById("printlock");
        printlock.style.display= 'inline-block';
        var nodes = document.getElementById("inputform").getElementsByTagName('*');
        for(var i = 0; i < nodes.length; i++){
            nodes[i].disabled = true;
    }
    //     for (var i = 0; i <= 60; i++){
      //       var stringy = "end" + i.toString();
        //    try{
          //       doc = document.getElementById(stringy);
            //     doc.setAttribute("disabled",true);
          
         // }        
          //  catch(err){
     
    //      }
  //   }  
 }

            
}




// ####################################################################################################

function confirmDelete() {
	var choice = confirm("Are you sure you want to delete records?");
	if (choice) {
		document.getElementById("deleteConfirm").value = "true";
	}
}

function confirmSend(self) {
	var choice = confirm("Are you sure you want to send records?")

	if (choice) {
		document.getElementById("sendConfirm").value = "true";
	}
}

function confirmEmail(self) {
	var sender = self.attributes['data-sender'].value;
	var receivers = self.attributes['data-receivers'].value;

	var choice = confirm("Sender: " + sender + "\n" + 
		"Receivers: " + receivers + "\n\n" +
		"Are you sure you want to email records?");

	if (choice) {
		document.getElementById("emailConfirm").value = "true";
	}
}

// ####################################################################################################
// ####################################################################################################


// gets element with provided id, sets value to "", and gives focus
function focusAndClearField(id) {
	var elem = document.getElementById(id);
	elem.value = "";
	elem.focus();
}


function adjustNextIndex(insertID, recordIndex) {
	document.getElementById(insertID).value = recordIndex;
}
// #####


// ####################################################################################################
// ####################################################################################################


function openViewer() {
	var str = document.getElementById("viewRecords").value;
	OpenWindow=window.open("", "newwin", "width=940, height=750, toolbar=no,scrollbars="+scroll+",menubar=no");
	OpenWindow.moveTo(0,0);
	OpenWindow.document.write(`
	<html>
	<head>
		<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css"/>
	 	<link rel="stylesheet" type="text/css" href="css/hours.css" />
		<title>Hours</title>
	</head>
	<body name="viewer">
	<div class="container" id="viewerContents">
		<div class="row">
			<div class="col-md-6 col-md-offset-3">
				<div class="panel panel-default">
					<div class="panel-body">`);
	OpenWindow.document.write(str);
	OpenWindow.document.write(`
					</div>
				</div>
			</div>
		</div>
	</div>
	</body>
	</html>
	`);
	//var contents = document.getElementById("viewerContents");
	//OpenWindow.resizeTo(contents.offsetWidth, contents.offsetHeight);
	OpenWindow.document.close();
	self.name="main";
}

// ####################################################################################################
// ####################################################################################################


// private function
function setBillableEmergency(index, billable, emergency) {
	
	var b = "<strong>" + billable + "</strong>";
	var e = "<strong>" + emergency + "</strong>";

	var bill = document.getElementById("billable" + index);
	var b_span = bill.children[1];
	var b_hidden = bill.children[2];

	b_span.innerHTML = b;
	b_hidden.value = billable;

	var emer = document.getElementById("emergency" + index);
	var e_span = emer.children[1];
	var e_hidden = emer.children[2];

	e_span.innerHTML = e;
	e_hidden.value = emergency;
}


function toggleBE(self) {
	
	var c = self.children;

	var span = c[1];
	var hidden = c[2];

	if (hidden.value === "Y") {
		span.innerHTML = "<strong>N</strong>";
		hidden.value = "N";
	} else {
		hidden.value = "Y";
		span.innerHTML = "<strong>Y</strong>";
	}
}

// for billable/emergency toggling
function toggleButtonPress(event, self) {
	event.preventDefault();
	// if enter or space button was pressed, toggle the billable/emergency element
	if (event.keyCode === 13 || event.keyCode === 32) {
		toggleBE(self);
	}
}

// ####################################################################################################
// ####################################################################################################


function dropdownChangeSelect(self) {
	var index = self.attributes["data-index"].value;
	var selected = self.options[self.selectedIndex];

	var billable = selected.attributes["data-billable"].value
	var emergency = selected.attributes["data-emergency"].value

	setBillableEmergency(index, billable, emergency);

	// console.log(index, billable, emergency);
	// console.log(selected);

	var input = self.parentElement.querySelector("[name='dropdown']");
	input.value = self.options[self.selectedIndex].text;

	var value = self.parentElement.querySelector("[name='label']");
	value.value = self.options[self.selectedIndex].value;
}

function dropdownChangeType(self) {
	var index = self.attributes["data-index"].value;
	var names = self.attributes["data-name"].value;
	var billable = self.attributes["data-billable"].value;
	var emergency = self.attributes["data-emergency"].value;
	

	names = names.replace(/,|'|\[|\]/g, '').split(" ");
	billable = billable.replace(/,|'|\[|\]/g, '').split(" ");
	emergency = emergency.replace(/,|'|\[|\]/g, '').split(" ");

	var selected_index = names.indexOf(self.value.toUpperCase());

	if (selected_index >= 0) {
		setBillableEmergency(index, billable[selected_index], emergency[selected_index]);
	} else {
		setBillableEmergency(index, billable[0], emergency[0]);
	}


	var input = self.parentElement.querySelector("[name='dropdown']");
	var value = self.parentElement.querySelector("[name='label']");

	value.value = input.value;
}

// ####################################################################################################
// ####################################################################################################


function submitOnEnterPressed(event, formElem) {

	// if enter button was pressed, submit the form
	if (event.keyCode === 13) {
		formElem.submit();
	}
}

function setValueFromInnerText(self) {
	self.value = self.innerText;
}

// function modifyTimePattern(self) {
// 	minTime = self.attributes["data-min"].value;
// 	maxTime = self.attributes["data-max"].value;
// 	default_pattern = "(\s*|(0?[0-9]|1[0-9]|2[0-3]):?(00|15|30|45))";
// 	console.log(default_pattern);

// 	pattern="(\s*|(";

// 	if (minTime.substr(0,2) < 10) {
// 		pattern += "0?";
// 		pattern += "[" + minTime.substr(1,1) + "-";

// 		if (maxTime.substr(0,2) < 10) {
// 			pattern += maxTime.substr(1,1);
// 		} else {
// 			pattern += "9";
// 		}
// 		pattern += "]";
// 	}
// 	else if (minTime.substr(0,2) >= 10 && minTime.substr(0,2) < 20) {
// 		pattern += "1[" + minTime.substr(1,1) + "-";

// 		if (maxTime.substr(0,2) >= 10 && maxTime.substr(0,2) < 20) {
// 			pattern += maxTime.substr(1,1);
// 		} else {
// 			pattern += "9";
// 		}
// 		pattern += "]";
// 	}
// 	else if (minTime.substr(0,2) >= 20) {
// 		pattern += "|2[" + minTime.substr(1,1) + "-" + maxTime.substr(1,1);
// 	}
	
// 	pattern += "):?(";

// 	minuteArray = ["00", "15", "30", "45"];

// 	var minIndex = minuteArray.indexOf(minTime.substr(2,2));
// 	var maxIndex = minuteArray.indexOf(maxTime.substr(2,2));

// 	pattern += minuteArray.slice(minIndex, maxIndex+1).join("|") + "))";

// 	console.log(pattern);
// }

function checkTime(self) {
	var time = self.value.replace(":","");
	// pad with a leading 0, if missing
	if (time.length == 3) { time = '0' + time }
	var min = self.attributes["data-min"].value.replace(":","") || "0000";
	var max = self.attributes["data-max"].value.replace(":","") || "2345";

	if ((time != "") && (time <= min || time >= max)) {
		alert("Invalid time!\nTime (" + time + ") should be within the range: " + min + "-" + max + "\nTime must be at a quarter-hour interval");
	}

}

function shiftDay(amount) {
	var delta = document.getElementById("time-delta");
	delta.value = String(amount);
}

</script>
