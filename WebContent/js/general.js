// JavaScript Document
	var letters = /^[A-Za-z]+$/;
	var numbers = /^[0-9]+$/;
	var emailExp = /^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/;

function mover(obj)
{obj.className="zoomsize";}//document.obj1.obj.className="zoomsize";}
function mout(obj)
{obj.className="fieldsize";}//document.obj1.obj.className="fieldsize";}
function compmover(obj)
{obj.className="compzoomsize";}//document.obj1.obj.className="zoomsize";}
function compmout(obj)
{obj.className="compfieldsize";}//document.obj1.obj.className="fieldsize";}

function qmover(obj)
{obj.className="quantityzoomsize";}
function qmout(obj)
{obj.className="quantityfieldsize";}

function upper(obj)
{
str=obj.value;
obj.value=str.toUpperCase();
}
function mousemove(obj)
{
	obj.className="noblink";
}


// blink "on" state
function show()
{
	if (document.getElementById)
	document.getElementById("blink1").style.visibility = "visible";
}
// blink "off" state
function hide()
{
	if (document.getElementById)
	document.getElementById("blink1").style.visibility = "hidden";
}
// toggle "on" and "off" states every 450 ms to achieve a blink effect
// end after 4500 ms (less than five seconds)
for(var i=900; i < 9000; i=i+900)
{
	setTimeout("hide()",i);
	setTimeout("show()",i+250);
}



function deletedefaulttext(obj,strvalue)
{
if(obj.value==strvalue)
obj.value="";
}
function checkdefaulttext(obj,strvalue)
{
if(obj.value=="")
obj.value=strvalue;
}

function validateEnrNo(enrolmentNo)
{
	alert("invoked the method");
}
