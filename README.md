# CriticalSection
Easy to use adoption of CriticalSection for FreePascal

<b>Features :</b><br/>

- time limited enter<br/>

<b>Use :</b><br/>
<br/>
<b>definition :</b><br/>
var CS : tCS;<br/>

<b>initialization :</b><br/>
CS := InitCS;<br/>

<b>use :</b><br/>
try<br/>
CS.Enter('name of this enter');<br/>
try<br/>
  Critical part of your code<br/>
finally<br/>
CS.Leave();<br/>
end;<br/>
except<br/>
 // We cannot go inside CS in timeout<br/>
end;<br/>


<b>finalization :</b><br/>
CS.Free;
