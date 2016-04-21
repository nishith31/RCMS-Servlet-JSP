<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page session="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml" lang="en"Xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /><meta http-equiv="Content-Language" content="en-us" />
<meta name="description" content="Put a description of the page here" /><meta name="keywords" content="Put your keywords here" /><meta name="robots" content="index,follow" />
<title>Despatch-By Hand</title><link rel="shortcut icon" href="../css/imgs/favicon.ico" /><link href="../css/blu.css" rel="stylesheet" type="text/css" media="all" /></head>
<body>
<div id="container">
  <div id="banner">
    <h1>RCMS-MDU PROJECT</h1>
    <div id="nav-meta">
      <ul>
        <li style="color:#FFFFFF">RC:&nbsp;07</li>      
  <li style="color:#FFFFFF">Welcome Nishith</li>  
            <li style="color:#FFFFFF"><a href="LogOut" accesskey="Z">Log Out</a></li>
      </ul>
    </div>
  </div>
  <div id="nav-main">
    <ul>
      <li ><a href="Home.jsp" >Home</a></li>
      <li ><a href="Despatch.jsp">Despatch</a></li>
	  <li><a href="Receive.jsp">Receive</a></li>
      <li><a href="Obsolete.jsp">Obsoleted</a></li>
      <li><a href="#">Enquiry</a></li>
      <li class="current"><a href="day.jsp">Day Selector</a></li>
    </ul>
  </div>

  <div id="nav-section">
    <ul>
    </ul>
  </div>

  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="form_day" action="day_result.jsp" onsubmit="return validateForm()">
    <table width="455" border="0">
      <tr>
        <td width="114" height="51"><strong>Select Date:</strong></td>
        <td width="107"><label>
          <select name="year" id="year" tabindex="1">
						        <option value="0">Select Year</option>
						        <option value="1968">1968</option>
						<option value="1969">1969</option>
						<option value="1970">1970</option>
						<option value="1971">1971</option>
						<option value="1972">1972</option>
						<option value="1973">1973</option>
						<option value="1974">1974</option>
						<option value="1975">1975</option>
						<option value="1976">1976</option>
						<option value="1977">1977</option>
						<option value="1978">1978</option>
						<option value="1979">1979</option>
						<option value="1980">1980</option>
						<option value="1981">1981</option>
						<option value="1982">1982</option>
						<option value="1983">1983</option>
						<option value="1984">1984</option>
						<option value="1985">1985</option>
						<option value="1986">1986</option>
						<option value="1987">1987</option>
						<option value="1988">1988</option>
						<option value="1989">1989</option>
						<option value="1990">1990</option>
						<option value="1991">1991</option>
						<option value="1992">1992</option>
						<option value="1993">1993</option>
						<option value="1994">1994</option>
						<option value="1995">1995</option>
						<option value="1996">1996</option>
						<option value="1997">1997</option>
						<option value="1998">1998</option>
						<option value="1999">1999</option>
						<option value="2000">2000</option>
						<option value="2001">2001</option>
						<option value="2002">2002</option>
						<option value="2003">2003</option>
						<option value="2004">2004</option>
						<option value="2005">2005</option>
						<option value="2006">2006</option>
						<option value="2007">2007</option>
						<option value="2008">2008</option>
						<option value="2009">2009</option>
						<option value="2010">2010</option>
						<option value="2011">2011</option>
						<option value="2012">2012</option>
						<option value="2013">2013</option>
						<option value="2014">2014</option>
						<option value="2015">2015</option>
						<option value="2016">2016</option>
						<option value="2017">2017</option>
						<option value="2018">2018</option>
						<option value="2019">2019</option>
						<option value="2020">2020</option>
						<option value="2021">2021</option>
						<option value="2022">2022</option>
						<option value="2023">2023</option>
						<option value="2024">2024</option>
						<option value="2025">2025</option>
						<option value="2026">2026</option>
						<option value="2027">2027</option>
						<option value="2028">2028</option>
						<option value="2029">2029</option>
						<option value="2030">2030</option>
						<option value="2031">2031</option>
						<option value="2032">2032</option>
						<option value="2033">2033</option>
						<option value="2034">2034</option>
						<option value="2035">2035</option>
						<option value="2036">2036</option>
						<option value="2037">2037</option>
						<option value="2038">2038</option>
						<option value="2039">2039</option>
						<option value="2040">2040</option>
                    </select>
        </label></td>
        <td width="116"><label>
          <select name="month" id="month" tabindex="2">
            <option value="0">Select Month</option>
            <option value="1">01</option>
            <option value="2">02</option>
            <option value="3">03</option>
            <option value="4">04</option>
            <option value="5">05</option>
            <option value="6">06</option>
            <option value="7">07</option>
            <option value="8">08</option>
            <option value="9">09</option>
            <option value="10">10</option>
            <option value="11">11</option>
            <option value="12">12</option>
          </select>
        </label></td>
        <td width="100"><label>
          <select name="day" id="day" tabindex="3">
            <option value="0">Select Day</option>
            <option value="1">01</option>
            <option value="2">02</option>
            <option value="3">03</option>
            <option value="4">04</option>
            <option value="5">05</option>
            <option value="6">06</option>
            <option value="7">07</option>
            <option value="8">08</option>
            <option value="9">09</option>
            <option value="10">10</option>
            <option value="11">11</option>
            <option value="12">12</option>
            <option value="13">13</option>
            <option value="14">14</option>
            <option value="15">15</option>
            <option value="16">16</option>
            <option value="17">17</option>
            <option value="18">18</option>
            <option value="19">19</option>
            <option value="20">20</option>
            <option value="21">21</option>
            <option value="22">22</option>
            <option value="23">23</option>
            <option value="24">24</option>
            <option value="25">25</option>
            <option value="26">26</option>
            <option value="27">27</option>
            <option value="28">28</option>
            <option value="29">29</option>
            <option value="30">30</option>
            <option value="31">31</option>
          </select>
        </label></td>
      </tr>
      <tr>
        <td height="66"><label>
          <div align="center">
            <input name="submit" type="submit" onmouseover="mover(this)" onmouseout="mout(this)" id="submit" tabindex="4" onClick="return checksubmit(this);" value="Submit" />
          </div>
        </label></td>
        <td colspan="3"><label>
          <div align="center">
            <input type="reset" name="clear" id="clear" value="Clear" tabindex="5" />
          </div>
        </label></td>
      </tr>
    </table>
</form>
    <h1>&nbsp;</h1>
  </div>

  <div id="sidebar">
    <h3>&nbsp;</h3>
    <div id="nav-supp">Select any Date from the Calender and it will show you the day name..</div>
    <h3>&nbsp;</h3>
  </div>

  <div id="info-site">
    <p id="info-company"><a href="Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="Privacy.jsp" target="_blank">PRIVACY</a> | <a href="Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>

<!--
   End of footer type info
-->

</div>
<script type="text/javascript">
function mover(obj)
{document.frm_hand.txt_enr.className="zoomsize";}
function mout(obj)
{document.frm_hand.txt_enr.className="fieldsize";}

</script>
<script>
function validateForm()
{
var year=document.form_day.year.value;
if(year=="0")
{
alert("please select year");
document.form_day.year.focus();
return false;
}
var month=document.form_day.month.value;
if(month=="0")
{
alert("please select month");
document.form_day.month.focus();
return false;
}
var day=document.form_day.day.value;
if(day=="0")
{
alert("please select day");
document.form_day.day.focus();
return false;
}

if(month==2 && day>28 && year%4!=0)
{
alert("February of this year can't be Greater then 28");
document.form_day.day.focus();
return false;
}
if(month==2 && day>29 && year%4==0)
{
alert("February of this year can't be Greater then 29");
document.form_day.day.focus();
return false;
}
if(month==4 || month==6 || month==9 || month==11)
{
if(day>30)
{
alert("Can not Select day 31 for this month");
document.form_day.day.focus();
return false;
}
}
}
</script>

</body>
</html>
